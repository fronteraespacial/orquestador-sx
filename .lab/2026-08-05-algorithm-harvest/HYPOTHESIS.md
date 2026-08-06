# HYPOTHESIS — Algorithm Harvest + Discovery/Pre-Plan

## Primary

> Extending v1.2.10 → **1.3.0** with Discovery ⊂ `research-lab`, textual WorkType, Lab Batch fan-in, VerifierLikeHuman, Algorithm Ledger + Harvest, and YIELD_PLAN surface handoff **preserves** zero-exec parent, lab APPROVE→prod, and verify FAIL→O2/O3 — and is shippable as one doc oleada.

## Locked specs (implementer contract)

### S1 — Discovery / Pre-Plan

- **Not** a new Wave/Oleada/Fase — **sub-phase of** `research-lab`, **before** native Plan / formal Implementation Plan.
- **Enter when any:** zero-to-one · large debug w/ no dominant hypothesis · legacy hot path · ≥2 plausible approaches · post-ESCALATE · architecture trade-off · irreversible change.
- **Skip:** T0/T1 clear repro / mechanical single-path.
- **Budget:** **one** research Batch; ≤**2** labs normal, ≤**3** only T3; **one** REVISE; then orch-only **`DECIDE` | `YIELD_PLAN` | `STOP`**.
- Labs: **no** prod writes; **no** formal Implementation Plan text.

### S2 — YIELD_PLAN

After DECIDE with enough evidence → orch emits **`YIELD_PLAN`** → human opens **surface native Plan UI** → human approves **Build** → only then O1 `execute`.  
**Decline Build** → **STOP** (no implementer).  
≠ lab verdict **`YIELD`**.

### S3 — Lab Batch

- 2–3 **distinct** hypotheses; isolated `.lab/<id>/` **and** services/ports/data.
- Fan-in matrix; merge **`APPROVE` > `REVISE` > `REJECT` > `YIELD`**.
- **≥2 APPROVE** → **human brake** (pick one). **One** winner → **one** prod path.

### S4 — VerifierLikeHuman (NEW role)

- Separate agent; model **always** Grok 4.5 High (`cursor-grok-4.5-high-fast` pack ID).
- After **technical verifier PASS**; only T2/T3 **human-facing** (UI/UX DoD · human-ops output · actionable docs · `Human-serve: yes`).
- Evidence: `CAPTURED|BROWSER|COMPUTER|PROXY|UNAVAILABLE`. No evidence → **INCONCLUSIVE**. **No visual hallucination**.
- **Never** edits prod; **never** opens O2 itself (orch classifies FAIL/INCONCLUSIVE).

### S5 — Maverick + Harvest

- Model **always** Grok 4.5 High (same pack ID); proposes only.
- **CONSULT early** on zero-to-one / architecture trade-off (Discovery).
- After T2/T3 technical PASS (+ VLH if gated): parent **Harvest** (Ledger ≤10 lines, parent-only) → **Maverick CONSULT mandatory** → **YIELD_OPT** needs **human** (no auto O2).

### S6 — WorkType routing

| WorkType | Discovery? | Labs / Batch |
|----------|------------|--------------|
| `greenfield` | Yes (z2o triggers) | Feature labs OK; Batch if ≥2 hyps |
| `evolving-product` | Only if trigger list hits | Prefer serial; skip if clear path |
| `legacy-app` | Yes on hot path / unknown | Map+repro labs; isolate carefully |
| `ops-diagnostic` | Evidence gather only | **No** feature lab/pipeline; **no** parallel mutations |

### S7 — Algorithm Ledger (parent-only)

```markdown
## Algorithm Ledger
- Need: …
- Delete: …
- Simplify: …
- Accelerate: …
- Automate: now|backlog|discard — …
```

## Claims

| ID | Claim | Result |
|----|-------|--------|
| H1 | Discovery ⊂ research-lab; triggers+budget S1 | HOLD |
| H2 | YIELD_PLAN → native Plan → Build; decline=STOP | HOLD |
| H3 | WorkType enum + ops-diagnostic exception | HOLD |
| H4 | Harvest → Maverick → YIELD_OPT human | HOLD |
| H5 | Lab Batch isolation + multi-APPROVE brake | HOLD |
| H6 | VLH gated; evidence classes; no edit/O2 | HOLD |
| H7 | Maverick always Grok; early + post-Harvest CONSULT | HOLD |

## Falsifiers (must not hold)

| ID | Risk | Mitigation |
|----|------|------------|
| F1 | Discovery becomes 5th Fase | S1: sub-phase only |
| F2 | VLH on every T0 | S4 gate |
| F3 | Parallel labs share port/DB → false APPROVE | S3 isolation |
| F4 | YIELD vs YIELD_PLAN confusion | S2 glossary |
| F5 | Harvest auto-opens O2 | YIELD_OPT human |
| F6 | Children write Ledger | S7 parent-only |
| F7 | Cursor auto-enters Plan Mode | ask-only / narrate |
| F8 | ops-diagnostic runs feature Lab Batch | S6 |

## Paper scenarios (required)

| # | Scenario | Trace | Pass? |
|---|----------|-------|-------|
| W1 | `greenfield` z2o | TRIAGE→Discovery Batch (mav CONSULT early)→≤2–3 labs→DECIDE→YIELD_PLAN→human Plan/Build→execute→verify | ✅ |
| W2 | `evolving-product` clear bug | Skip Discovery→implementer→verifier; no VLH if mechanical | ✅ |
| W3 | `legacy-app` hot path | Discovery map+repro→YIELD_PLAN if T2+→Build | ✅ |
| W4 | `ops-diagnostic` | Scout/explore serial; **no** feature lab; **no** parallel mutate; DECIDE/STOP | ✅ |
| V1 | VLH evidence UNAVAILABLE | After tech PASS → VLH **INCONCLUSIVE**; no “UI looks fine”; orch narrates gap; **no O2 from VLH** | ✅ |
| B1 | Parallel labs both APPROVE (conflict) | Fan-in → human brake → one path only | ✅ |
| Y1 | Human declines YIELD_PLAN / Build | **STOP**; no execute | ✅ |
| H1s | VERIFY PASS → Harvest → Maverick | Ledger update → Maverick CONSULT → YIELD_OPT human or STOP | ✅ |

## Success metric

All H* HOLD, F* mitigated, 8/8 scenarios pass, VERSION **1.3.0**, prod targets listed in REPORT.
