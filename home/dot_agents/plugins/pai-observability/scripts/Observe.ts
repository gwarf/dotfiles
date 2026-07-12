#!/usr/bin/env bun
/**
 * PAI observability trail for goose (observe-path hook — MUST exit 0;
 * non-zero on this path is logged as hook failure by goose).
 * Records tool NAMES and session lifecycle only — never tool_input,
 * which can carry secrets. Mirrors ToolActivityTracker at 10% weight.
 */

import { appendFileSync, mkdirSync } from "node:fs";
import { homedir } from "node:os";
import { join, dirname } from "node:path";

interface HookContext {
  event?: string;
  session_id?: string;
  tool_name?: string;
  working_dir?: string;
}

const LOG = join(homedir(), ".claude/PAI/MEMORY/OBSERVABILITY/goose-activity.jsonl");

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
} catch {
  // Observability must never break a session — swallow and exit 0.
}
