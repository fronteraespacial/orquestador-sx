# antigravity-windows.md — delta (agent-native, post-APPROVE)

## 0. Prerrequisito — agent-native (recomendado Desktop)

**Path A — sin CLI (Antigravity Desktop):**

1. Una vez por máquina: `Orchestrator.ps1 init -Scope user -ConfirmUserScope` (merge `~/.gemini/GEMINI.md`).
2. Abrí el repo destino en Antigravity Desktop.
3. En chat de trabajo, el agente **pregunta** si preparar con Orquestador SX.
4. Si aceptás → el agente **crea** `.orchestrator-lock.json` y materializa skill/rules/agents (ver `scaffold-manifest` en pack docs).
5. Customizations → **Always On**: `cj-orchestrator-bootstrap`, `spacex-orchestrator`.

**Path B — CLI (opcional / avanzado / CI):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
```

Verifica: lock, `.agents/`, `GEMINI.md`.

## 1. Subagentes AGY 2.0

| Acción | API |
|--------|-----|
| Registrar rol | **`define_subagent`** (plantillas en SKILL § Antigravity 2.0 Desktop) |
| Delegar | **`invoke_subagent`** |
| **No usar** | Cursor `Task` |

Roles: `explore`, `scout`, `maverick`, `lab-runner`, `implementer`, `verifier`, `skeptic`, `deletion`.

## 2. Pasos (actualizar)

Reemplazar paso 1 “Init project CLI obligatorio” por Path A arriba.

Añadir paso post-scaffold:

- Confirmar agente llamó **`define_subagent`** para roles base (o agent.md materializados).
- Primera delegación de prueba: `invoke_subagent` → `explore` (readonly).

## 6. Smoke (añadir)

0. Playground sin repo → **sin** metodología (control negativo).
1. Repo sin lock → agente **pregunta** (no scaffold silencioso).
2. Tras «sí» → lock + `.agents/skills/orchestrator/SKILL.md` existen.
3. Trabajo real → header T0–T3 + `invoke_subagent` (no Task).
4. Cierre → `## En criollo` presente.

---
