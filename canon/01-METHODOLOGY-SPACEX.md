# 01 — Metodología SpaceX + Orquestador (core)

Leé completo antes de instalar. Filosofía **universal**; los CLIs solo cambian el *cómo se spawnea*. Detalle operativo de roles/handoffs: [`02-ROLES-HANDOFFS-GATES.md`](02-ROLES-HANDOFFS-GATES.md). Skill canónica: `runtime/skills/orchestrator/SKILL.md`.

## 1. Idea en una frase

El **Orquestador** recibe el prompt crudo, lo clasifica, lo traduce a un **gate interno corto**, planifica **Run → Oleada O1–O3 → Fases**, escribe sobres, delega y fusiona **handoffs compactos (deltas)**. Los hijos ejecutan. El padre **no** edita, testea, despliega, hace web research ni explora el sistema — **ni en T0**.

## 2. Best-effort vs enforcement

| Superficie | Realidad |
|------------|----------|
| **Cursor** | Solo puede **auditar** esta política (`readonly`, rules, logs). **No** impone zero-exec al 100%. |
| **OpenCode / Codex** | Pueden negar edit/bash al agente orquestador si se configura. |
| **Antigravity** | Fuerte vía docs/agents; sigue siendo best-effort si se ignoran. |

Violación = fallo de proceso, no “el producto lo permitió”.

## 3. Algorithm fractal (orden)

1. **Requirements less dumb** — ¿hace falta? ¿quién lo pidió?
2. **Delete** — ¿qué borrar en vez de añadir?
3. **Simplify** — solo lo que sobrevivió
4. **Accelerate** — ciclo corto; paralelismo = táctica
5. **Automate** — cosechar al final (triage: ahora / backlog / descartar)

### Micro-gate (todo envelope)

```markdown
1. ¿Requisito mínimo? ¿Algo dumb/prematuro?
2. ¿Qué BORRAR en este alcance?
3. ¿Versión más simple que pasa la aceptación?
4. ¿Verificación rápida?
5. Automation candidates:
```

### Algorithm Ledger (parent-owned)

El Orquestador mantiene un ledger ≤10 líneas. **Hijos no escriben** el ledger.

```markdown
## Algorithm Ledger
- Need: …
- Delete: …
- Simplify: …
- Accelerate: …
- Automate: now|backlog|discard — …
```

| Momento | Qué poblar |
|---------|------------|
| **Prep / Discovery DECIDE** | **Need / Delete / Simplify** (evidencia → decisión) |
| **Harvest** (fin de verify PASS T2/T3) | **Automate** + triage; Maverick CONSULT propone `NO_CHANGE` \| `YIELD_OPT` — **nunca** auto O2 |

### Contrato de vuelta

`Delete check:` + `Automation candidates:` + `External contrast:` (según umbrales) + opcional `Curiosity:` + `ANOMALIA:` / `## ESCALATE` si aplica.

**`## En criollo`** (obligatorio **solo al cierre** de implementación / handoff al humano): 3–6 frases sobre impacto real — install, update, chats, modelos, links, fricción. **Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada.** No es cosmético: es parte del contrato SpaceX (regla Cursor `cj-criollo-changelog`, instalada en `.cursor/rules/`).

## 4. Header obligatorio (cada turno del Orquestador)

Bloque compacto — **no** un `##` H2 por campo:

```markdown
### Orch
T<0|1|2|3> — <brief reason> | WorkType <greenfield|evolving-product|legacy-app|ops-diagnostic> | Run R-<id> | O<1|2|3> <initial|corrective|escalated> | Fase <prep|research-lab|execute|verify> | Batch <B-<id>|none>
Role: Orchestrator | Action: Delegate
```

Recovery: append `| Failure-ID: F-<id>` on the Role line when applicable.

No existe `Action: Direct Execution`. T0 también delega.

**Anti-patrón:** nunca numerar una oleada por `invoke_subagent` / Task / Scout / fase — la oleada es ciclo completo; un spawn o batch es un paso dentro de una fase.

## 5. Señales de clasificación (≤10 líneas en el gate)

1. #archivos / boundaries  
2. Workstreams disjuntos  
3. Requisito borroso  
4. Riesgo prod / irreversible  
5. Evidencia UI  
6. Automatización nueva  
7. ¿Lab? (greenfield, frágil, fuera de caja, hipótesis de debug, automation nueva)  
8. ¿Anomalía de entorno? (WSL/contenedor/proxy/UDP vs TCP / host≠agent env)  
9. **WorkType:** `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic`

**Default** = tier más barato. **Cascade +1** si falla aceptación o `ANOMALIA` bloqueante.

### Gate interno corto (solo Orquestador)

