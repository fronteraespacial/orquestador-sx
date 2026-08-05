# AGENTS.md — SpaceX Orchestrator (pack template)

Reusable root policy for any repo that installs this pack. **Merge** with local rules; do not erase project-specific constraints.

## Bootstrap

- Before orchestrated work, check **`.orchestrator-lock.json`** at repo root (`enabled`, `version`, `sha256`). If missing, ask the human to run `Orchestrator init` — agents must not fetch or apply updates from chat. **Exception:** if the user pastes a FIRST-RUN / DEVICE-INSTALL link or canonical install/update frase, agents **may** run documented pack scripts; without that, **offer only**.
- Canonical skill: **`.agents/skills/orchestrator/SKILL.md`** (load when lock is OK). Manual deep rule: `@cj-orchestrator-mandatory`.

## Orchestration

- The **Orchestrator** receives the raw user prompt, classifies (T0–T3), writes a short internal gate, plans **waves 0–3**, delegates via the surface spawn API, and merges **compact handoffs (deltas only)**.
- **Zero direct execution:** the Orchestrator does **not** edit, run tests, deploy, web-research, or explore the system — **including T0**. Children execute (`explore`, `scout`, `maverick`, `lab-runner`, `implementer`/`executor`, `verifier`).
- **Multitask Mode / Build in Parallel:** does **not** collapse roles — no single `generalPurpose`/Composer doing lab + implement + verify + release. Parent **always** spawns by role: `lab-runner` (`APPROVE`) → `implementer` → `verifier` (scout/maverick per gates). Monolithic worker **only** if the human explicitly asks.
- **Enforcement:** Cursor can **audit** this policy (best-effort); it cannot fully force the parent. Prefer stronger edit/bash deny on OpenCode/Codex when available. Antigravity: follow `GEMINI.md` + role agents.
- Canonical skill: `.agents/skills/orchestrator/SKILL.md` (+ `reference.md`; WSL: `reference.wsl.md`). Do **not** treat `reference.cj-linux.md` as active wiring.

## Gates (summary)

| Gate | Rule |
|------|------|
| Header | Every orch turn: `## Complexity`, `## Role: Orchestrator`, `## Action: Delegate…`, `## Wave` |
| Scout | Soft-mandatory on greenfield / anomaly / post-ESCALATE |
| Lab | Greenfield → **`.lab/YYYY-MM-DD-<slug>/`** APPROVE before prod implementer (**not** `projects/.lab/`) |
| Maverick | Env-anomaly T2+ REQUIRED |
| Verifier | REQUIRED after any implementer/executor |
| ESCALATE | After 2 failed approaches in-envelope (no soft-web in writers) |
| ANOMALIA | Child reports → orch classifies → bounded retry / cascade +1 / lab |
| Human brake | Fuzzy/high-stakes trade-offs → ask before expensive waves |
| Cascade | Acceptance fail or blocking ANOMALIA → +1 tier |

## Handoffs

Children return ≤40 lines with the canonical section for their role (see pack `02-ROLES-HANDOFFS-GATES.md`). Orchestrator forwards **deltas** into the next envelope only.

## Lab

See `.lab/README.md`. Verdicts: APPROVE | REVISE | REJECT | YIELD. Never import lab code into prod runtime.

## Models

Skills do not switch models. Remap IDs per host (`07-MODELS-MATRIX.md` / optional `MODELS.local.md`).

| Role | Default | When remap |
|------|---------|------------|
| Parent orchestrator | Grok High | — |
| Implementer | Composer Fast | — |
| Maverick / ambiguous lab | Grok High Fast | env anomaly, T2/T3 lab |
| **Verifier (mechanical)** | Composer Fast | scripts, exit codes, lock/hash checks |
| **Verifier (judgment)** | Grok High Fast (Task) | docs/prompt clarity, security/methodology; Composer-tier writer |

Parent spot-checks verifier handoff (1–2 claims; no full DoD re-run); cascade Grok Fast verifier if doubt. Detail: `docs/MODEL-ROUTING-POLICY.md`.
