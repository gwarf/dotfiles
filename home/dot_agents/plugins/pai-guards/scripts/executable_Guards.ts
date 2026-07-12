#!/usr/bin/env bun
/**
 * Deny-capable PreToolUse guard for goose (Open Plugins hook).
 *
 * Engine only — the rules are data. Ships safe generic defaults and merges
 * an optional user config so you can add your own environment's sensitive
 * paths without editing this file (keep those private).
 *
 * goose deny protocol (crates/goose/src/hooks/mod.rs deny_reason(), v1.41+):
 * deny = exit 0 + `{"decision":"block","reason":"…"}` on stdout. Anything
 * else = allow. A crash fails open, so the rules ARE the security story.
 * Only PreToolUse and Stop route through the blocking path; do not reuse
 * this on observe-only events (BeforeShellExecution/BeforeReadFile), where
 * a non-zero exit is logged as a hook failure and ignored.
 *
 * Config: JSON at $PAI_GUARDS_CONFIG or ~/.agents/pai-guards.config.json:
 *   { "rules": [ { "name": "...", "pattern": "<regex>", "reason": "..." } ] }
 * User rules are appended to the defaults below.
 */

import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

interface HookContext {
  event?: string;
  tool_name?: string;
  tool_input?: unknown;
  working_dir?: string;
}

interface RuleSpec {
  name: string;
  pattern: string;
  reason: string;
}

// Generic, environment-agnostic defaults. No personal paths here.
const DEFAULT_RULES: RuleSpec[] = [
  {
    name: "secret-files",
    pattern:
      "(^|[\\s'\"=:/])(\\.env\\b|\\.ssh/|[\\w-]+\\.pem\\b|[\\w-]+\\.key\\b|id_(rsa|ed25519|ecdsa)\\b)",
    reason:
      "guard: reading or touching secret-bearing files is denied (env files, ssh keys, PEM/key material)",
  },
  {
    name: "private-key-content",
    pattern: "BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY",
    reason: "guard: handling private-key material is denied",
  },
  {
    name: "env-dumps",
    pattern:
      "(^|[;&|(]\\s*)(printenv|env)\\s*($|[;&|>)])|\\b(printenv|echo)\\s+[\"']?\\$\\{?\\w*(TOKEN|API_?KEY|SECRET|PASSWORD)",
    reason:
      "guard: dumping process env or echoing secret-shaped variables is denied — test credentials by USING them, not printing them",
  },
  {
    name: "git-remote-urls",
    pattern:
      "git\\s+remote\\s+(-v|get-url)|cat\\s+[^|;&]*\\.git/config|git\\s+config\\s+--list|git\\s+config\\s+--get\\s+remote\\.[\\w.]*\\.?url(?!\\s*\\|\\s*cut)",
    reason:
      "guard: printing git remote URLs is denied (HTTPS origins can embed tokens) — transport-only: git config --get remote.origin.url | cut -d: -f1",
  },
  // SecurityPipeline port (2026-07-12): dangerous-action + egress inspectors.
  // Injection MARKERS (ignore-previous-instructions etc.) live on tool OUTPUT,
  // which a PreToolUse hook can't see — those are logged by pai-observability.
  {
    name: "dangerous-actions",
    pattern:
      "\\brm\\s+-rf\\s+~|\\brm\\s+-rf\\s+/($|\\s|\\*)|\\bdelete\\s+all\\s+files\\b|\\bdisable\\s+(all\\s+)?(security|logging|monitoring|protection)\\b|\\bexfiltrate\\b|\\bupload\\s+(your|the)\\s+(data|config|secrets)\\b|\\bsend\\s+(your|the|all)\\s+(config|credentials|secrets|keys|tokens)\\s+to\\b",
    reason:
      "guard: destructive or exfiltration action denied (dangerous-action inspector)",
  },
  {
    name: "credential-egress",
    pattern:
      "(?=.*\\b(curl|wget|nc|ncat|fetch)\\b)(?=.*(TOKEN|API_?KEY|SECRET|PASSWORD|credential|\\.env\\b|\\.ssh/|id_(rsa|ed25519)))",
    reason:
      "guard: sending secret-shaped data to an outbound tool is denied (egress inspector)",
  },
  {
    name: "remote-pipe-to-shell",
    pattern: "\\b(curl|wget)\\b[^|]*\\|\\s*(sudo\\s+)?(sh|bash|zsh)\\b",
    reason:
      "guard: piping a downloaded script straight into a shell is denied — download, inspect, then run",
  },
];

function loadRules(): { re: RegExp; reason: string; name: string }[] {
  const specs = [...DEFAULT_RULES];
  const configPath =
    process.env.PAI_GUARDS_CONFIG ?? join(homedir(), ".agents", "pai-guards.config.json");
  try {
    const parsed = JSON.parse(readFileSync(configPath, "utf8")) as { rules?: RuleSpec[] };
    if (Array.isArray(parsed.rules)) specs.push(...parsed.rules);
  } catch {
    // no user config → defaults only
  }
  const compiled: { re: RegExp; reason: string; name: string }[] = [];
  for (const s of specs) {
    try {
      compiled.push({ re: new RegExp(s.pattern, "i"), reason: s.reason, name: s.name });
    } catch {
      // skip an invalid user regex rather than crash (crash = fail open)
    }
  }
  return compiled;
}

function extractTexts(input: unknown): string[] {
  const out: string[] = [];
  if (input == null) return out;
  if (typeof input === "string") return [input];
  if (typeof input === "object") {
    for (const v of Object.values(input as Record<string, unknown>)) {
      if (typeof v === "string") out.push(v);
      else if (typeof v === "object" && v != null) out.push(...extractTexts(v));
    }
  }
  if (out.length === 0) out.push(JSON.stringify(input));
  return out;
}

async function main(): Promise<void> {
  const raw = await Bun.stdin.text();
  let ctx: HookContext = {};
  try {
    ctx = JSON.parse(raw) as HookContext;
  } catch {
    return; // unparseable → allow (goose fail-open contract)
  }
  const rules = loadRules();
  const texts = extractTexts(ctx.tool_input);
  for (const t of texts) {
    for (const rule of rules) {
      if (rule.re.test(t)) {
        console.log(
          JSON.stringify({ decision: "block", reason: `${rule.reason} [rule: ${rule.name}]` }),
        );
        return;
      }
    }
  }
}

await main();