```markdown
## Gate
- Tier: T*
- WorkType: greenfield | evolving-product | legacy-app | ops-diagnostic
- Signals: …
- Lab / Scout / Maverick: …
- Discovery: enter | skip — <motivo>
- Run: R-<id> · Oleada: O1→… · Fases: prep→…
- Human brake: yes|no
```

## 6. Taxonomía Run / Oleada / Fase / Batch

| Término | Significado |
|---------|-------------|
| **Tier T0–T3** | Complejidad; máx T3; cascade en T3 → **ESCALATE** (no T4) |
| **WorkType** | `greenfield` \| `evolving-product` \| `legacy-app` \| `ops-diagnostic` (texto en gate) |
| **Run R-…** | Objetivo del usuario (estable por pedido) |
| **Oleada O1–O3** | Ciclo completo: O1 inicial, O2 correctivo, O3 escalado; no O4 por defecto |
| **Fase** | `prep` \| `research-lab` \| `execute` \| `verify` (sin P0–P3 ni Wave 0–3) |
| **Batch B…** | Spawns paralelos + fan-in |
| **Spawn** | Un hijo; **nunca** es una oleada |
| **Retry** | Reintento técnico en la misma fase/batch (≤2; ESCALATE@2) |

Jerarquía: `Run` ⊃ `Oleada` ⊃ `Fase` ⊃ `Batch|Spawn`.

| Fase | Quién |
|------|-------|
| **prep** | Orquestador: clasificar, WorkType, gate, sobres (sin tools de ejecución) |
| **research-lab** | scout, explore, auditors T3, lab-runner, maverick si aplica; **incluye** sub-fase Discovery/Pre-Plan cuando aplica |
| **execute** | implementer/executor (Batch si WS independientes) — solo tras Build aprobado cuando hubo YIELD_PLAN |
| **verify** | verifier si hubo writer; **VerifierLikeHuman** si T2/T3 user-facing tras PASS técnico; cross-surface integration check tras execute Batch multi-superficie; **RELEASE CHECKLIST** fase cuando aplique publish; Harvest + Maverick CONSULT T2/T3; triage automation; narrar |

El Orquestador **solo reenvía deltas** al siguiente sobre — no transcripts completos.

### 6.1 Discovery / Pre-Plan (⊂ `research-lab`)

**No** es una 5ª Fase ni oleada nueva. Estados acotados **antes** del Plan/Artifact nativo de la superficie:

```text
DISCOVERY → DECIDE → YIELD_PLAN → native Plan/Artifact → human approval → Build
```

| | Regla |
|--|-------|
| **Enter cuando cualquiera** | zero-to-one · large debug sin hipótesis dominante · legacy hot path · ≥2 enfoques plausibles · post-ESCALATE · architecture trade-off · irreversible change |
| **Skip** | Solo T0/T1 **clear / repro / local / doctrine-known** (camino único mecánico) |
| **Budget** | **Un** research Batch; máx **2** labs normal, **3** solo T3; **una** REVISE; luego orch-only **`DECIDE` \| `YIELD_PLAN` \| `STOP`** |
| **Labs en Discovery** | **Sin** writes a prod; **sin** Implementation Plan formal en el lab |
| **YIELD_PLAN** | Orch emite → humano abre Plan UI nativo → aprueba **Build** → recién entonces O1 `execute`. Declinar Build = **STOP**. ≠ veredicto lab **`YIELD`** |
| **Trabajo acotado directo** | Puede omitir Discovery solo bajo skip T0/T1 arriba |

### 6.2 WorkType router

| WorkType | Discovery / plan | Labs / ejecución |
|----------|------------------|------------------|
| **greenfield** | Discovery + plan (z2o dispara) | Feature labs OK; Lab Batch si ≥2 hipótesis |
| **evolving-product** | Baseline / impact / repro; Discovery solo si triggers | Lab selectivo; skip si camino claro |
| **legacy-app** | Map + repro **antes** de edit; Discovery en hot path / desconocido | Diff mínimo; labs aislados con cuidado |
| **ops-diagnostic** | Loop de evidencia; **no** pipeline de feature | **Sin** feature lab; **sin** mutaciones paralelas; freno humano duro si privileged / destructive / multi-host |

### 6.3 Surface plan policy (ask-only)

El Orquestador **narra / pide** al humano; **no** afirma que agentes auto-cambian de modo.

| Superficie | Tras YIELD_PLAN |
|------------|-----------------|
| **Cursor** | Humano cambia a **Plan Mode** → aprueba Build |
| **Antigravity** | **Planning Mode** + **Artifact Review** → aprueba Build |
| **OpenCode** | **Plan → Build** (humano) |
| **Codex** | `/plan` → ejecución explícita (humano) |

### verify FAIL → transición

