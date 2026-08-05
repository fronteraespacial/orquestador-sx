# REPORT — Orchestrator distro v1.1.0 (diseño)

**Verdict: APPROVE**

Diseño validado contra pack v1.0.11. La factorización con stubs, lock file, CLI unificada y docs de bootstrap es **coherente y ejecutable** en dos oleadas. Condiciones menores documentadas abajo; no bloquean implementación.

---

## Resumen por hipótesis

| ID | Resultado | Nota |
|----|-----------|------|
| H1 Factorización + stubs | ✅ Pass | 14 refs críticas; todas mitigables con stub o rewrite oleada A |
| H2 Micro-regla + lock | ✅ Pass | Skill sigue siendo source of truth; lock acotado a runtime paths |
| H3 CLI init/status/update/uninstall | ✅ Pass | Reutiliza lógica `Install-Orchestrator.ps1`; rate-limit + apply explícito |
| H4 FIRST-RUN + AGENT-BOOTSTRAP | ✅ Pass | Cierra gap onboarding humano/agente post-layout |
| H5 Repo privado v1.1.0 | ✅ Pass | Sunset pack zip → GitHub release como SoT; requiere gh auth doc |

---

## Evidencia (análisis estático pack actual)

1. **Root plano saturado:** 10× `0x-*.md`, `templates/`, `scripts/`, `docs/` mezclan canon, runtime y maintainer — difícil de versionar como distro único.
2. **Instalador acoplado a paths:** `Install-Orchestrator.ps1` usa `$PackRoot/templates` y `$PackRoot/sandbox/pilot` — oleada A debe parametrizar `$RuntimeRoot` / `$ToolingRoot` (1 cambio de constantes + stubs).
3. **Regla manual hoy:** `cj-orchestrator-mandatory.mdc` `alwaysApply: false`, ~45 líneas — micro-regla propuesta (9 líneas) + skill evita inyección masiva pero mantiene discoverability vía lock/`status`.
4. **Sin lock hoy:** grep `orchestrator-lock` → 0 hits — greenfield seguro en v1.1.0.
5. **Sandbox regenerable:** `-RefreshSandbox` ya backup+overwrite assets pack-owned en `sandbox/pilot/` — compatible con lock refresh post-init.

---

## Riesgos path-break

| Riesgo | Severidad | Mitigación (oleada A) |
|--------|-----------|------------------------|
| `00–09` links rotos en README, TEAM-ONBOARDING, bench worktrees | **Alta** | Stubs root 1-línea `> Moved to canon/0N-….md` + actualizar links en `start/README.md` |
| Validador hardcode `templates/`, `00–09` | **Alta** | `Validate-OrchestratorPack.ps1`: resolver vía `$CanonRoot` / `$RuntimeRoot`; stubs hasta rewrite |
| Bench worktrees copian layout viejo | **Media** | Regenerar worktrees post-A; documentar en maintainer checklist |
| Install `$PackRoot/templates` | **Alta** | `Join-Path $PackRoot 'runtime/templates'` + stub `templates/` |
| User install Jul 2026 (paths globales) | **Media** | `update --apply` no auto; FIRST-RUN advierte re-init; lock detecta drift |
| WSL vs Windows symlink stubs | **Media** | Stubs = archivos markdown redirect (no symlinks) — funciona en ambos |
| `docs/AGENT-HANDOFF.md` paths absolutos | **Baja** | Mover a `docs/maintainer/`; stub `docs/README.md` index |
| Referencias `.lab/` en regla/skill | **Baja** | Sin cambio semántico; micro-regla repite `.lab/` root-only |

**Conclusión path-break:** Riesgo **controlado** si oleada A entrega stubs **y** actualiza validador/install en la misma PR. Sin stubs → REJECT en implementación (no aplica a este diseño).

---

## Sandbox regenerable

| Mecanismo actual | Compatibilidad v1.1.0 |
|------------------|----------------------|
| `Install-Orchestrator.ps1 -RefreshSandbox` | ✅ Sigue siendo mecanismo; CLI `init --refresh` alias |
| `.install-manifest.json` en pilot | ✅ Extender con campo `lockVersion` o escribir `.orchestrator-lock.json` paralelo |
| `.install-backup/` timestamped | ✅ Preservar; `uninstall`/`refresh` no pierde custom edits fuera runtime |

