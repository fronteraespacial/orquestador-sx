# HYPOTHESIS — AGY 2.0 agent-native init

**Pack baseline:** v1.2.x · **Fecha lab:** 2026-08-05  
**Upstream:** usuario AGY Desktop (lock+criollo OK; bootstrap sin CLI; define_subagent API)

---

## Claim principal

Antigravity 2.0 Desktop puede preparar un repo con metodología Orquestador SX **desde chat**, sin `Orchestrator.ps1 init`: el bloque global `~/.gemini/GEMINI.md` pregunta; si el humano acepta, el agente **escribe** `.orchestrator-lock.json` y materializa la estructura mínima (skill, rules, agents, GEMINI repo, `.lab/`). Delegación usa **`define_subagent`** (registro/plantillas) + **`invoke_subagent`** (spawn) — **no** Cursor `Task`.

---

## Sub-claims

### C1 — Ask → agent scaffold

Global `GEMINI.user.md` mergeado en user init: repo abierto sin lock → **preguntar** → si sí → agente crea lock + paths según `scaffold-manifest.json` (draft lab).

**Falsifier:** texto sigue mandando `Orchestrator init -Scope project` como único path → REVISE.

### C2 — CLI opcional, no gate

Scripts pack (`Orchestrator.ps1`, `install-orchestrator.sh`) permanecen para Cursor/sandbox/update/SHA256 — pero **bootstrap AGY Desktop no los requiere**. Solo si el humano pegó frase canónica install/update el agente **puede** invocar scripts.

**Falsifier:** drafts exigen CLI para AGY first-run → REJECT.

### C3 — define_subagent templates en SKILL

`runtime/skills/orchestrator/SKILL.md` gana sección **Antigravity 2.0 Desktop** con plantillas `system_prompt` por rol: `explore`, `scout`, `maverick`, `lab-runner`, `implementer`, `verifier`, `skeptic`, `deletion`.

**Falsifier:** SKILL solo menciona `invoke_subagent` sin plantillas define → REVISE.

### C4 — Spawn API AGY 2.0

| Cursor | Antigravity 2.0 Desktop |
|--------|-------------------------|
| `Task` tool | **`invoke_subagent`** |
| `.cursor/agents/*.md` | **`define_subagent`** + `.agents/agents/*/agent.md` (materialized) |

Orquestador registra roles con `define_subagent` al scaffold (o lee agent.md existentes); spawn con `invoke_subagent`.

**Falsifier:** drafts documentan Task para AGY → REJECT.

### C5 — Lock + En criollo intactos

`.orchestrator-lock.json` schema 1.0 (`enabled`, `version`, `sha256`, `source: agent-native`). Handoffs y cierres mantienen `## En criollo` al final.

**Falsifier:** se elimina lock check o criollo → REJECT.

### C6 — Docs + reference

`reference.antigravity.md` (opcional) detalla wiring AGY-only. Delta `antigravity-windows.md` prioriza agent-native; CLI como alternativa avanzada.

---

## Arquitectura (target)

```text
~/.gemini/GEMINI.md (user init, always-on Desktop)
  └─ repo sin lock → ASK
       └─ human yes → agent scaffold:
            ├─ .orchestrator-lock.json
            ├─ .agents/skills/orchestrator/SKILL.md (+ reference*)
            ├─ .agents/rules/{cj-orchestrator-bootstrap,spacex-orchestrator}.md
            ├─ .agents/agents/<role>/agent.md (8 roles)
            ├─ GEMINI.md, AGENTS.md, .lab/README.md
            └─ define_subagent from SKILL templates (session register)

Orchestrator session
  └─ invoke_subagent(role, envelope) — never Task
```

---

## Falsifiers globales

| ID | Trigger → verdict |
|----|-------------------|
| F1 | Scaffold sobrescribe reglas humanas sin merge → REJECT |
| F2 | Agent init silencioso (sin ask) → REJECT |
| F3 | define_subagent templates incompletos (<8 roles) → REVISE |
| F4 | Pérdida gates hard (lab/maverick/verifier) en deltas → REJECT |
| F5 | Playground sin repo fuerza metodología → REJECT |

---

## Expected verdict

**APPROVE** si drafts + validate PASS; C1–C5 confirmados; C6 como note si reference opcional está drafteado.
