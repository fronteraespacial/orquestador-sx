# BRIEF — Antigravity bootstrap always-on

## Goal

Validar en lab que el pack puede cerrar el gap **“chat de 0 sin metodología”** en Antigravity 2.0 cuando el usuario no abrió un repo con `init -Scope project`, y que el cableado propuesto (bootstrap rule + enriquecimiento GEMINI/spacex-orchestrator + docs) es coherente con explore `ea1745e3` y scout `c1c5b24e`.

## Hipótesis bajo prueba

| # | Claim |
|---|--------|
| H1 | AGY es **project-only**; user-scope no instala agents/rules/GEMINI |
| H2 | Chat sin repo init = **sin** lock, rules ni metodología |
| H3 | Falta equivalente Cursor `cj-orchestrator-bootstrap.mdc` (`alwaysApply`) en `.agents/rules/` |
| H4 | `GEMINI.md` + `spacex-orchestrator.md` actuales **no** mencionan lock/bootstrap/En criollo |
| H5 | Docs FIRST-RUN + `antigravity-windows.md` deben pedir: init project → abrir repo en AGY → marcar rules **Always On** |
| H6 | P2 opt-in: snippet `~/.gemini/GEMINI.md` micro — **documentar**, no auto-escribir home sin flag |

## Constraints

- **Lab-only** hasta APPROVE: drafts viven en `.lab/2026-08-05-antigravity-bootstrap/draft/`
- **NO** editar `runtime/` ni docs prod fuera de `.lab/`
- Sin WebSearch (scout ya entregó external contrast)
- Alineado con install map actual (`Get-ProjectTemplateMap`)

## Acceptance

- [ ] Drafts cubren bootstrap (lock → skill), criollo, deltas GEMINI + spacex-orchestrator
- [ ] Draft docs incluyen flujo init + workspace + Always On UI
- [ ] P2 home GEMINI documentado como opt-in explícito
- [ ] `validate-drafts.ps1` PASS (tokens obligatorios)
- [ ] Veredicto: **APPROVE** | **REVISE**

## Out of scope

- Cambios reales en `Install-Orchestrator.ps1` (post-APPROVE implementer)
- Test físico Antigravity UI (checklist manual en REPORT)
- User-scope Antigravity (explícitamente excluido por diseño pack)
