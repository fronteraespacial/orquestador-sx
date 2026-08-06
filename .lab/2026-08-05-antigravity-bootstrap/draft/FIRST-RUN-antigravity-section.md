# FIRST-RUN.md — delta: Antigravity subsection (post-APPROVE)

Insert as **new subsection** after Paso 2 (init) or expand Paso 4:

---

## Antigravity (Windows / cross-platform)

Antigravity carga metodología **solo desde el repo** — no desde user-scope init.

1. **Init project** (mismo repo que usarás en AGY):

   ```powershell
   .\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
   ```

2. **Abrí ese repo** como workspace en Antigravity (no playground suelto).

3. **Customizations → Rules → Always On** para:
   - `.agents/rules/cj-orchestrator-bootstrap.md`
   - `.agents/rules/spacex-orchestrator.md`
   - `.agents/rules/cj-criollo-changelog.md`

4. **Smoke:** preguntá “¿qué reglas de orquestador están activas?” — debe mencionar lock, skill, zero-exec.

Guía detallada: [`docs/human/install/antigravity-windows.md`](install/antigravity-windows.md).

**User-scope init no alcanza** para Antigravity (solo instala skill global; sin agents/rules/GEMINI en home).

---
