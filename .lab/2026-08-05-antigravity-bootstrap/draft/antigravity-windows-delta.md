# antigravity-windows.md — delta (post-APPROVE)

## 0. Prerrequisito — init project (recomendado)

Desde el pack (o PATH con `Orchestrator.ps1`):

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
```

Verifica: `.orchestrator-lock.json`, `.agents/rules/`, `GEMINI.md`, `AGENTS.md`.

**Abrí ese repo en Antigravity** antes del primer chat de trabajo.

## 2. Pasos (actualizar numeración)

Add after step 2 (copy rules):

2b. Copiar `runtime/antigravity/rules/cj-orchestrator-bootstrap.md` → `.agents/rules/`.
2c. Copiar `runtime/antigravity/rules/cj-criollo-changelog.md` → `.agents/rules/`.

Add new step after copy:

9. **Antigravity UI:** Customizations → Rules → set **Always On** for:
    - `cj-orchestrator-bootstrap.md`
    - `spacex-orchestrator.md`
    - `cj-criollo-changelog.md`

## 6. Smoke (añadir)

0. Sin repo init / playground → metodología **no** debe aparecer (expected).
1. Con repo init + Always On → header T0–T3 + zero-exec en primera respuesta de trabajo real.

---
