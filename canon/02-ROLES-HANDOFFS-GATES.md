# 02 — Roles, handoffs y gates (detalle operativo)

**Prompts completos:** [`../runtime/cursor/agents/`](../runtime/cursor/agents/) y [`../runtime/antigravity/agents/`](../runtime/antigravity/agents/). Este archivo = contratos. Skill: `runtime/skills/orchestrator/SKILL.md`.

## 1. Roles lógicos

| Rol | Job | Write? | Web? |
|-----|-----|--------|------|
| **Orchestrator** | Clasificar, WorkType, gate, oleadas, Discovery/YIELD_PLAN, sobres, Ledger, Harvest, fusionar deltas, freno, narrar | **No** (política; Cursor = best-effort) | Solo vía hijos |
| **explore** | Repo/MCP/sistema **local** | No | No |
| **scout** | Docs/prior art externos | No | Sí (foco del sobre) |
| **maverick** | What-ifs; LAB propio; CONSULT early + post-Harvest | Solo `.lab/…-mav-…` | Sí |
| **lab-runner** / **lab** | MVP una hipótesis | Solo `.lab/<id>/` | No → ESCALATE |
| **implementer** / **executor** | Writer de producción | Sí (paths del sobre) | No |
| **verifier** | Tests/lint DoD técnico | No | No |
| **VerifierLikeHuman** | Juicio “como humano” post-PASS técnico (T2/T3 user-facing) | **No** | No |
| **skeptic** / **expert** (OpenCode) | Auditoría T3 / análisis RO | No | Según sobre |

### Glosario YIELD ≠ YIELD_PLAN

| Término | Quién | Significado |
|---------|-------|-------------|
| **YIELD** | lab-runner | Veredicto de lab: ceder / no APPROVE (≠ desbloqueo prod) |
| **YIELD_PLAN** | Orquestador | Tras DECIDE: pedir al humano Plan/Artifact nativo → Build; decline = STOP |
| **YIELD_OPT** | Maverick (propuesta) | Tras Harvest: sugerir optimización; **humano** decide; nunca auto O2 |
| **NO_CHANGE** | Maverick (propuesta) | Tras Harvest: no abrir trabajo extra |

## 2. Spawn por superficie

| Superficie | API | Definiciones |
|------------|-----|--------------|
| **Cursor** | **Task** o `/nombre` | `.cursor/agents/*.md` |
| **Antigravity** | `invoke_subagent` | `.agents/agents/<role>/agent.md` |
| **OpenCode** | Task / `@executor` | `opencode.json(c)` |
| **Codex** | TOML / Task | `.codex/agents/*.toml` |

**No** inventar `invoke_subagent` en Cursor. **No** asumir que Cursor carga `.agents/agents/`.

**Parent model:** humano / Auto — pack templates **omit** `model:` en orchestrator; sesión gana. **Nested orch (opcional — NOT default):** default direct; depth-1 nest solo con triggers en [`07-MODELS-MATRIX.md`](07-MODELS-MATRIX.md) §2.2 — outer thin launcher, nested owns classify/spawn; no nueva Fase.

**Plan nativo (ask-only):** Cursor → humano a Plan Mode; Antigravity → Planning Mode + Artifact Review; OpenCode → Plan→Build; Codex → `/plan`→ejecución explícita. Agentes **no** auto-cambian de modo.

### Header compacto (cada turno Orquestador)

```markdown
### Orch
T<0|1|2|3> — <brief> | WorkType <…> | Run R-<id> | O<1|2|3> <…> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate | Next spawn: <role(s)> | Parent tools: none
```

| Campo | Regla |
|-------|-------|
| **`Next spawn:`** | Próximo rol o Batch planificado (p. ej. `implementer×3`, `verifier`, `lab-runner`) |
| **`Parent tools: none`** | Padre **no** Write/Shell/test/deploy este turno; violación = **process fail** |
| **Recovery** | Append `| Failure-ID: F-<id>` en la línea Role cuando aplique |

