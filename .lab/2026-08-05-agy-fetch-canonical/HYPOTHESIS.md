# HYPOTHESIS — FETCH canonical AGY scaffold (not GENERATE)

**Pack baseline:** v1.2.8 · **Fecha lab:** 2026-08-05

---

## Claim principal

**FETCH/COPY** (never GENERATE) es el modelo correcto para materializar SKILL/rules/agents Antigravity: el agente obtiene bytes canónicos desde pack `runtime/` o GitHub raw (`rawBase` + `rawPath`), valida integridad, y **STOP** si el SKILL es inventado/corto.

---

## Sub-claims

### F1 — FETCH vs GENERATE wording

`GEMINI.user.md`, rules, `GEMINI.md`, SKILL § Antigravity, docs deben decir **FETCH/COPY** y prohibir inventar. Validator `-Strict` debe fallar si reaparece “generate SKILL”.

**Falsifier:** cualquier touchpoint manda generate → **REJECT**.

### F2 — Raw URLs como fuente

`scaffold-manifest.json` define `rawBase` + `rawPath` por archivo; `SCAFFOLD-FETCH.md` documenta orden local → raw → clone/zip.

**Falsifier:** manifest sin `rawBase` o sin paths fetchables → **REVISE**.

### F3 — Integrity T0–T3

Tras materializar, SKILL debe contener **todos** los `integrityMarkers`: `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`. SKILL canónico local >> 20 líneas (~300+).

**Falsifier:** markers ausentes en pack o en raw fetchable → **REJECT**.

### F4 — Drift vs plan 1.2.8

Pack local alineado: VERSION 1.2.8, `SCAFFOLD-FETCH.md` presente, validators FETCH-aware, CHANGELOG documenta cambio.

**Falsifier:** prod touchpoints aún dicen generate o faltan artefactos → **REVISE**.

### F5 — Remote fetch smoke

URL `{rawBase}/runtime/skills/orchestrator/SKILL.md` responde 200 y pasa markers (best-effort red).

**Falsifier:** main raw 404 o markers fail en remoto → **REVISE** (fallback/ pin).

---

## Integrity checks (acceptance T0–T3)

| Tier | Check | On fail |
|------|-------|---------|
| T0 | GEMINI.user + validator: no “generate SKILL” | REJECT hypothesis |
| T1 | manifest `rawBase`, `integrityMarkers`, required paths | REVISE |
| T2 | Local canonical SKILL: 4 markers + line count > 100 | REJECT |
| T3 | Remote main raw SKILL: 4 markers (network) | REVISE if fail; local-only OK with note |

Invented SKILL (~20 lines, missing markers) → delete fake `.agents/`, re-fetch, STOP (documented in SCAFFOLD-FETCH).

---

## Expected verdict

**APPROVE** si pack 1.2.8 + validate-hypothesis + Validate-OrchestratorPack -Strict PASS; FETCH model claro. **REVISE** si fallback raw roto o tag pin pendiente. **REJECT** si generate wording persiste o markers fallan localmente.
