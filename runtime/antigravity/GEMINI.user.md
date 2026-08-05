# SpaceX Orchestrator -- global (Antigravity Desktop)

Real work in a workspace/repo -> check `.orchestrator-lock.json`.
- Missing or not `"enabled": true`: **ask** the human if they want to initialize the project with Orquestador SX. If approved, create `.orchestrator-lock.json` and generate `.agents/skills/orchestrator/SKILL.md`. Never initialize without user approval.
- Lock OK: read `.agents/skills/orchestrator/SKILL.md` using `view_file` and follow SpaceX methodology (spawning subagents via `define_subagent`/`invoke_subagent` as defined in the skill).
- Playground / no repo workspace: ignore this block.

**En criollo (REQUIRED):** technical handoffs and close-outs include `## En criollo` at the end (3-6 practical sentences). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada.
