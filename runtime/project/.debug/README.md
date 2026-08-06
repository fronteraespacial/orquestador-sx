# `.debug/` — forensic diagnostic room

**For humans and future agents.** Case files for **Mode: diagnostic** — not feature experiments.

## ≠ `.lab/`

| Room | Purpose | Unlocks prod? |
|------|---------|---------------|
| **`.lab/`** | Feature / design hypotheses | **`APPROVE`** → implementer |
| **`.debug/`** | Failure forensics, RCA, regression narrative | **Never** — REPORT recommends next steps only |

Do **not** import `.debug/` code into production. Do **not** treat REPORT as lab APPROVE.

## Human brake

Before the first case (or before pack install copies this README into your repo), confirm you want a forensic room vs indexing failures in Harvest Ledger only. Maverick may prefer Harvest-only — human decides.

## Before opening a case — incident-review

Future diagnostic runs **shall grep prior reports**:

```powershell
# Example — adjust path to repo root
Get-ChildItem -Recurse .debug -Filter REPORT.md | Select-String -Pattern "Failure-ID|root cause|regression"
```

Cite matches in new REPORT **Prior incidents**. No auto-migrate from old cases — each fix needs explicit DECIDE.

## Layout (per case)

```text
.debug/YYYY-MM-DD-<slug>/
  BRIEF.md              # symptoms, Failure-ID, scope, triggers
  HYPOTHESES.md         # optional — H1–H3 + lane tags
  drone-logs|recent|structural|fragility/PROBE.md  # optional raw explore inventories (≤40 lines)
  maverick-consult/     # Maverick CONSULT HARD (post-probes, pre-REPORT)
  REPORT.md             # canonical Diagnostic REPORT schema (SKILL.md)
```

## 4 lanes (probe assignment)

| Lane | Typical focus |
|------|----------------|
| **logs** | Traces, stderr, CI artifacts, exit codes, timestamps |
| **recent-changes** | Diff reciente, commits, releases, config drift |
| **structural** | Boundaries, imports, wiring, installer maps, cross-surface naming |
| **similar-fragility** | Patrones análogos rotos en el repo / historial `.debug` |

Use 2–3 read-only explore drones on **disjoint** lanes — not four drones by default.

## Flow (summary)

1. incident-review (grep `.debug/`)
2. Parallel RO PROBEs (4 lanes) → fan-in
3. Maverick CONSULT HARD → `maverick-consult/` (mandatory before REPORT)
4. Grok synthesizer → `REPORT.md` (integrates Maverick block)
5. Orchestrator DECIDE — serial implementer/lab **after**, if at all

**No auto-migrate:** diagnostics may recommend schema or config fixes; humans or implementer apply them in a separate Run.

Full contract: `.agents/skills/orchestrator/SKILL.md` § **Mode: diagnostic**.
