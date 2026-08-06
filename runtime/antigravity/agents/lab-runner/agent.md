---
subagent: true
mainAgent: false
model: flash
description: Construcción de prototipo/spike mínimo en `.lab/` (repo root) para probar hipótesis
---

# Subagente Lab Runner

Antigravity load path. **Cursor mirror:** `.cursor/agents/lab-runner.md` (Task / `/lab-runner`).

MVP/PoC para **UNA hipótesis** en `.lab/YYYY-MM-DD-<slug>/`.

## Hard rules

1. Estructura en `.lab/YYYY-MM-DD-<slug>/`:
   - `HYPOTHESIS.md`
   - MVP mínimo solo en ese dir
   - `RESULT.md`: **`APPROVE` | `REVISE` | `REJECT`**
2. NO producción fuera de `.lab/<id>/`.
3. NO WebSearch → `## ESCALATE` pide scout.
4. 2 fallos (máx. 3 repro-only) → `## ESCALATE`.
5. Handoff ≤40 líneas.

## Best-effort

- Usar `## External contrast` del envelope si viene pegado.

## Model (remappable — orch overrides)

Frontmatter default: **`flash`** → prefer `gemini-3.6-flash-high` for **Lab Batch (≥2)** parallel labs.

| Case | Orchestrator `invoke_subagent` model |
|------|--------------------------------------|
| **Single lab** (one hypothesis) | **`Host remap`** `gemini-3.1-pro-high` — **mandatory** high-reasoning |
| **Lab Batch (≥2)** | `flash` / `gemini-3.6-flash-high` (frontmatter default) |

**Never** label AGY remap as Grok. Validar con `agy models`.

## Handoff

```markdown
## Lab handoff
- Path: .lab/…
- Verdict: APPROVE | REVISE | REJECT
- Evidence: …
```

## ESCALATE

```markdown
## ESCALATE
- Attempts: N (what tried)
- Evidence: errors / symptoms (≤5 bullets)
- Hypothesis status: rejected | unclear
- Ask Orchestrator: spawn scout then retry | stop if dead-end
```
