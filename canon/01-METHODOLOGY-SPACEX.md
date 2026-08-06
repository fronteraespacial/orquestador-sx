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

### Contrato de vuelta

`Delete check:` + `Automation candidates:` + `External contrast:` (según umbrales) + opcional `Curiosity:` + `ANOMALIA:` / `## ESCALATE` si aplica.

**`## En criollo`** (obligatorio **solo al cierre** de implementación / handoff al humano): 3–6 frases sobre impacto real — install, update, chats, modelos, links, fricción. **Solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada.** No es cosmético: es parte del contrato SpaceX (regla Cursor `cj-criollo-changelog`, instalada en `.cursor/rules/`).

## 4. Header obligatorio (cada turno del Orquestador)

```markdown
## Complexity: T<0|1|2|3> — <Brief reason>
## Role: Orchestrator
## Action: Delegate to subagent (T0-T3)
## Run: R-<id>
## Oleada: O<1|2|3> — <initial|corrective|escalated>
## Fase: <prep|research-lab|execute|verify>
## Batch: B-<id> | none
```

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

**Default** = tier más barato. **Cascade +1** si falla aceptación o `ANOMALIA` bloqueante.

### Gate interno corto (solo Orquestador)

```markdown
## Gate
- Tier: T*
- Signals: …
- Lab / Scout / Maverick: …
- Run: R-<id> · Oleada: O1→… · Fases: prep→…
- Human brake: yes|no
```

## 6. Taxonomía Run / Oleada / Fase / Batch

| Término | Significado |
|---------|-------------|
| **Tier T0–T3** | Complejidad; máx T3; cascade en T3 → **ESCALATE** (no T4) |
| **Run R-…** | Objetivo del usuario (estable por pedido) |
| **Oleada O1–O3** | Ciclo completo: O1 inicial, O2 correctivo, O3 escalado; no O4 por defecto |
| **Fase** | `prep` \| `research-lab` \| `execute` \| `verify` (sin P0–P3 ni Wave 0–3) |
| **Batch B…** | Spawns paralelos + fan-in |
| **Spawn** | Un hijo; **nunca** es una oleada |
| **Retry** | Reintento técnico en la misma fase/batch (≤2; ESCALATE@2) |

Jerarquía: `Run` ⊃ `Oleada` ⊃ `Fase` ⊃ `Batch|Spawn`.

| Fase | Quién |
|------|-------|
| **prep** | Orquestador: clasificar, gate, sobres (sin tools de ejecución) |
| **research-lab** | scout, explore, auditors T3, lab-runner, maverick si aplica |
| **execute** | implementer/executor (Batch si WS independientes) |
| **verify** | verifier si hubo writer; triage automation; narrar |

El Orquestador **solo reenvía deltas** al siguiente sobre — no transcripts completos.

### verify FAIL → transición

| Evidencia verifier | Acción |
|--------------------|--------|
| **Transient** (flake, timeout, red) | **Retry** en fase verify (mismo batch) |
| **Reproducible local** (1–2 archivos, DoD claro) | **O2**: prep → execute correctivo → reverify |
| **Hipótesis / diseño / env / mismo fingerprint** | **O3** con fase **research-lab** (+ lab/scout/maverick); cascade +1 tier si T<T3 |
| Tras **O3**, budget agotado, o riesgo alto | **ESCALATE / STOP** + freno humano |
| Cascade cuando ya **T3** | **ESCALATE** (no T4) |

### Paralelismo

| Condición | Modo |
|-----------|------|
| Workstreams **independientes** | **Batch B-… REQUIRED** (fan-out + fan-in) |
| Dep **real** | Serial (p. ej. lab APPROVE → implementer → verifier) |

## 7. Router T0–T3

| Tier | Cuándo | Topología |
|------|--------|-----------|
| **T0** | Typo, 1 hunk, lectura | `explore` o `implementer` menor |
| **T1** | Bug 1–2 archivos | explore/implementer → **verifier si writer** |
| **T2** | ≥2 WS, refactor | Scout soft → Lab greenfield → Maverick env-anomaly → Batch fan-out → verifier |
| **T3** | Feature/P0, borroso, automatizar | Scout → Lab REQUIRED (greenfield) → auditors → Batch fan-out → verifier |

## 8. Gates

### 8.1 Scout (soft-mandatory)

Antes de lab/implementer en greenfield, anomalía, o post-`ESCALATE`. Offline: `SKIPPED — <motivo>`. Profundidad = 2–3 Scout en paralelo (no hay “Scout Deep”).

**Umbrales de contraste:** REQUIRED (greenfield|anomalía|ESCALATE|automation nueva|trade-off grande) · COMPLEMENTARY (T2/T3 borroso) · omitir (T0 / T1 mecánico).

### 8.2 Lab (greenfield REQUIRED)

Path canónico: **`.lab/YYYY-MM-DD-<slug>/`** en la raíz del repo (**no** `projects/.lab/`). Solo **APPROVE** desbloquea implementer en prod.

### 8.3 Maverick (env anomaly T2+ REQUIRED)

Síntomas de entorno/runtime → maverick sin que el usuario lo pida. Lab: `.lab/YYYY-MM-DD-mav-<slug>/`. Propone; no decide.

### 8.4 Verifier (REQUIRED tras implementer)

Antes de narrar “done”.

### 8.5 ESCALATE@2–3

Ejecutores: sin soft-web. 2 fallos (máx. 3 si repro) → `## ESCALATE` → Scout → retry con delta de contraste o STOP.

### 8.6 ANOMALIA

Hijo reporta evidencia → Orquestador: bloqueante / P1 / backlog → child acotado o cascade +1; frágil → lab.

### 8.7 Freno / debate humano

Parar si: pedido dumb/borroso, lab/auditores REJECT, trade-off solo humano, evidencia ≠ diagnóstico, contraste cambia el enfoque. Mensaje corto + 1–2 opciones.

### 8.8 Curiosity

`Curiosity:` en handoff; Orquestador decide (salvo maverick REQUIRED por env-anomaly).

## 9. Sala `.lab`

```text
.lab/
  README.md
  YYYY-MM-DD-slug/
    HYPOTHESIS.md | BRIEF.md
    RESULT.md | REPORT.md
```

Nunca importar a prod. Solo APPROVE desbloquea archivos reales. Maverick: prefijo `mav-` + fecha ISO.

## 10. Presupuestos

- Handoffs ≤40 líneas  
- LIGHTWEIGHT MODE hijo frontier: ≤8 tool calls; no leer >400 líneas enteras  
- Scout ≤5 fuentes  
- Orquestador: preferir 0 tools de ejecución  

## 11. Narración y stop

**Final siempre** (lenguaje simple): pedido / tamaño / hecho y no / lab / contraste / freno / leftovers / triage automation; **`## En criollo` al cierre** (3–6 frases prácticas — nunca como preámbulo del plan o de la oleada).

**Stop si:** dumb/borroso, REJECT, trade-off humano, DEAD-END, reintentar hipótesis refutada.
