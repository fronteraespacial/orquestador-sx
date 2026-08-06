# P2 — ~/.gemini/GEMINI.md micro snippet (OPT-IN ONLY)

**Policy:** Install-Orchestrator **must NOT** write this file unless the human passes an explicit flag (e.g. `-ConfirmUserGemini` / documented opt-in in FIRST-RUN). Document only.

---

## When to use

Optional safety net when the user sometimes opens **initialized repos** but forgets Always On — **does not replace** project rules.

## Snippet (~5 lines)

```markdown
# Global hint — SpaceX Orchestrator (opt-in)

If the workspace repo has `.orchestrator-lock.json` with `"enabled": true`:
- Load `.agents/skills/orchestrator/SKILL.md`
- Apply `.agents/rules/spacex-orchestrator.md` + `cj-orchestrator-bootstrap.md`
- Main thread: zero direct execution; delegate via invoke_subagent

If no lock in workspace: ignore this block.
```

## Install (human manual)

1. Backup existing `~/.gemini/GEMINI.md` if non-empty.
2. Merge snippet (do not overwrite local rules).
3. Re-test: playground chat should still have **no** methodology; initialized repo should bootstrap.

## Falsifier

If global GEMINI causes methodology in playground → **REJECT** opt-in or narrow snippet further.

---
