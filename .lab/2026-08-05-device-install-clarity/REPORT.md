# REPORT — Device install clarity

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05

## Cold-agent simulation

**Input:** frase canónica + instrucción sandbox (equivalente a `DEVICE-INSTALL-PROMPT-draft.md`).

**Entorno:** Windows 10, pack local (post-clone simulado).

| Criterio | Resultado |
|----------|-----------|
| Script correcto por OS | PASS — `Orchestrator.ps1` |
| Sin curl\|bash / PAT | PASS |
| Path confirmado (sandbox pilot) | PASS |
| WhatIf preview | PASS |
| init + status coherente | PASS — lock 1.1.1, skill present, manifest OK |

## Comandos ejecutados

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot -WhatIf
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
```

## Falsifiers

| ID | Triggered? |
|----|------------|
| F1 curl\|bash | No |
| F2 wrong entrypoint | No |
| F3 no project path | No (sandbox explícito) |
| F4 status fail | No |
| F5 refuse scripts | No |

## macOS checklist (manual, post-prod)

- [ ] `./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot --whatif`
- [ ] `shasum -a 256` path en verify SHA256SUMS
- [ ] `~/.cursor`, `~/.agents` en user scope

## Next

Implementer copia prompt a `docs/agent/DEVICE-INSTALL-PROMPT.md` y aplica política multi-OS v1.2.0.
