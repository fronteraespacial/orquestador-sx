# 07 — Matriz de modelos

Los IDs cambian. **Siempre** listar modelos vivos en el host antes de fijar frontmatter.

**Política Cursor (decisión operativa del usuario):** parent = `cursor-grok-4.5-high`; Maverick / verifier / VLH / lab single-spawn = `cursor-grok-4.5-high-fast`; Lab Batch ≥2 parallel labs → each lab-runner `composer-2.5-fast`; demás hijos (implementer, explore, scout, skeptic, deletion) = `composer-2.5-fast`. Large Composer scope → más sobres acotados del **mismo rol**, no mega-pipeline. **No** hay conclusión local de superioridad Grok-vs-Composer; ver [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md).

**Maverick + VerifierLikeHuman + Verifier (cross-host):** use **Grok 4.5 High Fast** wherever the host exposes it. If the host has **no** Grok (e.g. Antigravity), apply an explicit **`Host remap`** to the best documented high-reasoning host model — **never** label that remap “Grok”. Roles stay enabled.

## 1. Principios

| Rol | Criterio | Evitar |
|-----|----------|--------|
| **Orchestrator** | Routing, gates, oleadas, freno; prefer heavy | Modelo que ignore REQUIRED o “codee T0”; `inherit` inestable en CLI |
| explore / scout | Rápido, tool-use, barato | Writer pesado |
| maverick | Creativo + razonamiento; techo alto; Grok 4.5 High Fast when exposed; else **`Host remap`** high-reasoning | Flash; calling a non-Grok ID “Grok” |
| implementer / executor | Código fiable en paths+DoD claros; scope grande → más sobres, mismo rol | Flash free ya marcado unreliable; mega-pipeline Composer |
| lab-runner | **Single spawn** → Grok Fast (Cursor); **Lab Batch ≥2** → Composer Fast each | Forzar Grok en batch paralelo; forzar Composer en lab único |
| verifier | Sigue DoD; no inventa PASS; **siempre** Grok Fast on Cursor; else **`Host remap`** high-reasoning | Composer verifier on Cursor; el más barato del catálogo |
| **VerifierLikeHuman** | Juicio humano post-PASS; Grok 4.5 High Fast when exposed; else **`Host remap`** high-reasoning | Composer; inventar evidencia visual; fake “Grok” labels |
| skeptic | Adversarial | Mismo modelo que implementer (sesgo) |

El Orquestador **no necesita** modelo “con tools de edición”; necesita disciplina de delegación. Skills **no** cambian el modelo — solo config nativa / Task `model:`.

## 2. Cursor

**Regla dura Composer:** ID canónico **`composer-2.5-fast`**. **Nunca** `composer-2.5` sin `-fast` en routing operativo (frontmatter / Task `model:`).

`agent --list-models` o UI. Estado versionado: [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md).

| Rol | Default pack | Notas |
|-----|--------------|-------|
| orchestrator (sesión) | **`cursor-grok-4.5-high`** | Verificado en template; **no** `inherit`. Fallback: nearest non-Fast Grok / frontier high |
| maverick | **`cursor-grok-4.5-high-fast`** | **Siempre** (early Discovery CONSULT + env-anomaly + post-Harvest) |
| VerifierLikeHuman | **`cursor-grok-4.5-high-fast`** | **Siempre**; T2/T3 user-facing tras tech PASS; sin edit / sin auto O2 |
| verifier (technical DoD) | **`cursor-grok-4.5-high-fast`** | **Siempre** — mechanical + judgment + cross-surface integration |
| lab-runner (**single spawn**) | **`cursor-grok-4.5-high-fast`** | One lab-runner in fase/Batch |
| lab-runner (**Lab Batch ≥2 parallel**) | **`composer-2.5-fast`** | Each parallel lab-runner |
| implementer / roles repetitivos | **`composer-2.5-fast`** | Refactors mecánicos, cambios quirúrgicos; large scope → split envelopes |
| explore / scout / skeptic / deletion | **`composer-2.5-fast`** | Nivel ligero |

ID ausente → remapear y anotar en `MODELS.local.md` / handoff de instalación.

### 2.1 Cadena correctiva (Composer → Verifier → Grok Fast)

Si el resultado Composer **no** satisface al orchestrator/verifier (o hay `## ESCALATE`):

1. Conservar handoff/delta.
2. Enriquecer el sobre con esa evidencia.
3. **Una** corrección/revisión con `cursor-grok-4.5-high-fast`.
4. No repetir Composer a ciegas ni sobrescribir sin evidencia.

