# BRIEF — Antigravity Desktop global micro-bootstrap

**Fecha:** 2026-08-05  
**Pack:** `spacex-orchestrator-windows-pack` v1.2.x  
**Contraste scout:** `~/.gemini/GEMINI.md` es capa **global always-on** en Antigravity 2.0 Desktop; el pack hoy excluía AGY del user scope (lab previo `antigravity-bootstrap` → P2 solo documentar).

## Goal

Validar que **user-scope init** (`-ConfirmUserScope` / `--yes`) puede cargar metodología **automáticamente** en Antigravity Desktop Windows (no CLI) vía merge en `%USERPROFILE%\.gemini\GEMINI.md` / `~/.gemini/GEMINI.md`, sin depender de marcar Always On manual para el micro-bootstrap. En chat nuevo con repo abierto, el agente debe **preguntar** si preparar el proyecto con Orquestador SX — nunca init silencioso.

## Hipótesis bajo prueba

| # | Criterio APPROVE |
|---|------------------|
| C1 | User-scope escribe/mergea micro bootstrap en `.gemini/GEMINI.md` (Win + Unix) |
| C2 | Contenido: repo sin lock → **preguntar** preparación; sí → guiar/ejecutar `init -Scope project`; **never silent install** |
| C3 | Opcional: `.gemini/AGENTS.md` stub corto |
| C4 | Micro-bootstrap **no** requiere Always On manual (Always On queda para rules de repo post-init) |
| C5 | Project rules/agents/skill siguen vía `init -Scope project` (map sin regresión) |

## Constraints

- **Lab-only:** cero edits fuera de `.lab/2026-08-05-agy-desktop-global/`
- Referencia read-only a `runtime/antigravity/GEMINI.user.md` y scripts de install ya presentes en working tree
- Sin WebSearch; contraste scout ya en envelope
- Smoke AGY Desktop UI = checklist manual post-promoción

## Baseline (gap confirmado)

| Área | Antes | Propuesta |
|------|-------|-----------|
| User scope | Solo Cursor + skill global | + merge `.gemini/GEMINI.md` |
| Chat AGY sin init | Sin metodología | Global GEMINI pregunta + ofrece init |
| Always On UI | Requerido para todo | Solo rules project-level post-init |
| Lab previo P2 | Documentar snippet, no escribir home | **Cambio política:** escribir con `-ConfirmUserScope` |

## Acceptance (lab)

- [ ] `HYPOTHESIS.md` con falsifiers
- [ ] `simulate-merge.ps1` PASS en temp (fresh / append / refresh)
- [ ] `validate-hypothesis.ps1` PASS contra criterios C1–C5
- [ ] Veredicto `APPROVE` | `REVISE` en `REPORT.md`

## Out of scope (implementer)

- Promover cambios a `runtime/` o `tooling/scripts/` (ya parcialmente en working tree)
- Sync docs `antigravity-windows.md`, `FIRST-RUN.md`, `CHANGELOG.md`
- Smoke real Antigravity Desktop UI
