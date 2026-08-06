# HYPOTHESIS — Wave taxonomy redesign

## Primary hypothesis

> Separar **Tier** (T0–T3), **Run** (R-…), **Oleada** (O1–O3), **Fase** (prep \| research-lab \| execute \| verify), **Batch** (B-…), **Spawn** (1 hijo) y **Retry** (técnico intra-fase) elimina la colisión Wave/Oleada y hace explícitas las transiciones post-verify FAIL, sin introducir T4 ni O4 por defecto.

## Glosario (jerarquía)

```text
Run R-<slug>           objetivo del usuario (puede abarcar O1→O3)
└─ Oleada O1|O2|O3     ciclo completo de fases
   └─ Fase             prep → research-lab → execute → verify (omitir vacías)
      └─ Batch B-<n>   N spawns paralelos + fan-in (orquestador merge deltas)
      └─ Spawn         exactamente 1 hijo (nunca etiquetar como oleada)
      └─ Retry         reintento técnico dentro de la misma fase/batch (≤2; ESCALATE@2)
```

| Símbolo | Significado | Prohibido |
|---------|-------------|-----------|
| **T0–T3** | Complejidad / router gates | T4 |
| **R-…** | Run ID estable por pedido usuario | Reusar R entre prompts distintos |
| **O1** | Primer ciclo completo | — |
| **O2** | Ciclo correctivo (fix acotado) | O4 salvo freno humano explícito |
| **O3** | Ciclo escalado (+ scout/maverick/lab según gate) | O4 por defecto |
| **Fase** | Nombre, no número | P0–P3, “Wave 2” en header nuevo |
| **B-…** | Paralelo independiente | Batch cuando hay dep serial real |
| **Spawn** | Un rol, un sobre | Multiplexar roles en un spawn |
| **Retry** | Misma fase/batch, mismo envelope delta | Confundir con O2 |

### Mapeo legacy (compat narrativa)

| Legacy | Nuevo |
|--------|-------|
| Wave 0 / Oleada 0 prep | O1 · fase **prep** |
| Wave 1 / Oleada 1 research | O* · fase **research-lab** |
| Wave 2 / Oleada 2 execute | O* · fase **execute** |
| Wave 3 / Oleada 3 verify | O* · fase **verify** |
| Segundo ciclo tras FAIL local | **O2** (no “Wave 4”) |
| Tercer ciclo + contraste/scout | **O3** |

## Header propuesto (orquestador)

```markdown
## Complexity: T<0|1|2|3> — <reason>
## Role: Orchestrator
## Action: Delegate to subagent
## Run: R-<slug>
## Oleada: O<1|2|3> — <initial|corrective|escalated>
## Fase: <prep|research-lab|execute|verify>
## Batch: B-<id>|—   (— = spawn único o prep sin hijos)
```

## verify FAIL → transición

| Evidencia verifier | Acción | Oleada / Fase |
|--------------------|--------|---------------|
| **Transient** (flake, timeout, red) | **Retry** en fase verify (mismo batch) | O* · verify |
| **Localized reproducible** (1–2 archivos, DoD claro) | **O2**: triage prep → execute correct → reverify | O2 · execute→verify |
| **Hypothesis / design / env / mismo fingerprint** | **O3** con fase **research-lab** (+ lab/scout/maverick según gate); cascade +1 tier si T<T3 | O3 · research-lab→… |
| Tras **O3**, budget agotado, o riesgo alto | **ESCALATE / STOP** + freno humano | — |
| Cascade cuando ya **T3** | **ESCALATE** (no T4) | — |

**Cascade +1 tier:** solo en O3 path por FAIL de diseño/hipótesis; nunca abrir T3 por un solo test rojo (doctrina actual).

## Paralelismo

| Condición | Modo | Ejemplo |
|-----------|------|---------|
| Workstreams **independientes** | **Batch B-… REQUIRED** (fan-out + fan-in) | B-docs: implementer A ∥ implementer B |
| Dep **real** | Serial | lab **APPROVE** → implementer → verifier |
| Multitask / Build in Parallel | Varios **Spawn** o un **Batch**; **no** monolito generalPurpose | scout ∥ explore en research-lab |

## Falsifiers

| ID | Observation → REVISE/REJECT |
|----|------------------------------|
| F1 | Alguna fase legacy (0–3) no mapea 1:1 a nombre |
| F2 | verify FAIL deja transición ambigua (≥2 rutas igualmente válidas sin gate) |
| F3 | Batch y Spawn intercambiables en texto/canónico |
| F4 | O2 u O3 duplican Retry técnico sin límite → bucle infinito |
| F5 | Fan-out independiente sigue siendo opcional en T2+ |
| F6 | T4 o O4 aparecen como rutas default |

## Test design (desk validation)

1. **Escenario A (T0 feliz):** R-fix-typo · O1 · prep→execute→verify · Spawn explore/implementer · PASS sin O2.
2. **Escenario B (T2 fan-out):** R-refactor-api · O1 · research-lab Batch B-split (implementer×2) · verify · deps: lab APPROVE serial antes de execute.
3. **Escenario C (verify FAIL local):** R-bug-login · O1 verify FAIL reproducible · O2 execute patch · verify PASS.
4. **Escenario D (verify FAIL diseño):** R-greenfield · O1 verify FAIL mismo fingerprint · cascade T2→T3 · O3 research-lab + lab REVISE/APPROVE · O3 execute.
5. **Escenario E (T3 cascade ceiling):** R-feature · T3 · O3 verify FAIL diseño otra vez → ESCALATE/STOP (no T4).

## Success metric

PASS si H1–H7 hold en los 5 escenarios, ningún F1–F6, y lista de archivos prod es finita (≤8).
