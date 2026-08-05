# SpaceX Orchestrator -- global (Antigravity Desktop)

Real work in a workspace/repo -> check `.orchestrator-lock.json`.
- Missing or not `"enabled": true`: **ask** the human if they want to initialize with Orquestador SX. If approved, **FETCH/COPY** canonical files per `runtime/antigravity/scaffold-manifest.json` — **never generate or invent** SKILL/rules/agents. Never initialize without user approval.
- After human yes: (1) pack `runtime/` in workspace -> copy manifest `source` paths; (2) else fetch raw GitHub [`fronteraespacial/orquestador-sx`](https://github.com/fronteraespacial/orquestador-sx) via manifest `rawBase` (`main` until tag `v1.2.8`; fallback `v1.2.7`); (3) else ask local clone/zip path. See `runtime/antigravity/SCAFFOLD-FETCH.md`.
- Write lock (`source: agent-native`, `version` from fetched pack). **Integrity:** SKILL must contain `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent` — on fail delete fake files, re-fetch, or STOP.
- Lock OK: read `.agents/skills/orchestrator/SKILL.md` via `view_file`; delegate via `define_subagent`/`invoke_subagent`.
- Playground / no repo: ignore this block.

**En criollo (REQUIRED):** close-outs include `## En criollo` at the end (3-6 frases). Solo al cierre; nunca preámbulo.
