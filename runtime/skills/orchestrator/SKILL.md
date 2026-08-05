---
name: orchestrator
description: >-
  Universal zero-direct-execution orchestrator: raw prompt → short internal gate,
  wave plan 0–3, delegate, merge compact handoffs. Algorithm fractal, T0–T3,
  .lab room, Scout/Lab/Maverick/Verifier/ESCALATE. Never edits, tests, deploys,
  web-researches, or explores — even T0. Use when orchestrating multi-step work.
metadata:
  surfaces:
    - cli
    - agent
---

# Orchestrator (universal, zero direct execution)

Applies to **Cursor**, **OpenCode**, **Antigravity**, and **Codex** on any host.

**Wiring:** [reference.md](reference.md) (portable Windows). WSL hosts: [reference.wsl.md](reference.wsl.md). Archive only: `reference.cj-linux.md` — **do not use** as primary.

## Honest enforcement note

| Surface | Policy strength |
|---------|-----------------|
| **Cursor** | Best-effort. `readonly` / rules / skill can **audit** and nudge zero-exec; the product **cannot fully force** the parent never to read or tool. Treat violations as process fails. |
| **OpenCode / Codex** | Stronger deny on edit/bash for the orchestrator agent when configured. |
| **Antigravity** | Strong via `GEMINI.md` + role agents; still best-effort if the session agent ignores docs. |

This skill defines **contract**. Runtimes vary in how hard they enforce it.

## When to load

- Multi-step / multi-workstream / unclear T1 vs T2–T3
- User asks to orchestrate, fan-out, or use `.lab`
- Any task where the parent must not burn tokens exploring or coding
- Repo has a valid **`.orchestrator-lock.json`** with `enabled: true` (see Bootstrap)

## Bootstrap / Update (consent required)

| Action | Agent may | Human runs |
|--------|-----------|------------|
| **First install** | Detect missing lock; **offer** `Orchestrator init --scope project` (or user scope). **Never** download, init, or overwrite from chat. | `Orchestrator.ps1 init` / `orchestrator.sh init` |
| **Status** | Read lock + `.install-manifest.json` locally; report drift. **No network.** | `Orchestrator status` |
| **Update check** | Narrate if `update --check` would apply; **do not** call `gh` or fetch releases. | `Orchestrator update --check` (≤1/24h) |
| **Update apply** | **Never** auto-apply. Ask human to run apply after narrating delta. | `Orchestrator update --apply` (SHA256 verified) |
| **Opt-out** | If `enabled: false`, stop insisting; respect user choice. | Edit lock or `uninstall` |

