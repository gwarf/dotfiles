#!/usr/bin/env bun
/**
 * Observability trail for goose (observe-path hook — MUST exit 0; non-zero on
 * this path is logged as a hook failure by goose).
 * Records tool NAMES and session lifecycle only, never tool_input.
 * Log path: $GOOSE_ACTIVITY_LOG or ~/.local/state/goose-daryl/activity.jsonl
 */

import { appendFileSync, mkdirSync } from "node:fs";
import { homedir } from "node:os";
import { join, dirname } from "node:path";

interface HookContext {
  event?: string;
  session_id?: string;
  tool_name?: string;
  tool_output?: string;
  working_dir?: string;
}

const STATE = join(homedir(), ".local", "state", "goose-daryl");
const LOG = process.env.GOOSE_ACTIVITY_LOG ?? join(STATE, "activity.jsonl");
const SECURITY_LOG = process.env.GOOSE_SECURITY_LOG ?? join(STATE, "security.jsonl");

// SecurityPipeline injection inspector, observe-tier. goose 1.41 PreToolUse
// can't see tool OUTPUT, and observe hooks can't block — so we AUDIT injection
// markers found in returned content (mail, web). A hit means the model just
// consumed content trying to hijack it; the trail is how you notice.
const INJECTION_MARKERS =
  /ignore\s+(all\s+)?previous\s+instructions|disregard\s+(all\s+)?(prior|previous|above)|your\s+new\s+instructions\s+are|system\s+override[:\s]|\[(SYSTEM|ADMIN)\]\s*:|you\s+are\s+now\s+in\s+\w+\s+mode|exfiltrate|send\s+(your|the|all)\s+(credentials|secrets|keys|tokens)\s+to/i;

try {
  const raw = await Bun.stdin.text();
  const ctx = JSON.parse(raw) as HookContext;
  const row = {
    ts: new Date().toISOString(),
    event: ctx.event ?? "unknown",
    session_id: ctx.session_id ?? null,
    tool_name: ctx.tool_name ?? null,
    working_dir: ctx.working_dir ?? null,
    source: "goose",
  };
  mkdirSync(dirname(LOG), { recursive: true });
  appendFileSync(LOG, JSON.stringify(row) + "\n");

  const out = ctx.tool_output ?? "";
  if (out && INJECTION_MARKERS.test(out)) {
    mkdirSync(dirname(SECURITY_LOG), { recursive: true });
    appendFileSync(
      SECURITY_LOG,
      JSON.stringify({
        ts: row.ts,
        session_id: row.session_id,
        tool_name: row.tool_name,
        alert: "injection_marker_in_tool_output",
        marker: (out.match(INJECTION_MARKERS) ?? [""])[0].slice(0, 80),
        source: "goose",
      }) + "\n",
    );
  }
} catch {
  // Observability must never break a session — swallow and exit 0.
}
