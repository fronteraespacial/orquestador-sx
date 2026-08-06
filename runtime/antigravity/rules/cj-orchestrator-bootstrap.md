# SpaceX Orchestrator — bootstrap (Antigravity, agent-native)

**Install:** `<repo>/.agents/rules/cj-orchestrator-bootstrap.md` · **Always On** (Customizations → Rules) + `spacex-orchestrator.md`.

## Before orchestrated work

1. Check **`.orchestrator-lock.json`** (`enabled`, `version`, `sha256`).
2. **Missing** + no canonical install frase → **ask** scaffold (`~/.gemini/GEMINI.md`); **never** download/init alone.
3. **Accepts** → **write lock + FETCH/COPY** from manifest (`runtime/antigravity/scaffold-manifest.json` / `SCAFFOLD-FETCH.md`); **never invent** SKILL.
4. Pasted install frase → may run pack scripts (optional). `enabled: false` → don't insist.
5. Lock OK → load **`.agents/skills/orchestrator/SKILL.md`**; roles via **`define_subagent`**; delegate **`invoke_subagent`**.

## Updates · Antigravity 2.0 · Multitask (hard)

Updates: frase `Actualizá la metodología orquestadora desde GitHub` → `update --check`, yes before `update --apply`; else narrate only.
Spawn **`invoke_subagent`** only (never Cursor `Task`); repair roles **`define_subagent`**. Close-outs: **`## En criollo`** (3–6 frases).
- **Multitask ≠ monolith:** parallel UI does **not** authorize one `generalPurpose`/Composer for lab+implement+verify+release — spawn **`scout`/`maverick` → `lab-runner` (APPROVE) → `implementer` → `verifier`** as distinct **`invoke_subagent`**.
- **Composer = bounded/surgical only** — light reads/scoped implementer; **not** lab-runner, pipeline, or parent Orchestrator.
