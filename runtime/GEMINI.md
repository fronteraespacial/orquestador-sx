# GEMINI.md — Antigravity root rules (compatibility layer)

> **Primary workspace rules:** `.agents/rules/spacex-orchestrator.md` + `.agents/rules/cj-orchestrator-bootstrap.md` (copy from pack `runtime/antigravity/rules/`).  
> **Always On:** Antigravity → **Customizations** → enable both rules in the **project repo** (not a blank chat).  
> This `GEMINI.md` remains for Antigravity builds that load root rules only — **merge** with local user rules; do not overwrite wholesale.

**Bootstrap (agent-native):** check `.orchestrator-lock.json`. Missing → **ask** human (global `~/.gemini` block); on yes → **agent writes lock + FETCH/COPY** `.agents/` tree from pack or GitHub raw — **never generate or invent** SKILL — **no `Orchestrator.ps1` required** on Desktop. Integrity markers required in SKILL. Canonical install frase may still use pack scripts. Lock OK → load `.agents/skills/orchestrator/SKILL.md`; **`define_subagent`** (include **`VerifierLikeHuman`**) + **`invoke_subagent`** for delegation (never Cursor `Task`). No init/update from chat without canonical install/update frase.

**En criollo (REQUIRED):** technical handoffs/close-outs include `## En criollo` **at the end** (3–6 frases prácticas). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. See bootstrap rule + `AGENTS.md`.

**Lab root:** `.lab/` at repo root — **do not** use `projects/.lab/` (legacy).

## MANDATORY ORCHESTRATION (ZERO EXCEPTIONS)

### First-line header (T0–T3)

Compact block — **not** one `##` H2 per field:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | WorkType <greenfield|evolving-product|legacy-app|ops-diagnostic> | Run R-<slug> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

- Never omit. Treating `orchestrator/SKILL.md` as optional is an anti-pattern.
- **Action is always** `Delegate to subagent (T0-T3)`. No `Direct Execution` on Antigravity — **T0 included**.
- **Taxonomy:** Run ⊃ Oleada O1–O3 ⊃ Fase ⊃ Batch (parallel) or Spawn (one child). No `Wave 0–3`. Independent work → multiple `invoke_subagent` **same turn** (Batch). lab APPROVE → implementer → verifier → VLH (if gated) stays serial in one Oleada. verify FAIL local → **O2**; design/env → **O3**; then ESCALATE/STOP (no O4). VLH/Maverick never open O2.
- **Multitask / Build in Parallel (hard):** does **NOT** authorize one monolith for lab + implement + verify + release. **Parallel** = Batch with multiple role `invoke_subagent` in one turn; **serial gates** = separate children (`lab-runner` → `implementer` → `verifier` → `verifier-like-human` if gated). **Composer compensation** = same-role bounded iterations — **not** mega-pipeline. Composer/flash = basic/bounded/surgical only — detail in `.agents/rules/spacex-orchestrator.md` §5b.
- **ops-diagnostic:** no feature lab/pipeline; **no** parallel mutations.

### Zero direct execution (hard)

Main agent **MUST NOT** execute commands, read files, or edit code in the main thread. Enrich → **`invoke_subagent`**.

### Subagent routing (`.agents/agents/`)

| Role | Model alias | Job |
|------|-------------|-----|
| **explore** | `flash` | Local repo/MCP/system (not web) |
| **scout** | `flash` | External contrast; soft before greenfield/anomaly |
| **maverick** | **`Host remap`:** `gemini-3.1-pro-high` | What-ifs; early Discovery + post-Harvest CONSULT; LAB in `.lab/YYYY-MM-DD-mav-<slug>/` only; proposes only (no auto O2). **Never** call this Grok |
| **lab-runner** | `flash` (Lab Batch ≥2) · **`Host remap`** `gemini-3.1-pro-high` (single lab) | Spike in `.lab/YYYY-MM-DD-<slug>/` — no formal Implementation Plan text. **Single lab** → high-reasoning remap; **Lab Batch (≥2)** → flash/fast cheaper ID |
| **implementer** | `pro` → prefer `gemini-3.1-pro-high` | Production writes (after lab APPROVE on greenfield) |
| **verifier** | **`Host remap`:** `gemini-3.1-pro-high` (always) | DoD tests + gap inventory — REQUIRED after implementer. **Never** flash for verifier; never label remap Grok |
| **verifier-like-human** | **`Host remap`:** `gemini-3.1-pro-high` | After tech PASS; T2/T3 human-facing; evidence classes; INCONCLUSIVE if absent; never edits/O2. **Never** call this Grok |
| **skeptic** | `flash` | Optional T3 requirements audit |
| **deletion** | `flash` | Optional T3 delete proposals |

