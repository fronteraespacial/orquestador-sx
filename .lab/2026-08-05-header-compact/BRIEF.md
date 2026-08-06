# BRIEF — Compact orchestrator header

## Goal

Cut vertical/token cost of the mandatory orchestrator header in Cursor and Antigravity while keeping machine-scannable taxonomy (Tier, Run, Oleada, Fase, Batch) and zero-exec gates.

## Problem

Legacy template (v1.2.9 wave-taxonomy) used 6–7 separate `##` H2 lines per turn (`## Complexity`, `## Role`, `## Run`, `## Oleada`, `## Fase`, `## Batch`, sometimes `## Wave`). Too tall in chat UIs.

## Hypothesis (Option A)

Replace per-field H2s with a 3-line `### Orch` block; child envelopes use `### Env · <role>` (2-line header + body fields).

## Constraints

- Lab-only until APPROVE; no prod edits from lab-runner
- Keep Tier / Run / Oleada O1–O3 / Fase / Batch taxonomy (wave-taxonomy APPROVE)
- No Wave 0–3 as live nomenclature
- Failure-ID only on recovery (verify FAIL / ESCALATE)
- Composer canonical = `composer-2.5-fast`

## Acceptance

- [x] Orchestrator header ≤3 lines (incl. `### Orch`)
- [x] All taxonomy tokens present and parseable (`T*`, `Run R-`, `O*`, `Fase`, `Batch`)
- [x] Child envelope header ≤3 lines before body
- [x] No tall per-field H2 stack in active templates (anti-pattern documented)
- [x] Verdict recorded
