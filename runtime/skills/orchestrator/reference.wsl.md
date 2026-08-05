# Orchestrator — portable WSL wiring

Use this on **WSL / Linux desktop** hosts that are **not** the archived CJ-linux snapshot. Keep methodology identical to [SKILL.md](SKILL.md); only paths and binaries differ.

**Do not use** `reference.cj-linux.md` (archive of a specific CJ-linux install).

## Surfaces (typical)

| CLI | Binary / notes | Spawn | Defs |
|-----|----------------|-------|------|
| **Cursor CLI** | `agent` / `cursor` on PATH or Windows interop | Task / `/name` | `<repo>/.cursor/agents/` |
| **OpenCode** | `opencode` | Task / `@agent` | `~/.config/opencode/opencode.jsonc` + repo `opencode.json` |
| **Antigravity** | `agy` if installed | `invoke_subagent` | `<repo>/.agents/agents/` + `GEMINI.md` |
| **Codex** | if installed | TOML agents | `~/.codex/agents/` |

## Paths

| Piece | Typical WSL location |
|-------|----------------------|
| Skill | `<repo>/.agents/skills/orchestrator/` or `~/.agents/skills/orchestrator/` |
| Cursor agents | `<repo>/.cursor/agents/` (preferred) |
| Lab | **`<repo>/.lab/`** only |
| AGENTS.md | `<repo>/AGENTS.md` (from pack `runtime/project/AGENTS.md`) |

## Policy reminders

- Zero-direct-execution parent (even T0) — same contract as Windows.
- Cursor = **best-effort** audit; configure stronger denies on OpenCode/Codex when available.
- Remap model IDs after `agent --list-models` / `opencode models` / `agy models`. Cursor pack: orchestrator `cursor-grok-4.5-high`; complex/anomaly lab + maverick → `cursor-grok-4.5-high-fast`; clear lab / implementer → `composer-2.5-fast` (see pack `docs/MODEL-ROUTING-POLICY.md`).
- Env-anomaly examples on WSL: Docker Desktop integration, corporate proxy, UDP/WebRTC vs TCP, bind mounts, Windows↔WSL path confusion — still route via **maverick** when T2+ matches; lab under those conditions → Task Grok High Fast.
