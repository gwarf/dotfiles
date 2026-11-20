import { afterEach, describe, expect, test } from "bun:test";
import { spawnSync } from "node:child_process";
import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { release, tmpdir } from "node:os";
import { join, resolve } from "node:path";

const SCRIPT = resolve("home/private_dot_local/bin/executable_meeting-autorec");
const POLL_MS = 50;
const LIMIT_MS = 30_000;

type Fixture = {
  root: string;
  out: string;
  bin: string;
  env: Record<string, string>;
  daemon: ReturnType<typeof Bun.spawn> | null;
  output: string;
  startedAt: number;
};
type Manifest = {
  complete: boolean;
  failures: number;
  parts: { file: string; failed?: string; audioOnly?: boolean }[];
};

const fixtures: Fixture[] = [];

function writeFake(bin: string, name: string, body: string): void {
  const path = join(bin, name);
  writeFileSync(path, `#!/bin/sh\n${body}\n`);
  chmodSync(path, 0o755);
}

function makeFixture(): Fixture {
  const root = mkdtempSync(join(tmpdir(), "meeting-autorec-test-"));
  const bin = join(root, "bin");
  const out = join(root, "recordings");
  mkdirSync(bin);
  mkdirSync(out);
  const modules = join(root, "modules");
  mkdirSync(join(modules, release()), { recursive: true });
  const pacmanLog = join(root, "pacman.log");
  writeFileSync(pacmanLog, "");
  const env: Record<string, string> = {
    HOME: root,
    PATH: `${bin}:/usr/bin:/bin`,
    MEETING_AUTOREC_DIR: out,
    MEETING_AUTOREC_POLL_MS: "200",
    MEETING_AUTOREC_GRACE_S: "1",
    MEETING_AUTOREC_DEAD_S: "1",
    MEETING_AUTOREC_SCREEN_FALLBACK: "1",
    MEETING_AUTOREC_RECORDER: "fake-recorder",
    MEETING_AUTOREC_FFMPEG: "fake-ffmpeg",
    MEETING_AUTOREC_MODULES_ROOT: modules,
    MEETING_AUTOREC_PACMAN_LOG: pacmanLog,
    MEETING_AUTOREC_BOOT_TIME: "1795200000",
    FIXTURE_ROOT: root,
  };
  writeFake(bin, "pw-dump", 'if [ -e "$FIXTURE_ROOT/mic" ]; then printf \'%s\\n\' \'[{"info":{"props":{"media.class":"Stream/Input/Audio","application.name":"Chromium input"}}}]\'; else printf \'[]\\n\'; fi');
  writeFake(bin, "notify-send", 'for a in "$@"; do printf \'%s\\037\' "$a" >> "$FIXTURE_ROOT/notify.log"; done; printf \'\\036\' >> "$FIXTURE_ROOT/notify.log"');
  writeFake(bin, "pactl", 'case "$1" in get-default-sink) printf \'fake_sink\\n\' ;; get-default-source) printf \'fake_source\\n\' ;; esac');
  writeFake(bin, "qdbus6", "exit 1");
  writeFake(bin, "journalctl", "exit 0");
  writeFake(bin, "pgrep", "exit 1");
  writeFake(bin, "fake-recorder", [
    'printf \'%s\\n\' "$*" >> "$FIXTURE_ROOT/recorder.argv"',
    'printf \'%s\\n\' "$$" > "$FIXTURE_ROOT/recorder.pid"',
    'out=', 'prev=', 'for a in "$@"; do if [ "$prev" = -o ]; then out=$a; fi; prev=$a; done',
    'mode=$(cat "$FIXTURE_ROOT/recorder.mode" 2>/dev/null || printf ok)',
    'case "$mode" in',
    'abort) head -c 88 /dev/zero > "$out"; kill -ABRT "$$" ;;',
    'exit3) head -c 88 /dev/zero > "$out"; exit 3 ;;',
    'stall) head -c 88 /dev/zero > "$out"; exec sleep 1000 ;;',
    'exit0) head -c 2048 /dev/zero > "$out"; exit 0 ;;',
    'ok) trap \'exit 0\' INT; while :; do head -c 2048 /dev/zero >> "$out"; sleep 0.2; done ;;',
    '*) exit 99 ;;',
    'esac',
  ].join("\n"));
  writeFake(bin, "fake-ffmpeg", [
    'printf \'%s\\n\' "$*" >> "$FIXTURE_ROOT/ffmpeg.argv"',
    'printf \'%s\\n\' "$$" > "$FIXTURE_ROOT/ffmpeg.pid"',
    'out=', 'for a in "$@"; do out=$a; done',
    'mode=$(cat "$FIXTURE_ROOT/ffmpeg.mode" 2>/dev/null || printf ok)',
    'case "$mode" in',
    'die) exit 1 ;;',
    'ok) trap \'touch "$FIXTURE_ROOT/ffmpeg.got-int"; exit 255\' INT; while :; do head -c 2048 /dev/zero >> "$out"; sleep 0.2; done ;;',
    '*) exit 99 ;;',
    'esac',
  ].join("\n"));
  const fixture: Fixture = { root, out, bin, env, daemon: null, output: "", startedAt: Date.now() };
  fixtures.push(fixture);
  return fixture;
}

