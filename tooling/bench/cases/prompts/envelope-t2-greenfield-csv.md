### Env · orchestrator
T2 — greenfield CSV export | Run R-csv-export | O1 initial | Fase research-lab | Batch none

**Context:** User asks to add CSV export to a dashboard. No similar feature exists in the repo.

**Goal:** Apply SpaceX gates before any production writer.

**Constraints:**
- Lab root: `.lab/` at repo root only (NOT `projects/.lab/`)
- Scout soft-mandatory; lab REQUIRED before implementer
- Orchestrator zero direct execution

**Acceptance:** Sequence of subagents with gate verdicts; delegate via Task.
