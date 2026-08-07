# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y [SemVer](https://semver.org/lang/es/).

## [1.3.5] - 2026-08-06

### Added

- **Codex Desktop-first:** detector `Test-CodexHostReady` (PATH ∥ embedded CLI ∥ Appx ∥ `~\.codex`); merge seguro de `[agents]` en `config.toml` (no overwrite de plugins/MCP).
- **Codex model+effort pins:** Sol/Terra/Luna + `model_reasoning_effort` en todos los `runtime/codex/agents/*.toml`; defaults Luna en `config.toml.example`.
- **SKILL / reference:** sección Codex Desktop/CLI (spawn, Ultra ban, effort bump acotado); pointer a `07-MODELS-MATRIX` §5.

### Changed

- **Codex ya no “deferred PATH-only”:** install docs + AGENT-HANDOFF alineados a Desktop + CLI embebido.
- **`07-MODELS-MATRIX` §5** + **MODEL-ROUTING-POLICY** §5.1: tabla esfuerzo CursorBench-aware; orch bump once on ESCALATE.
- **Validate:** tokens `gpt-5.6-`, `model_reasoning_effort`, `default_subagent_model`; rechaza `remap-after-codex` / `max_depth`.
- **Pin hygiene:** VERSION `1.3.5`; `SCAFFOLD-FETCH.md`, `GEMINI.user.md`, `scaffold-manifest.json` → tag `v1.3.5`.

## [1.3.4] - 2026-08-06

### Added

- **Mode diagnostic:** optional under `ops-diagnostic` / post-`ANOMALIA` / regression — **4 Composer RO explore lanes** (logs · recent-changes · structural · similar-fragility) → parent synthesizer **`REPORT.md`** in **`.debug/YYYY-MM-DD-<slug>/`** (forensic ≠ `.lab/`; never APPROVE→implementer).
- **Maverick CONSULT HARD** pre-REPORT: crisis framing · Best Part is No Part · `NO_CHANGE` \| `YIELD_OPT` · **Redesign-signals** (when fix ≠ patch) · never patch in CONSULT.
- **`.debug/` archive:** tags for humans + future agents; **incident-review** — orch scans `.debug/*/REPORT.md` on human ask (no re-spawn unless gap).
- **Optional `diagnostic` agent** (Cursor / AGY manifest); thin spawn alias — mode-on-orch remains default.

### Changed

- **Pin hygiene:** `SCAFFOLD-FETCH.md`, `GEMINI.user.md`, `scaffold-manifest.json` → tag `v1.3.4`.
- **Cross-host mirrors:** AGY `spacex-orchestrator.md`, Codex `orchestrator.toml`, OpenCode examples, AGENTS×3 Diagnostic gate row, installer/validate maps.

## [1.3.3] - 2026-08-06

### Changed

- **Parent orchestrator model:** session/user picker or host Auto — omit fixed frontmatter model ID; never force Grok on parent. Child role routing unchanged.
- **Optional nested orchestrator:** depth-1 skill-primed nested `Task(orchestrator)` after lab APPROVE — not default.
- **Optional nested `Task(orchestrator)` model:** `cursor-grok-4.5-high-fast` (Task-resolvable on current Cursor catalog; `cursor-grok-4.5-high` rejected by Task spawn even when listed in `list-models`). Session parent remains user/Auto.
- **Pin hygiene:** `SCAFFOLD-FETCH.md`, `GEMINI.user.md`, `scaffold-manifest.json` → tag `v1.3.3`.
- **Cross-host mirrors:** AGY `spacex-orchestrator.md`, Codex `orchestrator.toml`, OpenCode examples, AGENTS×3 Models table aligned.

## [1.3.2] - 2026-08-06

### Added

- **Build friction / zero-exec:** **Exit-card Build** (Build aprobado → padre solo spawnea implementer(s)); **Phrase→role** table; Plan todos con **`owner:`**; **`Next spawn:`** + **`Parent tools: none`** en header `### Orch`; **Amnesia check** en cada transición de Fase; **O2 via Task** implementer(s) — padre nunca Write/Shell en `execute` | `verify` | `research-lab`.
- **Implementer Batch (HARD):** T2/T3 + Composer writers → spawn **2–3** implementers path-disjoint en el mismo execute Batch; un **Release-owner** (VERSION/CHANGELOG/lock); **Inseparable** → serial micro-passes; **Lab Batch ≠ Implementer Batch**; ops-diagnostic serial; O2 reparte si gaps path-partitionable.