| Evidencia verifier | Acción |
|--------------------|--------|
| **Transient** (flake, timeout, red) | **Retry** en fase verify (mismo batch) |
| **Reproducible local** (DoD claro, gap inventory completo) | **Un solo O2**: prep → **one** execute correctivo Batch (todos los gaps) → reverify |
| **Hipótesis / diseño / env / mismo fingerprint** | **O3** con fase **research-lab** (+ lab/scout/maverick); cascade +1 tier si T<T3 |
| Tras **O3**, budget agotado, o riesgo alto | **ESCALATE / STOP** + freno humano |
| Cascade cuando ya **T3** | **ESCALATE** (no T4) |

**Verify loop (1.3.1):**

| Regla | Detalle |
|-------|---------|
| **A — Gap inventory** | Verifier **FAIL** entrega inventario **completo** de gaps (todos los bloqueantes), no solo el primero. Veredicto **FAIL** si cualquier gap bloquea. |
| **B — One O2 per fan-in** | Padre abre **como máximo un O2** por fan-in de verify que consolida el inventario completo en **un** Batch correctivo execute — **no** whack-a-mole O2/O3/O4 por gap individual. |
| **C — Input vs output** | Sobres **de entrada** al hijo pueden ser largos/completos; **handoffs de salida** ≤40 líneas. **Prohibido** aplicar ≤40/≤20 a prompts de entrada. |
| **D — Cross-surface check** | Tras execute Batch multi-superficie: verify incluye chequeo de **consistencia integrada** (installer maps, docs↔runtime, naming, orden de campos handoff) antes de claims de release. |
| **E — Release checklist fase** | Pasos release/publish (VERSION, lock sha, RefreshSandbox, zip/SHA256SUMS, pin tags) = fase **RELEASE CHECKLIST** planificada — **no** descubiertos vía cascadas sucesivas de FAIL. |

**VerifierLikeHuman** FAIL / INCONCLUSIVE: orch clasifica (narrar gap / O2|O3 / STOP). VLH **nunca** abre O2 ni edita.

### Paralelismo

| Condición | Modo |
|-----------|------|
| Workstreams **independientes** | **Batch B-… REQUIRED** (fan-out + fan-in) |
| Dep **real** | Serial (p. ej. lab APPROVE → implementer → verifier) |
| **ops-diagnostic** | **Serial only** — no parallel mutations |

### Multitask Mode / Composer — reglas duras

**Multitask Mode / Build in Parallel NO colapsa roles.** Paralelismo = varios **spawns de rol** en el mismo Batch — **nunca** un solo agente con lab + implement + verify.

| Regla | Detalle |
|-------|---------|
| **Composer ≠ pipeline** | `composer-2.5-fast` / `generalPurpose` **nunca** posee lab → implement → verify → release en un hilo. Solo tareas acotadas con DoD claro. Scope grande → **más sobres acotados del mismo rol**, no mega-pipeline. |
| **Cadena obligatoria** | Metodología / docs / features: `lab-runner` (greenfield / regla nueva) → `implementer`(s) por sobre → `verifier` → `VerifierLikeHuman` si gate → Harvest. Padre **solo** clasifica / spawnea / fusiona. |
| **Multitask ≠ colapso** | Parent Multitask Mode autoriza Tasks **paralelos por rol** — **no** un worker monolítico que absorba todos los roles. |
| **Anti-patrón explícito** | **Prohibido** Task un `generalPurpose` con “implementá el plan end-to-end” cubriendo lab + implement + verify + commit. |

## 7. Router T0–T3

| Tier | Cuándo | Topología |
|------|--------|-----------|
| **T0** | Typo, 1 hunk, lectura | `explore` o `implementer` menor; Discovery skip si clear |
| **T1** | Bug 1–2 archivos | explore/implementer → **verifier si writer**; Discovery skip si clear/repro |
| **T2** | ≥2 WS, refactor | Scout soft → Discovery si triggers → Lab / Batch → YIELD_PLAN si aplica → Batch fan-out → verifier → VLH si user-facing → Harvest + Maverick CONSULT |
| **T3** | Feature/P0, borroso, automatizar | Scout → Discovery (budget ≤3 labs) → Lab REQUIRED (greenfield) → auditors → YIELD_PLAN → Batch → verifier → VLH si user-facing → Harvest + Maverick CONSULT |

## 8. Gates

### 8.1 Scout (soft-mandatory)

Antes de lab/implementer en greenfield, anomalía, o post-`ESCALATE`. Offline: `SKIPPED — <motivo>`. Profundidad = 2–3 Scout en paralelo (no hay “Scout Deep”).

**Umbrales de contraste:** REQUIRED (greenfield|anomalía|ESCALATE|automation nueva|trade-off grande) · COMPLEMENTARY (T2/T3 borroso) · omitir (T0 / T1 mecánico).

### 8.2 Lab (greenfield REQUIRED) + Lab Batch

