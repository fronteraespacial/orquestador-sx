# SpaceX Orchestrator — bootstrap (Always On)

**Install path:** `<repo>/.agents/rules/cj-orchestrator-bootstrap.md`  
**Human setup:** Antigravity → **Customizations** → mark this rule **Always On** (same for `spacex-orchestrator.md`).

When doing real work in a repo: check `.orchestrator-lock.json`. If missing and the user did **not** paste a canonical install link/frase (FIRST-RUN, DEVICE-INSTALL-PROMPT, or `Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx`), **offer** `Orchestrator init` — do not download or run init alone. If the user **did** paste that link/frase, you **may** run the documented pack scripts (clone/local + init + status; verify SHA256 on release). If `enabled` is false, do not insist. If lock OK, load `.agents/skills/orchestrator/SKILL.md`. For updates: if the user says `Actualizá la metodología orquestadora desde GitHub`, run `update --check` then ask for a short yes before `update --apply`; otherwise narrate only.

**En criollo (REQUIRED):** every implementer handoff and technical close-out includes `## En criollo` **at the end** (3–6 plain sentences: what changes in practice for human/team/device — install, update, chats, models, links, friction). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. See `.cursor/rules/cj-criollo-changelog.mdc` (Cursor) and `AGENTS.md` / skill.

**Multitask Mode:** Build in Parallel does **not** authorize one agent to run lab + implement + verify + release. Parent Orchestrator must spawn roles (`lab-runner` → `implementer` → `verifier`; scout/maverick per gates). Monolithic worker only on explicit human request.
