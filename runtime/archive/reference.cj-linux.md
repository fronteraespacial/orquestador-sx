# ARCHIVE ONLY — do not use as primary wiring

**Status:** frozen snapshot of a specific CJ-linux install.  
**Active references:** [reference.md](reference.md) (Windows/portable) · [reference.wsl.md](reference.wsl.md) (WSL/Linux portable) · [SKILL.md](SKILL.md) (contract).  
Do **not** copy this file into installs; do **not** follow `projects/.lab/` paths below for new work — canonical lab root is **`.lab/`**.

---

# Orchestrator — CJ-linux wiring (archived)

Snapshot verified **2026-08-03** (Scout gate soft-mandatory + ESCALATE@2–3 + `.cursor/agents/scout`). Historical IDs only — re-check on any live host.

## CLI status

| CLI | Binary | Orchestration fit |
|-----|--------|-------------------|
| Cursor CLI | `agent` / `cursor` | Methodology + Task; child model often `composer-2.5-fast` only → else LIGHTWEIGHT MODE |
| OpenCode | `opencode` | Best native fit: per-agent `model` in [`projects/opencode.json`](../../../projects/opencode.json) |
| Antigravity | `agy` | Methodology via this skill + `AGENTS.md`; model via UI / `~/.gemini/antigravity-cli/settings.json` / `--model` (skill alone does not switch) |
| Codex | **not installed** | Defer TOML agents until `@openai/codex` is on PATH; MCP stub only at `/root/.codex/cj-mcp-servers.toml` |

## Cursor IDE / CLI (native subagents)