Path canónico: **`.lab/YYYY-MM-DD-<slug>/`** en la raíz del repo (**no** `projects/.lab/`). Solo **APPROVE** desbloquea implementer en prod.

**Lab Batch (targeted):** 2–3 hipótesis **distintas** con paths / ports / services / data **aislados**; evidence matrix fan-in; merge `APPROVE` > `REVISE` > `REJECT` > `YIELD`. **≥2 APPROVE** competidores → **human brake** (elige uno). Un ganador → un path de prod. **ops-diagnostic:** no Lab Batch de features; no mutaciones paralelas.

### 8.3 Maverick

| Cuándo | Modo |
|--------|------|
| Env-anomaly T2+ | **REQUIRED** (LAB o CONSULT) |
| Zero-to-one / architecture trade-off en Discovery | **CONSULT early** |
| Tras T2/T3 **PASS** técnico (+ VLH si gated) y Harvest | **CONSULT mandatory** — propone solo `NO_CHANGE` \| `YIELD_OPT`; **nunca** auto O2; `YIELD_OPT` necesita humano |

Síntomas de entorno/runtime → maverick sin que el usuario lo pida. Lab: `.lab/YYYY-MM-DD-mav-<slug>/`. Propone; no decide.

### 8.4 Verifier (REQUIRED tras implementer)

Antes de narrar “done”.

### 8.4b VerifierLikeHuman (T2/T3 user-facing)

Tras **verifier técnico PASS**, solo trabajo T2/T3 **user-facing** (UI/UX DoD · salida human-ops · docs accionables · `Human-serve: yes`). Rol dedicado; **no** edita; **no** abre O2. Requiere `Evidence-class` + `Serves-ask` + veredicto (detalle en [`02`](02-ROLES-HANDOFFS-GATES.md) / [`09`](09-VERIFY-CHECKLIST.md)). `UNAVAILABLE` → **INCONCLUSIVE** — nunca PASS visual inventado.

### 8.5 ESCALATE@2–3

Ejecutores: sin soft-web. 2 fallos (máx. 3 si repro) → `## ESCALATE` → Scout → retry con delta de contraste o STOP. Post-ESCALATE ∈ triggers de Discovery.

### 8.6 ANOMALIA

Hijo reporta evidencia → Orquestador: bloqueante / P1 / backlog → child acotado o cascade +1; frágil → lab.

### 8.7 Freno / debate humano

Parar si: pedido dumb/borroso, lab/auditores REJECT, trade-off solo humano, evidencia ≠ diagnóstico, contraste cambia el enfoque, multi-APPROVE en Lab Batch, decline YIELD_PLAN/Build, ops privileged/destructive/multi-host. Mensaje corto + 1–2 opciones.

### 8.8 Curiosity

`Curiosity:` en handoff; Orquestador decide (salvo maverick REQUIRED por env-anomaly / post-Harvest CONSULT).

### 8.9 Harvest (fin T2/T3 PASS)

Parent actualiza Algorithm Ledger (Automate) → Maverick CONSULT mandatory → `NO_CHANGE` o `YIELD_OPT` (humano decide; sin auto O2).

## 9. Sala `.lab`

```text
.lab/
  README.md
  YYYY-MM-DD-slug/
    HYPOTHESIS.md | BRIEF.md
    RESULT.md | REPORT.md
```

Nunca importar a prod. Solo APPROVE desbloquea archivos reales. Maverick: prefijo `mav-` + fecha ISO. En Discovery/Batch: sin writes a prod ni Implementation Plan formal dentro del lab.

## 10. Presupuestos

- **Handoffs de salida** ≤40 líneas (explore/scout/implementer/lab/verifier/VLH)  
- **Sobres de entrada** al hijo: **sin límite artificial** — pueden ser largos/completos (DoD, allow-list, gap inventory, deltas)  
- LIGHTWEIGHT MODE hijo frontier: ≤8 tool calls; no leer >400 líneas enteras  
- Scout ≤5 fuentes  
- Orquestador: preferir 0 tools de ejecución  
- Discovery: 1 research Batch; ≤2 labs (≤3 T3); 1 REVISE  
- Algorithm Ledger ≤10 líneas (parent-only)  
- Verifier FAIL: inventario **completo** de gaps; **un O2** por fan-in verify  
- Release/publish: fase **RELEASE CHECKLIST** explícita — no vía FAIL cascades  

## 11. Narración y stop

**Final siempre** (lenguaje simple): pedido / WorkType / tamaño / hecho y no / Discovery|YIELD_PLAN / lab / contraste / freno / leftovers / Harvest triage; **`## En criollo` al cierre** (3–6 frases prácticas — nunca como preámbulo del plan o de la oleada).

**Stop si:** dumb/borroso, REJECT, trade-off humano, DEAD-END, reintentar hipótesis refutada, decline YIELD_PLAN/Build, ops brake privileged.
