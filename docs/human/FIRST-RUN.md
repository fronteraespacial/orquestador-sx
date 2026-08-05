# First run (5 minutes)

Guía humana para la primera instalación del **Orquestador SX** v1.1.0.

**Repositorio canónico:** [github.com/fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx)

**Guía canónica (este doc en GitHub):** [github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md](https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md)

**Release estable (v1.1.0):** [github.com/fronteraespacial/orquestador-sx/releases/tag/v1.1.0](https://github.com/fronteraespacial/orquestador-sx/releases/tag/v1.1.0)

Descargar `spacex-orchestrator-v1.1.0.zip` (nombre histórico del asset) desde el release y verificar:

```text
6266226d32380a3be9691373c2f7bed52f9a0a086fb0ee1fc9f00dbd1df91f6d  spacex-orchestrator-v1.1.0.zip
```

Alternativa sin `gh`: clonar el repo o descargar el zip del release desde el navegador — no requiere autenticación.

## Prerrequisitos

1. **Cursor** (o IDE destino) instalado.
2. **PowerShell 5.1+** (Windows) o **bash** (WSL/Linux).
3. **GitHub CLI** (`gh`) — **opcional**. Solo hace falta para `update --check` / `update --apply` desde la CLI; los releases públicos se descargan sin auth:

   ```powershell
   gh auth login   # opcional
   ```

## Paso 1 — Validar el pack (opcional)

Desde la raíz del pack descargado o clonado:

```powershell
.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
```

## Paso 2 — Init en tu repo

**Sandbox (prueba segura, sin tocar tu home):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
```

**Proyecto real:**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
```

**User scope (global Cursor + skill; requiere confirmación):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope user -Source local -ConfirmUserScope
```

Preview sin cambios:

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot -WhatIf
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
# Comprobar release (máx. 1 vez / 24h; requiere gh si usás CLI)
.\tooling\scripts\Orchestrator.ps1 update -Check -TargetPath C:\path\to\your-repo

# Aplicar (verifica SHA256SUMS, backup, reinstall)
.\tooling\scripts\Orchestrator.ps1 update -Apply -TargetPath C:\path\to\your-repo
```

## Opt-out

Editar `.orchestrator-lock.json` → `"enabled": false`, o:

```powershell
.\tooling\scripts\Orchestrator.ps1 uninstall -Scope project -TargetPath C:\path\to\your-repo
```

## Siguiente

- Equipo: [`TEAM-SHARE.md`](TEAM-SHARE.md) · onboarding [`TEAM-ONBOARDING.md`](TEAM-ONBOARDING.md)
- Maintainer release: [`../maintainer/RELEASE.md`](../maintainer/RELEASE.md)