async function startDaemon(f: Fixture, recorderMode: string, ffmpegMode = "ok"): Promise<void> {
  writeFileSync(join(f.root, "mic"), "open");
  writeFileSync(join(f.root, "recorder.mode"), recorderMode);
  writeFileSync(join(f.root, "ffmpeg.mode"), ffmpegMode);
  f.startedAt = Date.now();
  f.daemon = Bun.spawn(["bun", SCRIPT], { env: f.env, stdout: "pipe", stderr: "pipe" });
  const proc = f.daemon;
  void (async () => { for await (const chunk of proc.stdout) f.output += new TextDecoder().decode(chunk); })();
  void (async () => { for await (const chunk of proc.stderr) f.output += new TextDecoder().decode(chunk); })();
}

function context(f: Fixture): string {
  return `\nDaemon output:\n${f.output || "(no output captured yet)"}`;
}

async function waitFor(f: Fixture, pred: () => boolean | Promise<boolean>, timeoutMs = LIMIT_MS, why = "condition"): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    if (await pred()) return;
    await Bun.sleep(POLL_MS);
  }
  throw new Error(`Timed out waiting for ${why} after ${timeoutMs}ms.${context(f)}`);
}

function readCount(path: string): number {
  if (!existsSync(path)) return 0;
  return readFileSync(path, "utf8").split("\n").filter(Boolean).length;
}

function manifestPath(f: Fixture): string {
  const found = readdirSync(f.out).filter((name) => name.endsWith(".parts.json"));
  if (found.length !== 1) throw new Error(`Expected one manifest, found ${found.length}`);
  return join(f.out, found[0]!);
}

function readManifest(f: Fixture): Manifest {
  return JSON.parse(readFileSync(manifestPath(f), "utf8")) as Manifest;
}

function notifications(f: Fixture): string[][] {
  const path = join(f.root, "notify.log");
  if (!existsSync(path)) return [];
  return readFileSync(path, "utf8").split("\x1e").filter(Boolean).map((record) => record.split("\x1f").filter((_, i, all) => i < all.length - 1));
}

function criticalNotifications(f: Fixture): string[][] {
  return notifications(f).filter((argv) => argv.some((arg, i) => arg === "-u" && argv[i + 1] === "critical"));
}

function allNotificationText(f: Fixture): string {
  return notifications(f).flat().join(" ");
}

function argvLines(f: Fixture, file: string): string[] {
  const path = join(f.root, file);
  return existsSync(path) ? readFileSync(path, "utf8").split("\n").filter(Boolean) : [];
}

function assertWithContext(f: Fixture, condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(`${message}${context(f)}`);
}

function pidIsGone(pidFile: string): boolean {
  if (!existsSync(pidFile)) return false;
  const pid = Number(readFileSync(pidFile, "utf8").trim());
  try { process.kill(pid, 0); return false; } catch { return true; }
}