**Exit-card Build:** Build aprobado → padre **solo** spawnea implementer(s); padre que edita/tests/shell = **process fail**. Multitask on/off no cambia. “Implement the plan / complete todos” = fase **execute** vía Task, no monolito.

**Phrase→role (canon resumen):** tabla completa en skill — “implement/fix/write prod” → `implementer`; “verify/DoD” → `verifier`; “lab/MVP” → `lab-runner`; “prior art afuera” → `scout`; “what-if/env” → `maverick`; “end-to-end plan” → execute Batch implementer(s), **no** monolito.

## 3. Run, oleadas, fases y deltas

```text
Tier T0–T3         complejidad del ask (T0 trivial → T3 máx.; cascade +1 hasta T3 → ESCALATE, no T4)
WorkType           greenfield | evolving-product | legacy-app | ops-diagnostic
Run R-<id>         objetivo del usuario (puede abarcar O1→O3)
└─ Oleada O1|O2|O3 ciclo completo de fases
   └─ Fase          prep → research-lab → execute → verify (omitir vacías)
      └─ Discovery  sub-fase ⊂ research-lab: DISCOVERY→DECIDE→YIELD_PLAN→Plan nativo→Build
      └─ Batch B-<n> N spawns paralelos + fan-in (Lab Batch: paths/ports/services/data aislados)
      └─ Spawn       exactamente 1 hijo (nunca etiquetar como oleada)
      └─ Retry       reintento técnico misma fase/batch (≤2; ESCALATE@2)
```

Ejemplo feliz (con Discovery):

```text
O1 · prep           Orch: WorkType + gate + Ledger (Need/Delete/Simplify seeds) + sobres
O1 · research-lab   Discovery Batch → labs ≤2 (≤3 T3) → DECIDE → YIELD_PLAN
                    → humano Plan/Artifact → Build
O1 · execute        Implementer Batch fan-out (2–3 si T≥2+Composer) → handoffs
O1 · verify         verifier → [VerifierLikeHuman si T2/T3 user-facing]
                    → Harvest (Automate) → Maverick CONSULT → narrate
```

Orquestador **pega solo deltas** (bloque canónico o 3–8 bullets) en el siguiente sobre. Prohibido reenviar el transcript completo del hijo.

**Paralelismo:** Batch **REQUIRED** si workstreams independientes; serial solo con deps reales (p. ej. lab APPROVE antes de execute). **ops-diagnostic:** sin mutaciones paralelas en **execute**; **Mode: diagnostic** permite Batch paralelo de **4 drones RO** (lanes disjuntas) antes del synthesizer.

### Mode: diagnostic (compact)

**Mode: diagnostic** ⊂ WorkType **`ops-diagnostic`** / post-**`ANOMALIA`** / regression — **no** WorkType nuevo. Skip si T0/T1 trivial; runtime no-diagnostic → **Cursor Debug Mode first**.

| Paso | Rol | Notas |
|------|-----|-------|
| Prior scan | Orquestador | Lee `.debug/*/REPORT.md` antes de spawn |
| Batch drones | **explore** ×4 RO | Lanes: **logs** \| **recent-changes** \| **structural** \| **similar-fragility** · `composer-2.5-fast` · writes solo en `.debug/<id>/drone-*/` |
| Fan-in | **Synthesizer** (parent merge → `REPORT.md`) | Grok Fast · tags human+agent · **sin patch prod** |
| Pre-close | **maverick CONSULT HARD** | Crisis · Best Part is No Part · `NO_CHANGE` \| `YIELD_OPT` · Redesign-signals · **never patch** |
| Post-REPORT | humano | Fix aprobado → **sale** del modo diagnostic → implementer normal |

**Incident-review:** humano pide → orch escanea `.debug/*/REPORT.md`, narra; no re-spawn salvo gap.

**Lab Batch fan-in:** evidence matrix; `APPROVE` > `REVISE` > `REJECT` > `YIELD`. **≥2 APPROVE** → human brake → un path prod.

