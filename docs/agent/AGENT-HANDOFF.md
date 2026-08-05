# Agent handoff — SpaceX Orchestrator Windows Pack

Documento de continuidad para reanudar pruebas, instalación y orquestación sin repetir descubrimiento. **No** reemplaza `00–09` ni el plan de distribución.

## Meta

| Campo | Valor |
|-------|-------|
| Pack VERSION | **1.1.0** |
| Fecha handoff | 2026-08-05 |
| Orquestación test | roles explore×3, scout×1, implementer, verifier |

---

## Instalación real (evidencia)

### Windows user `C:\Users\Julian\` — INSTALLED

| Path | Notas |
|------|-------|
| `.cursor\agents` | 9 SpaceX + debug-context7 |
| `.cursor\rules\cj-orchestrator-bootstrap.mdc` | `alwaysApply: true` (micro-regla) |
| `.cursor\rules\cj-orchestrator-mandatory.mdc` | `alwaysApply: false` (manual) |
| `.agents\skills\orchestrator\` | SKILL.md, reference.md, reference.wsl.md |
| `.config\opencode` | opencode.jsonc |

### Windows user — NOT (by design)

- `.agents\agents\` — Antigravity = **project-only**
- `GEMINI.md` / `AGENTS.md` / `.lab` at user home — **not** in User scope

### Sandbox pilot

- Path: `pack\sandbox\pilot\` — full stack
- Manifest refreshed: **2026-08-05T20:26:00Z**

### Pack repo root

- **NOT** project-installed (no `pack\.cursor` / `pack\.agents` runtime)

### WSL `/home/julian` — SEPARATE host INSTALLED

- agents, rule, skill, opencode
- **No** `.agents/agents/` (Antigravity project-only)

---

## Cursor skill/rule policy (Q1)

- **Bootstrap rule** `cj-orchestrator-bootstrap` → `alwaysApply: true` — chequea `.orchestrator-lock.json`; no init/update desde chat.
- **Manual rule** `cj-orchestrator-mandatory` → `alwaysApply: false` — activar con `@` / picker / `AGENTS.md`.
- Skill user-level `~/.agents/skills/orchestrator` puede estar disponible vía discovery en IDE local Windows.
- WSL es host separado (ya instalado allí también) — **no** “automágico” cross-host.
- **Cloud Agents:** pack sin doc Cloud explícita; honestidad: assets globales user ayudan IDE local; cloud/CLI/remote pueden **NO** ver user-level agents/rules salvo project-scoped + invocación. Prefer project `.cursor/agents/` per [`03-INSTALL-CURSOR-WINDOWS.md`](../03-INSTALL-CURSOR-WINDOWS.md).

---

## Modelos Cursor (política pack local)

Defaults orquestador (remap si falta ID):

- **Grok High** — parent / orchestrator
- **Grok High Fast** — maverick, lab complejo, correctiva
- **Composer Fast** — explore, lab claro, implementer/roles ligeros

Ver [`docs/MODEL-ROUTING-POLICY.md`](MODEL-ROUTING-POLICY.md) y [`07-MODELS-MATRIX.md`](../07-MODELS-MATRIX.md).

---

## OpenCode modelos (Q2)

| Agente | Model ID | Por qué |
|--------|----------|---------|
| orchestrator | *(sin model — TUI picker)* | routing; edit/bash/web deny |
| sx-explore | `opencode/north-mini-code-free` | rápido tool-use barato |
| sx-scout | `opencode/north-mini-code-free` | ligero + web contrast |
| sx-executor | `opencode/nemotron-3-ultra-free` | writer prod |
| sx-lab | `opencode/nemotron-3-ultra-free` | writer `.lab` only |
| sx-maverick | `opencode/nemotron-3-ultra-free` | creativo ≥ implementer |
| sx-verifier | `opencode/nemotron-3-ultra-free` | DoD bash allow |
| sx-skeptic | `opencode/mimo-v2.5-free` | adversarial ≠ writer |
| sx-expert | `opencode/nemotron-3-ultra-free` | análisis pesado RO |

**REMAP:** ejecutar `opencode models` antes de instalar; Zen free IDs pueden cambiar; documentar en `MODELS.local.md`.

**Alt writers:** `opencode-go/grok-4.5`

---

## Codex (Q3) — evidencia 2026-08-05

| Canal | Estado | Evidencia |
|-------|--------|-----------|
| **A App ChatGPT** | **SÍ** | winget MS Store ChatGPT 26.715.4045.0; runtime `%LOCALAPPDATA%\OpenAI\Codex\` con codex.exe embebido (~350 MB); `%USERPROFILE%\.codex` |
| **B CLI PATH** | **NO** | `Get-Command` / `where codex` fallan Win+WSL; npm global vacío |
| **C Pack** | deferred correcto | [`06-INSTALL-CODEX-WINDOWS.md`](../06-INSTALL-CODEX-WINDOWS.md); **app unificada ≠ CLI en PATH** |

**Scout contrast:** fusión desktop 9 jul 2026 Chat/Work/Codex; CLI install aparte (`install.ps1` / npm); cloud aparte. Fuentes: learn.chatgpt.com whats-new, openai/codex github install.ps1, developers.openai.com/codex/cli.

**No activar `-IncludeCodex`** hasta `codex` en PATH.

---

## Cómo reanudar tests sin gastar cuota

1. Preferir `Validate-OrchestratorPack.ps1 -Strict` (smoke) — **NO** `-Run` benchmark largo.
2. **No** User `-Scope User` overwrite en pruebas.
3. Usar `sandbox/pilot` para smoke.
4. Modelos fast para explore/verifier.

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
```

---

## JSONL válidos vs inconclusos

| Tipo | Criterio | Acción |
|------|----------|--------|
| **INCONCLUSO** | handoffs/subagent JSONL con solo `user_query` y sin assistant final | relanzar / interrupt |
| **VÁLIDO** | summary + veredicto ≤40 líneas | usable para evidencia |

No usar JSONL inconclusos para ranking ni declarar ganador local.

---

## Activar en proyecto nuevo

1. `Install -Scope Project -TargetPath <repo>` (o copiar agents manualmente).
2. Invocar regla `@cj-orchestrator-mandatory` o `AGENTS.md`.
3. Skill: user discovery **o** project `.agents/skills/orchestrator`.
4. OpenCode: copiar template + `opencode models` remap.

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target C:\path\to\your-repo
```

---

## Pendientes honestos

- Codex CLI no en PATH pese a app unificada.
- Cloud Agents: límites no documentados formalmente en pack (esta nota es la honestidad).
- Pack root sin project install.
- IDs OpenCode Zen free requieren remap por host.
- Wave-1 inicial: 3 agentes hung → interrupt/relaunch (orquestación OK tras recover).

---

## Referencias

- [`docs/human/FIRST-RUN.md`](../human/FIRST-RUN.md) — 5 min humano
- [`docs/agent/AGENT-BOOTSTRAP-PROMPT.md`](AGENT-BOOTSTRAP-PROMPT.md) — prompt agente
- [`03-INSTALL-CURSOR-WINDOWS.md`](../03-INSTALL-CURSOR-WINDOWS.md) — Cursor project scope
- [`06-INSTALL-CODEX-WINDOWS.md`](../06-INSTALL-CODEX-WINDOWS.md) — Codex deferred
- [`docs/MODEL-ROUTING-POLICY.md`](MODEL-ROUTING-POLICY.md) — política modelos
