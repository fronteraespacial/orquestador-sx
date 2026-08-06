# HYPOTHESIS — Antigravity bootstrap always-on

**Pack baseline:** v1.2.x · **Fecha lab:** 2026-08-05  
**Upstream:** explore `ea1745e3`, scout `c1c5b24e`

---

## Claim principal

Antigravity 2.0 **no** auto-inyecta metodología en conversaciones fuera de un workspace con assets project-level. El pack instala AGY **solo en project scope**; sin `Orchestrator init -Scope project` + abrir ese repo en AGY + rules **Always On**, el hilo principal ignora orchestrator.

---

## Sub-claims (con evidencia explore/scout)

### C1 — Project-only install

`Get-ProjectTemplateMap` copia: `.agents/agents/*`, `.agents/rules/spacex-orchestrator.md`, `.agents/skills/orchestrator/*`, `GEMINI.md`, `AGENTS.md`, `.lab/`.

`Get-UserTemplateMap` **excluye** agents, rules, GEMINI, AGENTS, `.lab/` — solo Cursor + skill global.

**Falsifier:** user init deja `.agents/rules/` o `GEMINI.md` en `$HOME` → **rechazado** (explore: solo skills en `~/.agents/`).

### C2 — Chat “desde cero” sin metodología

Causa compuesta:

1. Playground / repo sin init → no `.agents/rules/`, no lock.
2. `~/.gemini/GEMINI.md` vacío en PC usuario → cero reglas globales.
3. AGY no tiene `alwaysApply` en frontmatter como Cursor; requiere UI **Always On** por regla.

**Falsifier:** AGY carga reglas sin workspace → scout confirma jerarquía pero **global GEMINI** gana solo si existe contenido en home.

### C3 — Gap bootstrap vs Cursor

| Cursor | Antigravity (actual) | Propuesta lab |
|--------|---------------------|---------------|
| `cj-orchestrator-bootstrap.mdc` `alwaysApply: true` | **Ausente** | `draft/cj-orchestrator-bootstrap.md` |
| `cj-criollo-changelog.mdc` `alwaysApply: true` | **Ausente** en `runtime/antigravity/` | `draft/cj-criollo-changelog.md` |
| Lock check en bootstrap | Solo en `AGENTS.md` template (Cursor-centric) | Delta en GEMINI + spacex-orchestrator |

### C4 — Contenido runtime incompleto para bootstrap

`runtime/GEMINI.md` y `runtime/antigravity/rules/spacex-orchestrator.md`: **sí** gates/zero-exec; **no** lock, bootstrap init, En criollo.

`runtime/project/AGENTS.md`: **sí** Bootstrap + En criollo — pero referencia `.cursor/rules/` (no AGY).

### C5 — Docs no cablean flujo AGY

`FIRST-RUN.md` Paso 4 = Cursor-centric; no “abrí Antigravity en repo con init project”.

`antigravity-windows.md`: copy manual; no referencia `Orchestrator.ps1 init -Scope project`.

---

## Fix propuesto (lab drafts → prod post-APPROVE)

### P0 — Bootstrap rule AGY

Nueva regla `.agents/rules/cj-orchestrator-bootstrap.md` (nombre pack):

- Check `.orchestrator-lock.json` antes de trabajo orquestado
- Si missing → ofrecer init (no auto-download)
- Si OK → load `.agents/skills/orchestrator/SKILL.md`
- Instrucción post-install: marcar **Always On** en Customizations

### P0 — Enriquecer capas existentes

- `GEMINI.md`: sección Bootstrap (lock → skill) + pointer a bootstrap rule
- `spacex-orchestrator.md`: idem + En criollo obligatorio en cierres
- `cj-criollo-changelog.md`: regla AGY equivalente a Cursor mdc

### P0 — Docs

- `FIRST-RUN.md`: subsección Antigravity (init → abrir repo → Always On ×2 rules)
- `antigravity-windows.md`: paso 0 = `Orchestrator init -Scope project`; paso UI Always On

### P2 — Home GEMINI micro (opt-in)

Documentar snippet `~/.gemini/GEMINI.md` (~5 líneas: “si estás en repo con lock, cargá skill”). **Nunca** escribir home sin `-ConfirmUserScope` / flag explícito.

---

## Falsifiers globales

| ID | Trigger → verdict |
|----|-------------------|
| F1 | AGY auto-carga rules sin Always On UI → REVISE (frontmatter `always_on` si existe API) |
| F2 | Project init ya incluye bootstrap en map → REVISE scope |
| F3 | User-scope AGY viable sin romper handoff → REVISE arquitectura |
| F4 | Drafts incoherentes con install map → REJECT |

---

## Expected verdict

**APPROVE** si drafts + validate PASS y alineación explore/scout confirmada.
