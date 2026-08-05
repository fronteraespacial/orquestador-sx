# `.lab/` — rules for SpaceX orchestrator packs

Canonical experiment room at **repo root**: `.lab/`  
**Do not** use `projects/.lab/` as an operational path.

## Purpose

Spike / MVP evidence **before** production writes. On greenfield, Orchestrator needs **APPROVE** from lab-runner before implementer/executor touches prod.

## Naming

| Kind | Pattern |
|------|---------|
| Classical | `YYYY-MM-DD-<short-slug>/` |
| Maverick | `YYYY-MM-DD-mav-<short-slug>/` |

Example: `2026-08-05-hello-cli/`, `2026-08-05-mav-udp-alt/`

## Verdicts

| Verdict | Meaning | Next |
|---------|---------|------|
| **APPROVE** | Promote | implementer with bounded paths |
| **REVISE** | Retry lab with new envelope | Orchestrator updates brief |
| **REJECT** | Dead end | STOP or new theory (scout/maverick) |
| **YIELD** | Stop without fake APPROVE | Orchestrator decides |

## Boundaries

- Lab agents write **only** under their `.lab/<id>/`.
- No soft-web from lab → ESCALATE → scout.
- Never import `.lab` into prod runtime.
- Prefer fewer files when promoting (Delete check).

## Optional per-lab files

`BRIEF.md` / `HYPOTHESIS.md`, `REPORT.md` / `RESULT.md`, optional `scratch/` cleaned after close.
