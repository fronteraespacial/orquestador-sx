# HYPOTHESIS — AGY Desktop global micro-bootstrap

**Pack baseline:** v1.2.x · **Fecha lab:** 2026-08-05  
**Upstream:** scout (global `~/.gemini/GEMINI.md` always-on), lab previo `2026-08-05-antigravity-bootstrap` (project-only + P2 opt-in doc)

---

## Claim principal

Antigravity 2.0 **Desktop** carga `~/.gemini/GEMINI.md` como reglas **globales always-on** (sin toggle UI). El pack puede instalar un **micro-bootstrap** en user scope (con confirmación explícita) que, al abrir un repo en AGY, **pregunte** si preparar el proyecto con metodología Orquestador SX; tras `init -Scope project`, las rules completas siguen en `.agents/rules/` (Always On UI solo para capa project).

---

## Sub-claims

### C1 — User-scope merge paths

`Install-Orchestrator.ps1` / `install-orchestrator.sh` en `-Scope user` mergean `runtime/antigravity/GEMINI.user.md` → `%USERPROFILE%\.gemini\GEMINI.md` / `$HOME/.gemini/GEMINI.md` con marcadores `<!-- spacex-orchestrator-sx BEGIN/END -->` (idempotente: append o refresh).

**Falsifier:** user init no toca `.gemini/` → REJECT.

### C2 — Ask-first, never silent

Micro-bootstrap instruye: si hay workspace/repo y falta `.orchestrator-lock.json` (o `enabled: false`) → **preguntar** al humano (ES: *¿preparo este proyecto con Orquestador SX (Antigravity)?*); si acepta → guiar/ejecutar scripts pack; **prohibido** init/download silencioso.

**Falsifier:** texto permite auto-init sin consentimiento → REJECT.

### C3 — Optional AGENTS stub

Stub corto en `.gemini/AGENTS.md` refuerza pointer a skill + lock check. **Opcional** — no bloquea APPROVE si falta en v1.

### C4 — Sin Always On para micro-bootstrap

`GEMINI.user.md` **no** exige Always On para la capa global. Scout: home GEMINI ya es always-on en Desktop. Always On UI queda documentado solo para `.agents/rules/*` tras project init.

**Falsifier:** micro-bootstrap dice "mark Always On" para global → REVISE.

### C5 — Project map intacto

`Get-ProjectTemplateMap` / `append_project_entries` siguen instalando agents, rules, repo `GEMINI.md`, skill, lock workflow — sin mover AGY agents a `$HOME`.

**Falsifier:** user scope instala `.agents/agents/*` en home → REJECT.

---

## Arquitectura (target)

```text
User init (-ConfirmUserScope)
  └─ merge ~/.gemini/GEMINI.md     ← auto-loaded by AGY Desktop (always-on)
       └─ lock missing? → ASK → init project (scripts)
       └─ lock OK? → load skill; remind project rules Always On if needed

Project init (-Scope project)
  └─ .agents/rules/*, agents, skill, repo GEMINI.md, lock
       └─ AGY UI: Always On on bootstrap + spacex-orchestrator rules
```

---

## Falsifiers globales

| ID | Trigger → verdict |
|----|-------------------|
| F1 | Global GEMINI fuerza metodología en playground sin repo → REJECT o acotar snippet |
| F2 | Merge sobrescribe GEMINI.md humano sin backup → REJECT |
| F3 | User scope instala agents project-level en home → REJECT |
| F4 | Micro-bootstrap duplica gates hard de project rules → REVISE (mantener micro mínimo) |

---

## Expected verdict

**APPROVE** si simulate + validate PASS y C1,C2,C4,C5 confirmados (C3 opcional → REVISE note si ausente).
