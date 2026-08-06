# SpaceX Orchestrator — bootstrap (Antigravity, agent-native)

**Install path:** `<repo>/.agents/rules/cj-orchestrator-bootstrap.md`  
**Activation:** Customizations → Rules → **Always On** (+ `spacex-orchestrator.md`).

---

## Before orchestrated work

1. Check **`.orchestrator-lock.json`** at repo root (`enabled`, `version`, `sha256`).
2. If **missing** and the user did **not** paste a canonical install link/frase → **ask** if they want agent-native scaffold (see global `~/.gemini/GEMINI.md` block). **Do not** download or init alone.
3. If user **accepts** scaffold → **write lock + materialize** paths from SKILL § Agent-native scaffold (no `Orchestrator.ps1` required).
4. If user pasted canonical install frase → you **may** run documented pack scripts instead (optional advanced path).
5. If `enabled` is **false**, do not insist.
6. If lock OK → load **`.agents/skills/orchestrator/SKILL.md`**; register roles via **`define_subagent`** if needed; delegate via **`invoke_subagent`**.

## Updates

Frase `Actualizá la metodología orquestadora desde GitHub`: `update --check`, short yes before `update --apply`. Else narrate only.

## Antigravity 2.0

- Spawn: **`invoke_subagent`** only — **never** Cursor `Task`.
- Register/repair roles: **`define_subagent`** using SKILL templates.
- **En criollo (REQUIRED):** close-outs include `## En criollo` at the end (3–6 frases).

## Multitask Mode

Build in Parallel does **not** authorize one agent for lab + implement + verify. Parent spawns roles per gates.
