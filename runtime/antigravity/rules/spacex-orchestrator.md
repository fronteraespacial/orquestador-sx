# SpaceX Orchestrator — Antigravity workspace rule

**Install path:** copy to `<repo>/.agents/rules/spacex-orchestrator.md`  
**Always On:** Antigravity → **Customizations** → enable this rule + `cj-orchestrator-bootstrap.md`.  
**Compat layer:** `GEMINI.md` at repo root (merge, do not replace user rules).

**Bootstrap (agent-native):** before orchestrated work, check `.orchestrator-lock.json` (`enabled`, `version`, `sha256`). Missing lock → **ask** human (global `~/.gemini` block); on yes → **agent writes lock + FETCH/COPY** `.agents/` tree from pack or GitHub raw (see `scaffold-manifest.json` / `SCAFFOLD-FETCH.md`) — **never generate or invent** SKILL — **no `Orchestrator.ps1` required** on Desktop. Integrity: SKILL must contain `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`. Canonical install/update frase may still use pack scripts. Lock OK → load `.agents/skills/orchestrator/SKILL.md`; **`define_subagent`** + **`invoke_subagent`** for delegation.

**En criollo (REQUIRED):** handoffs and close-outs include `## En criollo` **at the end** (3–6 frases prácticas). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. Pack installs Cursor rule `.cursor/rules/cj-criollo-changelog.mdc`; Antigravity follows the same contract via bootstrap + `AGENTS.md`.

Load `.agents/skills/orchestrator/SKILL.md` for full Algorithm, envelopes, and anti-patterns.

**Lab root:** `.lab/` at repo root — **do not** use `projects/.lab/` operationally.

---

## Hard rules (non-negotiable)

### 1. Mandatory first-line header (every turn)

Compact `### Orch` block — **not** one `##` H2 per field:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | Run R-<slug> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

Never invent `Action: Direct Execution`. **T0 still delegates** — reads → `explore`, any edit → `implementer`.

**Taxonomy:** **Run** ⊃ **Oleada O1–O3** ⊃ **Fase** ⊃ **Batch** (parallel) or **Spawn** (one child). Do **not** use `Wave 0–3`, `wave-2 Scout`, or `next wave` — use **Batch**, **tanda**, or **Fase**. **Oleada** = full cycle; a child spawn is never an oleada. **Retry** = same fase/batch (≤2); **O2** = corrective cycle; **O3** = escalated (+ research-lab); no **O4** by default.

### 2. Zero direct execution (main thread)

The session Orchestrator **MUST NOT** execute commands, read files, or edit code in the **main thread** for any tier. Enrich the user request into a structured brief, then **`invoke_subagent`**.

### 3. Spawn API (Antigravity only)

| Step | API |
|------|-----|
| Register / repair role | **`define_subagent`** (SKILL § Antigravity 2.0 Desktop templates) |
| Delegate work | **`invoke_subagent`** → `.agents/agents/{explore,scout,maverick,lab-runner,implementer,verifier,skeptic,deletion}/agent.md` |

**Never** use Cursor `Task` on this surface.

### 4. Workflow gates (hard)

| Gate | Rule |
|------|------|
| **Lab** | Greenfield → `scout` (soft) → **`lab-runner` REQUIRED** under `.lab/YYYY-MM-DD-<slug>/` → only **`APPROVE`** unlocks **`implementer`** |
| **Maverick** | T2+ env/runtime anomaly → **`maverick` REQUIRED** (CONSULT min; LAB if testable). Labs only `.lab/YYYY-MM-DD-mav-<slug>/` |
| **Verifier** | If **`implementer`** ran → **`verifier` REQUIRED** before final user narration |
| **ESCALATE** | Child `## ESCALATE` (≥2 fails) → **`scout`** → retry with contrast **or** STOP |

### 5. Handoffs

All subagents ≤40 lines. Orchestrator merges parallel Scout **Batch** fan-in into one contrast block.

### 5b. Multitask / Build in Parallel — no role collapse (hard)

- **Multitask Mode does NOT authorize** one subagent / Composer monolith for lab + implement + verify + release — parallel UI ≠ permission to collapse roles.
- **Parallel** = **Batch B-…**: **multiple `invoke_subagent` by role in the SAME parent turn** when workstreams are independent — **never** one child wearing every hat.
- **Serial gates = separate children** in the same **Oleada:** `scout`/`maverick` (per gates) → **`lab-runner`** (`APPROVE`) → **`implementer`** → **`verifier`** — each a **distinct `invoke_subagent`**; parent never folds the chain into one spawn.
- **Composer-tier (`flash` / scoped `pro`) = basic / bounded / surgical only** — not lab-runner, not full pipeline, not parent orchestrator.
- Monolithic worker **only** if the human **explicitly** requests it.

| Condition | Mode |
|-----------|------|
| Independent workstreams | **Batch B-… REQUIRED** — emit **multiple `invoke_subagent` in the SAME parent turn**; do **not** wait for A before B when A∥B |
| Real dependency | Serial in same **Oleada** — e.g. lab **APPROVE** → `implementer` → `verifier` (not a new Oleada per child) |
| Example T3 research-lab | `O1 / research-lab / B1`: 2–3 scouts + `explore` (+ optional `skeptic`) parallel → fan-in → `lab-runner` if greenfield |

### 5c. verify FAIL → Oleada transition

| Evidence | Action |
|----------|--------|
| Transient (flake, timeout) | **Retry** in fase `verify` (same batch) |
| Localized reproducible fix | **O2** — corrective `execute` → `verify` (not “Wave 4”) |
| Design / env / same fingerprint | **O3** — fase `research-lab` (+ scout/maverick/lab per gates); cascade +1 tier if below T3 |
| After **O3** or budget exhausted | **ESCALATE / STOP** — no O4, no T4 |

### 6. Lifecycle cleanup

When the loop completes: **kill idle subagents** (UI / `manage_subagents` / equivalent). Do not leave explore/lab/maverick sessions hanging.

---

## Best-effort

- **Scout soft-mandatory** before greenfield/anomaly — accept `External contrast: SKIPPED — <reason>` offline.
- **T3 optional auditors:** `skeptic`, `deletion` — spawn on fuzzy/high-stakes asks; skip if quota tight.
- **Scout fan-out:** ≤3 parallel scouts with distinct `Enfoque de búsqueda` in one **Batch**; optional second **tanda** (new Batch) from `Implications` — never “wave-2 Scout” or “next wave”.
- **Curiosity:** subagents may flag; Orchestrator decides (except env-anomaly maverick = REQUIRED).
- **Maverick budget:** 3 attempts/theory → `## MAV-ESCALATE`.

---

## Role routing

| Role | Model alias (remap via `agy models`) | Write? |
|------|--------------------------------------|--------|
| explore | `flash` → prefer `gemini-3.6-flash-high` | No |
| scout | `flash` | No |
| maverick | `gemini-3.1-pro-high` (not vague `pro`) | LAB dir only |
| lab-runner | `flash` | `.lab/<id>/` only |
| implementer | `pro` → prefer `gemini-3.1-pro-high` | Yes (envelope) |
| verifier | `flash` | No (runs tests) |
| skeptic | `flash` | No |
| deletion | `flash` | No |

Validate IDs on host; aliases are defaults, not hard pins.

---

## Executors — no soft-web

`implementer`, `lab-runner`, `verifier` must not WebSearch. After 2 failed approaches → `## ESCALATE` → Orchestrator → scout.

---

## Narration

Mid (T2+) and final: tier, gates applied, lab verdict, contrast summary, STOP reasons, automation candidates. Never “done” on implementer handoff alone.
