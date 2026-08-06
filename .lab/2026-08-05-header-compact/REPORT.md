# REPORT — Compact orchestrator header

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05

## Resumen

Option A (`### Orch` + pipe taxonomy + Role|Action) replaces 6–7 H2 lines with 3 lines while preserving Tier, Run, Oleada O1–O3, Fase, Batch, Role, Action. Child envelopes mirror via `### Env · <role>`. Aligns with wave-taxonomy APPROVE; no Wave 0–3.

## Validación H1–H6

| ID | Resultado | Evidencia |
|----|-----------|-----------|
| H1 | ✅ | 1:1 field map from tall v1.2.9 header |
| H2 | ✅ | Stable regex tokens on pipe line |
| H3 | ✅ | 6–7 lines → 3 (~50%) |
| H4 | ✅ | Env: 2 header lines + body; no H2 stack |
| H5 | ✅ | Failure-ID only on recovery line 2 |
| H6 | ✅ | Run/Oleada/Fase/Batch; legacy Wave doc-only |

## Examples

**Orch (execute):**

```markdown
### Orch
T2 | Run R-header-compact | O1 initial | Fase execute | Batch B-docs
Role: Orchestrator | Action: Delegate
```

**Child:**

```markdown
### Env · implementer
T2 | Run R-header-compact | O1 | Fase execute | Batch B-docs
Model: fast | Sobre: skill-templates
**Objetivo:** …
```

**Recovery:**

```markdown
### Orch
T2 | Run R-auth | O2 corrective | Fase verify | Batch none
Role: Orchestrator | Action: Delegate | Failure-ID: F-vfy-01
```

## Prod files post-APPROVE (exact)

| Archivo | Cambio |
|---------|--------|
| `canon/01-METHODOLOGY-SPACEX.md` | §4 header template + anti-pattern |
| `canon/00-README-INSTALL-AGENT.md` | install smoke + envelope example |
| `canon/02-ROLES-HANDOFFS-GATES.md` | § envelope field list (compact) |
| `canon/09-VERIFY-CHECKLIST.md` | smoke expects `### Orch` |
| `runtime/skills/orchestrator/SKILL.md` | mandatory header + common Env header + anti-pattern |
| `runtime/skills/orchestrator/reference.antigravity.md` | parent header |
| `runtime/cursor/agents/orchestrator.md` | first-line header + Env example |
| `runtime/cursor/rules/cj-orchestrator-mandatory.mdc` | mandatory header |
| `runtime/antigravity/rules/spacex-orchestrator.md` | AGY header |
| `runtime/GEMINI.md` | root AGY header |
| `runtime/project/AGENTS.md` | gates table Header row |
| `docs/agent/AGENT-BOOTSTRAP-PROMPT.md` | bootstrap header block |
| `docs/human/install/antigravity-windows.md` | install checklist |
| `runtime/opencode/opencode.json.example` | orchestrator prompt string |
| `runtime/opencode/opencode.jsonc.example` | orchestrator prompt string |
| `tooling/bench/cases/prompts/envelope-t2-greenfield-csv.md` | bench envelope |
| `tooling/bench/cases/prompts/envelope-t2-udp-anomaly.md` | bench envelope |
| `tooling/bench/cases/prompts/envelope-t2-writer-bounded.md` | bench envelope |
| `runtime/codex/agents/orchestrator.toml` | **deferred** — still tall H2; sync when Codex active |
| `VERSION` → `1.2.10` | semver bump |
| `CHANGELOG.md` | compact header entry |
| `runtime/antigravity/scaffold-manifest.json` | pin `v1.2.10` |

**Pack tree note:** most rows above already show compact form in working tree; implementer pass = verify parity + codex.toml + optional drop of em-dash gloss after `T<n>`.

## Riesgos menores

1. Agents trained on tall H2 — mitigated by SKILL anti-pattern line.
2. Legacy transcripts with `## Complexity` — read-only history; new turns use compact only.

## Lab handoff

```markdown
## Lab handoff
- Path: .lab/2026-08-05-header-compact/
- Verdict: APPROVE
- Evidence: H1–H6 pass; 3-line Orch + 2-line Env; pipe taxonomy; Failure-ID recovery-only; 22 prod paths listed; wave-taxonomy compatible; no Wave 0–3
```
