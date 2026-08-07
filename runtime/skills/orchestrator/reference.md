# Orchestrator — portable wiring (Windows-first)

Primary reference for this pack. CJ-linux snapshot: `reference.cj-linux.md` (**archive only — do not use**). WSL hosts: [reference.wsl.md](reference.wsl.md).

## Surfaces

| CLI | Spawn | Agent defs | Root policy |
|-----|-------|------------|-------------|
| **Cursor** | Task tool, `/name` | `.cursor/agents/*.md` | rules + skill; orchestrator **best-effort** zero-exec |
| **Antigravity** | `invoke_subagent` | `.agents/agents/<role>/agent.md` | `GEMINI.md` |
| **OpenCode** | Task / `@agent` | `opencode.json(c)` | orchestrator edit/bash deny when configured |
| **Codex** | `spawn_agent` / named TOML roles (prompt-driven) | `.codex/agents/*.toml` (+ `%USERPROFILE%\.codex`) | TOML `sandbox_mode` + `developer_instructions`; skill = repo `.agents/skills/orchestrator` |

## Hard rules

1. **Never** document `invoke_subagent` as Cursor API.
2. **Never** assume Cursor loads `.agents/agents/`.
3. Prefer project-level `.cursor/agents/` (CLI may miss user-level).
4. Models: list on host, then remap (`agent --list-models`, `agy models`, `opencode models`, Codex Desktop picker / `models_cache.json`). Cursor pack pins: see below. Codex pins: § Codex below + `07-MODELS-MATRIX` §5.
5. Gates: Scout soft; Lab greenfield REQUIRED under **`.lab/`**; Discovery ⊂ research-lab; Maverick env-anomaly T2+ + early/Harvest CONSULT; Verifier after implementer; VLH after tech PASS on T2/T3 human-facing; **Run → Oleada O1–O3 → Fase → Batch** (not Wave 0–3); zero-exec parent.
6. **Taxonomy:** Run ⊃ Oleada O1–O3 ⊃ Fase (`prep` \| `research-lab` \| `execute` \| `verify`) ⊃ Batch \| Spawn. Independent workstreams → **Batch B-… REQUIRED** (multiple Task / `invoke_subagent` **same turn** when deps allow). verify FAIL reproducible local → **one O2** corrective (full gap inventory consolidated → `execute` → `verify`); design/env/hipótesis → **O3** (+ `research-lab`); no O4 / “Wave 4” by default. VLH **never** opens O2.
7. Cursor can **audit** zero-exec (readonly + logs); it cannot **fully enforce** it — OpenCode/Codex deny is stronger when wired.
8. **Multitask ≠ role collapse:** Multitask / Build in Parallel = parallel Tasks in one Batch — **not** one `composer-2.5-fast` / `generalPurpose` owning lab + implement + verify + release end-to-end.
9. **WorkType** in compact header: `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` (ops: no feature Lab Batch / no parallel mutations).

## Compact headers

