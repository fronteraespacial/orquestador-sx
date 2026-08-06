# BRIEF — AGY fetch canonical skill (FETCH not GENERATE)

**Lab ID:** `2026-08-05-agy-fetch-canonical`  
**Pack baseline:** v1.2.8 (local) · **Fecha:** 2026-08-05  
**Plan (read-only):** `agy_fetch_real_skill_f887d5f4.plan.md`

## Problema

Antigravity Desktop bootstrap usaba wording **generate** en `GEMINI.user`, provocando SKILL inventado (~20 líneas) sin T0–T3, zero-exec, gates Lab/Maverick/Verifier. El canónico vive en `runtime/skills/orchestrator/SKILL.md` (~345 líneas local) + reference + 8 agents.

## Objetivo lab

Validar que **FETCH/COPY** desde fuente canónica (pack local → GitHub raw → clone/zip) es el modelo correcto, con **integrity markers T0–T3** post-materialización — sin editar prod fuera de este dir.

## Alcance

- Read-only contra pack `runtime/antigravity/*`, SKILL, docs, validators
- Script `validate-hypothesis.ps1` + veredicto en `REPORT.md`
- **No** inventar SKILL; **no** promover drafts a prod desde lab

## Fuera de alcance

- Re-merge humano `~/.gemini/GEMINI.md` (checklist implementer)
- Smoke AGY Desktop en máquina destino
- Push/tag GitHub `v1.2.8`
