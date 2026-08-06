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
3. Copy Antigravity minimum: rules, role agents under `.agents/agents/<role>/agent.md` (incl. **verifier-like-human** when present in pack), repo `GEMINI.md` (merge), `.lab/README.md`.
4. **Integrity check:** SKILL must contain `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`. On fail → delete fake tree, re-fetch, or STOP.
5. No network → ask local pack path or clone. **Ask-first always** — never silent init.

CLI `Orchestrator.ps1 init -Scope project` remains valid **alternative** (Windows/Cursor).

## Parent orchestrator (main thread)

```markdown
### Orch
T<0|1|2|3> — <reason> | WorkType <greenfield|evolving-product|legacy-app|ops-diagnostic> | Run R-<slug> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Next spawn: <role|none> | Parent tools: none
Role: Orchestrator | Action: Delegate
```

**Process fail:** Fase `execute` | `verify` | `research-lab` + parent Write/Shell/edit.

**Taxonomy (do not use Wave 0–3 or “next wave”):**

| Layer | Meaning |
|-------|---------|
| **Run R-…** | Stable user objective (may span O1→O3) |
| **Oleada O1–O3** | Full cycle of fases — O1 initial, O2 corrective, O3 escalated; **no O4** by default |
| **Fase** | Named step: `prep` → `research-lab` → `execute` → `verify` (skip empty) |
| **Discovery** | Sub-phase of `research-lab` (not a 5th Fase): one Batch; ≤2 labs (≤3 T3); one REVISE; then `DECIDE` \| `YIELD_PLAN` \| `STOP` |
| **Batch B-…** | N parallel `invoke_subagent` + fan-in merge — **required** when workstreams are independent |
| **Spawn** | Exactly one child — never label a spawn as an oleada |
| **Retry** | Technical retry in same fase/batch (≤2; ESCALATE@2) — not O2 |

- **Zero direct execution** — classify, WorkType, gate, Discovery/DECIDE/YIELD_PLAN, Ledger/Harvest, envelopes, spawn, merge deltas, narrate.
- **T0 included** — reads → `explore`; any edit → `implementer`.
- **Parallel Batch (hard):** independent work → emit **multiple `invoke_subagent` in the SAME parent turn**; do **not** wait for A before launching B when A∥B. **Implementer Batch (T2/T3):** 2–3 `invoke_subagent(name: "implementer", …)` same execute Batch — disjoint paths, one Release-owner; fan-in → `verifier`. Lab Batch: isolate dirs **and** ports/services/data; ≥2 APPROVE → human brake; one prod path.
- **Serial deps (same Oleada):** lab **APPROVE** → (`YIELD_PLAN`→Build) → `implementer` → `verifier` → VLH if gated — sequential fases, **not** a new Oleada per child.
- **Example T3:** `O1 / research-lab / B1` = Discovery Batch (scouts + explore + optional maverick CONSULT + ≤2–3 isolated labs) → fan-in → `DECIDE` / `YIELD_PLAN`.
- **verify FAIL → transition:** transient → **Retry** (same fase); localized reproducible → **one O2** (consolidated gap inventory → corrective execute→verify); design/env/hypothesis → **O3** + fase `research-lab`; after **O3** budget → **ESCALATE/STOP** (no O4, no T4). Cross-surface integration check after multi-surface execute Batch. RELEASE CHECKLIST fase for publish steps. VLH never opens O2.
- Kill idle subagents when loop completes.

## YIELD_PLAN — Antigravity Plan UI (ask-only)

After Discovery **DECIDE**, emit **`YIELD_PLAN`**. Ask the human to open **Planning Mode** / **Artifact Review**, then approve **Build**. Decline → **STOP**. Do **not** claim the host auto-switched. Lab `YIELD` ≠ `YIELD_PLAN`.

Other surfaces (for cross-host narration): Cursor Plan Mode · OpenCode Plan→Build · Codex `/plan` — see [reference.md](reference.md).

## Compact role system prompts (envelope seeds)

Use as `system_prompt` / brief prefix when defining or invoking. Full defs: `.agents/agents/<role>/agent.md`.

### explore

Readonly local repo/MCP/system mapping. No web (→ scout). Handoff: `## Explore handoff` ≤40 lines. LIGHTWEIGHT: ≤8 tool calls.

### scout

External contrast only — official docs, GitHub issues, evidenced forums. No file writes. Deliver: `## External contrast` (REQUIRED/SKIPPED/COMPLEMENTARY). ≤5 sources.

### maverick

Counterintuitive what-ifs; CONSULT or LAB. LAB writes **only** `.lab/YYYY-MM-DD-mav-<slug>/`. Early CONSULT on zero-to-one / architecture trade-off. Post-Harvest CONSULT mandatory → `NO_CHANGE` \| `YIELD_OPT` (human decides; no auto O2). Budget 3 attempts/theory → `## MAV-ESCALATE`. Proposes, never decides.

### lab-runner

Spike **only** under `.lab/YYYY-MM-DD-<slug>/` (repo root — **not** `projects/.lab/`). Verdict in REPORT: APPROVE|REVISE|REJECT|YIELD. Isolate ports/services/data from sibling labs. No web. No prod paths. No formal Implementation Plan.

### implementer

Sole prod writer. Greenfield requires lab **APPROVE**. No web. Handoff ≤40 lines + `Delete check:` + `Automation candidates:`.

### verifier

DoD evidence only — scripts, exit codes, file checks, cross-surface integration. `Verdict: PASS|FAIL|INCONCLUSIVE`. On FAIL: **Gap inventory** (all blocking gaps). **REQUIRED** after implementer before “done”. Not VerifierLikeHuman. Cursor: `cursor-grok-4.5-high-fast` always; AGY: **`Host remap`** `gemini-3.1-pro-high`.