Cursor already ships subagents (docs: [subagents](https://cursor.com/docs/subagents.md)). **Do not** expect Antigravity `invoke_subagent` or `.agents/agents/*/agent.md` to load here.

| Mechanism | Path / API | Role |
|-----------|------------|------|
| Built-in | Task → Explore / Bash / Browser | Context-heavy search, shell series, browser MCP |
| Custom CJ roles | [`.cursor/agents/*.md`](../../../.cursor/agents/) | `explore`, `scout`, `maverick`, `implementer`, `lab-runner`, `verifier` |
| Antigravity source prompts | [`.agents/agents/*/agent.md`](../../agents/) | Loaded by Antigravity only; mirror kept in `.cursor/agents/` |
| Delegation API | **Task** tool (or `/scout`, `/verifier`, …) | Not `invoke_subagent` |

**Map Antigravity → Cursor**

| Antigravity | Cursor |
|-------------|--------|
| `invoke_subagent` + `explore` | Task → custom `explore` (`readonly: true`) and/or built-in Explore |
| `invoke_subagent` + `scout` | Task → `/scout` (`readonly: true`; web/docs only) |
| `invoke_subagent` + `maverick` (`gemini-3.1-pro-high`) | Task → `/maverick` (`cursor-grok-4.5-high-fast`; CONSULT or LAB own `.lab/*-mav-*/`; never main path) |
| `invoke_subagent` + `implementer` | Task → `/implementer` or auto by description |
| `invoke_subagent` + `lab-runner` | Task → `/lab-runner` |
| `invoke_subagent` + `verifier` | Task → `/verifier` |
| `Model: flash` / `pro` | Frontmatter `model` on `.cursor/agents/*.md`, or Task `model:` allowlist |

**Scout / ESCALATE / Maverick models (2026-08-03):**

| Role | Cursor | Antigravity | OpenCode |
|------|--------|-------------|----------|
| `maverick` | `cursor-grok-4.5-high-fast` | `gemini-3.1-pro-high` | `opencode/nemotron-3-ultra-free` (alt `opencode-go/grok-4.5`) |
| `scout` | `composer-2.5-fast` | `flash` → prefer `gemini-3.5-flash-high` / `gemini-3.6-flash-high` | `opencode/north-mini-code-free` |

**Scout / ESCALATE loop:** greenfield|anomaly → scout first (SKIPPED OK). Child ≥2 fails → `## ESCALATE` (no soft-web) → orchestrator scout → retry with contrast **or** STOP dead-end (optionally pair scout+maverick first).

**Orchestrator session:** prefer heavy (e.g. `grok-4.5` / frontier high) via `/model` or `cli-config.json`.

**Task / model caveats (CLI):**

- Prefer **project** `.cursor/agents/` (this workspace). User-level `~/.cursor/agents/` may not appear in CLI completions (known IDE/CLI mismatch).
- Pass `model: "composer-2.5-fast"` when the Task allowlist permits. **Never** non-Fast `composer-2.5` in operational routing (pack hard rule).
- `model: inherit` in frontmatter can be unreliable on CLI — prefer explicit `composer-2.5-fast`, or omit the field.
- If Task rejects or omits model override → paste **LIGHTWEIGHT MODE** from [SKILL.md](SKILL.md) into the child prompt.
- Parent agent may still use tools (Cursor product design). CJ policy still prefers enrich → Task for T1+ prod edits; do not invent a fake `invoke_subagent` API.

**Smoke 2026-08-03:** Task verifier handoff **PASS** (four `.cursor/agents/*.md` + rules/reference). CLI `agent -p --mode ask` listed explore/implementer/lab-runner/verifier. **Scout** added same day (gate + ESCALATE); see Scout smoke note below.

**Smoke Scout 2026-08-03:** `.cursor/agents/scout.md` + `.agents/agents/scout/agent.md` + OpenCode `scout.prompt` present; soft-mandatory gate in SKILL.

Do **not** rely on a missing SpaceX skill path; this shared skill is the source of truth on CJ-linux for methodology (T0–T3, `.lab`, envelopes).

## OpenCode

**Root-level (Cursor-like, any directory):** agents with per-model routing live in the **global config** `~/.config/opencode/opencode.jsonc` (2026-08-03, verified on 1.17.19). Fan-out from any CWD — Task and `@executor` resolve subagent models independently of the parent.

**Orchestrator = the agent you talk to.** `default_agent: orchestrator`, so a session starts in it. Its model is whatever you pick in the TUI model picker (no fixed `model:` in config) — like Cursor's `/model` on the main chat. It is **SpaceX-strict**: `edit deny`, `bash deny`, `task` allowlist only (general/explore/executor/lab/scout/skeptic/expert/verifier) — every tier is delegated, including T0.

| Agent | Mode | Model | Perm |
|-------|------|-------|------|
| `orchestrator` | primary | user-set (TUI picker) | edit/bash deny; task allowlist |
| `executor` | subagent | `opencode/nemotron-3-ultra-free` (alt: `opencode-go/grok-4.5`) | edit/bash allow |
| `lab` | subagent | `opencode/nemotron-3-ultra-free` (alt: `opencode-go/grok-4.5`) | edit/bash allow |
| `scout` | subagent | `opencode/north-mini-code-free` | edit deny; **prompt** = External contrast handoff |
| `maverick` | subagent | `opencode/nemotron-3-ultra-free` (alt: `opencode-go/grok-4.5`) | edit/bash allow (prompt-limited to own `.lab/*-mav-*/`); Maverick take / MAV-ESCALATE |
| `skeptic` | subagent | `opencode/mimo-v2.5-free` | edit/bash deny |
| `expert` | subagent | `opencode/nemotron-3-ultra-free` | edit deny |
| `verifier` | subagent | `opencode/nemotron-3-ultra-free` (alt: `opencode-go/grok-4.5`) | edit deny, bash allow |
| `general`* | subagent (built-in override) | `opencode/nemotron-3-ultra-free` (alt: `opencode-go/grok-4.5`) | — |
| `explore`* | subagent (built-in override) | `opencode/north-mini-code-free` | — |

`*` Built-in overrides: cheap/read workers stay on North Mini. **2026-08-04:** writers (`executor`/`lab`/`verifier`/`general`/`maverick`) → `opencode/nemotron-3-ultra-free`; alt Go `opencode-go/grok-4.5`. Left DeepSeek V4 Flash Free and Laguna.

Workspace copy for context/debug: [`projects/opencode.json`](../../../projects/opencode.json).

Portable SpaceX manual (OpenCode/Codex/Antigravity role maps, V1/V2 caveat, handoff template): [`data/compartido/ORQUESTADOR/spacex-orchestrator-OpenCode-Codex-Antigravity.md`](../../../data/compartido/ORQUESTADOR/spacex-orchestrator-OpenCode-Codex-Antigravity.md) (UTF-16; convert with `iconv -f UTF-16LE` to read).

Invoke: `@executor …` / Task tool; refresh IDs with `opencode models` if Zen renames free tiers.

## Antigravity

- Skills: this directory (`.agents/skills/orchestrator/`).
- Subagents: [`.agents/agents/`](../../agents/) including **`scout`** and **`maverick`** (`gemini-3.1-pro-high`).
- Flash workers: prefer explicit IDs from `agy models` — `gemini-3.5-flash-high` / `gemini-3.6-flash-high` (alias `flash` alone is ambiguous).
- Model: settings / mid-chat dropdown / `agy --model …`. Narrate “use Flash for trades” if the product does not auto-route.
- Auth failures block `availableModels` — fix login before trusting model matrix.
- Executors **ESCALATE** (no soft-web); orchestrator spawns scout then retry|STOP.
- **Gates (REQUIRED):** greenfield → `lab-runner` before `implementer`; T2+ PRoot/UDP/UserLAnd anomaly → `maverick`; after `implementer` → `verifier` before user “done”.
- **Lifecycle cleanup:** when the loop ends, stop idle subagents in the Antigravity UI/runtime (`manage_subagents` / kill idle if available in build). Do not leave background children hanging after handoff.
- Root rules: [`GEMINI.md`](../../../GEMINI.md) (mandatory header + workflow gates).
- Maverick lab path: only `projects/.lab/YYYY-MM-DD-mav-<slug>/`.

## Codex (deferred)

When `codex` is installed:

1. Create `.codex/agents/orchestrator.toml`, `executor_fast.toml`, `skeptic.toml`, **`scout.toml`** (readonly external contrast) per portable doc §9.3.
2. Point `developer_instructions` at this skill + `projects/AGENTS.md`.
3. Do not expect `AGENTS.md` alone to set `model` / `model_reasoning_effort`.

Until then: ignore Codex-specific snippets; use Cursor / OpenCode / Antigravity.

## `.lab`

Workspace lab root: [`projects/.lab/README.md`](../../../projects/.lab/README.md).

## Portable doc

Spanish full matrix + IDE snippets:
[`data/compartido/planes/orchestrator-portable-skill.md`](../../../data/compartido/planes/orchestrator-portable-skill.md).