### Changed

- **Verifier envelope:** technical-only — **forbids VLH/UI** judgment; human-serve → spawn separado `verifier-like-human` tras PASS.
- **Wrong-role Composer = process FAIL:** Composer en verifier / VLH / maverick / single-lab → fallo de proceso (auditable).
- **Cross-host mirrors:** canon 01/02, SKILL + references, MODEL-ROUTING §1.0b, CONTEXT-MAP, Cursor orch/implementer/verifier, AGY/OpenCode/Codex templates, AGENTS×3 alineados.
- **`scaffold-manifest.json`:** `rawBase` / lock template pinned to `v1.3.2`.

## [1.3.1] - 2026-08-06

### Changed

- **Cursor model routing (user decision):** parent stays `cursor-grok-4.5-high`; Maverick / technical Verifier / VerifierLikeHuman **always** `cursor-grok-4.5-high-fast` (no Composer mechanical verifier); **single** lab-runner → Grok Fast; **Lab Batch ≥2** parallel → each lab-runner `composer-2.5-fast`; all other children → `composer-2.5-fast`; large Composer scope → more bounded envelopes of the **same role**, not mega-pipeline.
- **Verify loop (A–E):** verifier FAIL returns **complete gap inventory**; parent opens **at most one O2** per verify fan-in (consolidated corrective Batch); input envelopes may be long — output handoffs ≤40 only; cross-surface integration check after multi-surface execute Batch; **RELEASE CHECKLIST** fase for VERSION/lock/sandbox/zip/SHA256SUMS/tags — not via verify FAIL cascades.
- **Cross-host remap:** AGY `gemini-3.1-pro-high` for Maverick/VLH/Verifier judgment equivalents; OpenCode/Codex prose aligned — Grok when exposed, else **Host remap**; never label remap “Grok”.
- **Docs aligned:** `MODEL-ROUTING-POLICY.md`, `CONTEXT-MAP.md`, canon 01/02/07, SKILL + `reference.md` + `reference.antigravity.md`.

## [1.3.0] - 2026-08-05

### Added

- **Discovery / Pre-Plan:** Discovery ⊂ `research-lab` (not a 5th Fase) with bounded budget; orch-only `DECIDE` | `YIELD_PLAN` | `STOP` before Build.
- **WorkType router:** header taxonomy `greenfield` | `evolving-product` | `legacy-app` | `ops-diagnostic` drives Discovery enter/skip, lab isolation, and ops-diagnostic no-mutate rules.
- **Lab Batch (targeted):** parallel lab-runners with path/port/service/data isolation, fan-in matrix, human brake on ≥2 `APPROVE`.
- **Algorithm Ledger + Harvest:** parent-owned Ledger ≤10 lines (Need/Delete/Simplify in prep/DECIDE; Automate at Harvest); post T2/T3 tech PASS → Harvest → Maverick CONSULT → `NO_CHANGE` | `YIELD_OPT` (human; never auto O2).
- **VerifierLikeHuman:** dedicated post-PASS human-judgment role (T2/T3 user-facing); Evidence-class / INCONCLUSIVE; cannot open O2.
- **Native plan flows (ask-only):** YIELD_PLAN asks human for host Plan/Build (Cursor selector / Shift+Tab, AGY Planning Mode + Artifact Review, OpenCode/Codex `/plan`) — decline → STOP; ≠ lab `YIELD`.
- **Host model remap:** Maverick + VLH use Grok 4.5 High Fast when the host exposes it; otherwise explicit **Host remap** high-reasoning (e.g. AGY `gemini-3.1-pro-high`) — never label remap as Grok.

### Changed

