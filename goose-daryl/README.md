# goose-daryl

A persona-briefed, guarded [goose](https://github.com/aaif-goose/goose) setup —
goose used as a second engine alongside a primary agent harness, sharing the
same stores. This is the **public mechanism**; personal content stays private
and layers on top.

Managed here via chezmoi. `chezmoi apply` deploys:

- `~/.agents/plugins/pai-guards/` — deny-capable PreToolUse hook (blocks secret
  files, key material, env dumps, git remote URLs, no human in the loop in
  `auto` mode). Extend with your own paths via a private config (below).
- `~/.agents/plugins/pai-observability/` — session + tool-name trail to a JSONL
  log (never tool inputs).
- `~/.local/bin/goose-daryl` — launcher: `goose-daryl [dir] [provider] [model]`,
  `GOOSE_MODE=approve` by default.

Requires [`bun`](https://bun.sh) and `goose`.

## Public / private split

This repo carries only the mechanism — no personal data (verified by leak
sweep). Your specifics stay private and are NOT in this repo:

| Public (here, in dotfiles) | Private (your own store) |
|----------------------------|--------------------------|
| `dot_agents/plugins/*` engine | `~/.agents/AGENTS.md` — your filled persona |
| `goose-daryl/AGENTS.md.example` | `~/.agents/pai-guards.config.json` — your paths |
| `goose-daryl/pai-guards.config.example.json` | provider auth in `~/.config/goose/` |

`Guards.ts` ships safe generic defaults and appends the rules from your private
`~/.agents/pai-guards.config.json`, so the engine is shareable while your
infrastructure fingerprint never leaves your machine.

## Deploy on a new host

1. `chezmoi apply` — lays down the plugins and launcher.
2. Drop your private `~/.agents/AGENTS.md` and `~/.agents/pai-guards.config.json`
   from your private store (see `AGENTS.md.example` /
   `pai-guards.config.example.json` here for the shape).
3. Register the plugins in `~/.config/goose/config.yaml` under `plugins:`
   (goose also auto-registers on first discovery).

## Guard protocol note

goose's blocking path (`crates/goose/src/hooks/mod.rs`, v1.41+): deny by
printing `{"decision":"block","reason":"…"}` and exiting 0. Only `PreToolUse`
and `Stop` route through it; observe events (`BeforeShellExecution`, …) ignore
a non-zero exit (fail open), so the guard runs on `PreToolUse`.

MIT — see LICENSE.