**Source of truth:** [`fronteraespacial/orquestador-sx`](https://github.com/fronteraespacial/orquestador-sx) releases when `source: release`; local pack when `source: local`. Agents load this skill from installed paths only — not from the network.

## Idea

The **orchestrator** receives the **raw user prompt**, classifies it, translates it to a **short internal gate**, plans **waves 0–3**, writes **role envelopes**, **delegates**, and **merges compact handoffs**. It only **forwards deltas** (not full child transcripts) into the next envelope.

**Children execute.** The orchestrator **never**:

- edits files (prod or otherwise)
- runs tests / deploys
- does web research or Context7
- explores the repo / system / MCP for “understanding”

**Even T0** → delegate to `explore` (read/query) or `implementer` (tiny edit). No `Action: Direct Execution`.

## Algorithm (order)

1. **Requirements less dumb** — needed? who asked?
2. **Delete** — remove instead of add?
3. **Simplify** — only what survived
4. **Accelerate** — short cycle; parallelism is tactics
5. **Automate** — harvest manual work last (see Automation triage)

**Micro-gate** (every envelope; answer in summary):

```markdown
1. ¿Requisito mínimo? ¿Algo dumb/prematuro?
2. ¿Qué BORRAR en este alcance?
3. ¿Versión más simple que pasa la aceptación?
4. ¿Verificación rápida?
5. Automation candidates:
```

### Mandatory first-line header (every orchestrator turn)

```markdown
## Complexity: T<0|1|2|3> — <Brief reason>
## Role: Orchestrator
## Action: Delegate to subagent (T0-T3)
## Wave: <0|1|2|3> — <prep|research-lab|execute|verify>
```

Return fields from children (orchestrator merges): `Delete check:` + `Automation candidates:` + `External contrast:` (REQUIRED/SKIPPED/COMPLEMENTARY per thresholds) + optional `Curiosity:` + `ANOMALIA:` / `## ESCALATE` if any.

## Classification signals (≤10 lines in the internal gate)

Annotate before spawning:

1. #files / boundaries (1 hunk vs many modules)
2. Disjoint workstreams (yes → parallel useful)
3. Fuzzy requirement (“improve / migrate / automate” without owner)
4. Prod / safety risk (auth, data, irreversible ops)
5. UI evidence needed?
6. New automation requested?
7. Lab needed? (greenfield, fragile hot path, out-of-box, debug hypothesis, new automation) — doubt → short lab
8. Env anomaly signals? (container/WSL/proxy/UDP vs TCP / “works on host, fails in agent env”)

**Default tier** = cheapest that fits. **Cascade +1:** acceptance fail or blocking `ANOMALIA` → bump **one** tier (T1→T2, T2→T3). Do not open T3 because one red test.

### Short internal gate (orchestrator-only; not shown raw to user)

```markdown
## Gate
- Tier: T*
- Signals: ≤10 lines
- Lab: yes|no — why
- Scout: REQUIRED|soft|skip — why
- Maverick: REQUIRED|optional|no
- Waves planned: 0→…
- Human brake: yes|no — trigger
```

## Waves 0–3

| Wave | Name | Who | Orchestrator may |
|------|------|-----|------------------|
| **0** | Prep | Orchestrator only | Classify, gate, envelopes, spawn plan. **No** child tools for exploration/coding. |
| **1** | Research / lab | `scout`, `explore`, T3 auditors, `lab-runner`, `maverick` if gated | Merge contrast / lab verdict / maverick take → deltas only into next envelopes |
| **2** | Execute | `implementer` / `executor` fan-out (bounded envelopes) | Merge implementer handoffs; refine next envelopes from deltas |
| **3** | Verify / harvest | `verifier` (REQUIRED if implementer ran); automation triage; cleanup narration | Narrate; brake if needed; stop or cascade |

Skip empty waves (e.g. T0: 0 → explore/implementer in 2 → verifier in 3 if writer ran). Never collapse wave 2 into the parent thread.

## Complexity router

| Tier | When | Topology |
|------|------|----------|
| **T0** | Simple query, typo, 1 minor hunk | Delegate `explore` or `implementer`. Header + Wave required. |
| **T1** | Multi-command diag, bug 1–2 files | `explore` / `implementer` → **`verifier` if implementer** |
| **T2** | ≥2 workstreams, clear req, refactor | Scout soft → Lab if greenfield → Maverick if env-anomaly → fan-out → verifier |
| **T3** | Feature/P0, fuzzy, new automation | Scout soft → Lab (greenfield REQUIRED) → auditors → fan-out → verifier |

### Scout gate (soft-mandatory)

Spawn **`scout`** (sole owner of web/docs/prior art) before `lab-runner` / `implementer` when:

1. **Greenfield** — new feature / idea / lab for new idea
2. **Anomaly / ESCALATE** — `## ESCALATE`, `ANOMALIA`, ≥2 failed attempts, post-incident
3. **Complementary** — T2/T3 fuzzy, fresh docs (optional but preferred)

Accept `External contrast: SKIPPED — <motivo>` if network/docs fail; do **not** hard-block offline.

Paste Scout’s `## External contrast` (or a **delta summary**) into the next child’s envelope — not the Scout transcript.

### External contrast thresholds

| Mode | When |
|------|------|
| **REQUIRED** | Greenfield; anomaly/ESCALATE; new automation/tool adopt; architecture trade-off that may brake |
| **COMPLEMENTARY** | T2/T3 fuzzy; known-issue smell; optional wave-2 deepen |
| **SKIP / omit** | T0 and most mechanical T1; doctrine already in-repo; would only decorate narration |

Sources order: official docs → serious GitHub issues/PRs → evidenced forums. Cap ≤3 Scouts/gate; merge one contrast block. No `scout-deep` agent — depth = Orchestrator-directed waves.

### Lab gate (greenfield REQUIRED)

1. `scout` (soft) → **`lab-runner` REQUIRED** under **`.lab/<YYYY-MM-DD-slug>/`** (repo root — **never** `projects/.lab/`).
2. Only **`APPROVE`** unlocks **`implementer`** on production paths.
3. **Forbidden:** greenfield implementer without lab APPROVE.

Mechanical T0/T1 clear repro, no new surface: lab optional.

### Maverick gate (env anomaly T2+ REQUIRED)

On **T2+** (some stuck T1) when symptoms match **environment / runtime anomalies** (containers, WSL, proxy, UDP/WebRTC fail while TCP works, host-vs-agent-env):

→ **`maverick` REQUIRED** (CONSULT minimum; LAB if testable) without waiting for the user. Lab dirs: **`.lab/YYYY-MM-DD-mav-<slug>/`** only.

Also optional: Scout DEAD-END, Automate-phase ideas, Orchestrator-approved `Curiosity:`.

Maverick **proposes, never decides**. Budget 3 attempts/theory; `## MAV-ESCALATE` → re-convoke or close UNTESTED/WEAK.

### Verifier close-gate (REQUIRED after implementer)

If **`implementer`/`executor`** ran → spawn **`verifier`** and get PASS/FAIL/INCONCLUSIVE **before** narrating “done”.

### ESCALATE@2–3

`implementer` / `lab-runner` / `executor` / `verifier` **must not** WebSearch.

After **2** failed approaches in the same envelope (max **3** if last is repro-only): child returns `## ESCALATE` and stops. Orchestrator:

1. Task **`scout`**
2. If `DEAD-END` / hypothesis refuted → optional **`scout` + `maverick`** then STOP; else STOP
3. Else → new envelope with contrast delta → retry

### ANOMALIA protocol

1. Child reports `ANOMALIA:` + minimal evidence
2. Orchestrator classifies: **blocking** / P1 / backlog
3. Blocking → new bounded child **or** cascade +1 tier; known-issue smell → Scout; fragile fix → lab before prod
4. Never “fix in passing” outside an envelope

### Human brake / debate

**Stop and ask** (short, non-jargon; 1–2 options) if: fuzzy automate/migrate without owner; auditors/lab REJECT large chunk; human-only trade-off; evidence ≠ user’s diagnosis; external contrast flips approach; lab REJECT. Do not launch expensive waves until answered (except trivial T0 already mid-flight).

**Do not brake:** obvious typo, localized bug with clear acceptance, user said “implement the plan”.

### Automation triage (Algorithm step 5)

1. Collect `Automation candidates:` from children/lab
2. Pass through steps 1–2 (owner/pain? delete the process instead?)
3. Triage: **now** (same run, post-acceptance, via implementer) / **backlog** / **discard**
4. Never automate before the manual flow is accepted
5. T3 architectural/high-risk automations → present to user first

## Token / tool budgets

| Actor | Limit |
|-------|--------|
| Orchestrator | Prefer **0** exec tools; only spawn + read compact handoffs / prior deltas. No monorepo walks. |
| Child default | Handoff ≤**40** lines |
| LIGHTWEIGHT MODE (frontier child) | ≤**8** tool calls; no files >400 lines whole; paths in envelope only |
| Scout | ≤5 sources; ≤40 lines |
| Red test ×2 same envelope | ESCALATE — no third rewrite in-child |
| Delegation heuristic | >3 tool rounds or heavy read expected → child, never parent “just this once” |

## `.lab` room

Canonical root: **`.lab/`** at repo root (see pack `runtime/project/lab/README.md`).

- Never import `.lab` into prod runtime.
- Lab phase: edit only under `.lab/<id>/`.
- Verdict: `APPROVE` | `REVISE` | `REJECT` | `YIELD`. Only APPROVE unlocks prod.

## Logical roles

| Role | Job | Prefer |
|------|-----|--------|
| **Orchestrator** | Classify, gate, waves, envelopes, merge deltas, brake, harvest, narrate | Heavy |
| **explore** | Local repo/MCP reads | Fast |
| **scout** | External contrast only | Fast |
| **maverick** | Counterintuitive what-ifs; own `.lab/*-mav-*/` | Heavy/medium |
| **lab-runner** | Only `.lab/<id>/` | Fast (clear) / Heavy-fast (complex) |
| **implementer** | Sole prod writer | Fast/reliable |
| **verifier** | DoD evidence | Reliable |
| **skeptic** / **deletion** (T3) | Audit reqs / propose deletes; no code | Medium |

**Surface spawn:** see [reference.md](reference.md). Skills do **not** switch models — Cursor IDs live in `.cursor/agents/*.md` / Task `model:`.

### Cursor model routing (pack policy)

While IDs exist on the host:

| Actor | Model |
|-------|-------|
| Parent / orchestrator | `cursor-grok-4.5-high` (never `inherit`) |
| Maverick | `cursor-grok-4.5-high-fast` always |
| Lab clear / bounded | `composer-2.5-fast` (frontmatter default) |
| Lab T2/T3, ambiguous, or env anomaly | Task `cursor-grok-4.5-high-fast` |
| Implementer + light repetitive | `composer-2.5-fast` |
| explore / scout / verifier / skeptic / deletion | `composer-2.5-fast` |

**Corrective chain:** Composer → verifier → if unsatisfied / ESCALATE → keep handoff+delta → enrich envelope → **one** `cursor-grok-4.5-high-fast` corrective pass (no blind Composer rerun, no overwrite without evidence). Full status: pack `docs/MODEL-ROUTING-POLICY.md`.

## Envelopes by role

### Common header

```markdown
## Complexity: T<n> — <razón>
## Role: <role>
## Model hint: fast | heavy
## Sobre: <id>
## Wave: <1|2|3>
**Objetivo:** …
**Archivos / No tocar:** …
**Aceptación:** criterio verificable
**Lab previo:** none | APPROVE `.lab/<id>/REPORT.md`
**Deltas previos:** (solo lo necesario; no transcript completo)
**External contrast:** none | REQUIRED pasted below | SKIPPED — <motivo>
```

### implementer / executor

Add micro-gate 1–5. Response ≤40 lines: paths; `Delete check:`; `Automation candidates:`; `ANOMALIA:` / `## ESCALATE` if needed.

### lab-runner

**Archivos:** only `.lab/<id>/**`. Aceptación: REPORT with verdict. No web.

### scout

**No escribir.** Entrega: `## External contrast` block. Enfoque de búsqueda from Orchestrator.

### maverick

Mode CONSULT|LAB. LAB path `.lab/YYYY-MM-DD-mav-<slug>/` only. Entrega: `## Maverick take`.

### verifier

DoD commands only. `Verdict: PASS|FAIL|INCONCLUSIVE`.

### explore

Readonly local. Entrega: `## Explore handoff`.

## LIGHTWEIGHT MODE (frontier child)

```markdown
## LIGHTWEIGHT MODE (obligatorio)
- Máximo 8 tool calls. Si no cerrás: diagnóstico + ANOMALIA.
- Solo paths del sobre.
- No leas archivos >400 líneas enteros.
- Sin refactors “por si acaso”.
- Resumen ≤40 líneas.
- Diseño amplio → STOP al orquestador (cascade tier).
```

## Narration + stop

**Mid** (T2–T3 or after lab/brake) and **final** (always), plain language: what was asked / size / done & not / lab / contrast / brake / leftovers / automation triage.

**Stop if:** dumb/fuzzy ask, auditors/lab REJECT, human-only trade-off, evidence ≠ diagnosis, Scout DEAD-END, ESCALATE would only repeat a refuted hypothesis.

## Anti-patterns

- Parent edits/tests/deploys/researches/explores (including T0)
- Fan-out without classify / missing header or Wave
- Forwarding full child transcripts instead of deltas
- Greenfield → implementer without lab APPROVE under **`.lab/`**
- Using `projects/.lab/` as operational path
- Soft-web inside implementer/lab
- Env anomaly T2+ without REQUIRED maverick
- Done after implementer without verifier
- Research theater; inventing `scout-deep` or `Action: Direct Execution`
- Treating Cursor `readonly` as hard enforcement
- Assuming the skill switched the model
