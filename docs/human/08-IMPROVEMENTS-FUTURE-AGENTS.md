# 08 — Mejoras futuras (backlog)

El instalador **no** se bloquea aquí.

## 1. Subagentes opcionales

| Nombre | Job | Write? |
|--------|-----|--------|
| **skeptic** | Atacar requisitos T3 | No |
| **integrator** | Plan de merge de labs APPROVE | No (o solo `.lab/integration-…`) |
| **pruner** / delete-check | Proponer borrados post-implementer | No |
| **telemetry** | Métricas DoD antes de verifier | No |
| **reliability** | Casos de fallo para lab | Solo `.lab/` |
| **chronicle** | Un writer de `agent-handoff.md` | Solo handoff |
| **range-safety** | Checklist antes de ops destructivas | No |

Prioridad si sumás uno: **skeptic** → **pruner**.

## 2. Refuerzos de proceso

1. Scoring post-corrida: tier, cascade?, lab?, contraste útil?, candidatos cosechados.
2. Biblioteca de sobres por tipo de tarea (genéricos; sin dominio propietario).
3. Señal automática de paths disjuntos para fan-out seguro.
4. `MODELS.local.md` por máquina.
5. SemVer del pack + changelog cuando cambien gates.
6. CI smoke de presencia de archivos (sin LLM).
7. Medir violaciones zero-exec en Cursor (best-effort) vía logs/handoff.

## 3. Algorithm → gaps

| Paso | Gap | Mejora |
|------|-----|--------|
| Requirements | Saltar a código | Gate explore/scout en T2+ |
| Delete | Solo mención | pruner o checklist verifier |
| Simplify | — | Skeptic “¿un paso menos?” |
| Accelerate | Fan-out ≠ acelerar | Telemetry de loop |
| Automate | Candidatos sin triage | Chronicle + “now/backlog/discard” |

## 4. Riesgos al sumar roles

- Más roles → más tokens y gates ignorados.
- Mantener ≤8 en la routing table del skill.
- Cada rol nuevo: spawn, handoff ≤40, modelo, una línea en skill.

## 5. Host notes (sin dominio de producto)

- Windows: `%USERPROFILE%`, `%APPDATA%` (03–06).
- WSL: usar `runtime/skills/orchestrator/reference.wsl.md`.
- Env-anomaly ejemplos portables: WSL2, Docker, proxy, Defender locks — no cablear stacks de un repo concreto.
- Handoff compartido: un `agent-handoff.md` por repo.
