# Start here

Punto de entrada post-factorización v1.1.0.

## Humanos

1. [`../README.md`](../README.md) — mapa del pack
2. [`../docs/human/FIRST-RUN.md`](../docs/human/FIRST-RUN.md) — **5 min** primera instalación
3. [`../docs/human/TEAM-ONBOARDING.md`](../docs/human/TEAM-ONBOARDING.md) — primer día
4. Validar → init → status → checklist canon 09

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
```

## Agentes (LLM)

1. [`../AGENTS.md`](../AGENTS.md) — entry root
2. [`../docs/agent/AGENT-BOOTSTRAP-PROMPT.md`](../docs/agent/AGENT-BOOTSTRAP-PROMPT.md) — prompt autocontenido
3. [`../docs/agent/CONTEXT-MAP.md`](../docs/agent/CONTEXT-MAP.md) — qué cargar / omitir
3. Canon en orden: [`../canon/00-README-INSTALL-AGENT.md`](../canon/00-README-INSTALL-AGENT.md) … [`../canon/09-VERIFY-CHECKLIST.md`](../canon/09-VERIFY-CHECKLIST.md)

## Canon index

| Doc | Tema |
|-----|------|
| [`canon/00-README-INSTALL-AGENT.md`](../canon/00-README-INSTALL-AGENT.md) | Instalación agente |
| [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md) | Metodología T0–T3 |
| [`canon/02-ROLES-HANDOFFS-GATES.md`](../canon/02-ROLES-HANDOFFS-GATES.md) | Roles y gates |
| [`canon/07-MODELS-MATRIX.md`](../canon/07-MODELS-MATRIX.md) | Matriz de modelos |
| [`canon/09-VERIFY-CHECKLIST.md`](../canon/09-VERIFY-CHECKLIST.md) | Verificación |

Instalación por IDE: [`docs/human/install/`](../docs/human/install/).

**Repo canónico:** [github.com/fronteraespacial/spacex-orchestrator](https://github.com/fronteraespacial/spacex-orchestrator)
