# HYPOTHESIS — Compact header

## Approved orchestrator header (Option A)

```markdown
### Orch
T<0|1|2|3> | Run R-<id> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

Recovery only — append on line 2:

```markdown
Role: Orchestrator | Action: Delegate | Failure-ID: F-<id>
```

**Wording note:** pipe-separated taxonomy line; no separate `##` H2 per field. Optional inline gloss after `T<n>` (e.g. `T2 — auth fix`) allowed when Run id alone is opaque — omit when Run is self-explanatory.

## Approved child envelope header

```markdown
### Env · <role>
T<n> | Run R-<id> | O<1|2|3> | Fase <fase> | Batch <B-<id>|none>
Model: fast | heavy | Sobre: <id>
```

Body unchanged: Objetivo, Archivos, Aceptación, Lab previo, Deltas, External contrast.

## Claims

| # | Claim |
|---|--------|
| H1 | 3-line orch header preserves all mandatory fields |
| H2 | Pipe line remains machine-scannable (`T[0-3]`, `Run R-`, `O[1-3]`, `Fase`, `Batch`) |
| H3 | ~50% header height vs 6× H2 block |
| H4 | Child `### Env · role` avoids 5–7 H2 stack; Model/Sobre on line 2 |
| H5 | Failure-ID optional on Role line keeps recovery unambiguous |
| H6 | Compatible with Run/Oleada/Fase/Batch; no Wave 0–3 |

## Anti-patterns rejected

- One-liner only (Role/Action hard to scan) → Option A wins
- Removing Batch/Tier/Run/Oleada/Fase → rejected
- Reverting to Wave 0–3 or per-field `## Complexity` / `## Role` / `## Run` stacks → rejected
