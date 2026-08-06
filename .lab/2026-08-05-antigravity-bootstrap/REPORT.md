# REPORT — Antigravity bootstrap always-on

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05

---

## Resumen

La hipótesis es **coherente** con explore `ea1745e3` y scout `c1c5b24e`. Antigravity es project-only; chat de 0 sin repo init no tiene metodología. El fix propuesto (bootstrap rule + criollo + deltas GEMINI/spacex-orchestrator + docs init/Always On + P2 home opt-in) cierra el gap vs Cursor sin romper el install map ni user-scope policy.

---

## Evidencia lab

| Check | Resultado |
|-------|-----------|
| Drafts bootstrap + criollo + deltas | PASS — 7 archivos en `draft/` |
| `validate-drafts.ps1` | PASS |
| Alineación explore (project-only, gaps) | PASS |
| Alineación scout (Always On UI, jerarquía AGY) | PASS |
| P2 home GEMINI | PASS — opt-in explícito, no auto-write |
| Falsifiers F1–F4 | No triggered |

---

## Causa raíz confirmada

1. User abrió AGY en playground / repo sin `init -Scope project`.
2. User-scope no instala `.agents/rules/` ni `GEMINI.md`.
3. Sin reglas **Always On** en UI, AGY no equivale a Cursor `alwaysApply`.
4. `~/.gemini/GEMINI.md` vacío → cero capa global.

---

## Promoción post-APPROVE (implementer)

| Prioridad | Acción |
|-----------|--------|
| P0 | Copiar `draft/cj-orchestrator-bootstrap.md` + `draft/cj-criollo-changelog.md` → `runtime/antigravity/rules/` |
| P0 | Añadir entradas en `Get-ProjectTemplateMap` → `.agents/rules/` |
| P0 | Merge deltas en `runtime/GEMINI.md`, `runtime/antigravity/rules/spacex-orchestrator.md` |
| P0 | Merge docs: `FIRST-RUN-antigravity-section`, `antigravity-windows-delta` |
| P1 | Refresh sandbox pilot + `Validate-OrchestratorPack.ps1` (nuevas rules) |
| P2 | Documentar `home-gemini-micro-OPTIN.md` en FIRST-RUN; **sin** flag de install |

---

## Checklist manual AGY (post-prod)

- [ ] `init -Scope project` en sandbox pilot
- [ ] Abrir pilot en Antigravity
- [ ] Marcar 3 rules Always On
- [ ] Chat trabajo → header T0–T3 + mención lock/skill
- [ ] Playground sin repo → **sin** metodología (control negativo)
- [ ] Opt-in home GEMINI: merge manual → repo init sí, playground no

---

## REVISE notes (no bloquean APPROVE)

- Wave-2: validar si AGY 2.0 soporta frontmatter `always_on` en `.agents/rules/` para persistir Always On sin UI.
- Wave-2: smoke automatizado imposible en lab — depende de UI Antigravity.

---

## Lab handoff

- Path: `.lab/2026-08-05-antigravity-bootstrap/`
- Verdict: **APPROVE**
- Evidence: drafts + validate PASS; coherente explore/scout; fix priorizado listo para implementer