Every orchestrator turn — **not** one `##` H2 per field:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | WorkType <greenfield|evolving-product|legacy-app|ops-diagnostic> | Run R-<id> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Next spawn: <role|none> | Parent tools: none
Role: Orchestrator | Action: Delegate
```

**Process fail:** Fase `execute` | `verify` | `research-lab` + parent Write/Shell/edit. See [SKILL.md](SKILL.md) Amnesia check + Phrase → role table.

Child envelopes (optional prefix):

```markdown
### Env · <role>
T<n> — <razón> | WorkType <…> | Run R-<id> | O<1|2|3> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Model: fast | heavy | Sobre: <id>
**Objetivo:** …
**Archivos / No tocar:** …
**Aceptación:** criterio verificable
**Human-serve:** yes|no
```

On recovery after verify FAIL or ESCALATE, append **`| Failure-ID: F-<id>`** on the Role line when applicable. Full envelope fields: [SKILL.md](SKILL.md).

## YIELD_PLAN — surface Plan UI (ask-only)

After Discovery **DECIDE**, orch emits **`YIELD_PLAN`**. Human opens the native Plan UI and approves **Build** before `implementer`. Decline → **STOP**. Lab `YIELD` ≠ `YIELD_PLAN`.

**Hosts do not auto-switch Plan Mode** — narrate and ask:

| Surface | Ask human to |
|---------|----------------|
| **Cursor** | Enter **Plan Mode**, then approve Build |
| **Antigravity** | **Planning Mode** / **Artifact Review**, then Build |
| **OpenCode** | **Plan → Build** |
| **Codex** | `/plan`, then approve Build |

## Discovery / Lab Batch (summary)

- Discovery ⊂ `research-lab`: one research Batch; ≤2 labs (≤3 T3); one REVISE; then `DECIDE` \| `YIELD_PLAN` \| `STOP`.
- Labs: no prod writes; no formal Implementation Plan.
- Parallel labs: isolate dirs **and** ports/services/data; fan-in matrix; ≥2 APPROVE → human brake; **one** prod path.

## Harvest + Maverick

After T2/T3 tech PASS (+ VLH if gated): parent Ledger → Maverick CONSULT mandatory → `NO_CHANGE` \| `YIELD_OPT` (human decides; **no auto O2**).

## Cursor model defaults (pack)

**Hard rule:** canonical Composer ID = **`composer-2.5-fast`**. Never `composer-2.5` without `-fast`.

| Role | ID | Notes |
|------|-----|-------|
| orchestrator (session parent) | **session / user picker / Auto** | Not pack-forced; optional nested orch Task → `cursor-grok-4.5-high-fast` (see below) |
| maverick | `cursor-grok-4.5-high-fast` | Always; early + Harvest CONSULT |
| **verifier** | `cursor-grok-4.5-high-fast` | Always; complete gap inventory on FAIL |
| **verifier-like-human** | `cursor-grok-4.5-high-fast` | Always; after tech PASS; T2/T3 human-facing |
| lab-runner (single spawn) | `cursor-grok-4.5-high-fast` | One lab in fase/Batch |
| lab-runner (Lab Batch ≥2) | `composer-2.5-fast` each | Parallel labs |
| implementer, explore, scout, skeptic, deletion | `composer-2.5-fast` | Large scope → more envelopes, same role |
| **diagnostic** (Mode diagnostic synthesizer) | `cursor-grok-4.5-high-fast` | After RO probes + Maverick CONSULT HARD; `.debug/` only |

Verify loop (1.3.1): FAIL → full gap inventory; **one O2** per fan-in; input envelopes long OK, output handoffs ≤40 lines; RELEASE CHECKLIST fase for publish steps.

Policy + evidence tiers: pack `docs/agent/MODEL-ROUTING-POLICY.md`. Matrix: `07-MODELS-MATRIX.md`.

## Codex Desktop / CLI

**Ready when:** `codex` on PATH **or** embedded `%LOCALAPPDATA%\OpenAI\Codex\bin\**\codex.exe` **or** Store Appx `OpenAI.Codex` **or** existing `%USERPROFILE%\.codex` (Desktop). Install agents with `-IncludeCodex` / `--include-codex`; **merge** `[agents]` into `config.toml` — never blind-overwrite `mcp_servers` / `plugins` / `notify` / `[desktop]` / `[windows]`.

| Piece | Path |
|-------|------|
| User config / agents | `%USERPROFILE%\.codex\config.toml`, `%USERPROFILE%\.codex\agents\` |
| Project agents | `<repo>\.codex\agents\*.toml` |
| Skill (methodology) | `<repo>\.agents\skills\orchestrator\` (not `~/.codex/skills` as SoT) |
| Pack templates | `runtime/codex/` |

**Config keys:** `agents.max_concurrent_threads_per_session` (legacy alias `max_threads`), `agents.default_subagent_model = "gpt-5.6-luna"`, `agents.default_subagent_reasoning_effort = "medium"`. Per-role: `model`, `model_reasoning_effort` in each agent TOML. Spawn may pass `reasoning_effort` / `model` (some builds ignore child effort — smoke).

**Pins:** parent `gpt-5.6-terra`+`medium`; workers Luna; judgment (mav/ver/VLH/lab-single) Terra+`high`. **Ultra ≠ SpaceX org chart.** Full table: [SKILL.md](SKILL.md) § Codex · `07-MODELS-MATRIX` §5 · `docs/human/install/codex-windows.md`.

## Lab (canonical)

- Path: **`.lab/`** at repo root — **not** `projects/.lab/`
- Classical: `YYYY-MM-DD-<slug>/`
- Maverick: `YYYY-MM-DD-mav-<slug>/`
- Prod write only after **APPROVE** (and Build after `YIELD_PLAN` when Discovery ran)

## Mode: diagnostic (optional)

Forensic failures under **`.debug/YYYY-MM-DD-<slug>/`** — ≠ `.lab/`. Flow: incident-review → explore×2–3 (4 lanes: logs|recent-changes|structural|similar-fragility) → Maverick CONSULT HARD (post-probes, pre-REPORT) → Task **`diagnostic`** @ `cursor-grok-4.5-high-fast` → REPORT. No APPROVE→implementer; no auto-migrate. Install: `runtime/project/.debug/README.md` → repo `.debug/README.md`. Full contract: [SKILL.md](SKILL.md) § Mode: diagnostic.

## Implementer Batch — Cursor Task example (T2/T3, same execute Batch)

When T≥2 and writers are `composer-2.5-fast`, spawn **2–3** implementers **in one parent turn** (same `Batch: B-<id>`), disjoint allow-lists, one Release-owner. Parent **waits fan-in** → one `verifier`.

```text
# Same turn — Batch B-impl-1, Fase execute
Task(subagent_type: implementer, model: composer-2.5-fast, prompt: "### Env · implementer (Imp-A)\n… allow-list: canon/, docs/ … Release-owner: NO")
Task(subagent_type: implementer, model: composer-2.5-fast, prompt: "### Env · implementer (Imp-B)\n… allow-list: runtime/cursor/ … Release-owner: NO")
Task(subagent_type: implementer, model: composer-2.5-fast, prompt: "### Env · implementer (Imp-C)\n… allow-list: VERSION, CHANGELOG … Release-owner: YES")
# After all handoffs → Task verifier (cursor-grok-4.5-high-fast)
```

**O2 corrective:** same pattern — parent consolidates gap inventory → **one O2** → Task implementer(s); **never** parent Write/Shell. Full contract: [SKILL.md](SKILL.md) § Implementer Batch + verify loop B.

## Optional nested orchestrator — Cursor Task example (NOT default)

Default = direct orch (session parent unpinned). Use depth-1 nest only when human asks, session parent is thin/cheap on vague T2/T3 multi-gate work, or outer already failed protocol once. Full contract: [SKILL.md](SKILL.md) § Optional nested orchestrator.

```text
# Outer session = thin launcher only — one spawn, then wait/narrate
Task(
  subagent_type: orchestrator,
  model: cursor-grok-4.5-high-fast,
  prompt: "### Orch\nT2 — … | WorkType … | Run R-… | O1 initial | Fase prep | Batch none\nNext spawn: scout | Parent tools: none\nRole: Orchestrator | Action: Delegate\n\nOuter role: thin-launcher\nLoad SKILL; zero-exec; child model table; phrase→role; Implementer Batch; exit-card Build.\n…"
)
# Nested owns classify/spawn/Ledger/Harvest — MUST NOT Task(orchestrator) again
# If Task(orchestrator) unavailable → direct + skill
```

## Shared handoff (optional)

e.g. `agent-handoff.md` — read at session start, append compact deltas before end.