- **Maverick policy:** early CONSULT on Discovery zero-to-one / architecture trade-offs; env-anomaly T2+ REQUIRED; mandatory post-Harvest CONSULT.
- **Install / scaffold wiring:** VLH agent templates on Cursor / Antigravity / Codex / OpenCode; `scaffold-manifest.json` registers `verifier-like-human`; installers copy new agents; canon 01/02/07/09 + SKILL/references + CONTEXT-MAP / MODEL-ROUTING-POLICY aligned.
- **`scaffold-manifest.json`:** `rawBase` / lock template pinned to `v1.3.0`; fallback `main`.
- **AGY Desktop pin residuals:** `GEMINI.user.md`, `SCAFFOLD-FETCH.md`, and `SKILL.md` bootstrap line aligned to tag `v1.3.0`.

## [1.2.10] - 2026-08-05

### Changed

- **Compact orchestrator header:** mandatory turn header is now a 3-line `### Orch` block (pipe-separated T|Run|O|Fase|Batch + Role|Action) instead of 6–7 separate `##` H2 lines. Child envelopes use `### Env · <role>` with the same compact taxonomy line.
- **Templates aligned:** canon 00/01/02, SKILL, Cursor orchestrator + mandatory rule, AGY `GEMINI.md` + `spacex-orchestrator.md`, `reference.antigravity.md`, `AGENTS.md`, bootstrap prompt, bench envelopes, OpenCode orchestrator prompt.
- **Failure-ID:** recovery only — append `| Failure-ID: F-<id>` on the Role line (not a standalone H2).
- **`scaffold-manifest.json`:** `rawBase` / lock template pinned to `v1.2.10`; fallback `main`.
- **Multitask / Composer hardening:** explicit HARD rules — Composer / `generalPurpose` never owns a full pipeline; Multitask Mode does not collapse roles; required chain lab-runner → implementer → verifier for methodology/docs/features; anti-pattern “implement end-to-end” in one Task. Canon 01/02 + SKILL aligned.

## [1.2.9] - 2026-08-05

### Changed

- **Taxonomy (Run / Oleada O1–O3 / Fase / Batch):** replaces legacy `Wave 0–3` and `wave-2 Scout` across Cursor wiring, AGENTS template, bootstrap prompt, install canon, verify checklist, and scout handoffs. Header now includes `## Run`, `## Oleada`, `## Fase`, `## Batch`.
- **Parallel Batch:** independent workstreams → multiple Task / `invoke_subagent` **same turn**; Multitask Mode = same Batch parallel Tasks (not role collapse).
- **verify FAIL transitions:** reproducible local → **O2** corrective (`execute` → `verify`); design/env/hipótesis → **O3** (+ `research-lab`); no O4 / “Wave 4”.
- **`MODEL-ROUTING-POLICY.md` §1.2:** O2 corrective routing — Composer Fast mechanical; Grok High Fast judgment/anomaly or single pass after Composer unsatisfied.
- **`runtime/skills/orchestrator/reference.md`**, **`runtime/cursor/agents/orchestrator.md`**, **`runtime/cursor/rules/cj-orchestrator-mandatory.mdc`**, **`docs/agent/CONTEXT-MAP.md`:** aligned with canon 01/02 + SKILL (already migrated in lab APPROVE).
- **`scaffold-manifest.json`:** `rawBase` / lock template pinned to `v1.2.9`; fallback `main`.

### Fixed

- **AGY Desktop pin residuals:** `GEMINI.user.md`, `SCAFFOLD-FETCH.md`, and `SKILL.md` bootstrap line aligned to tag `v1.2.9` (was `v1.2.8`).

## [1.2.8] - 2026-08-05

### Added

- **`runtime/antigravity/SCAFFOLD-FETCH.md`:** agent-facing FETCH/COPY checklist + raw GitHub URL examples.
- **`scaffold-manifest.json`:** `rawBase`, `rawBaseFallback`, `rawPath` per file, `integrityMarkers`.

### Changed

