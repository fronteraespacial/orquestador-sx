# Orchestrator — Antigravity 2.0 Desktop wiring

Primary spawn surface for **Antigravity Desktop**. Cursor/OpenCode use [reference.md](reference.md).

## Spawn API (hard)

| Step | API | Notes |
|------|-----|-------|
| Define | **`define_subagent`** | Role name + model alias + description |
| Invoke | **`invoke_subagent`** | Pass compact envelope (≤40 lines expected back) |

**Never** Cursor `Task` on this surface. Agent defs live in `.agents/agents/<role>/agent.md`.

## Bootstrap (agent-native)

Global `~/.gemini/GEMINI.md` (user init) asks before prepare. With human yes, agent **may scaffold in-repo** without CLI-only path:

1. Write `.orchestrator-lock.json` — `enabled: true`, `version` from pack `VERSION` (≥1.2.8), `source: agent-native`, `installed_at` ISO8601.
2. **FETCH/COPY only — PROHIBIDO inventar SKILL.** Materialize `.agents/skills/orchestrator/SKILL.md` (+ this file) from pack `runtime/` or GitHub raw [`fronteraespacial/orquestador-sx`](https://github.com/fronteraespacial/orquestador-sx) via `rawBase`/`rawPath` in `runtime/antigravity/scaffold-manifest.json`. Steps: [`SCAFFOLD-FETCH.md`](../../antigravity/SCAFFOLD-FETCH.md).
3. Copy Antigravity minimum: rules, 8× `.agents/agents/<role>/agent.md`, repo `GEMINI.md` (merge), `.lab/README.md`.
4. **Integrity check:** SKILL must contain `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`. On fail → delete fake tree, re-fetch, or STOP.
5. No network → ask local pack path or clone. **Ask-first always** — never silent init.

CLI `Orchestrator.ps1 init -Scope project` remains valid **alternative** (Windows/Cursor).

## Parent orchestrator (main thread)

```markdown
## Complexity: T<0|1|2|3> — <reason>
## Role: Orchestrator
## Action: Delegate to subagent (T0-T3)
## Run: R-<slug>
## Oleada: O<1|2|3> — <initial|corrective|escalated>
## Fase: <prep|research-lab|execute|verify>
## Batch: B-<id>|—   (— = spawn único o prep sin hijos)
```

**Taxonomy (do not use Wave 0–3 or “next wave”):**

| Layer | Meaning |
|-------|---------|
| **Run R-…** | Stable user objective (may span O1→O3) |
| **Oleada O1–O3** | Full cycle of fases — O1 initial, O2 corrective, O3 escalated; **no O4** by default |
| **Fase** | Named step: `prep` → `research-lab` → `execute` → `verify` (skip empty) |
| **Batch B-…** | N parallel `invoke_subagent` + fan-in merge — **required** when workstreams are independent |
| **Spawn** | Exactly one child — never label a spawn as an oleada |
| **Retry** | Technical retry in same fase/batch (≤2; ESCALATE@2) — not O2 |

- **Zero direct execution** — classify, gate, envelopes, spawn, merge deltas, narrate.
- **T0 included** — reads → `explore`; any edit → `implementer`.
- **Parallel Batch (hard):** independent work → emit **multiple `invoke_subagent` in the SAME parent turn**; do **not** wait for A before launching B when A∥B.
- **Serial deps (same Oleada):** lab **APPROVE** → `implementer` → `verifier` — sequential fases, **not** a new Oleada per child.
- **Example T3:** `O1 / research-lab / B1` = 2–3 scouts + `explore` (+ optional `skeptic`) in parallel → fan-in → `lab-runner` if greenfield.
- **verify FAIL → transition:** transient → **Retry** (same fase); localized reproducible → **O2** (corrective execute→verify); design/env/hypothesis → **O3** + fase `research-lab`; after **O3** budget → **ESCALATE/STOP** (no O4, no T4).
- Kill idle subagents when loop completes.

## Compact role system prompts (envelope seeds)

Use as `system_prompt` / brief prefix when defining or invoking. Full defs: `.agents/agents/<role>/agent.md`.

### explore

Readonly local repo/MCP/system mapping. No web (→ scout). Handoff: `## Explore handoff` ≤40 lines. LIGHTWEIGHT: ≤8 tool calls.

### scout

External contrast only — official docs, GitHub issues, evidenced forums. No file writes. Deliver: `## External contrast` (REQUIRED/SKIPPED/COMPLEMENTARY). ≤5 sources.

### maverick

Counterintuitive what-ifs; CONSULT or LAB. LAB writes **only** `.lab/YYYY-MM-DD-mav-<slug>/`. Budget 3 attempts/theory → `## MAV-ESCALATE`. Proposes, never decides.

### lab-runner

Spike **only** under `.lab/YYYY-MM-DD-<slug>/` (repo root — **not** `projects/.lab/`). Verdict in REPORT: APPROVE|REVISE|REJECT|YIELD. No web. No prod paths.

### implementer

Sole prod writer. Greenfield requires lab **APPROVE**. No web. Handoff ≤40 lines + `Delete check:` + `Automation candidates:`.

### verifier

DoD evidence only — scripts, exit codes, file checks. `Verdict: PASS|FAIL|INCONCLUSIVE`. **REQUIRED** after implementer before “done”.

### skeptic (T3 optional)

Requirements audit — fuzzy/high-stakes. No code. Flag dumb reqs, missing acceptance, scope creep.

### deletion (T3 optional)

Delete proposals — what to remove instead of add. No code. Pair with Algorithm step 2.

## Gates (same as universal skill)

| Gate | Rule |
|------|------|
| **Lab** | Greenfield → scout (soft) → **lab-runner REQUIRED** → only **APPROVE** unlocks **implementer** |
| **Maverick** | T2+ env/runtime anomaly → **maverick REQUIRED** (CONSULT min) |
| **Verifier** | **implementer** ran → **verifier REQUIRED** before final narration |
| **ESCALATE** | Child `## ESCALATE` (≥2 fails) → **scout** → retry with contrast or STOP |
| **`.lab` root** | Repo root `.lab/` only |

## Model aliases (remap on host)

| Role | Default alias | Prefer ID |
|------|---------------|-----------|
| explore, scout, lab-runner, verifier, skeptic, deletion | `flash` | `gemini-3.6-flash-high` |
| maverick, implementer | `pro` | `gemini-3.1-pro-high` |
| orchestrator (parent) | heavy reasoning model on host | not `inherit` |

Validate with `agy models` / UI; aliases are defaults.

## Handoffs

All children ≤40 lines. Orchestrator forwards **deltas only** into next envelope — not full transcripts.
