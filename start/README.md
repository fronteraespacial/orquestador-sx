# Start here

Punto de entrada post-factorización v1.2.0 — **multi-OS agent pack**.

## Humanos

1. [`../README.md`](../README.md) — mapa del pack
2. [`../docs/human/FIRST-RUN.md`](../docs/human/FIRST-RUN.md) — **5 min** primera instalación (Win / Linux / macOS)
3. [`../docs/human/TEAM-SHARE.md`](../docs/human/TEAM-SHARE.md) — bloque copy/paste para el equipo
4. Validar → init → status → checklist canon 09

**Install vía agente:** pegar `Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx` o [`DEVICE-INSTALL-PROMPT.md`](../docs/agent/DEVICE-INSTALL-PROMPT.md).

```powershell
# Windows
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
```

```bash
# Linux / macOS / WSL
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot --yes
./tooling/scripts/orchestrator.sh status --target ./tooling/sandbox/pilot
```

## Agentes (LLM)

1. [`../AGENTS.md`](../AGENTS.md) — entry root
2. **Install dispositivo:** [`../docs/agent/DEVICE-INSTALL-PROMPT.md`](../docs/agent/DEVICE-INSTALL-PROMPT.md)
3. **Orquestar repo:** [`../docs/agent/AGENT-BOOTSTRAP-PROMPT.md`](../docs/agent/AGENT-BOOTSTRAP-PROMPT.md)
4. **Update:** [`../docs/agent/UPDATE-PHRASE.md`](../docs/agent/UPDATE-PHRASE.md)
5. [`../docs/agent/CONTEXT-MAP.md`](../docs/agent/CONTEXT-MAP.md)
6. Canon: [`../canon/00-README-INSTALL-AGENT.md`](../canon/00-README-INSTALL-AGENT.md) … [`../canon/09-VERIFY-CHECKLIST.md`](../canon/09-VERIFY-CHECKLIST.md)

## Canon index

| Doc | Tema |
|-----|------|
| [`canon/00-README-INSTALL-AGENT.md`](../canon/00-README-INSTALL-AGENT.md) | Instalación agente multi-OS |
| [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md) | Metodología T0–T3 |
| [`canon/02-ROLES-HANDOFFS-GATES.md`](../canon/02-ROLES-HANDOFFS-GATES.md) | Roles y gates |
| [`canon/07-MODELS-MATRIX.md`](../canon/07-MODELS-MATRIX.md) | Matriz de modelos |
| [`canon/09-VERIFY-CHECKLIST.md`](../canon/09-VERIFY-CHECKLIST.md) | Verificación |

Instalación por IDE: [`docs/human/install/`](../docs/human/install/).

**Repo canónico:** [github.com/fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx)