### 2.2 Evidencia vs decisión (honestidad)

| Capa | Qué es |
|------|--------|
| **Medido (local)** | Smokes válidos de routing/direct Grok + catálogo autenticado de IDs — **no** ranking Grok-vs-Composer |
| **Externo** | CursorBench ~ Grok 4.5 High 66.7% vs Composer 2.5 56.1%; Cursor advierte posible ventaja por snapshot en entrenamiento (impacto incierto). **No** mide exactamente variantes Fast |
| **Decisión operativa** | Esta matriz / templates — elección del usuario + guardrails |
| **Inconclusos** | `20260805-164220-a1ac3e7f` (trust-block), `20260805-164654-d15e0bea` (nested telemetry), `20260805-170119-1cd75f23` (11/48 interrupted) — **no** usar para “ganador” |

Benchmark completo es **opcional** y no bloquea esta política. Ver [`bench/README.md`](bench/README.md).

## 3. Antigravity (**Host remap** — no Grok)

AGY does **not** expose Grok. **Never** put `grok-*` / “Grok” in AGY frontmatter or `define_subagent` model. Keep **maverick**, **verifier** (judgment tier), and **verifier-like-human** enabled.

| Rol | Preferencia | Notas |
|-----|-------------|-------|
| maverick | **`Host remap`:** `gemini-3.1-pro-high` | Documented AGY high-reasoning alias; CONSULT early + post-Harvest |
| VerifierLikeHuman | **`Host remap`:** `gemini-3.1-pro-high` | Same tier as maverick; after tech PASS; no edit |
| verifier (judgment tier) | **`Host remap`:** `gemini-3.1-pro-high` | Cross-surface / integration checks |
| implementer | `pro` → prefer `gemini-3.1-pro-high` | workers |
| lab-runner (Lab Batch) | flash-high (3.5/3.6) or cheaper flash | parallel labs |
| lab-runner (single) | **`Host remap`:** `gemini-3.1-pro-high` | One hypothesis — high-reasoning, not flash |
| scout / explore | flash-high | — |
| orchestrator | Pro / default UI | Debe respetar zero-exec + gates |

Validate with `agy models` / UI. If `gemini-3.1-pro-high` missing → nearest documented Pro/high-reasoning ID; still label **`Host remap`**, never “Grok”.

## 4. OpenCode

| Agent | Preferencia | Alternativa / Host remap |
|-------|-------------|--------------------------|
| maverick, verifier, verifier-like-human | `opencode-go/grok-4.5` when catalog exposes Grok | **`Host remap`:** nearest high-reasoning (e.g. `opencode/nemotron-3-ultra-free`) — do not call it Grok |
| executor, lab (batch), expert | `opencode/nemotron-3-ultra-free` | `opencode-go/grok-4.5` when useful for single lab |
| scout, explore | `opencode/north-mini-code-free` | — |
| skeptic | `opencode/mimo-v2.5-free` | — |
| orchestrator | picker TUI + **edit/bash deny** | — |

**No** writers en flash free ya degradado en el org. Prose: **Grok Fast when exposed** for Mav/Ver/VLH; else **Host remap**.

## 5. Codex

IDs OpenAI de la cuenta. Same **roles** (incl. VerifierLikeHuman). Prefer Grok-equivalent high-fast when the account exposes it for Mav/Ver/VLH; else **`Host remap`** to best high-reasoning OpenAI ID — never invent Gemini/OpenCode IDs or label non-Grok as Grok.

## 6. Checklist instalador

```text
[ ] Listé modelos en cada CLI del host
[ ] Remapeé templates donde el ID no existía
[ ] Orchestrator Cursor = cursor-grok-4.5-high (no inherit)
[ ] Maverick/VLH/Verifier Cursor = cursor-grok-4.5-high-fast when exposed
[ ] Lab single-spawn Cursor = cursor-grok-4.5-high-fast; Lab Batch ≥2 = composer-2.5-fast each
[ ] Maverick/VLH/Verifier AGY = Host remap gemini-3.1-pro-high (never labeled Grok)
[ ] OpenCode/Codex: Grok when exposed for Mav/Ver/VLH; else Host remap high-reasoning
[ ] Writers ≠ flash free fallido
[ ] Maverick / VLH / Verifier techo ≥ implementer; roles not disabled on AGY
[ ] Orchestrator configurado para no ser el writer (deny o disciplina)
[ ] MODELS.local.md opcional con IDs finales
```
