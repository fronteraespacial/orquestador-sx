# GEMINI.md — Antigravity root rules (compatibility layer)

> **Primary workspace rules:** `.agents/rules/spacex-orchestrator.md` + `.agents/rules/cj-orchestrator-bootstrap.md` (copy from pack `runtime/antigravity/rules/`).  
> **Always On:** Antigravity → **Customizations** → enable both rules in the **project repo** (not a blank chat).  
> This `GEMINI.md` remains for Antigravity builds that load root rules only — **merge** with local user rules; do not overwrite wholesale.

**Bootstrap (agent-native):** check `.orchestrator-lock.json`. Missing → **ask** human (global `~/.gemini` block); on yes → **agent writes lock + FETCH/COPY** `.agents/` tree from pack or GitHub raw — **never generate or invent** SKILL — **no `Orchestrator.ps1` required** on Desktop. Integrity markers required in SKILL. Canonical install frase may still use pack scripts. Lock OK → load `.agents/skills/orchestrator/SKILL.md`; **`define_subagent`** + **`invoke_subagent`** for delegation (never Cursor `Task`). No init/update from chat without canonical install/update frase.

**En criollo (REQUIRED):** technical handoffs/close-outs include `## En criollo` **at the end** (3–6 frases prácticas). Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. See bootstrap rule + `AGENTS.md`.

**Lab root:** `.lab/` at repo root — **do not** use `projects/.lab/` (legacy).

## MANDATORY ORCHESTRATION (ZERO EXCEPTIONS)

### First-line header (T0–T3)

Compact block — **not** one `##` H2 per field:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | Run R-<slug> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

- Never omit. Treating `orchestrator/SKILL.md` as optional is an anti-pattern.
- **Action is always** `Delegate to subagent (T0-T3)`. No `Direct Execution` on Antigravity — **T0 included**.
- **Taxonomy:** Run ⊃ Oleada O1–O3 ⊃ Fase ⊃ Batch (parallel) or Spawn (one child). No `Wave 0–3`. Independent work → multiple `invoke_subagent` **same turn** (Batch). lab APPROVE → implementer → verifier stays serial in one Oleada. verify FAIL local → **O2**; design/env → **O3**; then ESCALATE/STOP (no O4).
- **Multitask / Build in Parallel (hard):** does **NOT** authorize one monolith for lab + implement + verify + release. **Parallel** = Batch with multiple role `invoke_subagent` in one turn; **serial gates** = separate children (`lab-runner` → `implementer` → `verifier`). Composer/flash = basic/bounded/surgical only — detail in `.agents/rules/spacex-orchestrator.md` §5b.

### Zero direct execution (hard)

Main agent **MUST NOT** execute commands, read files, or edit code in the main thread. Enrich → **`invoke_subagent`**.

### Subagent routing (`.agents/agents/`)

| Role | Model alias | Job |
|------|-------------|-----|
| **explore** | `flash` | Local repo/MCP/system (not web) |
| **scout** | `flash` | External contrast; soft before greenfield/anomaly |
| **maverick** | `gemini-3.1-pro-high` | What-ifs; LAB in `.lab/YYYY-MM-DD-mav-<slug>/` only |
| **lab-runner** | `flash` | Spike in `.lab/YYYY-MM-DD-<slug>/` |
| **implementer** | `pro` → prefer `gemini-3.1-pro-high` | Production writes (after lab APPROVE on greenfield) |
| **verifier** | `flash` | DoD tests — REQUIRED after implementer |
| **skeptic** | `flash` | Optional T3 requirements audit |
| **deletion** | `flash` | Optional T3 delete proposals |

Invoke via **`invoke_subagent`**. Handoffs ≤40 lines. Cursor uses Task + `.cursor/agents/` — see skill `reference.md`.

**Models:** aliases above are defaults — list live IDs (`agy models` / UI) and remap frontmatter when missing.

---

## Workflow gates (hard)

1. **Lab gate:** greenfield → scout (soft) → **`lab-runner` REQUIRED** → only `APPROVE` from `.lab/<id>/` → **`implementer`**.
2. **Maverick gate:** T2+ env anomaly (constrained runtime, UDP/WebRTC, namespace quirks, “works on host / fails in sandbox”) → **`maverick` REQUIRED** without user ask.
3. **Verifier close-gate:** **`implementer` ran** → **`verifier`** before “done”.
4. **Lifecycle:** kill idle subagents when loop ends.
5. **Maverick naming:** only `.lab/YYYY-MM-DD-mav-<slug>/`.

## Best-effort

- Scout `SKIPPED` OK offline.
- T3 optional **`skeptic`**, **`deletion`**.
- Scout **Batch** (≤3 parallel scouts, distinct search foci); optional second **tanda** from `Implications` — not “wave-2” or “next wave”.
- Maverick 3 attempts/theory → `## MAV-ESCALATE`.
- Curiosity lines → Orchestrator decides (except env-anomaly maverick = REQUIRED).

## ESCALATE + no soft-web

Executors (**implementer** / **lab-runner** / **verifier**): no WebSearch. After 2 fails → `## ESCALATE` → scout → retry or STOP (optionally scout+maverick on DEAD-END).

---

*Duplicated gates also live in `.agents/rules/spacex-orchestrator.md` — keep both in sync when customizing.*
