# Orchestrator — portable wiring (Windows-first)

Primary reference for this pack. CJ-linux snapshot: `reference.cj-linux.md` (**archive only — do not use**). WSL hosts: [reference.wsl.md](reference.wsl.md).

## Surfaces

| CLI | Spawn | Agent defs | Root policy |
|-----|-------|------------|-------------|
| **Cursor** | Task tool, `/name` | `.cursor/agents/*.md` | rules + skill; orchestrator **best-effort** zero-exec |
| **Antigravity** | `invoke_subagent` | `.agents/agents/<role>/agent.md` | `GEMINI.md` |
| **OpenCode** | Task / `@agent` | `opencode.json(c)` | orchestrator edit/bash deny when configured |
| **Codex** | TOML agents / Task | `.codex/agents/*.toml` | `developer_instructions` / `AGENTS.md` |

## Hard rules

1. **Never** document `invoke_subagent` as Cursor API.
2. **Never** assume Cursor loads `.agents/agents/`.
3. Prefer project-level `.cursor/agents/` (CLI may miss user-level).
4. Models: list on host, then remap (`agent --list-models`, `agy models`, `opencode models`). Cursor pack pins: see below.
5. Gates: Scout soft; Lab greenfield REQUIRED under **`.lab/`**; Discovery ⊂ research-lab; Maverick env-anomaly T2+ + early/Harvest CONSULT; Verifier after implementer; VLH after tech PASS on T2/T3 human-facing; **Run → Oleada O1–O3 → Fase → Batch** (not Wave 0–3); zero-exec parent.
6. **Taxonomy:** Run ⊃ Oleada O1–O3 ⊃ Fase (`prep` \| `research-lab` \| `execute` \| `verify`) ⊃ Batch \| Spawn. Independent workstreams → **Batch B-… REQUIRED** (multiple Task / `invoke_subagent` **same turn** when deps allow). verify FAIL reproducible local → **one O2** corrective (full gap inventory consolidated → `execute` → `verify`); design/env/hipótesis → **O3** (+ `research-lab`); no O4 / “Wave 4” by default. VLH **never** opens O2.
7. Cursor can **audit** zero-exec (readonly + logs); it cannot **fully enforce** it — OpenCode/Codex deny is stronger when wired.
8. **Multitask ≠ role collapse:** Multitask / Build in Parallel = parallel Tasks in one Batch — **not** one `composer-2.5-fast` / `generalPurpose` owning lab + implement + verify + release end-to-end.
9. **WorkType** in compact header: `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` (ops: no feature Lab Batch / no parallel mutations).

## Compact headers

Every orchestrator turn — **not** one `##` H2 per field:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | WorkType <greenfield|evolving-product|legacy-app|ops-diagnostic> | Run R-<id> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

Child envelopes (optional prefix):

```markdown
### Env · <role>
T<n> — <razón> | WorkType <…> | Run R-<id> | O<1|2|3> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Model: fast | heavy | Sobre: <id>
**Objetivo:** …
**Archivos / No tocar:** …
**Aceptación:** criterio verificable
**Human-serve:** yes|no
```

On recovery after verify FAIL or ESCALATE, append **`| Failure-ID: F-<id>`** on the Role line when applicable. Full envelope fields: [SKILL.md](SKILL.md).

## YIELD_PLAN — surface Plan UI (ask-only)

After Discovery **DECIDE**, orch emits **`YIELD_PLAN`**. Human opens the native Plan UI and approves **Build** before `implementer`. Decline → **STOP**. Lab `YIELD` ≠ `YIELD_PLAN`.

**Hosts do not auto-switch Plan Mode** — narrate and ask:

| Surface | Ask human to |
|---------|----------------|
| **Cursor** | Enter **Plan Mode**, then approve Build |
| **Antigravity** | **Planning Mode** / **Artifact Review**, then Build |
| **OpenCode** | **Plan → Build** |
| **Codex** | `/plan`, then approve Build |

## Discovery / Lab Batch (summary)

- Discovery ⊂ `research-lab`: one research Batch; ≤2 labs (≤3 T3); one REVISE; then `DECIDE` \| `YIELD_PLAN` \| `STOP`.
- Labs: no prod writes; no formal Implementation Plan.
- Parallel labs: isolate dirs **and** ports/services/data; fan-in matrix; ≥2 APPROVE → human brake; **one** prod path.

## Harvest + Maverick

After T2/T3 tech PASS (+ VLH if gated): parent Ledger → Maverick CONSULT mandatory → `NO_CHANGE` \| `YIELD_OPT` (human decides; **no auto O2**).

## Cursor model defaults (pack)

**Hard rule:** canonical Composer ID = **`composer-2.5-fast`**. Never `composer-2.5` without `-fast`.

| Role | ID | Notes |
|------|-----|-------|
| orchestrator | `cursor-grok-4.5-high` | Explicit; not `inherit` |
| maverick | `cursor-grok-4.5-high-fast` | Always; early + Harvest CONSULT |
| **verifier** | `cursor-grok-4.5-high-fast` | Always; complete gap inventory on FAIL |
| **verifier-like-human** | `cursor-grok-4.5-high-fast` | Always; after tech PASS; T2/T3 human-facing |
| lab-runner (single spawn) | `cursor-grok-4.5-high-fast` | One lab in fase/Batch |
| lab-runner (Lab Batch ≥2) | `composer-2.5-fast` each | Parallel labs |
| implementer, explore, scout, skeptic, deletion | `composer-2.5-fast` | Large scope → more envelopes, same role |

Verify loop (1.3.1): FAIL → full gap inventory; **one O2** per fan-in; input envelopes long OK, output handoffs ≤40 lines; RELEASE CHECKLIST fase for publish steps.

Policy + evidence tiers: pack `docs/agent/MODEL-ROUTING-POLICY.md`. Matrix: `07-MODELS-MATRIX.md`.

## Lab (canonical)

- Path: **`.lab/`** at repo root — **not** `projects/.lab/`
- Classical: `YYYY-MM-DD-<slug>/`
- Maverick: `YYYY-MM-DD-mav-<slug>/`
- Prod write only after **APPROVE** (and Build after `YIELD_PLAN` when Discovery ran)

## Shared handoff (optional)

e.g. `agent-handoff.md` — read at session start, append compact deltas before end.
