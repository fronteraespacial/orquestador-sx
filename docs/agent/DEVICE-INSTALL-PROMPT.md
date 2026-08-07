# DEVICE-INSTALL-PROMPT

Prompt autocontenido para pegar a un agente en un **dispositivo nuevo**. No requiere transcript previo ni skill instalada.

**Repo canónico:** [fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx)

**Guía humana equivalente:** [FIRST-RUN.md](../human/FIRST-RUN.md)

---

## Prompt (copiar desde aquí)

```markdown
Instalá **orquestador-sx** en este dispositivo siguiendo el repo canónico:
https://github.com/fronteraespacial/orquestador-sx

## Tu rol

Sos un agente de **instalación** (no orquestador de tareas). Podés ejecutar los scripts documentados del pack cuando el humano te pide instalar vía link o frase canónica.

## Pasos obligatorios

1. **Detectar OS**
   - Windows → `tooling/scripts/Orchestrator.ps1`
   - Linux / macOS / WSL → `tooling/scripts/orchestrator.sh` (o wrapper `tooling/scripts/orchestrator`)
   - No uses `curl | bash`. No embebas PAT ni tokens.

2. **Obtener el pack**
   - Si ya estás en la raíz del repo clonado, usá `--source local` / `-Source local`.
   - Si no hay clone: cloná el repo público **o** descargá el zip del [último release](https://github.com/fronteraespacial/orquestador-sx/releases/latest) + verificá `SHA256SUMS` antes de extraer.

3. **Preguntar al humano**
   - ¿Instalación **user** (global Cursor/skills) o **project** (un repo)?
   - Si project: pedí la ruta absoluta del repo destino.
   - Para prueba segura: sandbox del pack `tooling/sandbox/pilot`.

4. **Init**
   - Preview primero (`-WhatIf` / `--whatif`).
   - Luego init real:
     - Windows: `.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath <path>`
     - Unix: `./tooling/scripts/orchestrator.sh init --scope project --source local --target <path> --yes`
   - User scope requiere confirmación explícita (`-ConfirmUserScope` / `--confirm-user-scope`).

5. **Status (sin red)**
   - Windows: `.\tooling\scripts\Orchestrator.ps1 status -TargetPath <path>`
   - Unix: `./tooling/scripts/orchestrator.sh status --target <path>`
   - Informá: versión lock, `enabled`, skill presente, manifiesto.

6. **Informe final**
   - OS detectado, scripts usados, paths escritos, versión del lock, próximo paso (metodología `canon/01`, frase de update).

## Prohibiciones

- No modificar otros repos sin path confirmado.
- No secrets en chat ni en scripts.
- No `update --apply` sin confirmación corta del humano.
- No orquestar trabajo de producto — solo instalar el pack.

## Frase alternativa (equivalente)

`Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx`

---

## Prompt Codex Desktop (copiar desde aquí)

Pegar en **ChatGPT Codex** (Desktop) con el repo destino abierto o indicando la ruta. Apunta a **[releases/latest](https://github.com/fronteraespacial/orquestador-sx/releases/latest)** (v1.3.5+ Codex Desktop-first).

```markdown
Instalá **orquestador-sx** (latest) en este Windows para **ChatGPT Codex**, desde:
https://github.com/fronteraespacial/orquestador-sx/releases/latest

## Tu rol
Agente de instalación (no orquestador de producto). Ejecutá solo scripts documentados del pack.

## Contexto host
- App Codex Desktop / Store `OpenAI.Codex` y/o CLI embebido en `%LOCALAPPDATA%\OpenAI\Codex\bin\**\codex.exe` cuentan como ready (no hace falta `codex` en PATH).
- Config viva: `%USERPROFILE%\.codex\config.toml` — **merge** `[agents]`, nunca overwrite ciego (conservar mcp/plugins/notify/desktop).

## Pasos
1. Obtener pack: cloná `fronteraespacial/orquestador-sx` en tag/latest **o** descargá el zip de releases/latest + verificá `SHA256SUMS`.
2. Preguntame la ruta absoluta del **repo proyecto** destino (o confirmá el workspace actual).
3. Preview: `.\tooling\scripts\Install-Orchestrator.ps1 -Scope Project -TargetPath <repo> -IncludeCodex -WhatIf`
4. Install real:
   `.\tooling\scripts\Install-Orchestrator.ps1 -Scope Project -TargetPath <repo> -IncludeCodex`
   (opcional global: `-Scope User -ConfirmUserScope -IncludeCodex` — solo agents + merge config.)
5. Asegurá skill en el repo: `.agents/skills/orchestrator/SKILL.md` (init project si falta lock).
6. Status / informe: versión lock, `.codex/agents/*.toml` presentes, `[agents]` Luna defaults, próximo smoke (parent Terra Medio → spawn explore → Luna).

## Modelos (Host remap)
Parent: `gpt-5.6-terra` + medium. Children default: `gpt-5.6-luna`. Judgment (mav/ver/VLH/lab-single): terra+high. Ultra ≠ org chart.

## Prohibiciones
No secrets. No `curl | bash`. No pisar `~\.codex\config.toml` entero. No orquestar features — solo instalar.
```

**Frase corta Codex:**

`Instalá orquestador-sx latest con Codex (-IncludeCodex) desde https://github.com/fronteraespacial/orquestador-sx/releases/latest`
```

---

## Tabla de entrypoints

| SO | Script |
|----|--------|
| Windows | `tooling/scripts/Orchestrator.ps1` |
| Linux / macOS / WSL | `tooling/scripts/orchestrator.sh` |
| Unix wrapper | `tooling/scripts/orchestrator` |

## Validado en lab

Ver `.lab/2026-08-05-device-install-clarity/REPORT.md` (APPROVE).
