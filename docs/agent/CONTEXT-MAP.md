# Context map — token budget (agentes)

Presupuestos para sesiones orquestadas sobre el pack (Discovery / VLH / Harvest docs). Objetivo: cargar lo mínimo operativo.

## Tier 0 — siempre (≤ ~15k tokens efectivos)

| Asset | Por qué |
|-------|---------|
| [`../AGENTS.md`](../AGENTS.md) | Entry root del pack |
| [`canon/01-METHODOLOGY-SPACEX.md`](../canon/01-METHODOLOGY-SPACEX.md) | T0–T3, WorkType, Discovery, `.lab/` |
| Post-install: `.agents/skills/orchestrator/SKILL.md` | Gates hard; Multitask = spawn roles, no collapse |
| Post-install: `.cursor/agents/orchestrator.md` | Zero-exec parent; Discovery→YIELD_PLAN; lab→implement→verify→VLH; Harvest |

## Tier 1 — según tarea

| Asset | Cuándo |
|-------|--------|
| [`canon/02-ROLES-HANDOFFS-GATES.md`](../canon/02-ROLES-HANDOFFS-GATES.md) | Delegación / handoffs / VLH / YIELD≠YIELD_PLAN |
| [`MODEL-ROUTING-POLICY.md`](MODEL-ROUTING-POLICY.md) | Cursor: Mav/Ver/VLH/single-lab → Grok Fast; Lab Batch ≥2 → Composer Fast each; Mav/VLH/Ver judgment: Grok when exposed else **Host remap** (AGY: `gemini-3.1-pro-high` — never label remap “Grok”); verify loop A–E |
| [`canon/07-MODELS-MATRIX.md`](../canon/07-MODELS-MATRIX.md) | IDs y remapping |
| [`canon/09-VERIFY-CHECKLIST.md`](../canon/09-VERIFY-CHECKLIST.md) | Tech verify + VLH evidence classes |
| Post-install: `.cursor/agents/verifier-like-human.md` | Human-serve gate (T2/T3 after tech PASS) |
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

- **Multitask Mode does NOT authorize** one `generalPurpose`/Composer monolith for lab + implement + verify + VLH + release — **Build in Parallel ≠ role collapse**.
- **Parallel** = same **Batch**: multiple role spawns (Cursor **Task** / Antigravity **`invoke_subagent`**) in **one parent turn** — never one child for the full chain.
- Parent **must** spawn **separate children:** `scout`/`maverick` (gates) → **`lab-runner`** (`APPROVE`) → **`implementer`** → **`verifier`** → **`verifier-like-human`** (if T2/T3 human-facing).
- **Composer = basic/bounded/surgical only** — scoped implementer, explore/scout/skeptic/deletion, **Lab Batch** lab-runners (≥2 parallel); **not** verifier, not single lab, not VLH, not pipeline, not parent. Large work → **more bounded envelopes**, same role.
- verify FAIL → **full gap inventory**; **one O2** per verify fan-in (consolidated corrective Batch); design/env → **O3** (no O4). Input envelopes may be long; output handoffs ≤40 lines. VLH never self-opens O2.
- **Release checklist fase** (VERSION, lock sha, sandbox, zip/SHA256SUMS, tags) — planned, not discovered via verify FAIL cascades.
- Worker monolítico solo si el humano lo pide explícitamente.
- **Install/update scripts:** ejecutar solo con link FIRST-RUN / DEVICE-INSTALL o frase canónica; sin eso, ofrecer únicamente.

## Discovery / YIELD_PLAN / Harvest (compact)

| Concept | Token note |
|---------|------------|
| **Discovery** | ⊂ `research-lab`; triggers + budget in orch entry / SKILL — not a 5th Fase |
| **YIELD_PLAN** | Ask-only on Cursor (selector / Shift+Tab + Discovery Brief → Build); ≠ lab `YIELD` |
| **Lab Batch** | Isolate dirs + ports/services/data; fan-in; human brake on ≥2 APPROVE |
| **VLH** | After tech PASS; evidence class required; UNAVAILABLE→INCONCLUSIVE |
| **Harvest** | Parent-only Algorithm Ledger ≤10 lines → Maverick CONSULT → human on YIELD_OPT |

## No cargar en parent orchestrator

- `tooling/bench/results/*.jsonl` — evidencia cruda; usar resúmenes
- `tooling/bench/worktrees/**` — árboles efímeros
- `runtime/archive/**` — histórico
- `.lab/**` salvo envelope activo con APPROVE
- Stubs root `00–09` — usar `canon/` directamente

## Lab root

Operativo: **`.lab/` en repo root** — nunca `projects/.lab/`.
