# 04 — Instalar en Antigravity (Windows)

Antigravity carga subagentes desde `.agents/agents/` con frontmatter `subagent: true` y se invocan vía **`invoke_subagent`**.

**Reglas:** `.agents/rules/cj-orchestrator-bootstrap.md` (lock/skill/En criollo) + `.agents/rules/spacex-orchestrator.md` (orquestación). **`GEMINI.md`** en repo root = capa de compatibilidad para builds que solo leen root rules.

**Global Desktop:** `%USERPROFILE%\.gemini\GEMINI.md` — bloque `<!-- spacex-orchestrator-sx BEGIN/END -->` instalado con **`init -Scope user -ConfirmUserScope`**. Chats nuevos preguntan si preparar el proyecto; playground sin repo ignora el bloque.

## 1. Paths Windows

| Pieza | Path |
|-------|------|
| **Global GEMINI (Desktop)** | `%USERPROFILE%\.gemini\GEMINI.md` (merge user init) |
| **Bootstrap rule (Always On)** | `<repo>\.agents\rules\cj-orchestrator-bootstrap.md` |
| **Workspace rule (Always On)** | `<repo>\.agents\rules\spacex-orchestrator.md` |
| Agents | `<repo>\.agents\agents\<role>\agent.md` |
| Skill | `<repo>\.agents\skills\orchestrator\SKILL.md` |
| Root rules (compat) | `<repo>\GEMINI.md` |
| Lock | `<repo>\.orchestrator-lock.json` |
| Lab | `<repo>\.lab\` (**única ruta operativa**; no usar `projects/.lab/`) |

Roles carpeta: `explore`, `scout`, `maverick`, `implementer`, `lab-runner`, `verifier` (6 base) + opcionales `skeptic`, `deletion`.

## 2. Pasos (orden correcto)

0. **Init user** (una vez por máquina — recomendado antes de Antigravity):

   ```powershell
   .\tooling\scripts\Orchestrator.ps1 init -Scope user -Source local -ConfirmUserScope
   ```

   Merge conservador en `~/.gemini/GEMINI.md`. Si ya tenés reglas propias, solo se añade/reemplaza el bloque marcado.

1. **Init project** en el repo destino:

   ```powershell
   .\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
   ```

2. **Abrí ese repo** en Antigravity: File → Open Folder → carpeta con `.orchestrator-lock.json` (no un chat suelto ni solo el pack sin init).

3. **Customizations → Always On:** marcá **`cj-orchestrator-bootstrap`** y **`spacex-orchestrator`** (refuerzo en repo; opcional si global GEMINI + init user ya activos).

4. Confirmá lock + skill (`Orchestrator.ps1 status -TargetPath …`).

5. Crear `\.lab\` en la raíz si no existe. **No** usar `projects/.lab/` como path operativo.

6. Copia manual (solo si no usás init): `runtime/antigravity/rules/*` → `.agents/rules/`; agents; skill; `GEMINI.md` (**merge** si ya existe).

7. Ajustar modelos en frontmatter: `agy models` (o UI). Aliases `flash` / `pro` → preferir IDs concretos (`gemini-3.6-flash-high`, `gemini-3.1-pro-high`).

8. Confirmar Orquestador de sesión **zero direct execution** en hilo principal (rules + GEMINI).

9. Documentar cleanup: al terminar loop, **matar subagentes idle** (UI / `manage_subagents` si existe).

## 3. Contenido crítico (no omitir)

En `.agents/rules/cj-orchestrator-bootstrap.md`, `.agents/rules/spacex-orchestrator.md` y GEMINI (compat):

- **Lock/bootstrap:** chequear `.orchestrator-lock.json`; offer init; load skill when OK
- **En criollo REQUIRED** en handoffs/close-out (3–6 frases prácticas)
- Header `## Complexity` / Role / Action Delegate (T0 incluido)
- **Zero direct execution** en hilo principal
- Routing table (6 base + skeptic/deletion opcionales)
- **Hard gates:** Lab greenfield REQUIRED (`.lab/` en raíz), Maverick env-anomaly REQUIRED, Verifier close-gate, ESCALATE→scout
- **Best-effort:** Scout soft, T3 auditors optional, Scout fan-out waves
- Lifecycle cleanup; naming `YYYY-MM-DD-mav-<slug>`
- Separación explícita **hard rules** vs **best-effort**

## 4. Cómo delega

```text
invoke_subagent → role name matching folder / description
Model parameter: flash | gemini-3.1-pro-high | … (aliases remapeables)
```

Handoffs ≤40 líneas (igual que 02).

## 5. Caveats

- Si el modelo trata SKILL.md como “docs opcionales”, **`.agents/rules/` + GEMINI`** deben repetir gates hard.
- No uses paths CJ-linux en prompts Windows.
- Maverick: ID concreto (`gemini-3.1-pro-high`), no solo alias `pro`.
- GEMINI solo = OK en builds viejos; ideal instalar **ambos** rule + GEMINI merge.

## 6. Smoke

1. Pedido greenfield → lab-runner en `.lab/` (raíz) antes de implementer.
2. Pedido con anomalía de entorno T2 → maverick sin que el usuario lo pida.
3. Tras edit de implementer → verifier antes de “listo”.
4. Fin de sesión → subagentes idle terminados.
