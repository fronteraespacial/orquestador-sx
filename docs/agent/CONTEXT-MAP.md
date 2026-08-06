# Context map — token budget (agentes)

Presupuestos para sesiones orquestadas sobre el pack v1.2.10. Objetivo: cargar lo mínimo operativo.

## Tier 0 — siempre (≤ ~15k tokens efectivos)

| Asset | Por qué |
|-------|---------|
| [`../AGENTS.md`](../AGENTS.md) | Entry root del pack |
| [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md) | T0–T3, `.lab/` |
| Post-install: `.agents/skills/orchestrator/SKILL.md` | Gates hard; Multitask = spawn roles, no collapse |
| Post-install: `.cursor/agents/orchestrator.md` | Zero-exec parent; lab→implement→verify chain |

## Tier 1 — según tarea

| Asset | Cuándo |
|-------|--------|
| [`canon/02-ROLES-HANDOFFS-GATES.md`](../canon/02-ROLES-HANDOFFS-GATES.md) | Delegación / handoffs |
| [`MODEL-ROUTING-POLICY.md`](MODEL-ROUTING-POLICY.md) | Elección de modelo |
| [`canon/07-MODELS-MATRIX.md`](../canon/07-MODELS-MATRIX.md) | IDs y remapping |
| [`../runtime/README.md`](../runtime/README.md) | Instalar o refrescar templates |
| [`AGENT-HANDOFF.md`](AGENT-HANDOFF.md) | Reanudar sesión / drift |

## Tier 2 — humano / maintainer (omitir en orchestrator rutinario)

| Asset | Cuándo |
|-------|--------|
| [`../docs/human/TEAM-ONBOARDING.md`](../docs/human/TEAM-ONBOARDING.md) | Onboarding humano |
| [`../docs/maintainer/DISTRIBUTION-CHECKLIST.md`](../docs/maintainer/DISTRIBUTION-CHECKLIST.md) | Release |
| [`../docs/human/install/`](../docs/human/install/) | Instalación por IDE |
| [`../tooling/bench/README.md`](../tooling/bench/README.md) | Benchmark opcional |

## Multitask Mode (recordatorio — hard)

- **Multitask Mode does NOT authorize** one `generalPurpose`/Composer monolith for lab + implement + verify + release — **Build in Parallel ≠ role collapse**.
- **Parallel** = same **Batch**: multiple role spawns (Cursor **Task** / Antigravity **`invoke_subagent`**) in **one parent turn** — never one child for the full chain.
- Parent **must** spawn **separate children:** `scout`/`maverick` (gates) → **`lab-runner`** (`APPROVE`) → **`implementer`** → **`verifier`**.
- **Composer = basic/bounded/surgical only** — scoped implementer, mechanical verifier, light reads; **not** lab-runner, not pipeline, not parent.
- verify FAIL local → **O2**; design/env → **O3** (no O4).
- Worker monolítico solo si el humano lo pide explícitamente.
- **Install/update scripts:** ejecutar solo con link FIRST-RUN / DEVICE-INSTALL o frase canónica; sin eso, ofrecer únicamente.

## No cargar en parent orchestrator

- `tooling/bench/results/*.jsonl` — evidencia cruda; usar resúmenes
- `tooling/bench/worktrees/**` — árboles efímeros
- `runtime/archive/**` — histórico
- `.lab/**` salvo envelope activo con APPROVE
- Stubs root `00–09` — usar `canon/` directamente

## Lab root

Operativo: **`.lab/` en repo root** — nunca `projects/.lab/`.
