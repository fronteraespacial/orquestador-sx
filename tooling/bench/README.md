# Cursor benchmark — SpaceX Orchestrator

Scaffold reproducible con dos modos de ejecución **separados** (no confundir telemetría). El benchmark es **opcional**: la política de modelos del pack ya está fijada en [`docs/MODEL-ROUTING-POLICY.md`](../docs/MODEL-ROUTING-POLICY.md) y **no** espera un “ganador” local.

| Modo | Qué mide | Evidencia stream |
|------|----------|------------------|
| **routing** (`orchestrator_delegate`) | Orchestrator → Task, padre Grok vs Composer | `delegation_status=stream_proven` + heurísticas |
| **direct_role_control** | Rol invocado directo, Grok vs Composer | **Root** `role_model_resolved` stream_proven + DoD rol |

> **Limitación CLI:** Nested Task subagent model telemetry unavailable in this CLI stream-json. Los smokes con `measurement_type=role` (frontmatter patch) **no** demuestran modelo hijo — conservar JSONL fallidos como evidencia, no para conclusiones.
>
> La comparación válida **no** afirma modelos hijos nested no observables. Solo routing (padre + Task) y role control directo (root model).

## Diseño piloto

| Dimensión | Valor |
|-----------|-------|
| Categorías | 4 — maverick/anomaly, scout/contrast, lab/greenfield, writer/bounded |
| Modelos | Arms Grok vs Composer en routing padre **y** en direct role — para **evidencia**, no para declarar ganador con grids incompletos |
| Réplicas | 3 |
| Casos | 16 (8 routing + 8 direct_role_control) → 48 ejecuciones |

## routing (orchestrator → Task)

- Prompt: `orchestrator-delegate-wrapper.md` + envelope
- `agent -p --model <parent> --trust --output-format stream-json` (solo worktrees bajo `bench/worktrees/`)
- **Pasa** si: exit 0, `delegation_status=stream_proven`, tests OK
- Verifica zero-direct-execution / routing real

## direct_role_control

- Prompt: `direct-role-wrapper.md` + contrato `.cursor/agents/<role>.md` + envelope
- `agent -p --model <Grok|Composer> --trust` — modelo demostrable como **root stream model**
- Casos usan `role_model_requested` (nunca `parent_model_requested`)
- **No** es telemetría de subagente anidado ni prueba de que Cursor emitió child model events
- **Pasa** si: exit 0, `role_model_resolved_status=stream_proven`, tests/DoD rol
- Paths aislados: writer → solo `.bench-marker/marker.txt`; lab → solo `.lab/...`

## Reglas

| Regla | Detalle |
|-------|---------|
| Dry-run | Sin artefactos |
| Trust | `--trust` **solo** en worktrees generados bajo `bench/worktrees/`; `-NoTrustWorktree` desactiva |
| YOLO | **Nunca** `--yolo` |
| Abort | `Workspace Trust Required` detiene el piloto |
| Exit final | 0 solo si todos los casos pasan criterios de su modo; excepción runtime → `_summary` failed + exit 1 |
| Winner | **Prohibido** declarar ganador con JSONL trust-blocked, nested-telemetry, o interrupted sin `_summary` |

## Política vs benchmark

La asignación operativa vive en [`docs/MODEL-ROUTING-POLICY.md`](../docs/MODEL-ROUTING-POLICY.md) / [`07-MODELS-MATRIX.md`](../07-MODELS-MATRIX.md). CursorBench externo (Grok 4.5 High vs Composer 2.5) **no** mide variantes Fast exactamente. Reanudar el grid es opcional y **no bloquea** implementación ni releases del pack.

## Uso (reanudar sin bloquear)

```powershell
# Preflight — no gasta cuota
.\bench\Run-Benchmark.ps1

# Smoke acotado (1 réplica)
.\bench\Run-Benchmark.ps1 -Run -Replicas 1 -CaseFilter direct-scout-contrast-grok

# Grid completo solo con cuota/tiempo
.\bench\Run-Benchmark.ps1 -Run

# Reporte markdown (no declara ganador con datos inconclusos)
.\bench\Summarize-Benchmark.ps1 -JsonlPath .\bench\results\<run-id>.jsonl -OutputPath .\bench\results\<run-id>.md
```

## Archivos

- `cases/manifest.json` v1.3.0
- `cases/prompts/direct-role-wrapper.md`
- `Run-Benchmark.ps1`, `Summarize-Benchmark.ps1`
- `schema/result-record.schema.json` v1.3.0

## Smokes de evidencia

| JSONL | Uso |
|-------|-----|
| `20260805-164541-7fb5ab8a.jsonl` | **Válido** — routing smoke Grok (`stream_proven`) |
| `20260805-165955-b686bd26.jsonl` | **Válido** — direct_role_control smoke Grok + `_summary` passed |
| `20260805-164220-a1ac3e7f.jsonl` | Trust-blocked — **inconcluso**; no conclusiones |
| `20260805-164654-d15e0bea.jsonl` | Nested telemetry / legacy — **inconcluso** |
| `20260805-170119-1cd75f23` | 11/48 interrupted, sin `_summary` — **inconcluso** |

**No** hay conclusión local de superioridad Grok-vs-Composer a partir de estos artefactos.
