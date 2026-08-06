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
2. **Copiar** (no reescribir de memoria) todos los archivos de `runtime/cursor/agents/` → `.cursor/agents/` (**incluye** `orchestrator.md`, roles base, `verifier-like-human.md`, opcionales `skeptic.md` / `deletion.md`).
3. Copiar `runtime/cursor/rules/cj-orchestrator-mandatory.mdc` → `.cursor/rules/`.
4. Copiar `runtime/skills/orchestrator/SKILL.md` → `.agents/skills/orchestrator/SKILL.md`.
5. Crear `reference.md` Windows (mínimo): ver sección 5 abajo (no uses `reference.cj-linux.md` tal cual — tiene paths Android).
6. Merge en `AGENTS.md` el párrafo de orquestación (sección 6).
7. Crear `.lab/README.md` (desde `runtime/project/lab/README.md`) con regla APPROVE y naming. **No** crear ni referenciar `projects/.lab/` como ruta operativa.
8. Verificar modelos: `agent --list-models` (CLI). Ajustar frontmatter `model:` en cada agent si el ID no existe (ver [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md)).
9. **Activar regla manual:** en Cursor, invocar `@cj-orchestrator-mandatory` o habilitar la rule en el picker — **`alwaysApply: false`** por diseño (no inyecta en chats ajenos).
10. Smoke: abrir Agent con regla activa; pedir tarea T1 → confirmar header + Task spawn; `/verifier` y `/verifier-like-human` listos en agents.

## 3. Entrypoint `orchestrator.md`

- Frontmatter: `readonly: true`; pack **omite** `model:` — gana el modelo de sesión (humano / Auto). Pin local opcional → `MODELS.local.md` only.
- **Zero direct execution:** clasificar T0–T3 + **WorkType**, sobres, Task, fusionar handoffs, narrar — **ni T0 escribe** en el hilo padre (edits → `implementer`, reads → `explore`).
- **`readonly` no es sandbox absoluto:** es hint de producto; puede no bloquear lecturas ni Task. La política zero-exec es **contrato de prompt** — documentado en el template.
- Modelos: ver `07-MODELS-MATRIX.md` y `docs/agent/MODEL-ROUTING-POLICY.md` (lab condicional, cadena Composer→Verifier→Grok corrective). Remap IDs con `agent --list-models` si faltan en el host.

### 1.3.1 — Discovery / YIELD_PLAN / VLH / Harvest (Cursor)

- **WorkType** en header: `greenfield` | `evolving-product` | `legacy-app` | `ops-diagnostic`.
- **Discovery** ⊂ `research-lab` (bounded: 1 Batch; ≤2 labs, ≤3 solo T3; 1 REVISE) → orch-only `DECIDE` | `YIELD_PLAN` | `STOP`.
- **YIELD_PLAN (ask-only):** Cursor **no** auto-cambia a Plan Mode. Tras DECIDE el orch pide al usuario abrir Plan (selector / **Shift+Tab**), pegar el **Discovery Brief**, revisar y elegir **Build** → recién ahí O1 `execute`. Decline → **STOP**. ≠ lab `YIELD`.
- Cadena: `implementer` → **`verifier`** (técnico) → **`verifier-like-human`** si T2/T3 human-facing tras PASS técnico.
- **Harvest** (parent-only, tras PASS T2/T3 + VLH si gated) → Maverick CONSULT → `NO_CHANGE` | `YIELD_OPT` (humano decide; sin auto-O2).

## 4. Cómo delega Cursor

- Tool **Task** con subagent custom por `name` / description.
- Invocación explícita: `/orchestrator`, `/explore`, `/scout`, `/maverick`, `/implementer`, `/lab-runner`, `/verifier`, `/verifier-like-human`, `/skeptic`, `/deletion`.
- Built-ins: Explore, Bash, Browser (automáticos; no borrar).
- Paralelo: varias llamadas Task en un mensaje (**Batch** / tanda Scout fan-out) — **no** un solo child para lab→implement→verify→VLH.
- `readonly: true` en explore/scout/verifier/verifier-like-human/skeptic/deletion/orchestrator.
- Maverick **sin** readonly (LAB escribe en `.lab/…-mav-…` en la raíz del repo).

