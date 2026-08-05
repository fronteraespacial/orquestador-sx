# SpaceX Orchestrator — LLM entry (pack root)

**Versión:** leer [`VERSION`](VERSION). **Changelog:** [`CHANGELOG.md`](CHANGELOG.md).

## Qué leer primero

1. [`start/README.md`](start/README.md) — bootstrap humano/agente
2. [`canon/00-README-INSTALL-AGENT.md`](canon/00-README-INSTALL-AGENT.md) → [`canon/01-METHODOLOGY-SPACEX.md`](canon/01-METHODOLOGY-SPACEX.md)
3. [`docs/agent/CONTEXT-MAP.md`](docs/agent/CONTEXT-MAP.md) — presupuestos de tokens / qué no cargar
4. Skill canónica (post-install): `.agents/skills/orchestrator/SKILL.md`
5. Entrypoint Cursor (post-install): `.cursor/agents/orchestrator.md`

## Árbol v1.2.1

| Ruta | Rol |
|------|-----|
| [`canon/`](canon/) | Metodología 00–09 (canónico) |
| [`runtime/`](runtime/) | Templates instalables |
| [`tooling/`](tooling/) | Scripts, bench, sandbox piloto |
| [`docs/human/`](docs/human/) | Onboarding e instalación por IDE |
| [`docs/agent/`](docs/agent/) | Handoff, routing, DEVICE-INSTALL, UPDATE-PHRASE |
| [`docs/maintainer/`](docs/maintainer/) | Distribución y release |

## No tocar (artefactos regenerables)

- `tooling/bench/worktrees/` — worktrees efímeros del benchmark
- `tooling/bench/results/` — JSONL de corridas (evidencia; no editar para “arreglar” el pack)
- `tooling/sandbox/pilot/.install-backup/` — backups del instalador
- `.lab/` en repos destino — solo bajo envelope APPROVE

## Comandos

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
.\tooling\scripts\Install-Orchestrator.ps1
```

Los stubs en root (`00–09`, `templates/`, `scripts/`) redirigen al canónico v1.2.1.

**Install vía agente:** [`docs/agent/DEVICE-INSTALL-PROMPT.md`](docs/agent/DEVICE-INSTALL-PROMPT.md) · **Update:** [`docs/agent/UPDATE-PHRASE.md`](docs/agent/UPDATE-PHRASE.md)
