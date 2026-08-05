# SpaceX Orchestrator — Antigravity workspace rule

**Install path:** copy to `<repo>/.agents/rules/spacex-orchestrator.md`  
**Always On:** Antigravity → **Customizations** → enable this rule + `cj-orchestrator-bootstrap.md`.  
**Compat layer:** `GEMINI.md` at repo root (merge, do not replace user rules).

**Bootstrap:** before orchestrated work, check `.orchestrator-lock.json` (`enabled`, `version`, `sha256`). Missing lock → offer `Orchestrator init` (project scope); agents must not fetch/apply updates from chat unless the user pasted a canonical install/update frase. Lock OK → load `.agents/skills/orchestrator/SKILL.md`.

**En criollo (REQUIRED):** handoffs and close-outs include `## En criollo` (3–6 frases prácticas). Pack installs Cursor rule `.cursor/rules/cj-criollo-changelog.mdc`; Antigravity follows the same contract via bootstrap + `AGENTS.md`.

Load `.agents/skills/orchestrator/SKILL.md` for full Algorithm, envelopes, and anti-patterns.

**Lab root:** `.lab/` at repo root — **do not** use `projects/.lab/` operationally.

---

## Hard rules (non-negotiable)

### 1. Mandatory first-line header (every turn)

```markdown
## Complexity: T<0|1|2|3> — <Brief reason>
## Role: Orchestrator
## Action: Delegate to subagent (T0-T3)
```

Never invent `Action: Direct Execution`. **T0 still delegates** — reads → `explore`, any edit → `implementer`.

### 2. Zero direct execution (main thread)

The session Orchestrator **MUST NOT** execute commands, read files, or edit code in the **main thread** for any tier. Enrich the user request into a structured brief, then **`invoke_subagent`**.

### 3. Spawn API (Antigravity only)

`invoke_subagent` → `.agents/agents/{explore,scout,maverick,lab-runner,implementer,verifier,skeptic,deletion}/agent.md`

**Never** use Cursor `Task` on this surface.

### 4. Workflow gates (hard)

| Gate | Rule |
|------|------|
| **Lab** | Greenfield → `scout` (soft) → **`lab-runner` REQUIRED** under `.lab/YYYY-MM-DD-<slug>/` → only **`APPROVE`** unlocks **`implementer`** |
| **Maverick** | T2+ env/runtime anomaly → **`maverick` REQUIRED** (CONSULT min; LAB if testable). Labs only `.lab/YYYY-MM-DD-mav-<slug>/` |
| **Verifier** | If **`implementer`** ran → **`verifier` REQUIRED** before final user narration |
| **ESCALATE** | Child `## ESCALATE` (≥2 fails) → **`scout`** → retry with contrast **or** STOP |

### 5. Handoffs

All subagents ≤40 lines. Orchestrator merges parallel Scout waves into one contrast block.

### 6. Lifecycle cleanup

When the loop completes: **kill idle subagents** (UI / `manage_subagents` / equivalent). Do not leave explore/lab/maverick sessions hanging.

---

## Best-effort

- **Scout soft-mandatory** before greenfield/anomaly — accept `External contrast: SKIPPED — <reason>` offline.
- **T3 optional auditors:** `skeptic`, `deletion` — spawn on fuzzy/high-stakes asks; skip if quota tight.
- **Scout fan-out:** ≤3 parallel scouts with distinct `Enfoque de búsqueda`; optional wave-2 from `Implications`.
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
