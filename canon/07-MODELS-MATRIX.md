# 07 — Matriz de modelos

Los IDs cambian. **Siempre** listar modelos vivos en el host antes de fijar frontmatter.

**Política Cursor (decisión operativa del usuario):** parent = `cursor-grok-4.5-high`; complejidad/anomalía/maverick/correctiva = `cursor-grok-4.5-high-fast`; claro/repetitivo/ligero = `composer-2.5-fast`; verifier mecánico = `composer-2.5-fast`, verifier juicio / mismo writer Composer = `cursor-grok-4.5-high-fast`. **No** hay conclusión local de superioridad Grok-vs-Composer; ver [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md).

## 1. Principios

| Rol | Criterio | Evitar |
|-----|----------|--------|
| **Orchestrator** | Routing, gates, oleadas, freno; prefer heavy | Modelo que ignore REQUIRED o “codee T0”; `inherit` inestable en CLI |
| explore / scout | Rápido, tool-use, barato | Writer pesado |
| maverick | Creativo + razonamiento; techo alto | Flash que solo parafrasea |
| implementer / executor | Código fiable en paths+DoD claros | Flash free ya marcado unreliable |
| lab-runner | Clear → fast; complex/anomaly → Grok Fast | Forzar Grok en todo lab simple |
| verifier | Sigue DoD; no inventa PASS; mecánico → Composer Fast, juicio / mismo writer → Grok Fast | El más barato del catálogo para todo |
| skeptic | Adversarial | Mismo modelo que implementer (sesgo) |

El Orquestador **no necesita** modelo “con tools de edición”; necesita disciplina de delegación. Skills **no** cambian el modelo — solo config nativa / Task `model:`.

## 2. Cursor

**Regla dura Composer:** ID canónico **`composer-2.5-fast`**. **Nunca** `composer-2.5` sin `-fast` en routing operativo (frontmatter / Task `model:`).

`agent --list-models` o UI. Estado versionado: [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md).

| Rol | Default pack | Notas |
|-----|--------------|-------|
| orchestrator (sesión) | **`cursor-grok-4.5-high`** | Verificado en template; **no** `inherit`. Fallback: nearest non-Fast Grok / frontier high |
| maverick | **`cursor-grok-4.5-high-fast`** | Siempre |
| lab-runner (claro) | **`composer-2.5-fast`** | Frontmatter default |
| lab-runner (T2/T3, ambiguo, anomalía env) | Task **`cursor-grok-4.5-high-fast`** | WSL/Docker/proxy/entorno; también post-verifier débil / ESCALATE |
| implementer / roles repetitivos | **`composer-2.5-fast`** | Refactors mecánicos, cambios quirúrgicos con paths+DoD |
| explore / scout / skeptic / deletion | **`composer-2.5-fast`** | Nivel ligero |
| verifier (DoD mecánico) | **`composer-2.5-fast`** | Scripts, exit codes, lock/hash, existencia de archivos |
| verifier (DoD juicio / mismo writer Composer) | Task **`cursor-grok-4.5-high-fast`** | Docs install/update, claridad de prompt, security/methodology; evitar Composer-verifica-Composer en diseño |

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

## 3. Antigravity

| Rol | Preferencia | Notas |
|-----|-------------|-------|
| maverick | `gemini-3.1-pro-high` | ID concreto |
| implementer / lab / verifier | flash-high (3.5/3.6) | workers |
| scout / explore | flash-high | — |
| orchestrator | Pro / default UI | Debe respetar zero-exec + gates |

## 4. OpenCode

| Agent | Preferencia | Alternativa |
|-------|-------------|-------------|
| executor, lab, verifier, maverick, expert | `opencode/nemotron-3-ultra-free` | `opencode-go/grok-4.5` |
| scout, explore | `opencode/north-mini-code-free` | — |
| skeptic | `opencode/mimo-v2.5-free` | — |
| orchestrator | picker TUI + **edit/bash deny** | — |

**No** writers en flash free ya degradado en el org.

## 5. Codex

IDs OpenAI de la cuenta. Mismo mapeo de **roles**; no copiar IDs Gemini/OpenCode.

## 6. Checklist instalador

```text
[ ] Listé modelos en cada CLI del host
[ ] Remapeé templates donde el ID no existía
[ ] Orchestrator Cursor = cursor-grok-4.5-high (no inherit)
[ ] Maverick = cursor-grok-4.5-high-fast; lab condicional documentado
[ ] Writers ≠ flash free fallido
[ ] Maverick techo ≥ implementer
[ ] Orchestrator configurado para no ser el writer (deny o disciplina)
[ ] MODELS.local.md opcional con IDs finales
```
