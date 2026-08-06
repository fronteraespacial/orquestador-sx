# Orchestrator — Antigravity 2.0 Desktop wiring

AGY-only reference. Portable cross-surface: [reference.md](reference.md). Cursor: [reference.cj-linux.md](reference.cj-linux.md) (archive).

## Surfaces (this file)

| Item | Antigravity 2.0 Desktop |
|------|-------------------------|
| Global ask/bootstrap | `~/.gemini/GEMINI.md` user block (merge via `init -Scope user -ConfirmUserScope`) |
| Project lock | `.orchestrator-lock.json` |
| Skill | `.agents/skills/orchestrator/SKILL.md` |
| Rules (Always On) | `.agents/rules/cj-orchestrator-bootstrap.md`, `spacex-orchestrator.md` |
| Agent files | `.agents/agents/<role>/agent.md` |
| Register roles | **`define_subagent`** (templates in SKILL § Antigravity 2.0) |
| Delegate | **`invoke_subagent`** |
| **Forbidden** | Cursor **`Task`** tool |

## Agent-native scaffold (no CLI)

Triggered after human **yes** to global ask (or bootstrap rule):

1. Write `.orchestrator-lock.json` (`source: agent-native`, `enabled: true`).
2. Materialize paths in pack `scaffold-manifest` (skill, rules, 8 agents, GEMINI merge, `.lab/README.md`).
3. Source files from open pack `runtime/` when available.
4. Call **`define_subagent`** per role using SKILL templates.
5. Remind: Customizations → **Always On** on project rules.

`Orchestrator.ps1 init -Scope project` remains valid for scripted/SHA256 installs — **not** the Desktop default path.

## Lab

- Root: **`.lab/`** at repo root
- Classical: `YYYY-MM-DD-<slug>/`
- Maverick: `YYYY-MM-DD-mav-<slug>/`
- Prod only after lab **APPROVE**

## Handoffs

≤40 lines; canonical sections per role (see SKILL + `02-ROLES-HANDOFFS-GATES.md`).

## En criollo

Required **at end** of implementer handoff and parent close-out (3–6 practical sentences).