- **Composer routing hard rule:** canonical ID `composer-2.5-fast`; never `composer-2.5` without `-fast` in operational templates/policy (`MODEL-ROUTING-POLICY.md`, `07-MODELS-MATRIX.md`, SKILL, AGENTS, mandatory rule).
- **Antigravity bootstrap:** global `GEMINI.user` and project rules now **FETCH/COPY** canonical SKILL/agents/rules from pack or GitHub raw — **PROHIBIDO generate/invent** methodology content.
- **Integrity gate:** after scaffold, SKILL must contain `T0–T3`, `Zero direct execution`, `lab-runner`, `invoke_subagent`; fake short skills → delete and re-fetch.
- **`SKILL.md` § Antigravity:** removed “embedded templates below” as SKILL source; templates remain for `define_subagent` only.
- **`reference.antigravity.md`**, **`docs/agent/SCAFFOLD-MANIFEST.md`**, **`docs/human/install/antigravity-windows.md`:** fetch-first docs + integrity markers.
- **Validators:** require `SCAFFOLD-FETCH.md`, `rawBase` in manifest, GEMINI.user must not say “generate”.
- **Ops:** `rawBase` pinned to tag `v1.2.8`; `rawBaseFallback` → `main` (removed broken `v1.2.7` 404); SCAFFOLD-FETCH examples aligned.

## [1.2.7] - 2026-08-05

### Added

- **`runtime/skills/orchestrator/reference.antigravity.md`:** Antigravity 2.0 Desktop wiring (`define_subagent` + `invoke_subagent`, agent-native bootstrap, role templates).
- **`runtime/antigravity/scaffold-manifest.json`:** path list for agent-native materialization after human yes.
- **`docs/agent/SCAFFOLD-MANIFEST.md`:** agent copy list pointer for Desktop scaffold.

### Changed

- **Agent-native bootstrap (Antigravity Desktop):** global `GEMINI.user` ask → agent writes lock + `.agents/` tree — **`Orchestrator.ps1 init` not required** on Desktop (CLI remains Path B).
- **`runtime/skills/orchestrator/SKILL.md`:** § Antigravity 2.0 Desktop with `define_subagent` templates (8 roles) + agent-native lock example.
- **`runtime/antigravity/rules/cj-orchestrator-bootstrap.md`**, **`spacex-orchestrator.md`**, **`runtime/GEMINI.md`:** agent-native bootstrap + spawn API.
- **`docs/human/install/antigravity-windows.md`:** Path A (agent-native) vs Path B (CLI); smoke tests for ask/scaffold/delegate.
- **`Install-Orchestrator.ps1`**, **`install-orchestrator.sh`:** project map includes `reference.antigravity.md`.
- **Validators:** require `reference.antigravity.md`, `scaffold-manifest.json`, `define_subagent` + `agent-native` tokens in SKILL.

## [1.2.6] - 2026-08-05

### Changed

- **`## En criollo` timing:** explicitado en regla `cj-criollo-changelog`, skill, implementer, canon 01/02, `AGENTS.md`, Antigravity rules y `GEMINI*.md` — solo al cierre del trabajo entregado; nunca como preámbulo del plan o de la oleada.

## [1.2.5] - 2026-08-05

### Added

- **`runtime/antigravity/GEMINI.user.md`:** micro global template (≤15 líneas) — lock check, ask before init project, load skill, En criollo.
- **User scope Antigravity Desktop:** `init -Scope user -ConfirmUserScope` merge en `%USERPROFILE%\.gemini\GEMINI.md` / `$HOME/.gemini/GEMINI.md` (bloque `<!-- spacex-orchestrator-sx BEGIN/END -->`; overwrite solo del bloque marcado).

### Changed

- **`Install-Orchestrator.ps1`**, **`install-orchestrator.sh`:** merge conservador GEMINI user; agents/AGENTS/.lab siguen project-only.
- **`docs/human/FIRST-RUN.md`**, **`install/antigravity-windows.md`**, **`TEAM-SHARE.md`:** flujo Desktop = init user una vez → chats nuevos preguntan → init project al aceptar; Always On ya no es único camino.
- **`docs/agent/AGENT-HANDOFF.md`:** user-scope AGY = GEMINI global en `.gemini/`, no agents en home.
- **Validators:** exigen asset `runtime/antigravity/GEMINI.user.md`.

## [1.2.4] - 2026-08-05

### Added

