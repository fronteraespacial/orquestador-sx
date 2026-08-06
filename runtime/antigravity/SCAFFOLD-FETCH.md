# Agent-native scaffold — FETCH/COPY (Antigravity Desktop)

**PROHIBIDO** generar o inventar contenido de metodología. Materializá el árbol canónico desde fuente real.

## Orden de fuente

1. **Pack local:** si el workspace contiene `runtime/` del pack → copiá cada `source` del [scaffold-manifest.json](scaffold-manifest.json).
2. **GitHub raw:** si no hay pack local → fetch por `rawPath` usando `rawBase` del manifest:
   - `rawBase`: `https://raw.githubusercontent.com/fronteraespacial/orquestador-sx/v1.3.4`
   - `rawBaseFallback`: `.../main` si el tag falla o aún no está publicado
   - URL por archivo: `{rawBase}/{rawPath}` (ej. `.../v1.3.4/runtime/skills/orchestrator/SKILL.md`)
3. **Sin red:** pedí path a clone local o zip verificado (`SHA256SUMS`).

## Checklist tras materializar

| Step | Action |
|------|--------|
| Lock | Escribir `.orchestrator-lock.json` (`enabled: true`, `source: agent-native`, `version` del pack fetched) |
| Files | Todos los `paths[]` con `required: true` presentes |
| Integrity | Leer SKILL.md — debe contener **todos** los `integrityMarkers`: `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent` |
| Fail | Si SKILL es corto/inventado → **borrar** `.agents/` fake + lock, re-fetch o STOP |
| Merge | `GEMINI.md` merge (nunca overwrite reglas humanas) |
| Register | `define_subagent` por rol (plantillas en [reference.antigravity.md](../skills/orchestrator/reference.antigravity.md)) |
| Human | Recordar Always On: `cj-orchestrator-bootstrap` + `spacex-orchestrator` |

## Raw URL examples (v1.3.4 pin)

```
https://raw.githubusercontent.com/fronteraespacial/orquestador-sx/v1.3.4/runtime/skills/orchestrator/SKILL.md
https://raw.githubusercontent.com/fronteraespacial/orquestador-sx/v1.3.4/runtime/antigravity/agents/explore/agent.md
https://raw.githubusercontent.com/fronteraespacial/orquestador-sx/v1.3.4/runtime/antigravity/rules/spacex-orchestrator.md
```

Fallback si tag no responde: reemplazá `v1.3.4` por `main` (`rawBaseFallback` en manifest).

CLI `Orchestrator.ps1 init -Scope project` sigue siendo Path B (opcional).
