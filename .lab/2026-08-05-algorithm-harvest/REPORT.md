# REPORT — Algorithm Harvest + Discovery/Pre-Plan

**Veredicto:** **APPROVE**  
**Fecha:** 2026-08-05 (rev. 3 — user trigger/CONSULT/isolation lock)  
**Base:** pack VERSION 1.2.10 → target **1.3.0**

## Resumen

Design holds against canon `01`/`02`/`07`/`09`: Discovery stays inside `research-lab` (no 5th Fase), preserves zero-exec + lab APPROVE + verify→O2/O3. Gaps from prior rev (explicit triggers, early Maverick CONSULT, VLH never-O2, port/data isolation, decline-YIELD_PLAN, ops no-mutate) are now locked. **8/8** paper scenarios pass. Ready for doc implementer oleada — **no prod edits from this lab**.

## Scenario results

| ID | Result | Note |
|----|--------|------|
| W1 greenfield | PASS | Discovery→YIELD_PLAN→Build; early mav CONSULT |
| W2 evolving-product | PASS | Skip Discovery when clear path |
| W3 legacy-app | PASS | Hot-path Discovery; isolate labs |
| W4 ops-diagnostic | PASS | No feature lab; no parallel mutations |
| V1 UNAVAILABLE | PASS | VLH INCONCLUSIVE; no hallucination; no self-O2 |
| B1 multi-APPROVE | PASS | Human brake; one prod path |
| Y1 decline YIELD_PLAN | PASS | STOP |
| H1s PASS→Harvest→Mav | PASS | Ledger→CONSULT→YIELD_OPT human |

## Compatibility with v1.2.10

| Invariant | Status |
|-----------|--------|
| Parent zero-exec (incl. T0) | Intact — Discovery via children |
| Lab APPROVE before prod | Intact — Batch fan-in still gates |
| Verifier after writer | Intact — VLH **after** tech PASS only |
| verify FAIL → O2/O3 matrix | Intact — VLH cannot open O2 |
| ESCALATE@2; no T4/O4 | Intact — post-ESCALATE ∈ Discovery triggers |
| Maverick proposes only | Intact — + early CONSULT + Harvest CONSULT |

## Residual risks (non-blocking)

1. Cursor cannot force Plan Mode — **ask-only** (F7); document per surface.
2. Isolation of ports/services is **policy** — install/skill must state checklist; no runtime enforcer.
3. `MODEL-ROUTING-POLICY.md` currently says “No new roles” — must flip for VLH in 1.3.0 oleada.

## Prod target areas (implementer — exact)

| # | Path | Change |
|---|------|--------|
| 1 | `canon/01-METHODOLOGY-SPACEX.md` | Discovery triggers/budget; WorkType; Harvest; YIELD_PLAN; Lab Batch; ops-diagnostic |
| 2 | `canon/02-ROLES-HANDOFFS-GATES.md` | VLH role + handoff; Maverick CONSULT timings; glossary YIELD≠YIELD_PLAN |
| 3 | `canon/07-MODELS-MATRIX.md` | VLH + Maverick = Grok 4.5 High (`cursor-grok-4.5-high-fast`) |
| 4 | `canon/09-VERIFY-CHECKLIST.md` | VLH evidence classes; INCONCLUSIVE; post-PASS gate |
| 5 | `runtime/skills/orchestrator/SKILL.md` | Gates, Discovery, Harvest, Batch fan-in |
| 6 | `runtime/skills/orchestrator/reference.md` | Cursor surfaces / ask-only Plan |
| 7 | `runtime/skills/orchestrator/reference.antigravity.md` | AGY Plan / invoke notes |
| 8 | `runtime/cursor/agents/orchestrator.md` | Spawn rules Discovery/VLH/Harvest |
| 9 | `runtime/cursor/agents/verifier-like-human.md` | **NEW** |
| 10 | `runtime/cursor/agents/maverick.md` | Early + post-Harvest CONSULT |
| 11 | `runtime/antigravity/agents/verifier-like-human/agent.md` | **NEW** |
| 12 | `runtime/antigravity/agents/maverick/agent.md` | Align CONSULT |
| 13 | `runtime/antigravity/scaffold-manifest.json` | Register VLH |
| 14 | `runtime/antigravity/rules/spacex-orchestrator.md` | Gates summary |
| 15 | `runtime/opencode/opencode.json.example` | VLH agent entry |
| 16 | `runtime/opencode/opencode.jsonc.example` | same |
| 17 | `runtime/codex/agents/orchestrator.toml` | Discovery/Harvest |
| 18 | `runtime/codex/agents/verifier-like-human.toml` | **NEW** |
| 19 | `tooling/scripts/Install-Orchestrator.ps1` | Copy new agent files |
| 20 | `docs/agent/CONTEXT-MAP.md` | Token map: Discovery/VLH/Harvest |
| 21 | `docs/agent/MODEL-ROUTING-POLICY.md` | New role VLH; drop “No new roles” |
| 22 | `AGENTS.md` + `runtime/project/AGENTS.md` + `tooling/sandbox/pilot/AGENTS.md` | Gates table |
| 23 | `CHANGELOG.md` + `VERSION` | **1.3.0** |

## Lab handoff (≤40)

```markdown
## Lab handoff
- Path: .lab/2026-08-05-algorithm-harvest/
- Verdict: APPROVE
- Evidence: S1–S7 locked; H1–H7 HOLD; F1–F8 mitigated; 8/8 scenarios PASS (4 WorkTypes, UNAVAILABLE→INCONCLUSIVE, multi-APPROVE brake, decline YIELD_PLAN→STOP, PASS→Harvest→Maverick); zero-exec/lab/O2-O3 preserved; 23 prod targets → VERSION 1.3.0; no prod edits
- Prod areas: canon/01,02,07,09; runtime/skills/orchestrator/*; runtime/{cursor,antigravity,opencode,codex} agents (+3 NEW VLH); Install-Orchestrator.ps1; docs/agent/{CONTEXT-MAP,MODEL-ROUTING-POLICY}; AGENTS.md×3; CHANGELOG+VERSION
- Ask Orchestrator: spawn implementer doc oleada on listed paths → verifier (judgment)
```
