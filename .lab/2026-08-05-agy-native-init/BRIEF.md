# BRIEF — Antigravity 2.0 agent-native init (no CLI)

**Fecha:** 2026-08-05  
**Pack:** `spacex-orchestrator-windows-pack` v1.2.x  
**Upstream:** feedback Antigravity Desktop usuario; labs previos `antigravity-bootstrap`, `agy-desktop-global`

## Goal

Validar que el pack puede bootstrap **agent-native** en Antigravity 2.0 Desktop: tras autorización humana (global `GEMINI.user` ask), el agente **materializa** lock + skill + estructura mínima AGY **sin depender de `Orchestrator.ps1 init`**. Subagentes vía **`define_subagent` + `invoke_subagent`** (no Cursor `Task`).

## Hipótesis bajo prueba

| # | Criterio APPROVE |
|---|------------------|
| C1 | `GEMINI.user` ask-first → agent scaffold (lock + paths mínimos) |
| C2 | Bootstrap **no** exige CLI; CLI queda opcional / canonical-frase only |
| C3 | `SKILL.md` delta incluye sección Antigravity 2.0 Desktop + plantillas `define_subagent` (8 roles) |
| C4 | Delegación documentada: `invoke_subagent` primario; `define_subagent` para (re)registrar roles |
| C5 | Lockfile + `## En criollo` al cierre se mantienen |
| C6 | `reference.antigravity.md` opcional; `antigravity-windows.md` delta coherente |

## Constraints

- **Lab-only:** cero edits fuera de `.lab/2026-08-05-agy-native-init/`
- Sin WebSearch
- Read-only a `runtime/` para extraer contenido de plantillas
- Smoke AGY Desktop UI = checklist manual post-promoción

## Acceptance (lab)

- [ ] `HYPOTHESIS.md` con falsifiers
- [ ] Drafts: GEMINI.user, bootstrap-native, SKILL delta, reference.antigravity, docs delta, scaffold-manifest
- [ ] `validate-hypothesis.ps1` PASS
- [ ] Veredicto `APPROVE` | `REVISE` en `REPORT.md`

## Out of scope (implementer)

- Promover drafts a `runtime/` / `docs/`
- Cambiar `Install-Orchestrator.ps1` (CLI sigue para Cursor/sandbox; agent-native es path AGY Desktop)
- Smoke físico Antigravity UI