**Multitask Mode / Build in Parallel (HARD):** parent Multitask Mode **does NOT** authorize collapsing roles. Parallelism = **multiple role spawns** (`lab-runner`, `implementer`, `verifier`, `VerifierLikeHuman`, `scout`…) possibly in the **same Batch** — **never** one `generalPurpose` / Composer doing lab + implement + verify + release. **Composer (`composer-2.5-fast`) = bounded mechanical tasks only** (surgical edits, repetitive, clear DoD; Lab Batch lab-runners ≥2 parallel). **Not** verifier, not single lab, not VLH — wrong-role Composer = **process FAIL**. Required chain: `lab-runner` (if greenfield) → `implementer`(s) → `verifier` → `VerifierLikeHuman` (if gated) → Harvest; orchestrator only classifies / spawns / merges. **Anti-pattern:** Task one `generalPurpose` with “implement the plan end-to-end” covering lab + implement + verify + commit.

**Implementer Batch (T2/T3 + Composer) — HARD:** cuando T∈{2,3} y writers son `composer-2.5-fast` (o host fast-Composer remap), spawn **2–3** implementers en el **mismo** execute Batch con allow-lists **disjuntas**, DoD compartido, **exactamente un** `Release-owner` (VERSION/CHANGELOG/lock) o defer a **RELEASE CHECKLIST**. T0/T1: **1**. **Inseparable** (archivo único / hunk acoplado): documentar + **serial micro-passes**. **Lab Batch ≠ Implementer Batch.** ops-diagnostic: serial. O2: misma regla si gaps path-partitionable. Padre rechaza overlap de paths; espera fan-in completo antes de verify. **Nunca** fold verifier/lab/VLH en implementer.

**Input vs output budgets (HARD):** child **input envelopes** may be long/complete; child **output handoffs** ≤40 lines. **Ban** applying ≤40/≤20 to input prompts.

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

**Diagnostic drone** (Mode: diagnostic — append lane):

```markdown
## Explore handoff · drone-<logs|recent-changes|structural|similar-fragility>
- Lane: logs | recent-changes | structural | similar-fragility
- Path: .debug/<id>/drone-<lane>/
- Evidence: ≤5 bullets
- Tags for REPORT: …
- Recommendations for synthesizer: …
```

### diagnostic synthesizer (parent-owned)

```markdown
## Diagnostic REPORT · .debug/<id>/REPORT.md
- Tags: … (human + future agents)
- Findings: ≤8 bullets (fan-in from 4 lanes)
- Maverick block: NO_CHANGE | YIELD_OPT · Redesign-signals · never patch
- Next: narrate | human fix approval → exit diagnostic mode
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
- Timing: early-discovery | env-anomaly | post-harvest
- What-if ideas: ≤3
- Best-part-is-no-part: …
- Unconventional reuse: …
- Lab evidence: none | .lab/<dir> … | YIELD
- Attempts: N/3
- Proposal (post-harvest): NO_CHANGE | YIELD_OPT — …
- Risk & why it might work anyway: …
- Not my call: …
```

Opcional `## MAV-ESCALATE` con theory / approaches / request.

**CONSULT timings:** (1) early en Discovery zero-to-one / architecture trade-off; (2) env-anomaly T2+ REQUIRED; (3) **mandatory** tras cada T2/T3 PASS (+ VLH si gated) y Harvest — solo `NO_CHANGE` \| `YIELD_OPT`, nunca auto O2; (4) **Mode: diagnostic — CONSULT HARD** antes de `REPORT.md` final en `.debug/<id>/` — crisis · Best Part is No Part · Redesign-signals · **never patch**.

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
- Isolation: paths | ports | services | data — …
```

### verifier

```markdown
Verdict: PASS | FAIL | INCONCLUSIVE
- Commands run: …
- Evidence: …
- Gap inventory: (FAIL only — **all** blocking gaps, not just first)
## ESCALATE  (si mismo DoD falla 2× sin nuevo envelope)
```

On **FAIL**: list **every** blocking gap in `Gap inventory:`; verdict stays **FAIL** if any gap blocks. Parent consolidates full inventory into **one O2** execute Batch — not one O2 per gap.

### VerifierLikeHuman

```markdown
## VerifierLikeHuman handoff
- Verdict: PASS | FAIL | INCONCLUSIVE
- Serves-ask: yes | partial | no
- Evidence-class: CAPTURED | BROWSER | COMPUTER | PROXY | UNAVAILABLE
- Evidence / artifact paths: …
- Ask Orchestrator: …
```

Gate: T2|T3 user-facing after technical PASS. `UNAVAILABLE` → **INCONCLUSIVE** (nunca PASS visual inventado). **No** edit; **no** web; **no** auto O2.

## 5. Envelopes por rol (mínimos)

Todos: compact `### Env · <role>` line (T|WorkType|Run|O|Fase|Batch), Model/Sobre, Objetivo, Archivos/No tocar, Aceptación, Lab previo, Deltas previos, External contrast. **Input envelopes may be long/complete** — full DoD, allow-lists, gap inventories OK. **Output handoffs ≤40 lines only.**

