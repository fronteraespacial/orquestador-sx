# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y [SemVer](https://semver.org/lang/es/).

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
