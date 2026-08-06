# 04 — Instalar en Antigravity (Windows)

Antigravity carga subagentes desde `.agents/agents/` con frontmatter `subagent: true` y se invocan vía **`define_subagent`** + **`invoke_subagent`**.

**Reglas:** `.agents/rules/cj-orchestrator-bootstrap.md` (lock/skill/En criollo) + `.agents/rules/spacex-orchestrator.md` (orquestación). **`GEMINI.md`** en repo root = capa de compatibilidad para builds que solo leen root rules.

**Global Desktop:** `%USERPROFILE%\.gemini\GEMINI.md` — bloque `<!-- spacex-orchestrator-sx BEGIN/END -->` instalado con **`init -Scope user -ConfirmUserScope`**. Chats nuevos preguntan si preparar el proyecto; playground sin repo ignora el bloque.

## 0. Prerrequisito — agent-native (recomendado Desktop)

**Path A — sin CLI (Antigravity Desktop):**

1. Una vez por máquina: `Orchestrator.ps1 init -Scope user -ConfirmUserScope` (merge `~/.gemini/GEMINI.md`).
2. Abrí el repo destino en Antigravity Desktop.
3. En chat de trabajo, el agente **pregunta** si preparar con Orquestador SX.
4. Si aceptás → el agente **FETCH/COPY** canónico: `.orchestrator-lock.json` + skill/rules/agents desde pack local o GitHub raw (ver `scaffold-manifest.json`, [`SCAFFOLD-FETCH.md`](../../runtime/antigravity/SCAFFOLD-FETCH.md), [`SCAFFOLD-MANIFEST.md`](../agent/SCAFFOLD-MANIFEST.md)). **Nunca** generar/inventar SKILL. Si aparece skill inventado → borrar `.agents/` fake y re-scaffold.
5. Customizations → **Always On**: `cj-orchestrator-bootstrap`, `spacex-orchestrator`.

**Path B — CLI (opcional / avanzado / CI):**

```powershell
.\tooling\scripts\Orchestrator.ps1 init -Scope project -Source local -TargetPath C:\path\to\your-repo
```

Verifica: lock, `.agents/`, `GEMINI.md`.

## 1. Paths Windows