**Política:** `sandbox/pilot/` permanece bajo `tooling/` o root (recomendación: **root `sandbox/`** — no mover; es artefacto local regenerable, no parte del release checksum).

---

## Contratos diseño (para implementer)

### Lock sidecar check rate-limit

```json
{ "lastCheck": "2026-08-05T21:00:00Z", "nextCheckAllowed": "2026-08-06T21:00:00Z" }
```

`update --check`: si `now < nextCheckAllowed` → exit 0 + mensaje “skipped (24h)”.

### Release asset layout (v1.1.0)

```
spacex-orchestrator-v1.1.0.zip
checksums.sha256          # sha256 per file in zip
MIGRATION-1.0-to-1.1.md
```

### FIRST-RUN outline

1. Prerrequisitos: Cursor, `gh auth login` (org fronteraespacial)
2. `Orchestrator.ps1 init` → sandbox
3. `Orchestrator.ps1 status` → green
4. Leer `canon/01` + activar `@cj-orchestrator` o bootstrap agent doc
5. Opcional: bench smoke

### AGENT-BOOTSTRAP-PROMPT outline

- Bloque fijo: Complexity T?, Role Orchestrator, Action Delegate
- Paths post-factor: skill, orchestrator.md, `.lab/` root
- “No edit locked paths” + invocar `status` ante duda

---

## Oleadas implementer (post-APPROVE)

### Oleada A — Factorize (estructura + compat)

| # | Entrega |
|---|---------|
| A1 | Crear dirs `start/`, `canon/`, `runtime/`, `tooling/`, `docs/{human,agent,maintainer}` |
| A2 | Mover assets según mapa HYPOTHESIS H1 |
| A3 | Stubs root (`00–09`, `templates/`, `scripts/`, `docs/`) |
| A4 | Parametrizar `$PackRoot` paths en install + validate |
| A5 | `start/README.md` + índice canon; VERSION → 1.1.0 |
| A6 | Regenerar `sandbox/pilot` + validador `-Strict` PASS |

**DoD A:** Validador PASS; install idempotente; bench preflight PASS; cero links rotos en start/canon.

### Oleada B — Lock / CLI / docs / GitHub

| # | Entrega |
|---|---------|
| B1 | `.orchestrator-lock.json` schema + escritura en `init` |
| B2 | Micro-regla ≤10 líneas (`alwaysApply: true`) en runtime template |
| B3 | `Orchestrator.ps1` + `Orchestrator.sh` (init/status/update/uninstall) |
| B4 | `update --check` 24h + `--apply` SHA256 vía `gh release` |
| B5 | `start/FIRST-RUN.md`, `docs/agent/AGENT-BOOTSTRAP-PROMPT.md` |
| B6 | Repo `fronteraespacial/spacex-orchestrator` tag `v1.1.0` + checksums |
| B7 | `docs/maintainer/MIGRATION-1.0-to-1.1.md`; CHANGELOG |

**DoD B:** `status` detecta drift; check rate-limited; apply verifica SHA256; release privado descargable con `gh`.

---

## Condiciones REVISE menores (no bloquean APPROVE)

1. **Repo privado:** FIRST-RUN debe documentar PAT/`gh auth` y fallback zip manual si CI sin gh.
2. **alwaysApply true:** Usuarios que preferían regla manual — documentar opt-out (`alwaysApply: false`) en maintainer FAQ.
3. **Sunset:** Windows pack zip 1.0.x → archived; single SoT GitHub 1.1.0+ (CHANGELOG explícito).

---

## Delete check (post-promote)

| Eliminar tras v1.1.0 estable | Mantener |
|------------------------------|----------|
| Stubs root (solo tras 1 release cycle + validador sin legacy paths) | `sandbox/`, `bench/results/` gitignored |
| Duplicado `docs/` flat si index stub redundante | Lock + CLI como entry único |
| Este lab `.lab/2026-08-05-orchestrator-distro/` | Canon en `canon/` |

---

## Lab handoff

- Path: `.lab/2026-08-05-orchestrator-distro/`
- Verdict: **APPROVE**
- Evidence: mapa H1 validado contra install/validate/README; lock+micro-regla coherentes con skill; CLI extiende scripts existentes; sandbox `-RefreshSandbox` compatible; path-break mitigable oleada A

**Siguiente:** Orchestrator delega **implementer oleada A**, luego **verifier**, luego **oleada B**.