## 5. `reference.md` mínimo Windows (crear)

```markdown
# Orchestrator — Windows wiring

## Cursor
- Entrypoint: .cursor/agents/orchestrator.md (readonly, zero-exec)
- Spawn: Task tool / slash /name
- Agents: .cursor/agents/*.md (base + verifier-like-human; skeptic/deletion optional)
- Rule: .cursor/rules/cj-orchestrator-mandatory.mdc (manual, alwaysApply: false)
- Lab root: `.lab/` (repo root). **Do not** use `projects/.lab/` operationally.
- Models: run `agent --list-models`; child IDs in templates may need remap
  - orchestrator (session): **no template pin** — human/Auto; optional local pin → MODELS.local.md
  - optional nested orch (NOT default): Task orchestrator @ cursor-grok-4.5-high — see MODEL-ROUTING
  - maverick / verifier / verifier-like-human: cursor-grok-4.5-high-fast (**always** — no Composer verifier)
  - lab-runner: single lab → Task cursor-grok-4.5-high-fast (mandatory); Lab Batch (≥2) → composer-2.5-fast
  - implementer + light roles: composer-2.5-fast
  - Composer compensation = same-role iterations, not mega-pipeline
  - Release: cross-surface check (Cursor+AGY+OpenCode+Codex), not FAIL-whack-a-mole

## Gates (hard)
WorkType + Discovery→YIELD_PLAN (user opens Plan; no auto-switch) → Build.
Lab greenfield REQUIRED, Maverick env-anomaly REQUIRED, Verifier after implementer,
VLH after tech PASS (T2/T3 human-facing), Harvest→Maverick CONSULT, ESCALATE→scout.

## Gates (best-effort)
Scout soft, early Maverick CONSULT on z2o/arch, T3 skeptic/deletion optional, Batch Scout-2 / tanda.
```

## 6. Snippet `AGENTS.md`

```markdown
## Orchestration
Load `.agents/skills/orchestrator/SKILL.md`. Enable rule `@cj-orchestrator-mandatory` (manual).
Act as Orchestrator via `.cursor/agents/orchestrator.md` (zero direct execution; readonly hint).
Cursor: Task + `.cursor/agents/` (explore, scout, maverick, implementer, lab-runner, verifier,
verifier-like-human; optional skeptic, deletion).
Lab root: `.lab/` at repo root (NOT `projects/.lab/`).
Gates: WorkType; Discovery→YIELD_PLAN (user Plan/Build; no auto-switch); greenfield → lab APPROVE
before implementer; env anomalies → maverick; implementer → verifier → VLH if human-facing;
Harvest→Maverick CONSULT (human on YIELD_OPT).
```

## 7. Caveats conocidos

- CLI a veces no lista `~\.cursor\agents\` — preferir project `.cursor\agents\`.
- Orchestrator template **sin** `model:` — sesión humano/Auto gana. Pin local opcional en `MODELS.local.md` (gitignored). Hijos: remapear IDs si faltan en el host.
- Skills **no** cambian modelo; el modelo va en frontmatter del subagente o Task `model:`.
- Parent `readonly` ≠ zero-exec garantizado — seguir prompt del orchestrator.
- Regla **no** es always-on: sin activarla, el IDE no fuerza gates.
- **Plan Mode:** el agente **pide** al humano abrir Plan; no hay auto-switch ni auto-Build.

## 8. Merge si ya hay agents

Si existen `debugger.md` / `security-auditor.md` del usuario: **no borrar**. Añadir/actualizar orchestrator + roles SpaceX (incl. `verifier-like-human`) + opcionales skeptic/deletion. Diff antes de overwrite.
