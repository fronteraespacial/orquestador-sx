# Team share — copy/paste

Texto listo para Slack o mail al compartir el orchestrator con el equipo.

---

## Bloque para Slack / mail

**Asunto:** Orquestador SX v1.1.1 — instalación en ~5 min

Hola,

Compartimos la metodología **Orquestador SX** (subagentes T0–T3, `.lab`, gates) para Cursor / Antigravity / OpenCode.

| Recurso | Enlace |
|--------|--------|
| **Repositorio** | https://github.com/fronteraespacial/orquestador-sx |
| **Guía first run** | https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md |
| **Release v1.1.1** | https://github.com/fronteraespacial/orquestador-sx/releases/tag/v1.1.1 |

Descargá **`orquestador-sx-v1.1.1.zip`** desde el release (v1.1.0: `spacex-orchestrator-v1.1.0.zip`) y verificá el digest SHA256:

```text
876fe30736b25bb4c4829c9e657b0951f11121de6785d263a382901309d0e393  orquestador-sx-v1.1.1.zip
```

Repo **público discreto** (link-only): compartir solo con quien lo necesite; no promocionar en redes.

### Qué hace

- Instala agents, rules y skill de orquestación en tu repo (o sandbox de prueba).
- Escribe `.orchestrator-lock.json` para saber qué versión tenés y si está activo.
- **No** pisa archivos existentes salvo que pidas refresh/update explícito.

### Prerrequisitos

- **Cursor** (recomendado para empezar).
- **PowerShell 5.1+** (Windows) o **bash** (WSL/Linux).
- **GitHub CLI** (`gh`) — **opcional** (solo para `update --check` / `--apply`). Clone o zip del release **sin auth**:

```powershell
gh auth login   # opcional
gh auth status  # opcional
```

### Tres comandos — Windows (desde la raíz del pack)

Prueba segura en sandbox (no toca tu repo de producto):

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 update -Check -TargetPath .\tooling\sandbox\pilot
```

Para tu repo real, cambiá `-TargetPath` por la ruta de tu proyecto (ver FIRST-RUN).

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
