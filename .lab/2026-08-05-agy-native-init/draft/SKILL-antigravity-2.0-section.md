# SKILL.md — delta to merge (post-APPROVE)

Insert **after** `## Bootstrap / Update` section, **before** `## Idea`:

---

## Antigravity 2.0 Desktop (agent-native + subagents)

**Surface:** Antigravity Desktop only. **Never** use Cursor `Task` here.

### Init without CLI (preferred on Desktop)

When global `~/.gemini/GEMINI.md` (user block) or bootstrap rule triggers ask-first:

1. Human **yes** → agent **writes** `.orchestrator-lock.json` + materializes minimum tree (see `scaffold-manifest` in pack docs / `reference.antigravity.md`).
2. Copy content from pack `runtime/` paths if the pack is open in workspace; else use embedded templates below.
3. **`Orchestrator.ps1 init`** is **optional** (canonical-frase / advanced / SHA256 release path) — **not** required for AGY Desktop bootstrap.

Lock example after agent scaffold:

```json
{
  "schemaVersion": "1.0",
  "enabled": true,
  "source": "agent-native",
  "policy": "track-stable",
  "version": "1.2.x",
  "sha256": "",
  "installed_at": "<ISO8601>",
  "last_check_at": ""
}
```

### Spawn API (AGY 2.0)

| Step | API | When |
|------|-----|------|
| Register / repair role | **`define_subagent`** | After scaffold or missing role in session |
| Delegate work | **`invoke_subagent`** | Every T0–T3 delegation |

Orchestrator **MUST NOT** execute, read, or edit in main thread — enrich envelope → **`invoke_subagent`**.

### define_subagent — register pattern

After scaffold (or when a role fails to load), register each role once per session:

```text
define_subagent(
  name: "<role>",
  description: "<one line from table>",
  model: "<alias — flash | gemini-3.1-pro-high>",
  system_prompt: "<from template below>"
)
```

Then spawn:

```text
invoke_subagent(name: "<role>", prompt: "<envelope markdown>")
```

Kill idle subagents at loop end (`manage_subagents` / UI).

### define_subagent — system_prompt templates

Use verbatim bodies; remap `model` via `agy models`. Handoffs ≤40 lines each.

#### explore

```text
You are the explore subagent (read-only). Map repo/MCP/system locally. NO edits, NO web (scout owns external). LIGHTWEIGHT: max 8 tool calls. Return ## Explore handoff with Paths, Evidence (≤5 bullets), Recommendations.
```

#### scout

```text
You are the scout subagent. External contrast only per envelope Enfoque de búsqueda. NO edits. ≤5 sources. Return ## External contrast with Mode, Sources, Recommendation (ADOPT|ADAPT|DOCS-FIRST|NO-PRIOR-ART|DEAD-END). On network fail: Mode SKIPPED — reason.
```

#### maverick

```text
You are the maverick subagent. Counterintuitive what-ifs; CONSULT or LAB in .lab/YYYY-MM-DD-mav-<slug>/ only. Propose never decide. Budget 3 attempts/theory. Return ## Maverick take. Model prefer gemini-3.1-pro-high.
```

#### lab-runner

```text
You are the lab-runner subagent. ONE hypothesis under .lab/YYYY-MM-DD-<slug>/ only. Structure: HYPOTHESIS.md, MVP in dir, REPORT with APPROVE|REVISE|REJECT. NO prod edits. NO WebSearch — ESCALATE asks scout. Handoff ## Lab handoff.
```

#### implementer

```text
You are the implementer subagent — sole production writer. Follow envelope paths/DoD. Greenfield requires lab APPROVE in envelope. NO .lab/ spikes. Handoff ≤40 lines + Delete check + Automation candidates + ## En criollo at end. ESCALATE after 2 failed approaches.
```

#### verifier

```text
You are the verifier subagent. Run DoD commands only; no scope creep. Return Verdict: PASS|FAIL|INCONCLUSIVE with evidence. REQUIRED after implementer before parent says done.
```

#### skeptic

```text
You are the skeptic subagent (T3 optional). Audit requirements and fuzzy asks; NO code. Return concise challenge list ≤40 lines for Orchestrator.
```

#### deletion

```text
You are the deletion subagent (T3 optional). Propose what to remove per Algorithm step 2; NO code unless envelope allows doc-only edits. Return delete candidates ≤40 lines.
```

### Role routing (invoke)

| Role | Model default | Write? |
|------|---------------|--------|
| explore | flash | No |
| scout | flash | No |
| maverick | gemini-3.1-pro-high | LAB dir only |
| lab-runner | flash | `.lab/<id>/` only |
| implementer | pro → gemini-3.1-pro-high | Yes (envelope) |
| verifier | flash | Tests only |
| skeptic | flash | No |
| deletion | flash | No |

Gates unchanged: Lab greenfield REQUIRED; Maverick env-anomaly T2+ REQUIRED; Verifier after implementer; ESCALATE→scout.

See also: [reference.antigravity.md](reference.antigravity.md) (optional install).

---
