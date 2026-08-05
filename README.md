# SpaceX Orchestrator — Windows Pack

**Versión:** `1.1.0` ([`VERSION`](VERSION)) · **Changelog:** [`CHANGELOG.md`](CHANGELOG.md)

Pack distribuible de la metodología **Orquestador SpaceX + subagentes** para Windows (Cursor, Antigravity, OpenCode, Codex). Instalación segura, validación automatizada y benchmark reproducible.

**Entry LLM:** [`AGENTS.md`](AGENTS.md) · **Bootstrap:** [`start/README.md`](start/README.md) · **First run:** [`docs/human/FIRST-RUN.md`](docs/human/FIRST-RUN.md)

**Repo canónico:** [github.com/fronteraespacial/spacex-orchestrator](https://github.com/fronteraespacial/spacex-orchestrator)

## Árbol v1.1.0

| Ruta | Contenido |
|------|-----------|
| [`canon/`](canon/) | Metodología 00–09 (canónico) |
| [`runtime/`](runtime/) | Templates instalables |
| [`tooling/scripts/`](tooling/scripts/) | Instaladores y validadores |
| [`tooling/bench/`](tooling/bench/) | Benchmark Cursor opcional |
| [`tooling/sandbox/pilot/`](tooling/sandbox/pilot/) | Piloto por defecto |
| [`docs/human/`](docs/human/) | Onboarding e instalación por IDE |
| [`docs/agent/`](docs/agent/) | Handoff, routing, context map |

Stubs en root (`00–09`, `templates/`, `scripts/`, `bench/`, `sandbox/`) redirigen al canónico.

## Inicio rápido (5 minutos)

```powershell
# 1. Validar el pack (sin instalar)
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict

# 2. Init en sandbox piloto (lock + templates)
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot

# 3. Status (sin red)
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot

# 4. Preview init (sin cambios)
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot -WhatIf

# 5. Instalador legacy (sin lock) sigue disponible
.\tooling\scripts\Install-Orchestrator.ps1

# 6. User scope (solo paths globales; NO Antigravity agents bajo $HOME)
.\tooling\scripts\Orchestrator.ps1 init --scope user --source local -ConfirmUserScope
```

En WSL / Linux:

```bash
./tooling/scripts/validate-orchestrator-pack.sh --strict
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot
./tooling/scripts/orchestrator.sh status --target ./tooling/sandbox/pilot
```

## Modos de instalación (PowerShell)

| Modo | Switch | Destino | Riesgo |
|------|--------|---------|--------|
| **Sandbox** (default) | _(ninguno)_ | `tooling/sandbox/pilot/` | Bajo |
| **Refresh sandbox** | `-RefreshSandbox` | `tooling/sandbox/pilot/` | Bajo — backup + overwrite pack-owned |
| **Proyecto** | `-Scope Project -TargetPath <repo>` | Repo indicado | Medio |
| **Usuario** | `-Scope User -ConfirmUserScope` | `.cursor/`, skills, opencode global | Alto |

## Entrypoint orchestrator (Cursor)

`.cursor/agents/orchestrator.md` es el **entrypoint zero-direct-execution**: clasifica T0-T3, abre sobres y delega via Task sin editar ni ejecutar en el hilo padre.

## Validación

Comprueba árbol canónico v1.1.0 (`canon/`, `runtime/`, `tooling/`), frontmatter, gates, secretos.

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
.\tooling\scripts\Validate-OrchestratorPack.ps1 -TargetPath ".\tooling\sandbox\pilot" -Strict
```

## Política de modelos

- Parent/orchestrator → `cursor-grok-4.5-high`
- Maverick / lab complejo → `cursor-grok-4.5-high-fast`
- Lab claro + implementer → `composer-2.5-fast`

Detalle: [`docs/agent/MODEL-ROUTING-POLICY.md`](docs/agent/MODEL-ROUTING-POLICY.md) · matriz [`canon/07-MODELS-MATRIX.md`](canon/07-MODELS-MATRIX.md).

## Benchmark (opcional)

```powershell
.\tooling\bench\Run-Benchmark.ps1
.\tooling\bench\Run-Benchmark.ps1 -Run -Replicas 1 -CaseFilter direct-scout-contrast-grok
```

Ver [`tooling/bench/README.md`](tooling/bench/README.md).

## Documentación

| Documento | Propósito |
|-----------|-----------|
| [`docs/human/FIRST-RUN.md`](docs/human/FIRST-RUN.md) | Primera instalación (5 min) |
| [`docs/human/TEAM-ONBOARDING.md`](docs/human/TEAM-ONBOARDING.md) | Primer día |
| [`docs/agent/AGENT-BOOTSTRAP-PROMPT.md`](docs/agent/AGENT-BOOTSTRAP-PROMPT.md) | Prompt agente |
| [`docs/agent/AGENT-HANDOFF.md`](docs/agent/AGENT-HANDOFF.md) | Continuidad agente |
| [`docs/agent/CONTEXT-MAP.md`](docs/agent/CONTEXT-MAP.md) | Presupuesto tokens |
| [`docs/maintainer/RELEASE.md`](docs/maintainer/RELEASE.md) | Proceso release |
| [`SECURITY.md`](SECURITY.md) | Privacidad y alcance |
| [`NOTICE.md`](NOTICE.md) | No afiliación |

## Orden de lectura (agente instalador)

1. [`start/README.md`](start/README.md) → [`canon/00-README-INSTALL-AGENT.md`](canon/00-README-INSTALL-AGENT.md)
2. [`canon/01-METHODOLOGY-SPACEX.md`](canon/01-METHODOLOGY-SPACEX.md) … [`canon/09-VERIFY-CHECKLIST.md`](canon/09-VERIFY-CHECKLIST.md)
3. Validador → instalador sandbox → checklist 09

## Licencia y origen

Metodología derivada del flujo CJ-linux. Ver [`NOTICE.md`](NOTICE.md).
