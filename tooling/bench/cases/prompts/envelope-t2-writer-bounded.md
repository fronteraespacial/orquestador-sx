## Complexity: T2 — bounded writer (benchmark sandbox)
## Role: orchestrator (classify and delegate only)

**Context:** LAB APPROVE received. Integration smoke test needs exactly one marker file in this worktree.

**Goal:** Delegate to **implementer** with a strict path envelope — no other writers.

**Constraints:**
- Implementer may **ONLY** create or edit `.bench-marker/marker.txt` in this worktree root
- **Forbidden:** any other path, `.lab/` changes, production dirs, bulk edits
- Orchestrator zero direct execution — spawn Task for implementer only

**Acceptance:** Routing narrative + Task delegation to implementer; handoff cites `.bench-marker/marker.txt` as the sole writable path.
