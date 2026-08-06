# Model routing policy — status & evidence

**Pack version:** see [`../VERSION`](../VERSION)  
**Last updated:** 2026-08-06  
**Authority:** user operational decision for this pack (not a local benchmark “winner”).

This document separates **what was measured**, **external signals**, **the operational decision**, and **what remains pending**. It does not declare a local Grok-vs-Composer superiority conclusion.

## 1. Exact operational policy (Cursor)

**Hard rule (Composer):** canonical ID = **`composer-2.5-fast`**. **Never** route to `composer-2.5` without `-fast` (no `composer-2.5[fast=false]`, no bare `composer-2.5` in frontmatter or Task `model:`). Cost delta vs non-Fast is negligible; speed wins.

While these model IDs remain available on the host (`agent --list-models`):

| Actor | Model ID | When |
|-------|----------|------|
| **Parent / orchestrator** | `cursor-grok-4.5-high` | Always (session default; template frontmatter) |
| **Maverick** | `cursor-grok-4.5-high-fast` | **Always** (early Discovery CONSULT + post-Harvest CONSULT; env anomaly) |
| **Verifier (technical DoD)** | `cursor-grok-4.5-high-fast` | **Always** — scripts, exit codes, file existence, lock/status, hash checks, cross-surface consistency |
| **VerifierLikeHuman** | `cursor-grok-4.5-high-fast` | **Always** — after technical verifier PASS; T2/T3 human-facing only |
| **Lab-runner (single spawn)** | `cursor-grok-4.5-high-fast` | **One** lab-runner in the fase/Batch (no sibling lab-runners) |
| **Lab-runner (Lab Batch ≥2 parallel)** | `composer-2.5-fast` | Each parallel lab-runner when ≥2 labs spawn together |
| **Implementer / repetitive roles** | `composer-2.5-fast` | Repetitive/fast work, mechanical refactors, surgical edits with clear paths + DoD |
| **explore, scout, skeptic, deletion** | `composer-2.5-fast` | Light / tool-use defaults |

**New role (1.3.0 oleada):** **VerifierLikeHuman** — dedicated agent; **not** folded into technical verifier. Parent picks models at spawn per table above. Cross-host remap: see §5 / §5.1 and [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md).

### 1.0 Verifier routing & parent spot-check

| DoD type | Verifier model | Notes |
|----------|----------------|-------|
| **All technical DoD** | `cursor-grok-4.5-high-fast` | Mechanical + judgment + cross-surface integration — **no** Composer verifier on Cursor |
| **Human-serve (VLH)** | `cursor-grok-4.5-high-fast` | After tech **PASS**; T2/T3 UI/UX · human-ops · actionable docs; evidence `CAPTURED\|BROWSER\|COMPUTER\|PROXY\|UNAVAILABLE`; `UNAVAILABLE`→**INCONCLUSIVE**; no edit / no web / no self-O2 |

**Verifier FAIL contract (1.3.1):** on **FAIL**, verifier returns a **complete gap inventory** (every blocking gap found) — not just the first FAIL. Verdict remains **FAIL** if any gap blocks. Parent opens **at most one O2** per verify fan-in, consolidating the full inventory into **one** corrective execute Batch — no whack-a-mole O2/O3/O4 per single gap. See [`../../canon/01-METHODOLOGY-SPACEX.md`](../../canon/01-METHODOLOGY-SPACEX.md) §6 verify loop.

After technical verifier handoff, parent (`cursor-grok-4.5-high`) **spot-checks 1–2 claims** against evidence — **does not** re-run the full DoD. If doubt remains → cascade one verifier pass on Grok Fast. When VLH is gated, spawn it as a **separate Task** after tech PASS.

### 1.0b Composer compensation (large / mechanical work)

When implementer (or other Composer role) faces **large or mechanical** scope:

1. Parent **splits** into **more iterations** — more **bounded envelopes of the same role** (same subagent type).
2. **Do not** collapse into one mega-Composer pipeline.
3. **Do not** collapse roles (lab + implement + verify in one worker).
4. Prefer **several surgical Composer passes** over one overloaded pass.

### 1.1 Composer → Verifier → single Grok High Fast corrective pass

