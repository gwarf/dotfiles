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
The everyday commands are a consistent `daryl` family:

- `daryl [dir]` — Daryl on your default provider (Claude). The everyday driver.
- `daryl-gpt [dir]` — Daryl on GitHub Copilot's flagship GPT (`gpt-5.6-sol`).
  Override the tier: `GOOSE_MODEL=gpt-5.6-terra daryl-gpt` (sol = flagship,
  terra = balanced, luna = fast/cheap).
- `daryl-gemini [dir]` — Daryl on Gemini via Copilot (`gemini-3.1-pro-preview`).

The Copilot-backed ones (`daryl-gpt`, `daryl-gemini`) need a Copilot seat with
those models enabled and a one-time `github_copilot` device login.

`~/.local/bin/goose-daryl` is the underlying launcher the family calls
(`goose-daryl [dir] [provider] [model]`, `GOOSE_MODE=approve` by default) — use
it directly only for an ad-hoc provider/model.

Requires [`bun`](https://bun.sh) and `goose`.

`ALGORITHM.md` (referenced from the brief via `@ALGORITHM.md`) adds a
goose-tuned version of a current-state-to-ideal-state Algorithm: self-selected
mode (MINIMAL/NATIVE/ALGORITHM), a phase spine, ISA-centred verification. It is
deliberately lighter than a full harness Algorithm — goose 1.41 can't inject a
classifier verdict into context (hooks are observe/deny only), so mode is
self-selected, and cross-vendor audit / typed agents are dropped. The doc names
what it drops and why.

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

## Appearance (optional)

In `~/.config/goose/config.yaml`:

```yaml
GOOSE_CLI_THEME: dark
GOOSE_CLI_DARK_THEME: Nord   # syntax palette for code blocks (default: zenburn)
```

Theme names are goose's underlying `bat` themes and are **case-sensitive** —
run `bat --list-themes` for valid values (`Nord`, `Dracula`, `gruvbox-dark`,
`zenburn`, `TwoDark`, …). A wrong value spams `Unknown theme` on every render.

To cut the `todo_write` boxes that clutter transcripts, disable the bundled
`todo` extension (set its `enabled: false`). `GOOSE_CLI_MIN_PRIORITY` does NOT
hide tool-call boxes — they render outside the priority filter — so disabling
the extension is the real lever.

## Guard protocol note

goose's blocking path (`crates/goose/src/hooks/mod.rs`, v1.41+): deny by
printing `{"decision":"block","reason":"…"}` and exiting 0. Only `PreToolUse`
and `Stop` route through it; observe events (`BeforeShellExecution`, …) ignore
a non-zero exit (fail open), so the guard runs on `PreToolUse`.

MIT — see LICENSE.
