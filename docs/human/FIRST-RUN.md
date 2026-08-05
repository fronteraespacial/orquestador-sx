# First run (5 minutes) — multi-OS

Guía humana para la primera instalación del **Orquestador SX** v1.2.0 en **Windows, Linux o macOS**.

**Repositorio canónico:** [github.com/fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx)

**Guía canónica (este doc en GitHub):** [github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md](https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md)

**Release estable (v1.2.0):** [github.com/fronteraespacial/orquestador-sx/releases/tag/v1.2.0](https://github.com/fronteraespacial/orquestador-sx/releases/tag/v1.2.0)

Descargar **`orquestador-sx-v1.2.0.zip`** desde el release y verificar:

```text
PLACEHOLDER_SHA256  orquestador-sx-v1.2.0.zip
```

Alternativa sin `gh`: clonar el repo o descargar el zip del release desde el navegador — no requiere autenticación.

## Instalación vía agente (recomendado)

Pegá esto a tu agente en Cursor (o IDE con terminal):

```text
Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx
```

O el prompt completo: [`docs/agent/DEVICE-INSTALL-PROMPT.md`](../agent/DEVICE-INSTALL-PROMPT.md).

El agente **sí puede** ejecutar los scripts documentados del pack (clone/local + init + status). Sin esa frase/link, solo te ofrece los comandos — no instala solo.

## Prerrequisitos

| SO | Shell | Notas |
|----|-------|-------|
| Windows | PowerShell 5.1+ | `Orchestrator.ps1` |
| Linux / WSL | bash 3.2+ | `orchestrator.sh` |
| macOS | bash 3.2+ (system) | `orchestrator.sh`; SHA via `shasum -a 256` |

- **Cursor** (o IDE destino) instalado.
- **GitHub CLI** (`gh`) — **opcional**. Releases públicos se descargan por HTTPS sin auth.

## Paso 1 — Validar el pack (opcional)

Desde la raíz del pack descargado o clonado:

**Windows:**

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
```

**Linux / macOS / WSL:**

```bash
./tooling/scripts/validate-orchestrator-pack.sh --strict
```

## Paso 2 — Init en tu repo

### Windows

**Sandbox (prueba segura):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
```

**Proyecto real:**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
```

**User scope (global Cursor + skill):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope user -Source local -ConfirmUserScope
```

Preview: `-WhatIf`

### Linux / macOS / WSL

**Sandbox:**

```bash
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot --yes
```

**Proyecto real:**

```bash
./tooling/scripts/orchestrator.sh init --scope project --source local --target /path/to/your-repo --yes
```

Preview: `--whatif`

Wrapper opcional: `./tooling/scripts/orchestrator init …` (detecta OS en Git Bash).

## Paso 3 — Status

**Windows:**

```powershell
.\tooling\scripts\Orchestrator.ps1 status -TargetPath C:\path\to\your-repo
```

**Unix:**

```bash
./tooling/scripts/orchestrator.sh status --target /path/to/your-repo
```

Debe mostrar `.orchestrator-lock.json`, manifiesto y skill presente si `enabled: true`.

## Paso 4 — Metodología + orquestación

1. [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md)
2. Regla bootstrap + skill `.agents/skills/orchestrator/SKILL.md`
3. Sesiones profundas: `@cj-orchestrator-mandatory`

**Agentes LLM (repo ya instalado):** [`AGENT-BOOTSTRAP-PROMPT.md`](../agent/AGENT-BOOTSTRAP-PROMPT.md)

## Paso 5 — Updates

Frase canónica al agente:

```text
Actualizá la metodología orquestadora desde GitHub
```

Ver [`UPDATE-PHRASE.md`](../agent/UPDATE-PHRASE.md). La CLI verifica `SHA256SUMS` (HTTPS o `gh`).

```powershell
# Windows
.\tooling\scripts\Orchestrator.ps1 update -Check -TargetPath C:\path\to\your-repo
.\tooling\scripts\Orchestrator.ps1 update -Apply -TargetPath C:\path\to\your-repo
```

```bash
# Unix
./tooling/scripts/orchestrator.sh update --check --target /path/to/your-repo
./tooling/scripts/orchestrator.sh update --apply --target /path/to/your-repo
```

## Opt-out

`"enabled": false` en el lock, o:

```powershell
.\tooling\scripts\Orchestrator.ps1 uninstall -Scope project -TargetPath C:\path\to\your-repo
```

## Siguiente

- Equipo: [`TEAM-SHARE.md`](TEAM-SHARE.md)
- Maintainer: [`../maintainer/RELEASE.md`](../maintainer/RELEASE.md)
