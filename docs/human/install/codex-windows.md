# 06 — Instalar en Codex (Windows)

**Estado:** templates **activos** cuando el host Codex está presente. Ready = ChatGPT Codex **Desktop** (Store/Appx) **o** CLI embebido en `%LOCALAPPDATA%\OpenAI\Codex\bin\**\codex.exe` **o** `codex` en PATH **o** `%USERPROFILE%\.codex` existente — **no** solo PATH.

Docs oficiales: [Subagents](https://developers.openai.com/codex/subagents), [Config reference](https://developers.openai.com/codex/config-reference), [Models Sol/Terra/Luna](https://developers.openai.com/codex/models).

## 1. Paths

| Pieza | Path |
|-------|------|
| User agents | `%USERPROFILE%\.codex\agents\` |
| Project agents | `<repo>\.codex\agents\` |
| Config | `%USERPROFILE%\.codex\config.toml` y/o `<repo>\.codex\config.toml` |
| Skill (metodología) | `<repo>\.agents\skills\orchestrator\` (SoT) — **no** sustituir por `~\.codex\skills` |
| Pack runtime | `runtime/codex/config.toml.example`, `runtime/codex/agents/*.toml` |
| Embedded CLI | `%LOCALAPPDATA%\OpenAI\Codex\bin\<hash>\codex.exe` |

## 2. Modelos + esfuerzo (Host remap GPT-5.6)

IDs: `gpt-5.6-sol` | `gpt-5.6-terra` | `gpt-5.6-luna`. Effort: `minimal`/`low`/`medium`/`high`/`xhigh` (UI ES: Mínimo / Medio / Alto / Muy alta).

| Rol | Model | Effort |
|-----|-------|--------|
| Parent (picker) | `gpt-5.6-terra` | `medium` (T3/fuzzy → `high`) — evitar `xhigh` default para routing |
| `[agents]` defaults | `gpt-5.6-luna` | `medium` |
| explore / scout | `gpt-5.6-luna` | `medium` (T0 → `low`) |
| executor_fast / Lab Batch ≥2 | `gpt-5.6-luna` | `high` |
| lab single | `gpt-5.6-terra` | `high` |
| maverick / verifier / VLH | `gpt-5.6-terra` | `high` (Sol+`high` solo post-ESCALATE) |

Orch puede **bump una vez** (+1 effort o Terra→Sol) en cascade/ESCALATE — no free-float. **Ultra ≠ org chart SpaceX.** Anclas CursorBench / matrix: `canon/07-MODELS-MATRIX.md` §5.

Caveat: algunos builds ignoran `reasoning_effort` del spawn hijo — smoke y anotar versión CLI.

## 3. Templates del pack

| Archivo | Rol | Sandbox |
|---------|-----|---------|
| `config.toml.example` → merge `config.toml` | `[agents]` defaults Luna | — |
| `agents/orchestrator.toml` | primary / zero-exec | `read-only` |
| `agents/explore.toml` | local RO | `read-only` |
| `agents/scout.toml` | contraste externo | `read-only` + `web_search = "live"` |
| `agents/maverick.toml` | consult / lab mav | `workspace-write` |
| `agents/lab.toml` | solo `.lab/<id>/` | `workspace-write` |
| `agents/executor_fast.toml` | implementer prod | `workspace-write` |
| `agents/verifier.toml` | tests DoD | `read-only` |
| `agents/verifier_like_human.toml` | VLH post tech PASS | `read-only` |

Cada TOML fija `model` + `model_reasoning_effort` (no placeholders). Contrato gates en `developer_instructions` + skill del repo.

### `[agents]` (schema oficial)

```toml
[agents]
max_concurrent_threads_per_session = 4
default_subagent_model = "gpt-5.6-luna"
default_subagent_reasoning_effort = "medium"
```

(`max_threads` = alias legacy. **No** usar `max_depth` — no está en el schema oficial.)

### Discovery / YIELD_PLAN / VLH

- Discovery ⊂ `research-lab` → `DECIDE` | `YIELD_PLAN` | `STOP`.
- **YIELD_PLAN:** humano abre Codex **`/plan`** → aprobación explícita → `executor_fast`. Decline → STOP.
- Cadena: writer → `verifier` → `verifier_like_human` (T2/T3 human-facing tras PASS).
- Harvest parent-only → Maverick CONSULT → `YIELD_OPT` (humano).

## 4. Pasos de install

1. Detectar host (Desktop / embedded / PATH / `~\.codex`).
2. Backup de `%USERPROFILE%\.codex\` si existe.
3. Instalar skill + resto del pack en el **repo** (`Install-Orchestrator.ps1 -Scope Project -TargetPath <repo>`).
4. Añadir Codex: `-IncludeCodex` — copia `agents/*.toml`; **merge** claves `[agents]` en `config.toml` existente (**no** pisa `mcp_servers`, `plugins`, `notify`, `[desktop]`, `[windows]`).
5. Confirmar modelos en el picker Desktop (Sol/Terra/Luna).
6. Asegurar `.lab/README.md` en el repo.
7. Smoke (abajo).

```powershell
.\tooling\scripts\Install-Orchestrator.ps1 -Scope Project -TargetPath C:\path\to\repo -IncludeCodex
# User scope (global agents + merge config) — requiere -ConfirmUserScope:
.\tooling\scripts\Install-Orchestrator.ps1 -Scope User -ConfirmUserScope -IncludeCodex
```

## 5. Smoke (humano en Desktop)

1. Abrir el repo en Codex Desktop; parent **Terra + Medio**.
2. Forzar spawn `explore` → debe verse **Luna** (default o pin TOML).
3. Confirmar sandbox RO en orch / explore / verifier.
4. Si el effort del hijo ≠ pin → anotar `codex --version` / build y re-spawn; documentar en handoff.

## 6. Limitaciones

- Spawn Codex = config + prompt, no Cursor Task hard roles.
- No activar Ultra como sustituto de roles nombrados.
- WSL `~/.codex` no comparte Desktop nativo salvo sync / `CODEX_HOME`.
- Después de install: load skill desde el repo (`.agents/skills/orchestrator`).