- **Antigravity bootstrap rule:** `runtime/antigravity/rules/cj-orchestrator-bootstrap.md` — lock check, offer init, load skill, En criollo REQUIRED; Always On via Customizations.
- **Install project map:** copies bootstrap rule to `.agents/rules/cj-orchestrator-bootstrap.md` (PS1 + sh).

### Changed

- **`runtime/antigravity/rules/spacex-orchestrator.md`**, **`runtime/GEMINI.md`:** lock/bootstrap/En criollo pointers (no essay duplication).
- **`runtime/project/AGENTS.md`:** Antigravity rules path + Always On note alongside Cursor criollo.
- **`docs/human/FIRST-RUN.md`**, **`docs/human/install/antigravity-windows.md`:** init project → open repo in Antigravity → Always On for bootstrap + spacex-orchestrator.
- **Validators:** require Antigravity bootstrap asset and installed path.

## [1.2.3] - 2026-08-05

### Changed

- **`## En criollo` en metodología canónica:** contrato SpaceX en `canon/01-METHODOLOGY-SPACEX.md` y `canon/02-ROLES-HANDOFFS-GATES.md` (handoff implementer + narrate final).
- **`cj-criollo-changelog.mdc`:** `alwaysApply: true` (regla micro); viaja con init project/user a `.cursor/rules/`.
- **`runtime/project/AGENTS.md`:** En criollo REQUIRED + rule presente en repo instalado.
- **`docs/human/FIRST-RUN.md`**, **`TEAM-SHARE.md`**, **`canon/00-README-INSTALL-AGENT.md`:** pointer install de la rule.

## [1.2.2] - 2026-08-05

### Added

- **Regla `cj-criollo-changelog`:** bloque obligatorio `## En criollo` (3–6 frases) en handoffs y close-out — qué cambia en la práctica (install, update, chats, modelos, links, fricción).
- Updated: `runtime/cursor/rules/cj-criollo-changelog.mdc`, `runtime/skills/orchestrator/SKILL.md`, `runtime/project/AGENTS.md`, `runtime/cursor/agents/implementer.md`.
- Instaladores (User + Project scope): copian la nueva rule junto a bootstrap + mandatory.

## [1.2.1] - 2026-08-05

### Changed

- **Verifier model routing:** mechanical DoD → `composer-2.5-fast`; judgment DoD (docs install/update, prompt clarity, security/methodology) or Composer-tier writer → Task `cursor-grok-4.5-high-fast`. Parent orchestrator spot-checks 1–2 verifier claims (no full DoD re-run); cascade Grok Fast verifier on doubt.
- Updated: `runtime/skills/orchestrator/SKILL.md`, `runtime/cursor/agents/{orchestrator,verifier}.md`, `runtime/project/AGENTS.md`, `docs/agent/MODEL-ROUTING-POLICY.md`.
- Doc coherence: split verifier routing in `canon/07-MODELS-MATRIX.md` §2, `runtime/cursor/rules/cj-orchestrator-mandatory.mdc`, root `AGENTS.md` (v1.2.1), sandbox pilot `AGENTS.md` Models table; links → `docs/agent/MODEL-ROUTING-POLICY.md`.

### Note

- Maintainer may tag `v1.2.1` when ready; installs pick up skill/agent templates on next `update --apply`.

## [1.2.0] - 2026-08-05

### Added

- **Install multi-OS vía agente:** frases canónicas ES (install + update); [`docs/agent/DEVICE-INSTALL-PROMPT.md`](docs/agent/DEVICE-INSTALL-PROMPT.md), [`docs/agent/UPDATE-PHRASE.md`](docs/agent/UPDATE-PHRASE.md).
- **Wrapper CLI:** `tooling/scripts/orchestrator` (detecta OS → `.ps1` / `.sh`).
- **`install-orchestrator.sh`** (Linux / macOS / WSL); stub compat `install-orchestrator-wsl.sh`.
- **Release HTTPS sin `gh`:** `update --check` / `--apply` vía API/assets públicos cuando `gh` no está instalado.
- **Lab APPROVE:** `.lab/2026-08-05-device-install-clarity/` — claridad prompt cold-agent.

### Changed

