# 02 — Roles, handoffs y gates (detalle operativo)

**Prompts completos:** [`../runtime/cursor/agents/`](../runtime/cursor/agents/) y [`../runtime/antigravity/agents/`](../runtime/antigravity/agents/). Este archivo = contratos. Skill: `runtime/skills/orchestrator/SKILL.md`.

## 1. Roles lógicos

| Rol | Job | Write? | Web? |
|-----|-----|--------|------|
| **Orchestrator** | Clasificar, gate, oleadas, sobres, fusionar deltas, freno, narrar | **No** (política; Cursor = best-effort) | Solo vía hijos |
| **explore** | Repo/MCP/sistema **local** | No | No |
| **scout** | Docs/prior art externos | No | Sí (foco del sobre) |
| **maverick** | What-ifs; LAB propio | Solo `.lab/…-mav-…` | Sí |
| **lab-runner** / **lab** | MVP una hipótesis | Solo `.lab/<id>/` | No → ESCALATE |
| **implementer** / **executor** | Writer de producción | Sí (paths del sobre) | No |
| **verifier** | Tests/lint DoD | No | No |
| **skeptic** / **expert** (OpenCode) | Auditoría T3 / análisis RO | No | Según sobre |

## 2. Spawn por superficie

| Superficie | API | Definiciones |
|------------|-----|--------------|
| **Cursor** | **Task** o `/nombre` | `.cursor/agents/*.md` |
| **Antigravity** | `invoke_subagent` | `.agents/agents/<role>/agent.md` |
| **OpenCode** | Task / `@executor` | `opencode.json(c)` |
| **Codex** | TOML / Task | `.codex/agents/*.toml` |

**No** inventar `invoke_subagent` en Cursor. **No** asumir que Cursor carga `.agents/agents/`.

## 3. Oleadas y deltas

```text
Wave 0  Orch: gate + sobres
Wave 1  scout|explore|lab|maverick|auditors → handoffs ≤40
Wave 2  implementer fan-out → handoffs
Wave 3  verifier + triage automation + narrate
```

Orquestador **pega solo deltas** (bloque canónico o 3–8 bullets) en el siguiente sobre. Prohibido reenviar el transcript completo del hijo.

## 4. Handoffs canónicos (≤40 líneas)

### explore

```markdown
## Explore handoff
- Paths: …
- Evidence: ≤5 bullets
- Recommendations for Orchestrator: …
- Curiosity: (opcional)
- ANOMALIA: (si aplica)
```

### scout

```markdown
## External contrast
- Mode: REQUIRED | COMPLEMENTARY | SKIPPED — <motivo>
- Focus (from envelope): …
- Sources: ≤5
- Prior art / better approach: …
- Fresh docs before implement/test: …
- Recommendation: ADOPT | ADAPT | DOCS-FIRST | NO-PRIOR-ART | DEAD-END
- Implications for envelope: … (optional wave-2 Scout: …)
```

### maverick

```markdown
## Maverick take
- Mode: CONSULT | LAB
- What-if ideas: ≤3
- Best-part-is-no-part: …
- Unconventional reuse: …
- Lab evidence: none | .lab/<dir> … | YIELD
- Attempts: N/3
- Risk & why it might work anyway: …
- Not my call: …
```

Opcional `## MAV-ESCALATE` con theory / approaches / request.

### implementer / executor

```markdown
## Implementer handoff
- Files created/modified: …
- Delete check:
- Automation candidates:
- Curiosity: (opcional)
```

O:

```markdown
## ESCALATE
- Attempts: N
- Evidence: ≤5
- Hypothesis status: rejected | unclear
- Ask Orchestrator: spawn scout then retry | stop if dead-end
```

O `ANOMALIA: <evidencia mínima>`.

### lab-runner

```markdown
## Lab handoff
- Path: .lab/…
- Verdict: APPROVE | REVISE | REJECT | YIELD
- Evidence: …
```

### verifier

```markdown
Verdict: PASS | FAIL | INCONCLUSIVE
- Commands run: …
- Evidence: …
## ESCALATE  (si mismo DoD falla 2× sin nuevo envelope)
```

## 5. Envelopes por rol (mínimos)

Todos: Complexity, Role, Sobre, Wave, Objetivo, Archivos/No tocar, Aceptación, Lab previo, Deltas previos, External contrast.

| Rol | Extra |
|-----|--------|
| implementer | Micro-gate 1–5; sin web |
| lab-runner | Solo `.lab/<id>/**`; REPORT + veredicto |
| scout | Enfoque de búsqueda; no escribir |
| maverick | CONSULT\|LAB; path mav fechado |
| verifier | Lista DoD / comandos |
| explore | Readonly local |
| skeptic/deletion | Sin código; entregables de auditoría |

Plantillas largas: skill § Envelopes by role.

## 6. Flujo feliz

```text
User ask
  → Wave 0: header + gate (señales, cascade rules)
  → Wave 1: [scout?] [lab APPROVE?] [maverick si env-anomaly?]
  → [freno humano?]
  → Wave 2: implementer(s) con deltas
  → Wave 3: verifier REQUIRED si hubo writer → triage automation → narrate
  → ANOMALIA/ESCALATE → scout / cascade +1 / STOP
```

## 7. Fronteras

| Necesidad | Rol |
|-----------|-----|
| ¿Dónde está X en el repo? | explore |
| ¿Docs/prior art afuera? | scout |
| ¿Y si borramos Y / al revés? | maverick |
| Soft-web desde implementer | **Prohibido** → ESCALATE |

## 8. OpenCode extras

- **skeptic:** requisitos T3 adversariales; edit deny.  
- **expert:** análisis pesado RO.  
Opcional en Cursor (ver 08).
