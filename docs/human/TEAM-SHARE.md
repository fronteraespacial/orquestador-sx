# Team share — copy/paste

Un bloque para Slack o mail: link + pegar al agente + frases install/update.

---

## Bloque para Slack / mail

**Asunto:** Orquestador SX v1.2.0 — instalación multi-OS (~5 min)

Hola,

Metodología **Orquestador SX** (subagentes T0–T3, `.lab`, gates) para Cursor / Antigravity / OpenCode en **Windows, Linux y macOS**.

| Recurso | Enlace |
|--------|--------|
| **Repositorio** | https://github.com/fronteraespacial/orquestador-sx |
| **Guía first run** | https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md |
| **Prompt install (agente)** | https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/agent/DEVICE-INSTALL-PROMPT.md |
| **Release v1.2.0** | https://github.com/fronteraespacial/orquestador-sx/releases/tag/v1.2.0 |

Descargá **`orquestador-sx-v1.2.0.zip`** y verificá SHA256:

```text
e2656ffde8dcccfb53164021de1fc671ea93b4238ef537e653c90a7562339aec  orquestador-sx-v1.2.0.zip
```

Repo **público discreto** (link-only).

### Pegá esto a tu agente (install)

```text
Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx
```

(O el bloque completo de DEVICE-INSTALL-PROMPT en el repo.)

### Pegá esto para actualizar metodología

```text
Actualizá la metodología orquestadora desde GitHub
```

### Qué hace

- Instala agents, rules y skill en tu repo (o sandbox de prueba), incluida **`.cursor/rules/cj-criollo-changelog.mdc`** (bloque `## En criollo` obligatorio en cierres técnicos).
- Escribe `.orchestrator-lock.json`.
- **No** pisa archivos existentes salvo update explícito.

### Prerrequisitos

- **Cursor** (recomendado).
- **PowerShell** (Windows) o **bash** (Linux / macOS / WSL).
- **`gh`** opcional — releases públicos sin auth.

### Comandos rápidos — Windows

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot
.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot
```

### Comandos rápidos — Linux / macOS / WSL

```bash
./tooling/scripts/orchestrator.sh init --scope project --source local --target ./tooling/sandbox/pilot --yes
./tooling/scripts/orchestrator.sh status --target ./tooling/sandbox/pilot
```

### Importante

- Sin frase/link canónico, el agente **ofrece** init pero no instala solo.
- Opt-out: `"enabled": false` o `Orchestrator uninstall`.

Más: `docs/human/TEAM-ONBOARDING.md` o FIRST-RUN.

---