| Rol | Extra |
|-----|--------|
| implementer | Micro-gate 1–5; sin web; Build aprobado si hubo YIELD_PLAN; honor path allow-list; `Release-owner: yes\|no`; T≥2+Composer → Implementer Batch 2–3 (disjoint paths) |
| lab-runner | Solo `.lab/<id>/**`; REPORT + veredicto; isolation checklist |
| scout | Enfoque de búsqueda; no escribir |
| maverick | CONSULT\|LAB; timing; path mav fechado |
| verifier | Lista DoD / comandos; on FAIL → **complete gap inventory**; cross-surface integration check when multi-surface execute Batch |
| VerifierLikeHuman | `## VerifierLikeHuman handoff`; Evidence-class; Serves-ask; Evidence paths; sin edit/web/auto O2 |
| explore | Readonly local; **diagnostic drones** RO → `.debug/<id>/drone-*/` only |
| **diagnostic synthesizer** | Parent-owned merge → `.debug/<id>/REPORT.md`; Grok Fast; integra Maverick CONSULT HARD; tags; no prod patch |
| skeptic/deletion | Sin código; entregables de auditoría |
| **release-checklist** | VERSION, lock sha, RefreshSandbox, zip/SHA256SUMS, pin tags — **fase explícita**, not discovered via verify FAIL cascades |

Plantillas largas: skill § Envelopes by role.

## 6. Flujo feliz

```text
User ask → Run R-<id> · WorkType
  → O1 · prep: header + gate (señales, Discovery enter|skip, Ledger seeds)
  → O1 · research-lab: [Discovery Batch?] [scout?] [lab APPROVE / Lab Batch?] [maverick early|env?]
       → DECIDE | YIELD_PLAN | STOP
       → [YIELD_PLAN → humano Plan nativo → Build | decline=STOP]
  → [freno humano?]
  → O1 · execute: implementer(s) Batch si WS independientes, con deltas
  → O1 · verify: verifier REQUIRED si hubo writer
       → cross-surface integration check si execute Batch multi-superficie
       → [VerifierLikeHuman si T2/T3 user-facing tras PASS]
       → [RELEASE CHECKLIST fase si publish]
       → Harvest (Ledger Automate) → Maverick CONSULT mandatory (T2/T3)
       → triage automation → narrate
  → verify FAIL reproducible → **one O2** · execute→verify (full gap inventory consolidated)
  → verify FAIL diseño/hipótesis → O3 · research-lab (+ cascade +1 si T<T3)
  → ANOMALIA/ESCALATE → scout / Discovery / cascade +1 / STOP (T3 ceiling → ESCALATE, no T4)
```

## 7. Fronteras

| Necesidad | Rol |
|-----------|-----|
| ¿Dónde está X en el repo? | explore |
| ¿Docs/prior art afuera? | scout |
| ¿Y si borramos Y / al revés? | maverick |
| ¿Se siente bien para el humano? | VerifierLikeHuman (post tech PASS) |
| Soft-web desde implementer | **Prohibido** → ESCALATE |
| Escribir Algorithm Ledger | **Solo** Orquestador |

## 8. OpenCode extras

- **skeptic:** requisitos T3 adversariales; edit deny.  
- **expert:** análisis pesado RO.  
Opcional en Cursor (ver 08).
