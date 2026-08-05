# Orchestrator — portable wiring (Windows-first)

Primary reference for this pack. CJ-linux snapshot: `reference.cj-linux.md` (**archive only — do not use**). WSL hosts: [reference.wsl.md](reference.wsl.md).

## Surfaces

| CLI | Spawn | Agent defs | Root policy |
|-----|-------|------------|-------------|
| **Cursor** | Task tool, `/name` | `.cursor/agents/*.md` | rules + skill; orchestrator **best-effort** zero-exec |
| **Antigravity** | `invoke_subagent` | `.agents/agents/<role>/agent.md` | `GEMINI.md` |
| **OpenCode** | Task / `@agent` | `opencode.json(c)` | orchestrator edit/bash deny when configured |
| **Codex** | TOML agents / Task | `.codex/agents/*.toml` | `developer_instructions` / `AGENTS.md` |

## Hard rules

1. **Never** document `invoke_subagent` as Cursor API.
2. **Never** assume Cursor loads `.agents/agents/`.
3. Prefer project-level `.cursor/agents/` (CLI may miss user-level).
4. Models: list on host, then remap (`agent --list-models`, `agy models`, `opencode models`). Cursor pack pins: see below.
5. Gates: Scout soft; Lab greenfield REQUIRED under **`.lab/`**; Maverick env-anomaly T2+ REQUIRED; Verifier after implementer; waves 0–3; zero-exec parent.
6. Cursor can **audit** zero-exec (readonly + logs); it cannot **fully enforce** it — OpenCode/Codex deny is stronger when wired.

## Cursor model defaults (pack)

| Role | ID | Notes |
|------|-----|-------|
| orchestrator | `cursor-grok-4.5-high` | Explicit; not `inherit` |
| maverick | `cursor-grok-4.5-high-fast` | Always |
| lab-runner | `composer-2.5-fast` default; Task → `cursor-grok-4.5-high-fast` if T2/T3 / ambiguous / anomaly | Do not force Grok on every simple lab |
| implementer, explore, scout, verifier, skeptic, deletion | `composer-2.5-fast` | Corrective: one Grok High Fast pass after failed verifier |

Policy + evidence tiers: pack `docs/MODEL-ROUTING-POLICY.md`. Matrix: `07-MODELS-MATRIX.md`.

## Lab (canonical)

- Path: **`.lab/`** at repo root — **not** `projects/.lab/`
- Classical: `YYYY-MM-DD-<slug>/`
- Maverick: `YYYY-MM-DD-mav-<slug>/`
- Prod write only after **APPROVE**

## Shared handoff (optional)

e.g. `agent-handoff.md` — read at session start, append compact deltas before end.