- Bootstrap / skill / `AGENT-BOOTSTRAP-PROMPT`: agente **puede** ejecutar scripts con link/frase canónica; sin frase, solo ofrecer init.
- `orchestrator.sh`: header Linux/macOS/WSL; SHA256 via `sha256sum` **o** `shasum -a 256`.
- `FIRST-RUN`, `TEAM-SHARE`, `README`, `canon/00`, `start/README`: multi-OS agent-driven; dejan de centrarse en “Windows Pack”.
- Asset release renombrado: **`orquestador-sx-v1.2.0.zip`** (+ SHA256SUMS).

## [1.1.1] - 2026-08-05

### Changed

- Repo canónico renombrado a **`fronteraespacial/orquestador-sx`** (público discreto, link-only).
- `$DefaultRepo` / `DEFAULT_REPO` en CLI apuntan al nuevo slug.
- Docs humanas, agente y maintainer: URLs actualizadas; `gh auth` opcional; sin requisito de invite/org privado.
- `SECURITY.md`: nota repo público, sin PAT, anti-popularización social.
- Asset release `spacex-orchestrator-v1.1.0.zip` conserva nombre histórico (SHA256SUMS v1.1.0 sin cambio).

## [1.1.0] - 2026-08-05

### Added

- **Lock file:** `runtime/lock/orchestrator-lock.json.example` — schema `version`, `sha256`, `source`, `policy` (`track-stable`), `enabled`, `installed_at`, `last_check_at`.
- **Micro-regla bootstrap:** `runtime/cursor/rules/cj-orchestrator-bootstrap.mdc` (`alwaysApply: true`, ≤10 líneas) — chequea lock; no init/update desde chat.
- **CLI unificada:** `tooling/scripts/Orchestrator.ps1` + `orchestrator.sh` — `init`, `status`, `update --check|--apply`, `uninstall`.
- **Docs:** `docs/human/FIRST-RUN.md`, `TEAM-SHARE.md`, `docs/agent/AGENT-BOOTSTRAP-PROMPT.md`, `docs/maintainer/RELEASE.md`.
- **GitHub workflows:** `.github/workflows/validate.yml`, `release.yml` (tag → zip → SHA256SUMS).

### Changed

- **Factorización del árbol:** `canon/`, `runtime/`, `tooling/`, `docs/{human,agent,maintainer}/`, `start/`.
- `templates/` → `runtime/` (cursor, antigravity, skills, opencode, codex, project).
- `scripts/`, `bench/`, `sandbox/` → `tooling/`; stubs de compat en root.
- Instaladores copian **ambas** rules: bootstrap + mandatory (User y Project scope).
- `runtime/skills/orchestrator/SKILL.md` — sección Bootstrap/Update (consent; nunca fetch desde chat).
- `runtime/project/AGENTS.md` — pointer a lock + skill.
- Instaladores y validadores parametrizados con `$RuntimeRoot` / paths v1.1.0; validador acepta lock schema y exige skill si `enabled: true`.
- Root `AGENTS.md`, `start/README.md`, `docs/agent/CONTEXT-MAP.md`, SECURITY, DISTRIBUTION-CHECKLIST, AGENT-HANDOFF actualizados.

### Note

- Repo destino: `fronteraespacial/spacex-orchestrator`. Tag/release es paso maintainer aparte.

## [1.0.11] - 2026-08-05

### Added

- `docs/MODEL-ROUTING-POLICY.md`: estado versionado (medido / externo CursorBench / decisión operativa / pendientes) + cadena Composer→Verifier→Grok High Fast corrective.

### Changed

- Cursor templates: orchestrator default `cursor-grok-4.5-high` (no `inherit`); implementer → `composer-2.5-fast`; lab clear `composer-2.5-fast` vs lab complejo Task `cursor-grok-4.5-high-fast`; maverick sigue Grok High Fast.
- `07-MODELS-MATRIX.md`, `03-INSTALL-CURSOR-WINDOWS.md`, skill/rules/reference, README / onboarding / bench README: política operativa sin declarar “ganador” local; benchmark opcional y no bloqueante.
- `MODELS.local.md`: IDs autenticados + smokes válidos vs inconclusos.

### Note

