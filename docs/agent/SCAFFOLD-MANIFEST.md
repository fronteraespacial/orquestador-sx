# Agent-native scaffold manifest (Antigravity Desktop)

When a human accepts Orquestador SX prep in Antigravity Desktop, the agent materializes the minimum tree listed in [`runtime/antigravity/scaffold-manifest.json`](../../runtime/antigravity/scaffold-manifest.json).

## Quick reference

| Item | Detail |
|------|--------|
| Lock | `.orchestrator-lock.json` with `source: agent-native` |
| Skill | `.agents/skills/orchestrator/SKILL.md` (+ optional `reference.antigravity.md`) |
| Rules | `.agents/rules/cj-orchestrator-bootstrap.md`, `spacex-orchestrator.md` |
| Agents | 8 roles under `.agents/agents/<role>/agent.md` |
| Compat | `GEMINI.md` merge (never overwrite human rules) |
| Lab | `.lab/README.md` |

After scaffold: **`define_subagent`** per role (SKILL § Antigravity 2.0 Desktop), then **`invoke_subagent`** for delegation.

CLI `Orchestrator.ps1 init -Scope project` remains valid as Path B (sandbox/CI/canonical-frase).

See also: [`docs/human/install/antigravity-windows.md`](../human/install/antigravity-windows.md), [`runtime/skills/orchestrator/reference.antigravity.md`](../../runtime/skills/orchestrator/reference.antigravity.md).
