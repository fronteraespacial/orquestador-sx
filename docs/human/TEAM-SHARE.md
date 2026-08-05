# Team share — copy/paste

Texto listo para Slack o mail al compartir el orchestrator con el equipo.

---

## Bloque para Slack / mail

**Asunto:** SpaceX Orchestrator v1.1.0 — instalación en ~5 min

Hola,

Compartimos la metodología **SpaceX Orchestrator** (subagentes T0–T3, `.lab`, gates) para Cursor / Antigravity / OpenCode.

| Recurso | Enlace |
|--------|--------|
| **Repositorio** | https://github.com/fronteraespacial/spacex-orchestrator |
| **Guía first run** | https://github.com/fronteraespacial/spacex-orchestrator/blob/main/docs/human/FIRST-RUN.md |
| **Release v1.1.0** | https://github.com/fronteraespacial/spacex-orchestrator/releases/tag/v1.1.0 |

Descargá **`spacex-orchestrator-v1.1.0.zip`** desde el release y verificá el digest SHA256:

```text
6266226d32380a3be9691373c2f7bed52f9a0a086fb0ee1fc9f00dbd1df91f6d  spacex-orchestrator-v1.1.0.zip
```

### Qué hace

- Instala agents, rules y skill de orquestación en tu repo (o sandbox de prueba).
- Escribe `.orchestrator-lock.json` para saber qué versión tenés y si está activo.
- **No** pisa archivos existentes salvo que pidas refresh/update explícito.

### Prerrequisitos

- **Cursor** (recomendado para empezar).
- **PowerShell 5.1+** (Windows) o **bash** (WSL/Linux).
- Repo **privado**: necesitás acceso al org/repo `fronteraespacial` (el maintainer te invita).
- **GitHub CLI** (`gh`) autenticado con acceso a la org **`fronteraespacial`** (clonar, releases y `update --check` / `--apply`):

```powershell
gh auth login
gh auth status
```

### Tres comandos — Windows (desde la raíz del pack)

Prueba segura en sandbox (no toca tu repo de producto):

```powershell
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 update --check -TargetPath .\tooling\sandbox\pilot
```

Para tu repo real, cambiá `--target` / `-TargetPath` por la ruta de tu proyecto (ver FIRST-RUN).

### Tres comandos — WSL (desde la raíz del pack)

```bash
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot
./tooling/scripts/orchestrator.sh status --target ./tooling/sandbox/pilot
./tooling/scripts/orchestrator.sh update --check --target ./tooling/sandbox/pilot
```

### Importante

- Los **agentes en chat no instalan ni actualizan solos** — vos corrés `Orchestrator init` / `update --apply`.
- Opt-out: `"enabled": false` en el lock o `Orchestrator uninstall`.

Cualquier duda: `docs/human/TEAM-ONBOARDING.md` en el pack o el canal #dev-tools.

---
