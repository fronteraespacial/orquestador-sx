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

## 3. Run, oleadas, fases y deltas

```text
Tier T0–T3         complejidad del ask (T0 trivial → T3 máx.; cascade +1 hasta T3 → ESCALATE, no T4)
Run R-<id>         objetivo del usuario (puede abarcar O1→O3)
└─ Oleada O1|O2|O3 ciclo completo de fases
   └─ Fase          prep → research-lab → execute → verify (omitir vacías)
      └─ Batch B-<n> N spawns paralelos + fan-in
      └─ Spawn       exactamente 1 hijo (nunca etiquetar como oleada)
      └─ Retry       reintento técnico misma fase/batch (≤2; ESCALATE@2)
```

Ejemplo feliz:

```text
O1 · prep           Orch: gate + sobres
O1 · research-lab   scout|explore|lab|maverick|auditors → handoffs ≤40
O1 · execute        implementer Batch fan-out → handoffs
O1 · verify         verifier + triage automation + narrate
```

Orquestador **pega solo deltas** (bloque canónico o 3–8 bullets) en el siguiente sobre. Prohibido reenviar el transcript completo del hijo.

**Paralelismo:** Batch **REQUIRED** si workstreams independientes; serial solo con deps reales (p. ej. lab APPROVE antes de execute).

**Multitask Mode / Build in Parallel (HARD):** parent Multitask Mode **does NOT** authorize collapsing roles. Parallelism = **multiple role spawns** (`lab-runner`, `implementer`, `verifier`, `scout`…) possibly in the **same Batch** — **never** one `generalPurpose` / Composer doing lab + implement + verify + release. **Composer (`composer-2.5-fast`) = bounded mechanical tasks only** (surgical edits, repetitive, clear DoD). Required chain for methodology / docs / features: `lab-runner` (if greenfield) → `implementer`(s) by envelope → `verifier`; orchestrator only classifies / spawns / merges. **Anti-pattern:** Task one `generalPurpose` with “implement the plan end-to-end” covering lab + implement + verify + commit.

**En criollo:** todo cierre al humano (implementer handoff, narrate final del Orquestador) incluye `## En criollo` **al final del mensaje entregado** — contrato metodológico, no tip opcional. Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada. Regla instalada: `.cursor/rules/cj-criollo-changelog.mdc`.

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
- Implications for envelope: … (optional Batch Scout-2 / tanda Scout: …)
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

## En criollo
(3–6 frases: qué cambia en la práctica — install, update, chats, modelos, links, fricción)
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

Todos: compact `### Env · <role>` line (T|Run|O|Fase|Batch), Model/Sobre, Objetivo, Archivos/No tocar, Aceptación, Lab previo, Deltas previos, External contrast.

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
User ask → Run R-<id>
  → O1 · prep: header + gate (señales, cascade rules)
  → O1 · research-lab: [scout?] [lab APPROVE?] [maverick si env-anomaly?]
  → [freno humano?]
  → O1 · execute: implementer(s) Batch si WS independientes, con deltas
  → O1 · verify: verifier REQUIRED si hubo writer → triage automation → narrate
  → verify FAIL reproducible → O2 · execute→verify
  → verify FAIL diseño/hipótesis → O3 · research-lab (+ cascade +1 si T<T3)
  → ANOMALIA/ESCALATE → scout / cascade +1 / STOP (T3 ceiling → ESCALATE, no T4)
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