Invoke via **`invoke_subagent`**. Register VLH with **`define_subagent`** (`VerifierLikeHuman`). Handoffs ≤40 lines. Cursor uses Task + `.cursor/agents/` — see skill `reference.md`.

**Models:** AGY has **no** Grok. Maverick/VLH stay enabled via **`Host remap`** `gemini-3.1-pro-high` — list live IDs (`agy models` / UI); never `grok-*` frontmatter; never silent-downgrade to flash. Cursor (other surface) uses `cursor-grok-4.5-high-fast` when Grok is exposed.

---

## Workflow gates (hard)

1. **WorkType + Discovery:** classify WorkType; Discovery ⊂ `research-lab` when triggers hit — budget one Batch; ≤2 labs (≤3 T3); one REVISE; then **`DECIDE` \| `YIELD_PLAN` \| `STOP`**.
2. **YIELD_PLAN (AGY):** human opens **Planning Mode** + **Artifact Review** → **Request Review** / **Proceed** — ask/narrate only; **no silent auto Plan Mode**. Decline Build → STOP. ≠ lab `YIELD`.
3. **Lab Batch:** isolate dirs + ports/services/data; fan-in; ≥2 APPROVE → human brake; one prod path.
4. **Lab gate:** greenfield → scout (soft) → **`lab-runner` REQUIRED** → only `APPROVE` from `.lab/<id>/` → **`implementer`**.
5. **ops-diagnostic:** evidence only — no feature labs; no parallel mutations.
6. **Maverick gate:** **`Host remap`** high-reasoning (`gemini-3.1-pro-high`); early CONSULT on z2o/trade-off; T2+ env anomaly → **REQUIRED**; post-Harvest CONSULT mandatory — proposes only; no auto O2.
7. **Verifier close-gate:** **`implementer` ran** → **`verifier`** before “done”; then **`verifier-like-human`** if T2/T3 human-facing after PASS.
8. **Harvest:** parent-only Ledger after T2/T3 PASS (+ VLH if gated) → Maverick CONSULT → human YIELD_OPT.
9. **Lifecycle:** kill idle subagents when loop ends.
10. **Maverick naming:** only `.lab/YYYY-MM-DD-mav-<slug>/`.

### Verify loop (1.3.1 — brief)

| Rule | Detail |
|------|--------|
| **L4 — Cross-surface check** | After multi-surface execute Batch: verifier includes integration consistency (installer maps, docs↔runtime, naming) before release claims. |
| **L5 — RELEASE CHECKLIST fase** | VERSION, lock sha, RefreshSandbox, zip/SHA256SUMS, pin tags = explicit fase — **not** discovered via successive verify FAIL cascades. |

Full verify loop **A–E** (gap inventory, one O2, input vs output): `.agents/skills/orchestrator/SKILL.md` § Verify loop + pack `canon/01-METHODOLOGY-SPACEX.md` § verify FAIL.

## Best-effort

- Scout `SKIPPED` OK offline.
- T3 optional **`skeptic`**, **`deletion`**.
- Scout **Batch** (≤3 parallel scouts, distinct search foci); optional second **tanda** from `Implications` — not “wave-2” or “next wave”.
- Maverick 3 attempts/theory → `## MAV-ESCALATE`.
- Curiosity lines → Orchestrator decides (except env-anomaly maverick = REQUIRED).

## ESCALATE + no soft-web

Executors (**implementer** / **lab-runner** / **verifier** / **verifier-like-human**): no WebSearch. After 2 fails → `## ESCALATE` → scout → retry or STOP (optionally scout+maverick on DEAD-END).

---

*Duplicated gates also live in `.agents/rules/spacex-orchestrator.md` — keep both in sync when customizing.*
