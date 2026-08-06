# SpaceX Orchestrator — bootstrap (Antigravity workspace rule)

**Install path:** `<repo>/.agents/rules/cj-orchestrator-bootstrap.md`  
**Activation:** Customizations → Rules → **Always On** (required — AGY has no Cursor-style `alwaysApply` frontmatter).

---

## Before orchestrated work

1. Check **`.orchestrator-lock.json`** at repo root (`enabled`, `version`, `sha256`).
2. If **missing** and the user did **not** paste a canonical install link/frase (FIRST-RUN, DEVICE-INSTALL-PROMPT, or `Instalá orquestador-sx desde …`), **offer** `Orchestrator init -Scope project` — do **not** download or run init alone from chat.
3. If the user **did** paste that link/frase, you **may** run documented pack scripts (clone/local + init + status; verify SHA256 on release).
4. If `enabled` is **false**, do not insist on orchestration.
5. If lock OK, load **`.agents/skills/orchestrator/SKILL.md`** and follow gates in `.agents/rules/spacex-orchestrator.md`.

## Updates

If the user says `Actualizá la metodología orquestadora desde GitHub`: run `update --check`, ask short yes before `update --apply`. Otherwise narrate only.

## Multitask Mode

Build in Parallel does **not** authorize one agent to run lab + implement + verify + release. Parent Orchestrator spawns roles per gates. Monolithic worker only on explicit human request.

## Antigravity-specific

- This rule complements **`spacex-orchestrator.md`** (gates) — both should be **Always On** after project init.
- **`GEMINI.md`** at repo root is compat redundancy if a build skips `.agents/rules/`.
- **No methodology** applies if you chat outside a repo with project init — open the initialized repo as workspace first.