### verifier-like-human (NEW role)

After **technical verifier PASS**; T2/T3 **human-facing** only. Handoff exactly:

```markdown
## VerifierLikeHuman handoff
- Verdict: PASS | FAIL | INCONCLUSIVE
- Serves-ask: yes | partial | no
- Evidence-class: CAPTURED | BROWSER | COMPUTER | PROXY | UNAVAILABLE
- Evidence / artifact paths: …
- Ask Orchestrator: …
```

`UNAVAILABLE` → **INCONCLUSIVE**; no visual claims without evidence. **Never** edit/web/auto O2.

### skeptic (T3 optional)

Requirements audit — fuzzy/high-stakes. No code. Flag dumb reqs, missing acceptance, scope creep.

### deletion (T3 optional)

Delete proposals — what to remove instead of add. No code. Pair with Algorithm step 2 (Need/Delete).

## Gates (same as universal skill)

| Gate | Rule |
|------|------|
| **WorkType** | `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` in compact header |
| **Discovery** | ⊂ research-lab; budget one Batch / ≤2 labs (≤3 T3) / one REVISE → DECIDE\|YIELD_PLAN\|STOP |
| **Lab** | Greenfield → scout (soft) → **lab-runner REQUIRED** → only **APPROVE** unlocks **implementer** (after Build if YIELD_PLAN) |
| **ops-diagnostic** | No feature lab/pipeline; no parallel mutations |
| **Maverick** | T2+ env anomaly → **REQUIRED**; early CONSULT on z2o/trade-off; Harvest CONSULT mandatory |
| **Verifier** | **implementer** ran → **verifier REQUIRED** before final narration |
| **VLH** | After tech PASS; T2/T3 human-facing; no edits / no O2 |
| **Harvest** | Ledger parent-only → Maverick → `NO_CHANGE`\|`YIELD_OPT` human |
| **ESCALATE** | Child `## ESCALATE` (≥2 fails) → **scout** → retry with contrast or STOP |
| **`.lab` root** | Repo root `.lab/` only |
| **Mode diagnostic** | Optional; `.debug/` forensic ≠ `.lab/`; Maverick CONSULT HARD post-probes pre-REPORT (mandatory); see [SKILL.md](SKILL.md) § Mode: diagnostic |

## Model aliases (**Host remap** on AGY — no Grok)

AGY does **not** expose Grok. Maverick + VerifierLikeHuman stay **enabled** via explicit **`Host remap`** — **never** put `grok-*` in frontmatter / `define_subagent`, and **never** narrate the Gemini ID as “Grok”.

| Role | Default alias | Prefer ID |
|------|---------------|-----------|
| explore, scout, lab-runner (Lab Batch), skeptic, deletion | `flash` | `gemini-3.6-flash-high` |
| lab-runner (single) | `pro` / `flash` | per envelope |
| **maverick** | `pro` | **`Host remap`:** `gemini-3.1-pro-high` |
| **verifier** | `pro` | **`Host remap`:** `gemini-3.1-pro-high` |
| **verifier-like-human** | `pro` | **`Host remap`:** `gemini-3.1-pro-high` |
| implementer | `pro` | `gemini-3.1-pro-high` |
| **diagnostic** (Mode diagnostic synthesizer) | `pro` | **`Host remap`:** `gemini-3.1-pro-high` |
| orchestrator (session parent) | **host UI default** — not pack-forced | Auto / user-picked OK |
| orchestrator (optional nested, depth-1) | **`Host remap`:** `gemini-3.1-pro-high` | Only when optional nest pattern used; never call it Grok; never re-nest |

Validate with `agy models` / UI. **Optional nested orch:** outer = thin launcher; one `invoke_subagent` / defined nested orch @ **`Host remap` `gemini-3.1-pro-high`** with full skill-primed envelope; nested owns classify/spawn/Ledger/Harvest; depth-1 only — see [SKILL.md](SKILL.md) § Optional nested orchestrator. Cursor (other surface): session parent unpinned; optional nested Task → `cursor-grok-4.5-high-fast`; Mav/Ver/VLH/single-lab → `cursor-grok-4.5-high-fast`; Lab Batch ≥2 → `composer-2.5-fast` each — see [SKILL.md](SKILL.md) + pack `docs/agent/MODEL-ROUTING-POLICY.md` §5.1. OpenCode/Codex: Grok when exposed for Mav/Ver/VLH; else **Host remap**.

## Handoffs

Child **output** handoffs ≤40 lines. Child **input envelopes** may be long/complete. Orchestrator forwards **deltas only** into next envelope — not full transcripts.

### Implementer Batch — invoke ×2–3 (T2/T3, same execute Batch)

```text
# Same turn — Batch B-impl-1, Fase execute (T2/T3 Implementer Batch)
invoke_subagent(name: "implementer", prompt: "### Env · implementer (Imp-A)\n… allow-list: canon/ …")
invoke_subagent(name: "implementer", prompt: "### Env · implementer (Imp-B)\n… allow-list: runtime/antigravity/ …")
invoke_subagent(name: "implementer", prompt: "### Env · implementer (Imp-C)\n… Release-owner: YES — VERSION, CHANGELOG …")
# fan-in → invoke_subagent(name: "verifier", …)
```

**Composer on verifier / VLH / maverick / single-lab = process FAIL.** Policy identical to [SKILL.md](SKILL.md) + [reference.md](reference.md).
