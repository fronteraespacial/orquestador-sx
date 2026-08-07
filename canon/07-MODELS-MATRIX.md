# 07 — Matriz de modelos

Los IDs cambian. **Siempre** listar modelos vivos en el host antes de fijar frontmatter.

**Política Cursor (decisión operativa del usuario):** parent / orchestrator = **humano** (model picker) o host **Auto** (más capaz disponible); templates del pack **omit** `model:` en orchestrator — gana el modelo de sesión; pin local opcional solo en `MODELS.local.md`. Hijos: Maverick / verifier / VLH / lab single-spawn = `cursor-grok-4.5-high-fast`; Lab Batch ≥2 parallel labs → each lab-runner `composer-2.5-fast`; demás hijos (implementer, explore, scout, skeptic, deletion) = `composer-2.5-fast`. Large Composer scope → más sobres acotados del **mismo rol**, no mega-pipeline. **No** hay conclusión local de superioridad Grok-vs-Composer; ver [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md).

**Maverick + VerifierLikeHuman + Verifier (cross-host):** use **Grok 4.5 High Fast** wherever the host exposes it. If the host has **no** Grok (e.g. Antigravity), apply an explicit **`Host remap`** to the best documented high-reasoning host model — **never** label that remap “Grok”. Roles stay enabled.

## 1. Principios

| Rol | Criterio | Evitar |
|-----|----------|--------|
| **Orchestrator** | Routing, gates, oleadas, freno; sesión = humano / Auto | Modelo que ignore REQUIRED o “codee T0”; pin pack-forzado en template |
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
| orchestrator (sesión) | **Sin pin en template** — humano / Auto | Pack **omite** `model:`; sesión gana. Pin local opcional → `MODELS.local.md` only. Nested orch opcional → ver §2.2 / MODEL-ROUTING |
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

### 2.2 Nested orchestrator (opcional — NOT default)

**Default:** sesión parent carga SKILL y spawnea hijos **directo** (sin nest).

**Opcional depth-1** — solo si humano pide, sesión thin/cheap en T2/T3 multi-gate vago, o outer ya violó protocolo una vez: `Task(orchestrator, model: cursor-grok-4.5-high-fast)` (Task-resolvable; AGY **Host remap:** `gemini-3.1-pro-high`). Outer = thin launcher; nested owns classify/spawn/Ledger/Harvest; **no** re-nest; **no** monolito. Triggers: [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md) · lab `.lab/2026-08-06-nested-orch-vs-direct/`.

### 2.3 Evidencia vs decisión (honestidad)

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

## 5. Codex (Desktop + CLI — Host remap GPT-5.6)

Same **roles** (incl. VerifierLikeHuman). ChatGPT Codex Desktop, CLI, and IDE extension share `%USERPROFILE%\.codex` (+ project `.codex/`). Ready when Desktop/Store app **or** embedded CLI **or** `codex` on PATH — not PATH-only.

**IDs (do not invent):** `gpt-5.6-sol` | `gpt-5.6-terra` | `gpt-5.6-luna`. Effort: `minimal` | `low` | `medium` | `high` | `xhigh` (UI ES: Mínimo / Medio / Alto / Muy alta). **Ultra/Max ≠ effort pin** — Ultra is free-form subagent fan-out; **never** use Ultra as SpaceX org chart.

| Role | Model | `model_reasoning_effort` | Notes |
|------|-------|--------------------------|-------|
| Parent orchestrator (session) | `gpt-5.6-terra` | `medium` (T3/fuzzy → `high`) | Picker/UI; avoid default `xhigh` for routing-only |
| `[agents]` child defaults | `gpt-5.6-luna` | `medium` | `default_subagent_model` / `default_subagent_reasoning_effort` |
| explore / scout | `gpt-5.6-luna` | `medium` (T0 inventory → `low`) | Cheap RO |
| executor_fast / Lab Batch ≥2 | `gpt-5.6-luna` | `high` | CursorBench Luna High ≈ Composer 2.5 band, lower $ |
| lab (single hyp) | `gpt-5.6-terra` | `high` | Spawn override; never Luna for single lab |
| maverick / verifier / VLH | `gpt-5.6-terra` | `high` | Judgment tier; Sol+`high` only post-ESCALATE |
| diagnostic synthesizer | `gpt-5.6-terra` | `high` | Same judgment tier |

**Orch effort/model bump:** at most **+1** effort step **or** Terra→Sol on cascade/ESCALATE — not free-float every turn. Pin in `.codex/agents/*.toml`; spawn may pass `reasoning_effort` / `model`. Some builds ignore child effort overrides — smoke and document.

**CursorBench 3.2 anchors (cost/quality guidance, not DoD):** Luna High ~56.8% @ ~$0.16; Luna Extra High ~57.7% @ ~$0.23; Terra High ~54.2% @ ~$0.71; Terra Extra High ~59.2% @ ~$1.15. Prefer Luna High workers over Terra `xhigh` parent for routine routing.

Detail: [`docs/agent/MODEL-ROUTING-POLICY.md`](../docs/agent/MODEL-ROUTING-POLICY.md) §5.1 Codex + [`docs/human/install/codex-windows.md`](../docs/human/install/codex-windows.md).

## 6. Checklist instalador

```text
[ ] Listé modelos en cada CLI del host
[ ] Remapeé templates donde el ID no existía
[ ] Orchestrator Cursor: template **sin** `model:` — sesión humano/Auto gana; pin local opcional → MODELS.local.md
[ ] Maverick/VLH/Verifier Cursor = cursor-grok-4.5-high-fast when exposed
[ ] Lab single-spawn Cursor = cursor-grok-4.5-high-fast; Lab Batch ≥2 = composer-2.5-fast each
[ ] Maverick/VLH/Verifier AGY = Host remap gemini-3.1-pro-high (never labeled Grok)
[ ] OpenCode: Grok when exposed for Mav/Ver/VLH; else Host remap high-reasoning
[ ] Codex: Desktop/embedded CLI detected; agents TOML pin Sol/Terra/Luna + effort; `[agents]` Luna defaults; Ultra not used as org chart
[ ] Codex judgment (mav/ver/VLH/lab-single) = terra+high (not luna); workers = luna+high/medium
[ ] Writers ≠ flash free fallido
[ ] Maverick / VLH / Verifier techo ≥ implementer; roles not disabled on AGY
[ ] Orchestrator configurado para no ser el writer (deny o disciplina)
[ ] MODELS.local.md opcional con IDs finales
```
