# First run (5 minutes)

Guía humana para la primera instalación del **SpaceX Orchestrator** v1.1.0.

**Repositorio canónico:** [github.com/fronteraespacial/spacex-orchestrator](https://github.com/fronteraespacial/spacex-orchestrator)

**Release estable (v1.1.0):** [github.com/fronteraespacial/spacex-orchestrator/releases/tag/v1.1.0](https://github.com/fronteraespacial/spacex-orchestrator/releases/tag/v1.1.0)

Descargar spacex-orchestrator-v1.1.0.zip y verificar:

`	ext
6266226d32380a3be9691373c2f7bed52f9a0a086fb0ee1fc9f00dbd1df91f6d  spacex-orchestrator-v1.1.0.zip
`

## Prerrequisitos

1. **Cursor** (o IDE destino) instalado.
2. **PowerShell 5.1+** (Windows) o **bash** (WSL/Linux).
3. Para updates desde GitHub: **GitHub CLI** (`gh`) con acceso a la org `fronteraespacial`:
   ```powershell
   gh auth login
   ```

## Paso 1 — Validar el pack (opcional)

Desde la raíz del pack descargado o clonado:

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
```

## Paso 2 — Init en tu repo

**Sandbox (prueba segura, sin tocar tu home):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot
```

**Proyecto real:**

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target C:\path\to\your-repo
```

**User scope (global Cursor + skill; requiere confirmación):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope user --source local -ConfirmUserScope
```

Preview sin cambios:

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot -WhatIf
```

WSL:

```bash
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot --whatif
```

## Paso 3 — Status

```powershell
.\tooling\scripts\Orchestrator.ps1 status -TargetPath C:\path\to\your-repo
```

Debe mostrar `.orchestrator-lock.json`, manifiesto de instalación y skill presente si `enabled: true`.

## Paso 4 — Leer metodología + activar orquestación

1. [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md) — T0–T3 y oleadas.
2. En Cursor: regla bootstrap (`cj-orchestrator-bootstrap`, auto) + skill `.agents/skills/orchestrator/SKILL.md`.
3. Para sesiones profundas: `@cj-orchestrator-mandatory` o entrypoint `.cursor/agents/orchestrator.md`.

**Agentes LLM:** pegar el prompt de [`docs/agent/AGENT-BOOTSTRAP-PROMPT.md`](../docs/agent/AGENT-BOOTSTRAP-PROMPT.md) al iniciar una sesión orquestada.

## Paso 5 — Updates (consentimiento explícito)

Los agentes **no** descargan ni aplican updates solos.

```powershell
# Comprobar release (máx. 1 vez / 24h)
.\tooling\scripts\Orchestrator.ps1 update --check -TargetPath C:\path\to\your-repo

# Aplicar (verifica SHA256SUMS, backup, reinstall)
.\tooling\scripts\Orchestrator.ps1 update --apply -TargetPath C:\path\to\your-repo
```

## Opt-out

Editar `.orchestrator-lock.json` → `"enabled": false`, o:

```powershell
.\tooling\scripts\Orchestrator.ps1 uninstall --scope project --target C:\path\to\your-repo
```

## Siguiente

- Equipo: [`TEAM-SHARE.md`](TEAM-SHARE.md) · onboarding [`TEAM-ONBOARDING.md`](TEAM-ONBOARDING.md)
- Maintainer release: [`../maintainer/RELEASE.md`](../maintainer/RELEASE.md)
