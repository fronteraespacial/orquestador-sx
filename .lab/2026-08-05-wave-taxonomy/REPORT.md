# REPORT — Wave taxonomy redesign

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05

## Resumen

La taxonomía propuesta resuelve la colisión documentada **Wave 0–3** (canon 02 / SKILL header) vs **Oleada 0–3** (canon 01) reutilizando los mismos nombres de fase que el pack ya enumera (`prep`, `research-lab`, `execute`, `verify`) pero **sin números P0–P3**. Introduce capas faltantes (**Run**, **Batch**, **Retry**) alineadas con doctrina existente (zero-exec, verifier close-gate, cascade +1, ESCALATE@2, no T4).

## Validación H1–H7

| ID | Resultado | Evidencia |
|----|-----------|-----------|
| H1 Fase nombrada | ✅ Pass | Mapeo 1:1 Wave/Oleada 0–3 → 4 fases; header SKILL ya incluye sufijo `— prep\|…` |
| H2 Oleada O1–O3 | ✅ Pass | O1=ciclo inicial; O2=correctivo local; O3=escalado+research-lab; O4 ausente por default |
| H3 Run R-… | ✅ Pass | Estabiliza narrativa multi-oleada; no contradice gate interno |
| H4 Batch vs Spawn | ✅ Pass | Batch=fan-out; Spawn=1 hijo; multitask rule SKILL §253–273 preservada |
| H5 Retry ≠ Oleada | ✅ Pass | Retry acotado a verify transient / ESCALATE@2; O2+ implica nuevo ciclo |
| H6 verify FAIL matrix | ✅ Pass | 5 filas cubren transient, local, diseño/env, post-O3, T3 ceiling |
| H7 Paralelo REQUIRED | ✅ Pass | Serial solo lab→implementer→verifier; T2+ disjoint → Batch obligatorio |

## Desk walkthrough (5 escenarios)

| Escenario | Trayectoria | Transición clave |
|-----------|-------------|------------------|
| A T0 typo | R-fix · O1 · prep→execute→verify | Sin O2; 2–3 Spawn |
| B T2 refactor | R-refactor · O1 · research-lab **B-split** → verify | Serial lab APPROVE antes execute |
| C FAIL local | R-bug · O1 verify FAIL → **O2** execute→verify | No Retry confundido con O3 |
| D FAIL diseño | R-green · O1 FAIL → cascade T→T+1 · **O3** research-lab | Lab gate intacto |
| E T3 ceiling | R-feat · T3 · O3 FAIL → **ESCALATE/STOP** | No T4 |

## Falsifiers

| ID | Triggered? |
|----|------------|
| F1 unmapped fase | No |
| F2 ambiguous FAIL route | No — matriz prioriza transient→Retry antes de O2 |
| F3 Batch=Spawn | No |
| F4 infinite Retry/O2 | No — ESCALATE@2 + O3 cap |
| F5 optional fan-out | No — H7 explicit REQUIRED |
| F6 T4/O4 default | No |

## Riesgos menores (no bloquean)

1. **Migración header:** convivencia temporal `## Wave:` alias → `## Fase:` en una release (REVISE doc-only, no REJECT).
2. **Envelope fields:** canon 02 §5 lista “Wave” en sobres — renombrar a Fase+Oleada+Run en implementer oleada doc.
3. **ES vs EN:** mantener “oleada” en criollo; IDs `O1`/`R-` en headers técnicos.

## Archivos prod post-APPROVE (implementer doc oleada)

| Archivo | Cambio |
|---------|--------|
| `runtime/skills/orchestrator/SKILL.md` | §Waves → §Fases/Oleadas; header template |
| `canon/01-METHODOLOGY-SPACEX.md` | §6 Oleadas 0–3 → taxonomía Run/Oleada/Fase |
| `canon/02-ROLES-HANDOFFS-GATES.md` | §3 diagrama + envelope fields |
| `runtime/cursor/agents/orchestrator.md` | Header + routing narrative |
| `AGENTS.md` / `runtime/project/AGENTS.md` | Gates summary 1 párrafo |
| `canon/09-VERIFY-CHECKLIST.md` | Smoke “Wave 0→ explore” → Fase prep |

## Lab handoff

```markdown
## Lab handoff
- Path: .lab/2026-08-05-wave-taxonomy/
- Verdict: APPROVE
- Evidence: H1–H7 pass; 5 desk scenarios; F1–F6 none; ≤6 prod files; resolves Wave/Oleada collision; verify FAIL matrix complete; parallel Batch REQUIRED rule explicit
```

**Siguiente:** Orchestrator → implementer doc oleada (sin código runtime) → verifier checklist smoke.