When Composer output does **not** satisfy the orchestrator or verifier:

1. **Keep** the child handoff and delta (do not discard evidence).
2. **Enrich** the next envelope with that delta, verifier FAIL/INCONCLUSIVE notes, and acceptance gaps.
3. Call **one** corrective/review pass on `cursor-grok-4.5-high-fast` (same role/envelope scope).
4. **Do not** blindly re-run Composer, and **do not** overwrite prior work without the preserved evidence trail.

Same single Grok High Fast corrective path applies after `## ESCALATE` or an insufficient verifier close when the prior writer was Composer-family.

### 1.2 O2 corrective routing (Oleada O2)

When verify **FAIL** is reproducible local (consolidated gap inventory, clear DoD) → parent opens **one O2** (`execute` → `verify`), not “Wave 4” or multiple O2s per gap:

| O2 scope | Model | When |
|----------|-------|------|
| **Mechanical / surgical** | `composer-2.5-fast` | Clear paths, scripted DoD, bounded file list from full gap inventory |
| **Judgment / anomaly / design** | `cursor-grok-4.5-high-fast` | Ambiguous acceptance, env fingerprint, methodology |
| **After Composer unsatisfied** | `cursor-grok-4.5-high-fast` | One corrective pass per §1.1 — keep delta, enrich envelope |

O3 (design/env/hipótesis) defaults to Grok High Fast for `research-lab` roles; implementer in O2 stays Composer unless judgment row applies.

### 1.3 Input envelopes vs output handoffs

| Artifact | Budget |
|----------|--------|
| **Child input envelope** | May be **long and complete** (full DoD, allow-list, gap inventory, deltas) |
| **Child output handoff** | **≤40 lines** — compact canonical section only |

**Ban:** applying ≤40 / ≤20 limits to **input prompts** or parent-written envelopes.

## 2. Measured (local pack evidence)

| Run ID | Status | Use |
|--------|--------|-----|
| `20260805-164541-7fb5ab8a` | **Valid** routing smoke (Grok) | Confirms orchestrator → Task / stream routing path |
| `20260805-165955-b686bd26` | **Valid** direct_role_control smoke (Grok) | Confirms root model resolution for direct role |
| Authenticated `agent --list-models` | **Confirmed** | IDs present: `cursor-grok-4.5-high`, `cursor-grok-4.5-high-fast`, `composer-2.5-fast` (and related Composer IDs as listed in `MODELS.local.md`) |

| Run ID | Status | Use |
|--------|--------|-----|
| `20260805-164220-a1ac3e7f` | Trust-blocked | **Inconclusive** — do not use for winner |
| `20260805-164654-d15e0bea` | Nested telemetry / legacy role | **Inconclusive** — do not use for winner |
| `20260805-170119-1cd75f23` | 11/48 interrupted, no `_summary` | **Inconclusive** — do not use for winner |

**Local conclusion:** there is **no** valid local head-to-head that establishes Grok superiority over Composer for this pack. Smokes validate **routing/IDs**, not model ranking.

## 3. External (CursorBench — not Fast variants)

Public CursorBench (as of policy freeze) reports approximately:

- **Grok 4.5 High** — 66.7%
- **Composer 2.5** — 56.1%

Cursor states a **possible** Grok advantage from an accidental Cursor snapshot included in training; **impact uncertain**.

**Honesty constraints:**

- This does **not** measure exactly the **Fast** variants (`cursor-grok-4.5-high-fast`, `composer-2.5-fast`).
- It is an **external** signal informing the user’s choice, not a local pack scoreboard.
- Do not cite CursorBench as proof that local Fast routing “won.”

## 4. Operational decision (why this pack pins these defaults)

The pack pins:

- Orchestrator → `cursor-grok-4.5-high`
- Maverick / verifier / VLH / single lab → `cursor-grok-4.5-high-fast`
- Lab Batch (≥2 parallel labs) → each lab-runner `composer-2.5-fast`
- Clear / repetitive / light children → `composer-2.5-fast`
- Large Composer work → **more bounded envelopes**, same role — not mega-pipeline

