# Clarity — AGENTS.md

Repo guide for agents. Org-wide rules live in
[AGENT-STANDARD.md](https://github.com/agent-next/.github/blob/main/AGENT-STANDARD.md);
on conflict the standard wins.

## Purpose

Clarity is a zero-dependency shell/Python tool for Claude Code context and
token management. It ships four surfaces over one analyzer: a `doctor` usage
report, a statusline script, an MCP server, and a Claude Code plugin.
See README.md for the product description.

## Orient

- `bin/clarity` — bash CLI entrypoint (`doctor`, `status`, `version`, `help`)
- `scripts/analyze.py` — stdlib-only Python analyzer behind `doctor`
- `scripts/clarity-status.sh` — statusline output; reads Claude Code
  statusline JSON on stdin
- `mcp/server.py` — MCP server, JSON-RPC 2.0 over stdio, spec `2025-11-25`
- `.claude-plugin/` — `plugin.json` is the version source of truth;
  `marketplace.json` must match it
- `install.sh` — git-based installer into `~/.claude/clarity`
- `skills/clarity-doctor/` — slash-command skill definition
- `tests/smoke.sh` — the test suite; self-contained bash, uses a fake
  `claude` binary, needs `python3`, `git`, `rg`, `rsync`
- `scripts/release-check.sh` — pre-PR gate: smoke + version consistency
- `docs/` — reference doc, MCP notes, release checklist

## Setup

```sh
make setup
```

Verifies the required tools (`python3`, `git`, `rg`, `rsync`) and installs
missing ones via `apt-get` or `brew` when available. There are no language
dependencies: Python is stdlib-only, everything else is bash/sh.

## Check

```sh
make check                      # = bash tests/smoke.sh — same gate CI runs
bash scripts/release-check.sh   # fuller pre-PR gate per CONTRIBUTING.md
```

CI (`.github/workflows/ci.yml`) runs the smoke suite on ubuntu + macOS for
every PR and push to main. `smoke.sh` overrides `HOME` with a temp dir; it
never touches the real `~/.claude`.

## Boundaries

- Release-sensitive files (`install.sh`, `bin/clarity`, `.claude-plugin/*`,
  `mcp/server.py`, `README.md`, `CHANGELOG.md`, `tests/smoke.sh`): keep
  version strings in sync — see CONTRIBUTING.md.
- No new dependencies, CI complexity, or top-level commands without
  discussion (CONTRIBUTING.md "Scope guidance").
- The tool is read-only against `~/.claude` — keep it that way. No
  telemetry, no external accounts.
- User-facing behavior changes go in `CHANGELOG.md`.

## Done

- `make check` green; before opening a PR run `scripts/release-check.sh`.
- Version bumps update all four surfaces (CLI / plugin / marketplace / MCP)
  together.
- Minimal diffs; README claims stay narrower than implementation.