- Smokes válidos `20260805-164541-7fb5ab8a` / `20260805-165955-b686bd26`; inconclusos trust/nested/interrupted conservados — sin conclusión local Grok-vs-Composer.

## [1.0.10] - 2026-08-05

### Fixed

- `Run-Benchmark.ps1`: `Get-CaseOptionalProperty` / `Get-ManifestOptionalProperty` usan `-Name` + `PSObject.Properties` (StrictMode-safe); casos `direct_role_control` leen solo `role_model_requested`.
- Excepción runtime → `_summary` `run_status=failed` + exit 1; exit 0 solo si todos los casos cumplen criterios de su modo.

### Changed

- Política de asignación (`07-MODELS-MATRIX.md` §2.1): `composer-2.5` no es ganador preestablecido; Grok 4.5 Fast candidato 1º para routing/anomalías; umbral ESCALATE (2 fallos Composer reproducibles o diferencia material tras 3 réplicas).
- Documentación: comparación válida = routing vs direct_role_control; sin afirmar modelos hijos nested; `--trust` limitado a `bench/worktrees/`; nunca `--yolo`.

## [1.0.9] - 2026-08-05

### Fixed

- Intento de acceso StrictMode-safe por `execution_mode` (incompleto: parámetro `-Name` vs `$PropertyName` — corregido en 1.0.10).
- Errores runtime escriben `_summary` con `run_status=failed` y `exit 1`; éxito solo si todas las ejecuciones completan y pasan criterios.

## [1.0.8] - 2026-08-05

### Changed

- Benchmark reestructurado: **routing** (`orchestrator_delegate`) mide Orchestrator → Task con `delegation_status=stream_proven`; **direct_role_control** invoca cada rol directo con `--model` Grok/Composer (root stream model demostrable).
- Eliminada pretensión de telemetría de modelo hijo anidado vía Task stream (limitación CLI documentada).
- JSONL v1.3.0: `execution_mode`, `role_model_*`, `case_passed`, `stream_limitation_note`.
- Nuevo `bench/Summarize-Benchmark.ps1`: reporte markdown sin declarar ganador con datos inconclusos.

### Note

- Smokes `20260805-164220` / `20260805-164654` conservados como evidencia; no usar para conclusiones.

## [1.0.7] - 2026-08-05

### Fixed

- Benchmark `-Run`: `agent --trust` default por worktree en `bench/worktrees/` (pack-controlled); `-NoTrustWorktree` para desactivar; nunca `--yolo`.
- Abort temprano ante `Workspace Trust Required` (evita 48 repeticiones fallidas); registro `_summary` + `exit 1`.
- `Set-DelegateAgentModel`: modelo ya igual → `verified=true`, `patched=false`, `already configured`.
- Exit code final explícito: `0` solo si todos OK; `1` si exit≠0, role unverified o tests fallidos.

### Note

- JSONL `20260805-164220-a1ac3e7f.jsonl` conservado como evidencia del bloqueo trust — no usar para conclusiones de routing/role.

## [1.0.6] - 2026-08-05

### Fixed

- Benchmark role: las **4 categorías** (incl. `writer-bounded`) comparan arms hijo **Grok vs Composer** (`composer-2.5`, no fast); IDs renombrados (`*-child-grok` / `*-child-composer`); eliminado `composer_alt` del manifest.

## [1.0.5] - 2026-08-05

### Added

- Benchmark piloto **4 categorías × 2 modelos × 3 réplicas**: maverick/anomaly, scout/contrast, lab/greenfield, **writer-bounded** (envelope acotado a `.bench-marker/marker.txt`).
- Mediciones separadas en manifest y JSONL: **routing** (padre Grok vs Composer) y **role** (padre baseline `composer-2.5`, hijo parcheado en worktree).
- `MODELS.local.md` (gitignored): snapshot local de CLI/modelos medidos sin claves.
- Esquema JSONL v1.2.0: `measurement_type`, `parent_model_*`, `child_model_*`, `delegation_status`, `role_verification_status`.

### Changed