…as a **user decision** supported by (a) CursorBench as a soft external prior and (b) operational guardrails (gates, single O2 per verify fan-in, full gap inventory, evidence retention, VLH evidence classes, release checklist fase). It is **not** justified by a completed local superiority grid.

## 5. Fallback / remap

1. Run `agent --list-models` (or UI equivalent).
2. If `cursor-grok-4.5-high` is missing → nearest non-Fast Grok / frontier **high** reasoning ID; document in `MODELS.local.md` and install handoff.
3. If `cursor-grok-4.5-high-fast` is missing on a host that still has Grok → nearest Grok Fast / high-reasoning creativo ≥ implementer tier.
4. If `composer-2.5-fast` is missing → nearest **fast** tool-use Composer ID on the host; **never** fall back to non-Fast `composer-2.5`.
5. Prefer Task `model:` override when frontmatter ID is wrong for the host; do not invent roles beyond the matrix (orchestrator, explore, scout, maverick, lab-runner, implementer, verifier, **verifier-like-human**, skeptic, deletion).

`model: inherit` is **not** the orchestrator default (CLI instability). Explicit `cursor-grok-4.5-high` is the verified template pin.

### 5.1 Maverick + VerifierLikeHuman + Verifier judgment — Grok when exposed; else **`Host remap`**

| Host | Maverick / VLH / Verifier (judgment tier) | Label |
|------|-------------------------------------------|-------|
| **Cursor** (Grok exposed) | `cursor-grok-4.5-high-fast` | Pack Grok ID — not a remap |
| **Antigravity** (no Grok) | `gemini-3.1-pro-high` | **`Host remap`** — documented AGY high-reasoning; **never** call it Grok |
| **OpenCode** | `opencode-go/grok-4.5` when catalog has Grok | Else **`Host remap`** nearest high-reasoning (e.g. Nemotron) — never label “Grok” |
| **Codex** | Grok-equivalent high-fast if account exposes it | Else **`Host remap`** best OpenAI high-reasoning ID |

**Hard:** do not disable maverick, verifier judgment tier, or VLH on AGY. Do not put `grok-*` frontmatter on AGY. Do not narrate a Gemini/OpenAI remap as “Grok”. OpenCode/Codex prose: **Grok Fast when exposed** for Mav/Ver/VLH; else **Host remap**.

## 6. Pending (optional; does not block implementation)

- Full pilot grid (3 replicas, routing + direct_role_control) to completion with `_summary`.
- Any future comparison that claims Fast-vs-Fast must measure those IDs explicitly.
- Nested Task child-model telemetry remains **unavailable** in current CLI stream-json — do not pretend otherwise.

**Resume optional benchmark** (never required to ship policy):

```powershell
.\bench\Run-Benchmark.ps1                              # dry-run preflight
.\bench\Run-Benchmark.ps1 -Run -Replicas 1 -CaseFilter <id>
.\bench\Run-Benchmark.ps1 -Run                          # full grid when quota allows
.\bench\Summarize-Benchmark.ps1 -JsonlPath .\bench\results\<run-id>.jsonl
```

Interrupted or trust-blocked JSONL must stay on disk; summarize without declaring a winner. See [`../../tooling/bench/README.md`](../../tooling/bench/README.md).

## 7. Related docs

| Doc | Role |
|-----|------|
| [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md) | Matrix + remap checklist |
| [`../../canon/01-METHODOLOGY-SPACEX.md`](../../canon/01-METHODOLOGY-SPACEX.md) | Verify loop A–E, release checklist fase |
| [`../../runtime/cursor/agents/orchestrator.md`](../../runtime/cursor/agents/orchestrator.md) | Parent default + Task routing table |
| [`../../runtime/cursor/agents/verifier-like-human.md`](../../runtime/cursor/agents/verifier-like-human.md) | VLH role + evidence classes |
| [`../../runtime/cursor/agents/maverick.md`](../../runtime/cursor/agents/maverick.md) | Early + post-Harvest CONSULT |
| [`../../MODELS.local.md`](../../MODELS.local.md) | Host-local ID snapshot (gitignored) |
| [`../../tooling/bench/README.md`](../../tooling/bench/README.md) | How evidence is classified |
