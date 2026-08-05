# Sandbox piloto

Destino **por defecto** del instalador (`scripts/Install-Orchestrator.ps1` sin parámetros).

## Propósito

- Probar la metodología SpaceX Orchestrator sin modificar `%USERPROFILE%` ni repos de producción.
- Ejecutar el smoke de [`09-VERIFY-CHECKLIST.md`](../09-VERIFY-CHECKLIST.md) sección C.
- Destino seguro para experimentos de `.lab/` (nunca usar `projects/.lab/` operativo en el pack fuente).

## Uso

```powershell
# Regenerar desde templates corregidos (`.lab/` canónico)
..\scripts\Install-Orchestrator.ps1 -RefreshSandbox

# Validar instalación
..\scripts\Validate-OrchestratorPack.ps1 -TargetPath .
```

Abrir esta carpeta como workspace en Cursor tras instalar.

## Contenido esperado post-instalación

```text
.cursor/agents/{explore,scout,maverick,implementer,lab-runner,verifier,orchestrator,skeptic,deletion}.md
.cursor/rules/cj-orchestrator-mandatory.mdc
.agents/agents/<role>/agent.md  (+ skeptic, deletion)
.agents/rules/spacex-orchestrator.md
.agents/skills/orchestrator/{SKILL,reference,reference.wsl}.md
AGENTS.md
.lab/README.md
GEMINI.md
opencode.json + opencode.jsonc
.install-manifest.json
```

## Notas

- Los archivos existentes **no se sobrescriben**; re-ejecutar el instalador es idempotente.
- Eliminar `.install-backup/` cuando ya no necesites revertir.
- Para promover a un repo real: `Install-Orchestrator.ps1 -Scope Project -TargetPath <repo>`.
