# Runtime — installable templates

Assets copiados por `tooling/scripts/Install-Orchestrator.ps1` (y WSL). **Copiar, no regenerar de memoria.**

## Mapa origen → destino

| Pack (`runtime/`) | Destino en repo |
|-------------------|-----------------|
| `cursor/agents/*.md` | `.cursor/agents/` |
| `cursor/rules/*.mdc` | `.cursor/rules/` |
| `antigravity/agents/<role>/agent.md` | `.agents/agents/<role>/` |
| `antigravity/rules/*.md` | `.agents/rules/` |
| `skills/orchestrator/SKILL.md`, `reference.md`, `reference.wsl.md` | `.agents/skills/orchestrator/` |
| `project/AGENTS.md` | `<repo>/AGENTS.md` (merge) |
| `project/lab/README.md` | `.lab/README.md` |
| `GEMINI.md` | `GEMINI.md` (merge) |
| `opencode/*.example` | `opencode.json(c)` |
| `codex/config.toml.example`, `codex/agents/*.toml` | `.codex/` |
| `lock/orchestrator-lock.json.example` | `.orchestrator-lock.json` (oleada B) |

## Archivado (no instalar)

- [`archive/reference.cj-linux.md`](archive/reference.cj-linux.md) — referencia histórica CJ-linux

## Instalación

```powershell
.\tooling\scripts\Install-Orchestrator.ps1              # tooling/sandbox/pilot
.\tooling\scripts\Install-Orchestrator.ps1 -RefreshSandbox
.\tooling\scripts\Install-Orchestrator.ps1 -Scope Project -TargetPath C:\path\to\repo
```

Guías por IDE: [`docs/human/install/`](../docs/human/install/).
