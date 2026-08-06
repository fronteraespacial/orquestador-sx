# BRIEF — Algorithm Harvest + Discovery/Pre-Plan

## Goal

Desk-validate the **v1.3.0** methodology design (Discovery/Pre-Plan, WorkType, Lab Batch, VerifierLikeHuman, Harvest, YIELD_PLAN) against canon v1.2.10 — **paper only**, no prod edits.

## In scope

| Piece | Contract |
|-------|----------|
| **WorkType** | `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` |
| **Discovery** | Bounded evidence **before** native Plan Mode; one research Batch; ≤2 labs (≤3 T3); 1 REVISE; then DECIDE / YIELD_PLAN / STOP |
| **YIELD_PLAN** | Human opens surface Plan UI → approves Build |
| **VerifierLikeHuman** | New role; Grok 4.5 High; after technical verifier on T2/T3 human-facing; evidence classes; never edits / never opens O2 |
| **Maverick** | Always Grok 4.5 High; CONSULT early (z2o/trade-off) + post-Harvest; proposes only |
| **Lab Batch** | 2–3 isolated hypotheses (dirs + ports/services/data); fan-in; one prod path after decide/brake |
| **ops-diagnostic** | No feature lab/pipeline; no parallel mutations |

## Out of scope

Prod/canon/SKILL edits; runtime code; live IDE Plan Mode automation.

## Acceptance

- [x] Triggers + budget locked; YIELD ≠ YIELD_PLAN glossary
- [x] Paper scenarios: 4 WorkTypes + UNAVAILABLE + multi-APPROVE + decline YIELD_PLAN + PASS→Harvest→Maverick
- [x] Zero-exec / lab APPROVE / verify→O2|O3 matrix preserved
- [x] Verdict + exact prod target areas
