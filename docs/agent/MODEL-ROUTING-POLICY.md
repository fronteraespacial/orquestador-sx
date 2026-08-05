# Model routing policy — status & evidence

**Pack version:** see [`../VERSION`](../VERSION)  
**Last updated:** 2026-08-05  
**Authority:** user operational decision for this pack (not a local benchmark “winner”).

This document separates **what was measured**, **external signals**, **the operational decision**, and **what remains pending**. It does not declare a local Grok-vs-Composer superiority conclusion.

## 1. Exact operational policy (Cursor)

While these model IDs remain available on the host (`agent --list-models`):

| Actor | Model ID | When |
|-------|----------|------|
| **Parent / orchestrator** | `cursor-grok-4.5-high` | Always (session default; template frontmatter) |
| **Maverick** | `cursor-grok-4.5-high-fast` | Always |
| **Lab-runner (complex)** | `cursor-grok-4.5-high-fast` | Lab is **T2/T3**, **ambiguous**, or **anomalous** (WSL / Docker / proxy / env); also after insufficient verifier or `## ESCALATE` |
| **Lab-runner (clear)** | `composer-2.5-fast` | Clear, bounded hypothesis; default frontmatter — **do not** force Grok on every simple lab |
| **Implementer / repetitive roles** | `composer-2.5-fast` | Repetitive/fast work, mechanical refactors, surgical edits with clear paths + DoD |
| **explore, scout, verifier, skeptic, deletion** | `composer-2.5-fast` | Light / tool-use defaults (no new roles) |

**No new roles.** Remap only if an ID is missing on the host (see §5 and [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md)).

### 1.1 Composer → Verifier → single Grok High Fast corrective pass

When Composer output does **not** satisfy the orchestrator or verifier:

1. **Keep** the child handoff and delta (do not discard evidence).
2. **Enrich** the next envelope with that delta, verifier FAIL/INCONCLUSIVE notes, and acceptance gaps.
3. Call **one** corrective/review pass on `cursor-grok-4.5-high-fast` (same role/envelope scope).
4. **Do not** blindly re-run Composer, and **do not** overwrite prior work without the preserved evidence trail.

Same single Grok High Fast corrective path applies after `## ESCALATE` or an insufficient verifier close when the prior writer was Composer-family.

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
- Complex / anomaly / maverick / corrective → `cursor-grok-4.5-high-fast`
- Clear / repetitive / light → `composer-2.5-fast`

…as a **user decision** supported by (a) CursorBench as a soft external prior and (b) operational guardrails (gates, single corrective pass, evidence retention). It is **not** justified by a completed local superiority grid.

## 5. Fallback / remap

1. Run `agent --list-models` (or UI equivalent).
2. If `cursor-grok-4.5-high` is missing → nearest non-Fast Grok / frontier **high** reasoning ID; document in `MODELS.local.md` and install handoff.
3. If `cursor-grok-4.5-high-fast` is missing → nearest Grok Fast / high-reasoning creativo ≥ implementer tier.
4. If `composer-2.5-fast` is missing → nearest fast tool-use Composer (or `composer-2.5` if Fast absent).
5. Prefer Task `model:` override when frontmatter ID is wrong for the host; do not invent new roles.

`model: inherit` is **not** the orchestrator default (CLI instability). Explicit `cursor-grok-4.5-high` is the verified template pin.

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
| [`../../runtime/cursor/agents/orchestrator.md`](../../runtime/cursor/agents/orchestrator.md) | Parent default + Task routing table |
| [`../../MODELS.local.md`](../../MODELS.local.md) | Host-local ID snapshot (gitignored) |
| [`../../tooling/bench/README.md`](../../tooling/bench/README.md) | How evidence is classified |
