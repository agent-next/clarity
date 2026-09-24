# clarity — agent guide

Org rules: https://github.com/agent-next/.github/blob/main/AGENT-STANDARD.md (hard limits, PR/merge policy).

## Purpose

Claude Code context and token management, shipped as four surfaces sharing one
analyzer: CLI (`bin/clarity`), MCP server (`mcp/server.py`), Claude Code plugin
(`.claude-plugin/`), and slash-command skill (`skills/clarity-doctor/`).
Status: public alpha (v0.0.6); honest feature coverage and the roadmap live in
`README.md` (`Roadmap`, `Blog coverage`).

## Orient

`git status`, `git branch --show-current`, `git worktree list`,
`gh pr list --state open`. Read first: `README.md`, `tests/smoke.sh`,
`install.sh`. Release metadata lives in `.claude-plugin/plugin.json` and must
stay in sync with `bin/clarity` `VERSION` and `mcp/server.py` `SERVER_INFO` —
the smoke suite asserts they match.

## Setup

`make setup` verifies the required toolchain is on PATH: `bash`, `git`,
`python3` (stdlib only — the project has zero runtime deps), `rg`, `rsync`.
There is nothing to install; the repo has no package manifests.

## Check

`make check` runs `bash tests/smoke.sh` — the same suite CI runs
(`.github/workflows/ci.yml`, ubuntu + macOS). It compiles the Python entry
points, syntax-checks the shell scripts, pins version metadata, exercises the
doctor/statusline/MCP paths, and replays the documented install flow against a
fake `claude` binary. Everything runs under temp dirs (`mktemp -d`); a single
test is not split out — run the whole script.

## Boundaries

- Public repo — no secrets, credentials, or private data in code, tests, or
  fixtures. The smoke suite greps doctor output for stale private references.
- `install.sh` mutates `~/.claude` only when invoked; tests always override
  `HOME`, `CLARITY_INSTALL_DIR`, and `CLARITY_REPO_URL` — never run it without
  those overrides.
- No external accounts, telemetry, or paid APIs — keep it that way
  (`README.md` "What Clarity will never do").

## Done

Branch per change -> PR; a test with a real oracle for new code (extend
`tests/smoke.sh`); `make check` green; CI green before merge; receipts
(commands + output) in the PR body.
