# 04 — Instalar en Antigravity (Windows)

Antigravity carga subagentes desde `.agents/agents/` con frontmatter `subagent: true` y se invocan vía **`invoke_subagent`**.

**Reglas:** preferir `.agents/rules/spacex-orchestrator.md` (workspace). **`GEMINI.md`** en repo root = capa de compatibilidad para builds que solo leen root rules.

## 1. Paths Windows

| Pieza | Path |
|-------|------|
| **Workspace rule (primary)** | `<repo>\.agents\rules\spacex-orchestrator.md` |
| Agents | `<repo>\.agents\agents\<role>\agent.md` |
| Skill | `<repo>\.agents\skills\orchestrator\SKILL.md` |
| Root rules (compat) | `<repo>\GEMINI.md` |
| Lab | `<repo>\.lab\` (**única ruta operativa**; no usar `projects/.lab/`) |

Roles carpeta: `explore`, `scout`, `maverick`, `implementer`, `lab-runner`, `verifier` (6 base) + opcionales `skeptic`, `deletion`.

## 2. Pasos

1. Crear `\.lab\` en la raíz del repo si no existe. **No** usar `projects/.lab/` como path operativo.
2. Copiar `runtime/antigravity/rules/spacex-orchestrator.md` → `.agents/rules/`.
3. Copiar árbol `runtime/antigravity/agents/*` → `.agents/agents/` (8 roles si incluís skeptic + deletion).
4. Copiar `runtime/skills/orchestrator/SKILL.md`.
5. Copiar `runtime/GEMINI.md` → `GEMINI.md` del repo (**merge** si ya existe: conservar reglas locales; **añadir** header, zero-exec, routing, gates). GEMINI apunta a `.agents/rules/` como fuente primaria.
6. Ajustar modelos en frontmatter: `agy models` (o UI). Aliases `flash` / `pro` → preferir IDs concretos (`gemini-3.6-flash-high`, `gemini-3.1-pro-high`). Remapear si falta el ID.
7. Confirmar Orquestador de sesión **zero direct execution** en hilo principal (regla + GEMINI).
8. Documentar cleanup: al terminar loop, **matar subagentes idle** (UI / `manage_subagents` si existe).

## 3. Contenido crítico (no omitir)

En `.agents/rules/spacex-orchestrator.md` y GEMINI (compat):

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
