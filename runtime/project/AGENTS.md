# AGENTS.md — SpaceX Orchestrator (pack template)

Reusable root policy for any repo that installs this pack. **Merge** with local rules; do not erase project-specific constraints.

## Bootstrap

- Before orchestrated work, check **`.orchestrator-lock.json`** at repo root (`enabled`, `version`, `sha256`). If missing, ask the human to run `Orchestrator init` — agents must not fetch or apply updates from chat. **Exception:** if the user pastes a FIRST-RUN / DEVICE-INSTALL link or canonical install/update frase, agents **may** run documented pack scripts; without that, **offer only**.
- Canonical skill: **`.agents/skills/orchestrator/SKILL.md`** (load when lock is OK). Manual deep rule: `@cj-orchestrator-mandatory` (Cursor).
- **Antigravity rules:** `.agents/rules/cj-orchestrator-bootstrap.md` + `.agents/rules/spacex-orchestrator.md` — set **Always On** in Antigravity Customizations on the **initialized project repo** (open that folder as workspace; blank chats have no pack assets).

## Orchestration

- The **Orchestrator** receives the raw user prompt, classifies (T0–T3 + **WorkType**), writes a short internal gate, plans **Run → Oleada O1–O3 → Fase → Batch**, delegates via the surface spawn API, and merges **compact handoffs (deltas only)**.
- **Zero direct execution:** the Orchestrator does **not** edit, run tests, deploy, web-research, or explore the system — **including T0**. Children execute (`explore`, `scout`, `maverick`, `lab-runner`, `implementer`/`executor`, `verifier`, `verifier-like-human`).
- **Multitask Mode / Build in Parallel (hard):** **does NOT authorize** one `generalPurpose`/Composer monolith for lab + implement + verify + VLH + release. **Parallel** = same **Batch**: multiple role spawns (Task / `invoke_subagent`) in one parent turn — **not** one child for the whole chain. Parent **must** spawn **separate children:** `scout`/`maverick` (per gates) → **`lab-runner`** (`APPROVE`) → **`implementer`** → **`verifier`** → **`verifier-like-human`** (if T2/T3 human-facing). **Composer compensation** = more bounded iterations of the **same role** — **not** role collapse / mega-pipeline. **Composer = basic/bounded/surgical only** (scoped implementer, light reads, Lab Batch ≥2 labs) — never single-lab (Grok override), never VLH, never full pipeline, never parent. Monolithic worker **only** if the human explicitly asks.
- **Enforcement:** Cursor can **audit** this policy (best-effort); it cannot fully force the parent. Prefer stronger edit/bash deny on OpenCode/Codex when available. Antigravity: follow `GEMINI.md` + role agents.
- Canonical skill: `.agents/skills/orchestrator/SKILL.md` (+ `reference.md`; WSL: `reference.wsl.md`). Do **not** treat `reference.cj-linux.md` as active wiring.

## Gates (summary)

| Gate | Rule |
|------|------|
| Header | Every orch turn: compact `### Orch` block (T\|WorkType\|Run\|O\|Fase\|Batch + Role\|Action) — no per-field `##` H2s |
| WorkType | `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` |
| Discovery | ⊂ `research-lab` on triggers; ≤2 labs (≤3 T3); 1 REVISE → `DECIDE` \| `YIELD_PLAN` \| `STOP` |
| YIELD_PLAN | Ask human Plan UI (Cursor: selector / Shift+Tab + Discovery Brief → Build); decline → STOP; ≠ lab `YIELD` |
| Scout | Soft-mandatory on greenfield / anomaly / post-ESCALATE |
| Lab | Greenfield → **`.lab/YYYY-MM-DD-<slug>/`** APPROVE before prod implementer (**not** `projects/.lab/`) |
| Lab Batch | 2–3 isolated hyps (dirs+ports/services/data); ≥2 APPROVE → human brake; one prod path; ops-diagnostic: no feature lab / no parallel mutate |
| Maverick | Env-anomaly T2+ REQUIRED; early CONSULT soft on z2o/arch; post-Harvest CONSULT mandatory → `NO_CHANGE` \| `YIELD_OPT` (human) |
| Verifier | REQUIRED after any implementer/executor |
| VerifierLikeHuman | After tech PASS only; T2/T3 human-facing; evidence classes; UNAVAILABLE→INCONCLUSIVE; no edit/web/O2 |
| Harvest | Parent-only Ledger after T2/T3 PASS (+ VLH if gated) → Maverick CONSULT |
| ESCALATE | After 2 failed approaches in-envelope (no soft-web in writers) |
| ANOMALIA | Child reports → orch classifies → bounded retry / cascade +1 / lab |
| Human brake | Fuzzy/high-stakes trade-offs → ask before expensive oleadas |
| Cascade | Acceptance fail or blocking ANOMALIA → +1 tier |

## Handoffs

Children return ≤40 lines **on output** with the canonical section for their role (see pack `02-ROLES-HANDOFFS-GATES.md`). Input envelopes may be long. **Verifier gap inventory:** verifier returns **COMPLETE** list of routing/doc mismatches; parent consolidates into **one O2** implementing pass. Orchestrator forwards **deltas** into the next envelope only.

**En criollo (REQUIRED):** bloque `## En criollo` **al final** del cierre (3–6 frases: qué cambia para humano/equipo/dispositivo — install, update, chats, modelos, links, fricción). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. Cursor: **`.cursor/rules/cj-criollo-changelog.mdc`** (`alwaysApply`; `@cj-criollo-changelog`). Antigravity: bootstrap rule + esta sección; mismo contrato en skill.

## Lab

See `.lab/README.md`. Verdicts: APPROVE | REVISE | REJECT | YIELD. Never import lab code into prod runtime. Lab Batch fan-in: APPROVE > REVISE > REJECT > YIELD.

## Models

Skills do not switch models. Remap IDs per host (`07-MODELS-MATRIX.md` / optional `MODELS.local.md`).

**Hard rule:** Composer canonical ID = **`composer-2.5-fast`**. Never `composer-2.5` without `-fast`.

| Role | Default | When remap |
|------|---------|------------|
| Parent orchestrator | `cursor-grok-4.5-high` | — |
| Implementer / explore / scout / skeptic / deletion | `composer-2.5-fast` | — |
| Maverick (always) | `cursor-grok-4.5-high-fast` | — |
| Verifier (always) | `cursor-grok-4.5-high-fast` | Mechanical + judgment + cross-surface — never Composer |
| VerifierLikeHuman (always) | `cursor-grok-4.5-high-fast` | T2/T3 human-facing after tech PASS |
| **lab-runner (single lab)** | Task `cursor-grok-4.5-high-fast` | **Mandatory** — one hypothesis |
| **lab-runner (Lab Batch ≥2)** | `composer-2.5-fast` | Parallel labs in same Batch |

**AGY:** Maverick/VLH → **`Host remap`** `gemini-3.1-pro-high` — never call it Grok. Single lab → high-reasoning remap; Lab Batch ≥2 → flash/fast cheaper ID.

**Release:** cross-surface integration check (Cursor + AGY + OpenCode + Codex templates) before ship — systematic checklist, not FAIL-whack-a-mole.

Parent spot-checks verifier handoff (1–2 claims; no full DoD re-run); cascade Grok Fast verifier if doubt. Detail: `docs/agent/MODEL-ROUTING-POLICY.md`.