- Worktrees copian **todos** `sandbox/pilot/.cursor/agents/*.md`; casos role parchean frontmatter del delegado con meta verificable.
- `role_verification_status=verified` solo con evento Task/subagent + modelo hijo en stream; si no, `unverified`.
- Réplicas default = 3 desde manifest; dry-run sin artefactos; `-Run` sigue bloqueado sin auth.

### Removed

- `sandbox/temp-wsl-test/` y backups de la distribución (artefacto WSL de prueba).

## [1.0.4] - 2026-08-05

### Fixed

- `install-orchestrator-wsl.sh`: arrays `COPIED`/`REFRESHED`/`SKIPPED`/`MISSING` inicializadas explícitamente; contadores seguros con `set -u` cuando no hay refrescos ni skips.

## [1.0.3] - 2026-08-05

### Fixed

- `Validate-OrchestratorPack.ps1`: expresión `-and` en `Where-Object` corregida; falla ante errores de runtime (`Test-RuntimeErrors`).
- `validate-orchestrator-pack.sh`: heredoc/`check_toml` sin `then` extra; stripper JSONC string-aware (URLs en strings).
- `Install-Orchestrator.ps1`: `-RefreshSandbox -WhatIf` continúa hasta cada `Copy-TemplateSafe` (sin cancelar en el gate global).

## [1.0.2] - 2026-08-05

### Fixed

- `bench/Run-Benchmark.ps1`: `Build-CasePrompt` usa `$CaseManifest` (StrictMode); delegación y `unverified` intactos.
- Instalador PS: `-RefreshSandbox` exige target bajo `<pack>/sandbox` siempre; `Scope Sandbox` rechaza `-TargetPath` externo; repos arbitrarios requieren `-Scope Project -TargetPath`.
- Backups PS/Bash: estructura relativa al target en `.install-backup/<timestamp>/` (sin colisiones de `agent.md`).
- Documentación: parámetro correcto `-ConfirmUserScope`; ejemplos de repo real con `-Scope Project -TargetPath`.
- Docs: entrypoint orchestrator zero-direct-execution y oleadas de benchmark.

## [1.0.1] - 2026-08-05

### Fixed

- Instaladores: set completo (orchestrator, skeptic, deletion, `.agents/rules`, AGENTS.md, reference.wsl, OpenCode JSONC, Codex opcional).
- User scope: mapeo global seguro; excluye Antigravity agents/GEMINI/AGENTS/.lab bajo `$HOME`.
- `-RefreshSandbox`: regenera assets pack-owned en `sandbox/pilot` con backup/manifiesto.
- Validadores: JSON/JSONC/TOML, frontmatter Cursor/Antigravity, detección operativa de `projects/.lab`.
- Benchmark: dry-run sin artefactos; `-Run` con `stream-json`, delegación vía orchestrator, `model/agent_resolved` solo si stream lo prueba.
- Casos benchmark: mismo sobre, comparación routing Grok vs Composer.

## [1.0.0] - 2026-08-05

### Added

- Capa de distribución: README de acceso rápido, VERSION SemVer, onboarding, seguridad y aviso legal.
- `scripts/Install-Orchestrator.ps1`: instalador PowerShell con `SupportsShouldProcess`, sandbox por defecto, backup/manifiesto, `-WhatIf`, sin overwrite.
- `scripts/install-orchestrator-wsl.sh`: instalador Bash idempotente con confirmación explícita.
- `scripts/Validate-OrchestratorPack.ps1` y `scripts/validate-orchestrator-pack.sh`: validación de estructura, gates, frontmatter y secretos.
- `bench/`: scaffold de benchmark Cursor (routing Composer vs Grok, worktree aislado, JSONL, runner con gate `-Run`).
- `sandbox/pilot/`: destino piloto por defecto con README de uso.
- `docs/`: guías operativas del pack distribuible.

### Security

- Instalación por defecto limitada a `sandbox/pilot/`; scope de usuario requiere `-Scope User -ConfirmUserScope`.
- Validadores detectan patrones comunes de secretos antes de distribuir o instalar.
- Benchmark no ejecuta llamadas costosas sin `-Run` ni asume credenciales embebidas.

[1.0.0]: https://github.com/example/spacex-orchestrator-windows-pack/releases/tag/v1.0.0
