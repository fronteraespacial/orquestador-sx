# 06 — Instalar en Codex (Windows)

**Estado en este host/pack: deferred.** Codex **no** está instalado localmente (`codex` ausente del PATH). Este pack entrega templates TOML reales para cuando el binario exista; no actives la integración hasta detectarlo.

Docs / schema: agentes en `.codex/agents/*.toml` con `name`, `description`, `developer_instructions`, más campos `ConfigToml` (p. ej. `sandbox_mode`, `web_search`). Verificar siempre contra la versión instalada (`codex --help` / docs).

## 1. Paths

| Pieza | Path |
|-------|------|
| User agents | `%USERPROFILE%\.codex\agents\` |
| Project agents | `<repo>\.codex\agents\` |
| Config | `%USERPROFILE%\.codex\config.toml` (u equivalente actual) |
| Pack runtime | `runtime/codex/config.toml.example`, `runtime/codex/agents/*.toml` |

## 2. Templates del pack (ya no son stubs conceptuales)

Copiar desde `runtime/codex/`:

| Archivo | Rol | Sandbox típico |
|---------|-----|----------------|
| `config.toml.example` → `config.toml` | `[agents] max_threads` / `max_depth` | — |
| `agents/orchestrator.toml` | primary / zero ejecución directa | `read-only` |
| `agents/explore.toml` | local read-only | `read-only` |
| `agents/scout.toml` | contraste externo | `read-only` + `web_search = "live"` |
| `agents/maverick.toml` | consult / lab mav | `workspace-write` |
| `agents/lab.toml` | solo `.lab/<id>/` | `workspace-write` |
| `agents/executor_fast.toml` | implementer prod | `workspace-write` |
| `agents/verifier.toml` | tests DoD | `read-only` |
| `agents/verifier_like_human.toml` | VLH post tech PASS | `read-only` |

Cada TOML incluye:

- `name`, `description`, `developer_instructions` (requeridos en roles descubiertos)
- `sandbox_mode` read-only donde aplica (orchestrator, explore, scout, verifier, verifier_like_human)
- `# model = "<remap-after-codex>"` como **placeholder** — **no inventar** IDs; fijar tras listar modelos en el host
- **Maverick / Verifier / VLH:** Grok high-fast when host exposes; else **Host remap** high-reasoning — never label remap Grok
- **lab:** single lab → high-reasoning remap; Lab Batch (≥2) → cheaper/fast ID
- Verifier gap inventory → parent one O2 pass; handoffs ≤40 on output only

Contrato embebido en `developer_instructions`:

- Orquestador sin ejecución directa
- Sala canónica **`.lab/`** (no `projects/.lab/`)
- Gates: WorkType; Discovery→YIELD_PLAN; scout soft; lab greenfield REQUIRED; maverick env-anomaly T2+; verifier post-writer → VLH si gated; Harvest→Maverick CONSULT; ESCALATE@2

### 1.3.1 — Discovery / YIELD_PLAN / VLH (Codex)

- **WorkType** + Discovery ⊂ `research-lab` (budget acotado) → `DECIDE` | `YIELD_PLAN` | `STOP`.
- **YIELD_PLAN:** orch pide al humano abrir Codex **`/plan`** → aprobación **explícita** de ejecución → recién ahí `executor_fast`. Decline → STOP. Sin auto-entrar Plan ni auto-ejecutar. ≠ lab `YIELD`.
- Cadena: writer → `verifier` → `verifier_like_human` (T2/T3 human-facing tras PASS técnico).
- **Harvest** parent-only → Maverick CONSULT → `YIELD_OPT` (humano; sin auto-O2).

### Límites `[agents]` actuales

En `runtime/codex/config.toml.example`:

```toml
[agents]
max_threads = 4
max_depth = 2
```

Ajustar tras instalar Codex; confirmar nombres de clave en la docs de esa versión. Los roles se descubren desde `.codex/agents/*.toml`; el example deja comentarios para `config_file` opcional.

## 3. Pasos (cuando `codex` exista)

1. Detectar `codex` en PATH. Si no → dejar **deferred** y seguir con otros CLIs (caso actual).
2. Backup de `%USERPROFILE%\.codex\` si existe.
3. Crear directorios agents; copiar TOML del pack.
4. Merge `config.toml.example` → config del usuario (conservar MCP/secrets existentes; este pack **no** incluye secretos).
5. Remapear `model` solo con IDs confirmados en el host.
6. Asegurar `.lab/README.md` en el repo objetivo.
7. Smoke T1: tarea que fuerce scout o verifier según capabilities de esa build.

## 4. Limitaciones

- No asumir spawn/Task idéntico a Cursor u OpenCode; seguir el mecanismo de multi-agent de la build instalada.
- Si la versión no soporta multi-agent nativo: una sesión “orchestrator” con roles simulados vía prompts es peor; preferir upgrade.
- Modelos OpenAI / reasoning effort: ver `07-MODELS-MATRIX.md` como orientación; IDs finales = host.
- **No** activar ni fingir instalación local mientras Codex esté deferred.
