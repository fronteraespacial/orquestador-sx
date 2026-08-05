# Team share — copy/paste

Texto listo para Slack o mail al compartir el orchestrator con el equipo.

---

**Asunto:** SpaceX Orchestrator v1.1.0 — instalación en 5 min

Hola,

Compartimos la metodología **SpaceX Orchestrator** (subagentes T0–T3, `.lab`, gates) para Cursor / Antigravity / OpenCode.

**Repo:** https://github.com/fronteraespacial/spacex-orchestrator  
**Guía rápida:** ver `docs/human/FIRST-RUN.md` en el release o pack.

### Qué hace

- Instala agents, rules y skill de orquestación en tu repo (o sandbox de prueba).
- Escribe `.orchestrator-lock.json` para saber qué versión tenés y si está activo.
- **No** pisa archivos existentes salvo que pidas refresh/update explícito.

### Instalación (Windows)

```powershell
# Desde el pack descargado
.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target C:\tu\repo
.\tooling\scripts\Orchestrator.ps1 status -TargetPath C:\tu\repo
```

Para probar sin tocar tu repo: `--target .\tooling\sandbox\pilot`

### Requisitos

- Cursor (recomendado para empezar)
- `gh auth login` solo si vas a usar `update --check` / `--apply` desde GitHub releases

### Importante

- Los **agentes en chat no instalan ni actualizan solos** — vos corrés `Orchestrator init` / `update --apply`.
- Opt-out: `"enabled": false` en el lock o `Orchestrator uninstall`.

Cualquier duda: `docs/human/TEAM-ONBOARDING.md` o el canal #dev-tools.

---
