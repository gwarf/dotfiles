#!/usr/bin/env bun
/**
 * LLM injection inspector — the SecurityPipeline's model-judgment tier for
 * goose, scoped to HIGH-RISK actions (mail send, outbound network). Runs as a
 * second PreToolUse hook after the pattern-based Guards.ts; only high-risk
 * commands reach the judge, so ordinary tool calls pay zero latency.
 *
 * Judge: $PAI_INJECTION_JUDGE — a command that reads the proposed command on
 * stdin and prints "BLOCK: <reason>" to block or anything else to allow.
 * No judge configured → allow + log (the pattern guard and approve mode still
 * apply). Judge error/timeout → allow + log (fail-open: a broken judge must not
 * block every send). goose deny protocol: exit 0 + {"decision":"block",...}.
 */

import { spawnSync } from "node:child_process";
import { appendFileSync, mkdirSync } from "node:fs";
import { homedir } from "node:os";
import { join, dirname } from "node:path";

interface HookContext {
  tool_name?: string;
  tool_input?: unknown;
}

const HIGH_RISK = /\bMail\.ts\b[^|;&]*\bsend\b|\b(curl|wget|nc|ncat|fetch)\b/i;
const SECURITY_LOG =
  process.env.GOOSE_SECURITY_LOG ??
  join(homedir(), ".local", "state", "goose-daryl", "security.jsonl");

function log(alert: string, detail: string): void {
  try {
    mkdirSync(dirname(SECURITY_LOG), { recursive: true });
    appendFileSync(
      SECURITY_LOG,
      JSON.stringify({
        ts: new Date().toISOString(),
        alert,
        detail: detail.slice(0, 200),
        inspector: "injection",
        source: "goose",
      }) + "\n",
    );
  } catch {
    /* logging must never break the session */
  }
}

function extractText(input: unknown): string {
  if (typeof input === "string") return input;
  if (input && typeof input === "object") {
    return Object.values(input as Record<string, unknown>)
      .map((v) => (typeof v === "string" ? v : ""))
      .join(" ");
  }
  return "";
}

async function main(): Promise<void> {
  const raw = await Bun.stdin.text();
  let ctx: HookContext = {};
  try {
    ctx = JSON.parse(raw) as HookContext;
  } catch {
    return; // unparseable → allow
  }
  const text = extractText(ctx.tool_input);
  if (!text || !HIGH_RISK.test(text)) return; // not high-risk → allow, no judge

  const judge = process.env.PAI_INJECTION_JUDGE;
  if (!judge) {
    log("no_judge_configured", text);
    return;
  }

  const res = spawnSync("sh", ["-c", judge], {
    input: text,
    encoding: "utf8",
    timeout: 20000,
  });
  const out = (res.stdout ?? "").trim();

  if (/^BLOCK\b/i.test(out)) {
    console.log(
      JSON.stringify({
        decision: "block",
        reason: `PAI injection inspector — ${out.slice(0, 160)}`,
      }),
    );
    log("blocked", `${out.slice(0, 120)} || ${text.slice(0, 80)}`);
    return;
  }
  if (res.error || res.status !== 0) log("judge_error", text);
}

await main();