| Pieza | Path |
|-------|------|
| **Global GEMINI (Desktop)** | `%USERPROFILE%\.gemini\GEMINI.md` (merge user init) |
| **Bootstrap rule (Always On)** | `<repo>\.agents\rules\cj-orchestrator-bootstrap.md` |
| **Workspace rule (Always On)** | `<repo>\.agents\rules\spacex-orchestrator.md` |
| Agents | `<repo>\.agents\agents\<role>\agent.md` |
| Skill | `<repo>\.agents\skills\orchestrator\SKILL.md` |
| AGY wiring (opcional) | `<repo>\.agents\skills\orchestrator\reference.antigravity.md` |
| Root rules (compat) | `<repo>\GEMINI.md` |
| Lock | `<repo>\.orchestrator-lock.json` |
| Lab | `<repo>\.lab\` (**única ruta operativa**; no usar `projects/.lab/`) |

Roles carpeta: `explore`, `scout`, `maverick`, `implementer`, `lab-runner`, `verifier`, `verifier-like-human` + opcionales `skeptic`, `deletion`.

## 2. Subagentes AGY 2.0

| Acción | API |
|--------|-----|
| Registrar rol | **`define_subagent`** (plantillas en SKILL § Antigravity 2.0 Desktop) |
| Delegar | **`invoke_subagent`** |
| **No usar** | Cursor `Task` |

## 3. Pasos (Path A o B)

Tras scaffold (Path A) o init project (Path B):

1. **Abrí ese repo** en Antigravity: File → Open Folder → carpeta con `.orchestrator-lock.json` (no un chat suelto ni solo el pack sin prep).

2. **Customizations → Always On:** marcá **`cj-orchestrator-bootstrap`** y **`spacex-orchestrator`**.

3. Confirmar agente llamó **`define_subagent`** para roles base (o agent.md materializados).

4. Primera delegación de prueba: `invoke_subagent` → `explore` (readonly).

5. Confirmá lock + skill (`Orchestrator.ps1 status -TargetPath …`).

6. Crear `\.lab\` en la raíz si no existe. **No** usar `projects/.lab/` como path operativo.

7. Ajustar modelos en frontmatter: `agy models` (o UI). Aliases `flash` / `pro` → preferir IDs concretos (`gemini-3.6-flash-high`, `gemini-3.1-pro-high`). **Maverick + VerifierLikeHuman + verifier (always):** **`Host remap`** `gemini-3.1-pro-high` — AGY no tiene Grok; **nunca** poner `grok-*` ni llamar Grok al remap; **nunca** flash para verifier. **lab-runner:** single lab → high-reasoning remap; Lab Batch (≥2) → flash/fast cheaper ID. Roles siguen habilitados.

8. Confirmar Orquestador de sesión **zero direct execution** en hilo principal (rules + GEMINI).

9. Documentar cleanup: al terminar loop, **matar subagentes idle** (UI / `manage_subagents` si existe).

### 1.3.1 — Discovery / YIELD_PLAN / VLH (Antigravity)

- **WorkType** + Discovery ⊂ `research-lab` (budget acotado) → orch-only `DECIDE` | `YIELD_PLAN` | `STOP`.
- **YIELD_PLAN (ask-only):** AGY **no** silent auto-switch. Tras DECIDE el orch pide al humano abrir **Planning Mode** + **Artifact Review** → **Request Review** / **Proceed** antes de Build → recién ahí O1 `execute`. Decline → **STOP**. ≠ lab `YIELD`.
- **Lab Batch:** aislar dirs + ports/services/data; fan-in; human brake si ≥2 `APPROVE`.
- Cadena: `implementer` → **`verifier`** (técnico) → **`verifier-like-human`** si T2/T3 human-facing tras PASS técnico.
- **Host remap** Maverick/VLH: ID real AGY `gemini-3.1-pro-high` (high-reasoning); **nunca** etiquetar como Grok ni usar `grok-*`.

## 4. Contenido crítico (no omitir)

En `.agents/rules/cj-orchestrator-bootstrap.md`, `.agents/rules/spacex-orchestrator.md` y GEMINI (compat):

- **Lock/bootstrap (agent-native):** chequear `.orchestrator-lock.json`; ask → materialize; load skill when OK
- **En criollo REQUIRED** en handoffs/close-out (3–6 frases prácticas)
- Header compacto `### Orch` (T|WorkType|Run|O|Fase|Batch + Role|Action; T0 incluido)
- **Zero direct execution** en hilo principal
- **`define_subagent` + `invoke_subagent`** (no Cursor `Task`)
- Routing table (base + VLH + skeptic/deletion opcionales)
- **Hard gates:** Lab greenfield REQUIRED (`.lab/` en raíz), Maverick env-anomaly REQUIRED, Verifier close-gate, VLH after tech PASS (T2/T3 human-facing), ESCALATE→scout
- **Host remap:** Maverick/VLH → `gemini-3.1-pro-high` (nunca etiquetar “Grok”)
- **Best-effort:** Scout soft, T3 auditors optional, Scout fan-out waves
- Lifecycle cleanup; naming `YYYY-MM-DD-mav-<slug>`
- Separación explícita **hard rules** vs **best-effort**

## 5. Cómo delega

```text
define_subagent → register role (once per session if needed)
invoke_subagent → role name matching folder / description
Model parameter: flash | gemini-3.1-pro-high | … (aliases remapeables)
```

Handoffs ≤40 líneas (igual que 02).

## 6. Caveats

- Si el modelo trata SKILL.md como “docs opcionales”, **`.agents/rules/` + GEMINI`** deben repetir gates hard.
- No uses paths CJ-linux en prompts Windows.
- Maverick / VLH: **`Host remap`** ID concreto (`gemini-3.1-pro-high`), no solo alias `pro`, **nunca** “Grok”.
- GEMINI solo = OK en builds viejos; ideal instalar **ambos** rule + GEMINI merge.

## 7. Smoke

0. Playground sin repo → **sin** metodología (control negativo).
1. Repo sin lock → agente **pregunta** (no scaffold silencioso).
2. Tras «sí» → lock `source: agent-native` + `.agents/skills/orchestrator/SKILL.md` existen y pasan integrity (`T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`; SKILL >> 20 líneas).
3. Pedido greenfield → lab-runner en `.lab/` (raíz) antes de implementer.
4. Pedido con anomalía de entorno T2 → maverick sin que el usuario lo pida.
5. Trabajo real → header compacto `### Orch` + `invoke_subagent` (no Task).
6. Tras edit de implementer → verifier antes de “listo”.
7. Cierre → `## En criollo` presente.
8. Fin de sesión → subagentes idle terminados.