async function stopFixture(f: Fixture): Promise<void> {
  if (f.daemon) {
    try { f.daemon.kill("SIGTERM"); } catch {}
    const deadline = Date.now() + 3000;
    while (Date.now() < deadline) {
      if (f.daemon.exitCode !== null) break;
      await Bun.sleep(50);
    }
    if (f.daemon.exitCode === null) {
      try { f.daemon.kill("SIGKILL"); } catch {}
      await Promise.race([f.daemon.exited, Bun.sleep(1000)]);
    }
  }
  for (const name of ["recorder.pid", "ffmpeg.pid"]) {
    const path = join(f.root, name);
    if (existsSync(path)) {
      const pid = Number(readFileSync(path, "utf8").trim());
      if (Number.isInteger(pid) && pid > 1) { try { process.kill(pid, "SIGKILL"); } catch {} }
    }
  }
  rmSync(f.root, { recursive: true, force: true });
}

afterEach(async () => {
  while (fixtures.length) await stopFixture(fixtures.pop()!);
});

describe("meeting-autorec dead-part handling", () => {
  test("SIGABRT raises a critical alert and starts the two-track ffmpeg fallback", async () => {
    const f = makeFixture();
    await startDaemon(f, "abort");
    await waitFor(f, () => readCount(join(f.root, "ffmpeg.argv")) === 1 && readManifest(f).parts.length === 2, LIMIT_MS, "SIGABRT fallback");
    const [manifestName] = readdirSync(f.out).filter((name) => name.endsWith(".parts.json"));
    const stem = join(f.out, manifestName!.replace(/\.parts\.json$/, ""));
    const ffargs = argvLines(f, "ffmpeg.argv")[0]!;
    assertWithContext(f, criticalNotifications(f).some((args) => args.join(" ").includes("SIGABRT")), "Missing critical SIGABRT notification.");
    assertWithContext(f, readCount(join(f.root, "ffmpeg.argv")) === 1, "ffmpeg should start exactly once.");
    assertWithContext(f, ffargs.includes("-f pulse -i fake_sink.monitor -f pulse -i fake_source -map 0:a -map 1:a -c:a libopus"), "ffmpeg arguments did not contain the expected two-input audio mapping.");
    assertWithContext(f, ffargs.endsWith(`${stem}.part02.mka`), "ffmpeg output was not part02.mka in the configured directory.");
    const manifest = readManifest(f);
    assertWithContext(f, manifest.failures === 1 && !!manifest.parts[0]?.failed && manifest.parts[1]?.audioOnly === true, "Manifest did not record one failed video part followed by audio-only fallback.");
  }, LIMIT_MS);

  test("nonzero recorder exit reports its code and starts fallback", async () => {
    const f = makeFixture();
    await startDaemon(f, "exit3");
    await waitFor(f, () => readCount(join(f.root, "ffmpeg.argv")) === 1 && readManifest(f).parts.length === 2, LIMIT_MS, "exit-code fallback");
    assertWithContext(f, criticalNotifications(f).some((args) => args.join(" ").includes("code 3")), "Missing critical code 3 notification.");
    assertWithContext(f, readManifest(f).parts[1]?.audioOnly === true, "Manifest did not record the audio-only fallback.");
  }, LIMIT_MS);

  test("stalled recorder is killed and fallback starts", async () => {
    const f = makeFixture();
    await startDaemon(f, "stall");
    await waitFor(f, () => readCount(join(f.root, "ffmpeg.argv")) === 1 && readManifest(f).parts.length === 2, LIMIT_MS, "stalled recorder fallback");
    await waitFor(f, () => pidIsGone(join(f.root, "recorder.pid")), 3000, "stalled recorder pid to stop running");
    assertWithContext(f, criticalNotifications(f).some((args) => args.join(" ").includes("no data")), "Missing critical no-data notification.");
  }, LIMIT_MS);

  test("mic close stops fallback after grace and marks the call saved", async () => {
    const f = makeFixture();
    await startDaemon(f, "abort", "ok");
    await waitFor(f, () => readCount(join(f.root, "ffmpeg.argv")) === 1 && readManifest(f).parts.length === 2, LIMIT_MS, "audio fallback before mic close");
    rmSync(join(f.root, "mic"));
    await waitFor(f, () => existsSync(join(f.root, "ffmpeg.got-int")) && readManifest(f).complete, LIMIT_MS, "graceful ffmpeg stop and completed manifest");
    await waitFor(f, () => allNotificationText(f).toLowerCase().includes("saved"), 2000, "final saved notification");
    assertWithContext(f, allNotificationText(f).toLowerCase().includes("saved"), "No final notification mentioned the saved recording.");
  }, LIMIT_MS);

  test("failed fallback is not retried and reports that the call is not recorded", async () => {
    const f = makeFixture();
    await startDaemon(f, "abort", "die");
    await waitFor(f, () => readManifest(f).failures === 2 && readCount(join(f.root, "ffmpeg.argv")) === 1, LIMIT_MS, "audio fallback failure");
    await waitFor(f, () => criticalNotifications(f).some((args) => args.join(" ").includes("NOT being recorded")), 2000, "not-being-recorded notification");
    await waitFor(f, () => Date.now() - f.startedAt >= 4000, LIMIT_MS, "four seconds without crash-loop retries");
    assertWithContext(f, readCount(join(f.root, "recorder.argv")) === 1, "Recorder was restarted after a failed fallback.");
    assertWithContext(f, readCount(join(f.root, "ffmpeg.argv")) === 1, "ffmpeg was restarted after its failure.");
    assertWithContext(f, readManifest(f).failures === 2, "Manifest should record both recorder and fallback failures.");
  }, LIMIT_MS);

  test("clean recorder exit is treated as user stop without fallback", async () => {
    const f = makeFixture();
    await startDaemon(f, "exit0");
    await waitFor(f, () => readCount(join(f.root, "recorder.argv")) === 1 && readManifest(f).complete, LIMIT_MS, "clean user stop");
    await waitFor(f, () => Date.now() - f.startedAt >= 3000, LIMIT_MS, "three seconds without restarting a user-stopped recording");
    assertWithContext(f, readCount(join(f.root, "ffmpeg.argv")) === 0, "A clean user stop must not start ffmpeg.");
    assertWithContext(f, criticalNotifications(f).length === 0, "A clean user stop must not issue a critical notification.");
    assertWithContext(f, readCount(join(f.root, "recorder.argv")) === 1, "Recorder restarted after a clean user stop.");
  }, LIMIT_MS);

  test("check reports missing running-kernel modules", () => {
    const f = makeFixture();
    rmSync(join(f.root, "modules", release()), { recursive: true });
    const result = spawnSync("bun", [SCRIPT, "check"], { encoding: "utf8", env: f.env });
    expect(result.status).toBe(0);
    expect(`${result.stdout}${result.stderr}`).toContain("gone");
  });

  test("check reports graphics packages upgraded after boot", () => {
    const f = makeFixture();
    writeFileSync(join(f.root, "pacman.log"), "[2026-11-20T09:04:00+0100] [ALPM] upgraded mesa (1:26.2.7-1 -> 1:26.3.1-1)\n");
    f.env.MEETING_AUTOREC_BOOT_TIME = "1795100000";
    const result = spawnSync("bun", [SCRIPT, "check"], { encoding: "utf8", env: f.env });
    expect(result.status).toBe(0);
    expect(`${result.stdout}${result.stderr}`).toContain("mesa");
  });

  test("check reports no pending reboot when boot is later than package upgrade", () => {
    const f = makeFixture();
    writeFileSync(join(f.root, "pacman.log"), "[2026-11-20T09:04:00+0100] [ALPM] upgraded mesa (1:26.2.7-1 -> 1:26.3.1-1)\n");
    f.env.MEETING_AUTOREC_BOOT_TIME = "1795200000";
    const result = spawnSync("bun", [SCRIPT, "check"], { encoding: "utf8", env: f.env });
    expect(result.status).toBe(0);
    expect(`${result.stdout}${result.stderr}`).toContain("no reboot pending");
  });

  test("healthy recorder past the dead threshold does not trigger fallback", async () => {
    const f = makeFixture();
    await startDaemon(f, "ok");
    await waitFor(f, () => readCount(join(f.root, "recorder.argv")) === 1, LIMIT_MS, "healthy recorder start");
    await waitFor(f, () => Date.now() - f.startedAt >= 3000, LIMIT_MS, "three seconds of healthy recording");
    assertWithContext(f, criticalNotifications(f).length === 0, "Healthy recording emitted a critical notification.");
    assertWithContext(f, readCount(join(f.root, "ffmpeg.argv")) === 0, "Healthy recording incorrectly started ffmpeg.");
  }, LIMIT_MS);
});
