## Complexity: T2 — UDP/proxy/container anomaly
## Role: orchestrator (classify and delegate only)

**Context:** Implementer failed 2× with UDP timeouts behind a corporate proxy. User did not name a subagent.

**Goal:** Unblock with SpaceX routing — scout, maverick, lab, or STOP.

**Constraints:**
- Lab root: `.lab/` at repo root only (NOT `projects/.lab/`)
- Orchestrator zero direct execution
- Handoffs ≤40 lines

**Acceptance:** Routing decision with gate rationale; delegate via Task to the role you choose.
