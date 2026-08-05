# Agent-native scaffold manifest (Antigravity Desktop)

When a human accepts Orquestador SX prep in Antigravity Desktop, the agent **FETCH/COPY** the minimum tree listed in [`runtime/antigravity/scaffold-manifest.json`](../../runtime/antigravity/scaffold-manifest.json). **Never generate or invent** SKILL/rules/agents.

## Quick reference

| Item | Detail |
|------|--------|
| Lock | `.orchestrator-lock.json` with `source: agent-native` |
| Skill | `.agents/skills/orchestrator/SKILL.md` (+ optional `reference.antigravity.md`) — **from pack or GitHub raw** |
| Rules | `.agents/rules/cj-orchestrator-bootstrap.md`, `spacex-orchestrator.md` |
| Agents | 8 roles under `.agents/agents/<role>/agent.md` |
| Compat | `GEMINI.md` merge (never overwrite human rules) |
| Lab | `.lab/README.md` |
| Fetch guide | [`runtime/antigravity/SCAFFOLD-FETCH.md`](../../runtime/antigravity/SCAFFOLD-FETCH.md) |

## GitHub raw

Manifest field `rawBase` (currently `main` until tag `v1.2.8`; fallback `v1.2.7`). Per-file URL: `{rawBase}/{rawPath}`.

## Integrity markers (required in SKILL.md)

After fetch/copy, verify SKILL contains **all** of:

- `T0–T3`
- `Zero direct execution`
- `lab-runner`
- `invoke_subagent`

If any marker missing or SKILL is suspiciously short → delete fake `.agents/` tree, re-fetch, or STOP.

After scaffold: **`define_subagent`** per role (SKILL § Antigravity 2.0 Desktop), then **`invoke_subagent`** for delegation.

CLI `Orchestrator.ps1 init -Scope project` remains valid as Path B (sandbox/CI/canonical-frase).

See also: [`docs/human/install/antigravity-windows.md`](../human/install/antigravity-windows.md), [`runtime/skills/orchestrator/reference.antigravity.md`](../../runtime/skills/orchestrator/reference.antigravity.md).
