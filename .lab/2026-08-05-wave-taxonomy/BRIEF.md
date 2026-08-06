# BRIEF — Wave taxonomy redesign (Tier / Run / Oleada / Fase / Batch)

## Goal

Validar **solo en diseño** que la taxonomía propuesta desambigua el pack v1.2.x sin romper zero-exec, gates (scout/lab/maverick/verifier), cascade T0–T3 ni handoffs ≤40.

## Problema baseline

| Término hoy | Uso actual | Conflicto |
|-------------|------------|-----------|
| **Wave 0–3** | Header + canon 02 | Número = fase dentro de un ciclo |
| **Oleada 0–3** | canon 01 | Mismo número, distinto significado (ciclo completo vs fase) |
| *(ausente)* | — | No hay ID de objetivo usuario (`Run`) ni de fan-out paralelo (`Batch`) |
| **Retry** | implícito en ESCALATE | Mezclado con oleada correctiva |

## Hipótesis bajo prueba

| # | Claim |
|---|--------|
| H1 | **Fase** con nombre (`prep` \| `research-lab` \| `execute` \| `verify`) reemplaza Wave/P0–P3 sin pérdida semántica |
| H2 | **Oleada O1–O3** modela ciclos completos (inicial / correctivo / escalado); no O4 por defecto |
| H3 | **Run R-…** ancla el objetivo del usuario a través de oleadas |
| H4 | **Batch B…** + **Spawn** separan fan-out paralelo de un hijo único |
| H5 | **Retry** (técnico, misma fase/batch) ≠ transición de oleada |
| H6 | Matriz **verify FAIL → transición** es completa y no contradice cascade/ESCALATE |
| H7 | Fan-out paralelo **REQUIRED** si workstreams independientes; serial solo con deps reales |

## Constraints

- **Lab-only:** cero edits fuera de `.lab/2026-08-05-wave-taxonomy/`
- Max tier **T3**; cascade en T3 → **ESCALATE** (no T4)
- Spawn nunca es una oleada; oleada nunca es un spawn
- Compat: mapeo 1:1 desde Wave 0–3 / Oleada 0–3 legacy documentado

## Acceptance (diseño)

- [ ] Glosario + reglas de composición (`Run` ⊃ `Oleada` ⊃ `Fase` ⊃ `Batch|Spawn`)
- [ ] Tabla verify FAIL → `{Retry \| O2 \| O3+research-lab \| ESCALATE/STOP}`
- [ ] ≥3 escenarios walkthrough (T0 feliz, T2 fan-out, verify FAIL → O2)
- [ ] Lista de archivos prod a tocar post-APPROVE (canon 01/02, SKILL, orchestrator.md)
- [ ] Veredicto lab: **APPROVE** \| **REVISE** \| **REJECT** \| **YIELD**

## Out of scope

- Editar canon/skill/agents en esta corrida
- Cambiar spawn API Cursor/Antigravity
- Automatizar header parsing en scripts
