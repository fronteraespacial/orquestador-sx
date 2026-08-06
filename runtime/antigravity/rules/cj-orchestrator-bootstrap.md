# SpaceX Orchestrator — bootstrap (Antigravity, agent-native)

**Install:** `<repo>/.agents/rules/cj-orchestrator-bootstrap.md` · **Always On** (Customizations → Rules) + `spacex-orchestrator.md`.

## Before orchestrated work

1. Check **`.orchestrator-lock.json`** (`enabled`, `version`, `sha256`).
2. **Missing** + no canonical install frase → **ask** scaffold (`~/.gemini/GEMINI.md`); **never** download/init alone.
3. **Accepts** → **write lock + FETCH/COPY** from manifest (`runtime/antigravity/scaffold-manifest.json` / `SCAFFOLD-FETCH.md`); **never invent** SKILL.
4. Pasted install frase → may run pack scripts (optional). `enabled: false` → don't insist.
5. Lock OK → load **`.agents/skills/orchestrator/SKILL.md`**; roles via **`define_subagent`** (include **`VerifierLikeHuman`**); delegate **`invoke_subagent`**.

## Updates · Antigravity 2.0 · Multitask (hard)

Updates: frase `Actualizá la metodología orquestadora desde GitHub` → `update --check`, yes before `update --apply`; else narrate only.
Spawn **`invoke_subagent`** only (never Cursor `Task`); repair roles **`define_subagent`**. Close-outs: **`## En criollo`** (3–6 frases).
- **Multitask ≠ monolith:** parallel UI does **not** authorize one `generalPurpose`/Composer for lab+implement+verify+release — spawn **`scout`/`maverick` → `lab-runner` (APPROVE) → `implementer` → `verifier` → `verifier-like-human` (if T2/T3 human-facing)** as distinct **`invoke_subagent`**.
- **Composer = bounded/surgical only** — light reads/scoped implementer, Lab Batch ≥2 labs; **not** single-lab (high-reasoning remap), pipeline, VLH/Maverick (**Host remap** high-reasoning / Grok only if host offers it; AGY: named remap e.g. `gemini-3.1-pro-high`), or parent Orchestrator.
- **Composer compensation:** same-role bounded iterations — **not** mega-pipeline.
- **YIELD_PLAN / Plan Mode:** after orch `YIELD_PLAN`, human opens AGY **Planning Mode** + **Artifact Review** (**Request Review** / **Proceed**) — agents **ask/narrate only**; never claim silent auto mode change.
