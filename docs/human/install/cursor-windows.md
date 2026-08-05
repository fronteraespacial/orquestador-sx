# 03 — Instalar en Cursor (Windows IDE + CLI)

Docs producto: [Subagents](https://cursor.com/docs/subagents.md), [Skills](https://cursor.com/docs/skills.md), [Rules](https://cursor.com/docs/rules.md), [CLI](https://cursor.com/docs/cli/overview.md).

## 1. Paths Windows

| Pieza | Path preferido | Alternativa |
|-------|----------------|-------------|
| **Orchestrator entrypoint** | `<repo>\.cursor\agents\orchestrator.md` | — |
| Agents (subagentes) | `<repo>\.cursor\agents\*.md` | `%USERPROFILE%\.cursor\agents\` (IDE sí; CLI a veces no lista user-level) |
| Rules (manual) | `<repo>\.cursor\rules\cj-orchestrator-mandatory.mdc` | `%USERPROFILE%\.cursor\rules\` |
| Skill | `<repo>\.agents\skills\orchestrator\SKILL.md` | `%USERPROFILE%\.agents\skills\orchestrator\` o `.cursor\skills\` |
| AGENTS.md | `<repo>\AGENTS.md` (snippet orquestación) | — |
| Lab | `<repo>\.lab\` | **No usar** `projects/.lab/` (path legado — rechazar en prompts) |

**Recomendación Windows:** instalar **a nivel proyecto** (repo de trabajo) + opcionalmente user-level para IDE.

## 2. Pasos de instalación

1. Crear directorios si no existen (`\.cursor\agents\`, `\.cursor\rules\`, `\.lab\`).
2. **Copiar** (no reescribir de memoria) todos los archivos de `runtime/cursor/agents/` → `.cursor/agents/` (**incluye** `orchestrator.md`, 6 roles base, `skeptic.md`, `deletion.md`).
3. Copiar `runtime/cursor/rules/cj-orchestrator-mandatory.mdc` → `.cursor/rules/`.
4. Copiar `runtime/skills/orchestrator/SKILL.md` → `.agents/skills/orchestrator/SKILL.md`.
5. Crear `reference.md` Windows (mínimo): ver sección 4 abajo (no uses `reference.cj-linux.md` tal cual — tiene paths Android).
6. Merge en `AGENTS.md` el párrafo de orquestación (sección 5).
7. Crear `.lab/README.md` (desde `runtime/project/lab/README.md`) con regla APPROVE y naming. **No** crear ni referenciar `projects/.lab/` como ruta operativa.
8. Verificar modelos: `agent --list-models` (CLI). Ajustar frontmatter `model:` en cada agent si el ID no existe (ver [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md)).
9. **Activar regla manual:** en Cursor, invocar `@cj-orchestrator-mandatory` o habilitar la rule en el picker — **`alwaysApply: false`** por diseño (no inyecta en chats ajenos).
10. Smoke: abrir Agent con regla activa; pedir tarea T1 → confirmar header + Task spawn; `/verifier` lista en agents.

## 3. Entrypoint `orchestrator.md`

- Frontmatter: `readonly: true`, `model: cursor-grok-4.5-high` (explícito; **no** `inherit`).
- **Zero direct execution:** clasificar T0–T3, sobres, Task, fusionar handoffs, narrar — **ni T0 escribe** en el hilo padre (edits → `implementer`, reads → `explore`).
- **`readonly` no es sandbox absoluto:** es hint de producto; puede no bloquear lecturas ni Task. La política zero-exec es **contrato de prompt** — documentado en el template.
- Modelos: ver `07-MODELS-MATRIX.md` y `docs/MODEL-ROUTING-POLICY.md` (lab condicional, cadena Composer→Verifier→Grok corrective).

## 4. Cómo delega Cursor

- Tool **Task** con subagent custom por `name` / description.
- Invocación explícita: `/orchestrator`, `/explore`, `/scout`, `/maverick`, `/implementer`, `/lab-runner`, `/verifier`, `/skeptic`, `/deletion`.
- Built-ins: Explore, Bash, Browser (automáticos; no borrar).
- Paralelo: varias llamadas Task en un mensaje (Scout fan-out).
- `readonly: true` en explore/scout/verifier/skeptic/deletion/orchestrator.
- Maverick **sin** readonly (LAB escribe en `.lab/…-mav-…` en la raíz del repo).

## 5. `reference.md` mínimo Windows (crear)

```markdown
# Orchestrator — Windows wiring

## Cursor
- Entrypoint: .cursor/agents/orchestrator.md (readonly, zero-exec)
- Spawn: Task tool / slash /name
- Agents: .cursor/agents/*.md (6 base + skeptic + deletion optional)
- Rule: .cursor/rules/cj-orchestrator-mandatory.mdc (manual, alwaysApply: false)
- Lab root: `.lab/` (repo root). **Do not** use `projects/.lab/` operationally.
- Models: run `agent --list-models`; defaults in templates may need remap
  - orchestrator: cursor-grok-4.5-high (not inherit)
  - maverick: cursor-grok-4.5-high-fast (always)
  - lab-runner: composer-2.5-fast clear; Task cursor-grok-4.5-high-fast if T2/T3/ambiguous/anomaly
  - implementer + light roles: composer-2.5-fast

## Gates (hard)
Lab greenfield REQUIRED, Maverick env-anomaly REQUIRED, Verifier after implementer, ESCALATE→scout.

## Gates (best-effort)
Scout soft, T3 skeptic/deletion optional, Scout wave-2.
```

## 6. Snippet `AGENTS.md`

```markdown
## Orchestration
Load `.agents/skills/orchestrator/SKILL.md`. Enable rule `@cj-orchestrator-mandatory` (manual).
Act as Orchestrator via `.cursor/agents/orchestrator.md` (zero direct execution; readonly hint).
Cursor: Task + `.cursor/agents/` (explore, scout, maverick, implementer, lab-runner, verifier; optional skeptic, deletion).
Lab root: `.lab/` at repo root (NOT `projects/.lab/`). Gates: greenfield → lab APPROVE before implementer; env anomalies → maverick; after implementer → verifier.
```

## 7. Caveats conocidos

- CLI a veces no lista `~\.cursor\agents\` — preferir project `.cursor\agents\`.
- Orchestrator usa `model: cursor-grok-4.5-high` (evitar `inherit` — inestable en CLI). Si el ID falta, remapear al nearest frontier high y anotar en `MODELS.local.md`.
- Skills **no** cambian modelo; el modelo va en frontmatter del subagente o Task `model:`.
- Parent `readonly` ≠ zero-exec garantizado — seguir prompt del orchestrator.
- Regla **no** es always-on: sin activarla, el IDE no fuerza gates.

## 8. Merge si ya hay agents

Si existen `debugger.md` / `security-auditor.md` del usuario: **no borrar**. Añadir/actualizar orchestrator + 6 roles SpaceX + opcionales skeptic/deletion. Diff antes de overwrite.
