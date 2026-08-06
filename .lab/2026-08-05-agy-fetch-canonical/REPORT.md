# REPORT — AGY fetch canonical skill (FETCH not GENERATE)

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05  
**Path:** `.lab/2026-08-05-agy-fetch-canonical/`

---

## Resumen

La hipótesis **FETCH/COPY (never GENERATE)** se confirma contra el pack local **v1.2.8**: la causa raíz (wording “generate” en bootstrap AGY) ya está corregida en prod touchpoints; raw URLs vía `rawBase`+`rawPath` son viables; integrity markers T0–T3 detectan SKILL inventado. `validate-hypothesis.ps1` **PASS**; `Validate-OrchestratorPack.ps1 -Strict` **PASS** (106/106).

---

## FETCH vs GENERATE

| Modelo | Evidencia | Veredicto |
|--------|-----------|-----------|
| **GENERATE** | Plan diagnóstico: GEMINI.user antiguo provocó SKILL ~20 líneas sin gates | **Rechazado** como bootstrap |
| **FETCH/COPY** | GEMINI.user, rules, SKILL § AGY, SCAFFOLD-FETCH, manifest, docs — todos mandan fetch + prohibir inventar | **Aprobado** |

Fuente canónica local: `runtime/skills/orchestrator/SKILL.md` (**346 líneas**, 4/4 markers).  
Fuente remota smoke: `https://raw.githubusercontent.com/fronteraespacial/orquestador-sx/main/runtime/skills/orchestrator/SKILL.md` → **200**, 4/4 markers.

---

## Evidencia lab

| Check | Resultado |
|-------|-----------|
| F1 GEMINI.user FETCH + no generate | PASS |
| F2 manifest `rawBase` + `rawPath` + SCAFFOLD-FETCH | PASS |
| F3 local SKILL integrity + length | PASS (346 lines) |
| F4 touchpoints aligned (6 files) | PASS |
| F4 VERSION 1.2.8 | PASS |
| F5 remote main raw SKILL | PASS |
| F5b rawBaseFallback `v1.2.7` | **WARN** — 404 (tag/path no publicado) |
| validate-hypothesis.ps1 | PASS |
| Validate-OrchestratorPack -Strict | PASS |

---

## Integrity acceptance (implementer T0–T3)

| Tier | Check | On fail |
|------|-------|---------|
| **T0** | GEMINI.user / validator: no “generate SKILL”; must say FETCH/COPY | REJECT deploy |
| **T1** | `scaffold-manifest.json`: `rawBase`, `integrityMarkers`, `rawPath` on required paths | Fix manifest |
| **T2** | Post-scaffold SKILL: all 4 markers + lines >> 100 | Delete fake `.agents/`, re-fetch, STOP |
| **T3** | Lock `source: agent-native`, `version` matches fetched pack; optional `sha256` from SHA256SUMS | Re-scaffold |

**Markers required:** `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent` (manifest + SCAFFOLD-FETCH).

**Invented SKILL symptom:** ~20 lines, missing markers → delete + re-fetch per SCAFFOLD-FETCH.

---

## Gaps operativos (no bloquean APPROVE)

1. **`rawBaseFallback` v1.2.7** → 404 en GitHub hoy; usar **`main`** hasta publicar tag `v1.2.8`.
2. **`SCAFFOLD-FETCH.md`** ejemplos aún citan URLs `v1.2.7` — actualizar post-tag.
3. **Push + tag `v1.2.8`** en `fronteraespacial/orquestador-sx`; luego pin `rawBase` a tag.
4. **`~/.gemini/GEMINI.md`** re-merge humano (`init -Scope user -ConfirmUserScope`).
5. **Smoke AGY Desktop** manual: ask → fetch → integrity → `define_subagent` (fuera de lab).

---

## Implementer checklist (post-APPROVE)

- [ ] Commit/push pack 1.2.8 + tag GitHub `v1.2.8`
- [ ] Pin `rawBase` a `.../v1.2.8`; fix/remove broken fallback o documentar `main`-only
- [ ] Refresh URL examples in SCAFFOLD-FETCH.md
- [ ] Re-merge user GEMINI on dev machines
- [ ] AGY smoke: repo sin lock → ask → FETCH → SKILL >100 lines + 4 markers
- [ ] Verifier pass: no “generate” in GEMINI.user; manifest rawBase present

---

## Lab handoff

- Path: `.lab/2026-08-05-agy-fetch-canonical/`
- Verdict: **APPROVE**
- Evidence: validate-hypothesis.ps1 PASS; pack prod 1.2.8 FETCH-aligned; remote main raw OK; fallback v1.2.7 WARN only
