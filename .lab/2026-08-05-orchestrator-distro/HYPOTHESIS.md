# HYPOTHESIS — Orchestrator distro v1.1.0

## H1 — Factorización con stubs preserva compatibilidad

**Claim:** Reorganizar el pack en `start/`, `canon/`, `runtime/`, `tooling/`, `docs/{human,agent,maintainer}` **sin romper** scripts, bench ni docs existentes, dejando en root **stubs mínimos** (redirect o symlink policy documentada).

**Propuesta de mapa**

| Destino | Contenido canónico | Origen actual |
|---------|-------------------|---------------|
| `start/` | README quick start, `FIRST-RUN.md`, entry CLI | `README.md` (sección rápida), nuevo |
| `canon/` | Metodología `00–09` | `00-README-INSTALL-AGENT.md` … `09-VERIFY-CHECKLIST.md` |
| `runtime/` | Templates instalables | `templates/` |
| `tooling/` | Install, validate, bench, CLI | `scripts/`, `bench/` |
| `docs/human/` | Onboarding equipo | `TEAM-ONBOARDING.md`, `03–06` extracts |
| `docs/agent/` | Bootstrap prompts | nuevo `AGENT-BOOTSTRAP-PROMPT.md`, handoff |
| `docs/maintainer/` | Release, seguridad, distribución | `docs/DISTRIBUTION-CHECKLIST.md`, `SECURITY.md`, `CHANGELOG.md` |

**Stubs root (obligatorios v1.1.0)**

```
README.md              → start/README.md (frontmatter: canonical path)
00-README-...md        → canon/00-... (1 línea redirect)
templates/             → runtime/templates/ (README stub)
scripts/               → tooling/scripts/ (README stub)
docs/                  → docs/human/ index stub
VERSION                → queda root (lock + release)
```

**Test:** Todo path referenciado en `Validate-OrchestratorPack.ps1`, `Install-Orchestrator.ps1`, `bench/Run-Benchmark.ps1`, y `README.md` tiene stub **o** rewrite planificado en oleada A.

**Falsificación:** >5 referencias hardcoded sin stub y sin rewrite en oleada A → REJECT parcial.

---

## H2 — Micro-regla alwaysApply + lock evitan drift

**Claim:** Una regla ≤10 líneas con `alwaysApply: true` que **solo** apunta al skill + lock file; el detalle de gates queda en `.agents/skills/orchestrator/SKILL.md` (sin duplicar 45 líneas).

**Micro-regla propuesta (9 líneas body)**

```markdown
---
description: SpaceX Orchestrator — load skill + respect lock
alwaysApply: true
---
# Orchestrator
Load `.agents/skills/orchestrator/SKILL.md`. Parent: `.cursor/agents/orchestrator.md` (zero direct execution).
Installed version: see `.orchestrator-lock.json`. Do not edit locked paths; run `Orchestrator.ps1 status`.
Lab root: `.lab/` at repo root only.
```

**Lock `.orchestrator-lock.json` (esquema)**

```json
{
  "schema": "orchestrator-lock/1",
  "distro": "fronteraespacial/spacex-orchestrator",
  "version": "1.1.0",
  "installedAt": "ISO8601",
  "scope": "sandbox|project|user",
  "checksums": {
    "runtime/templates/cursor-agents/orchestrator.md": "sha256:…"
  },
  "lastCheck": "ISO8601",
  "releaseTag": "v1.1.0"
}
```

**Test:** Lock permite `status` diff vs release; micro-regla no contradice `alwaysApply: false` actual **post-migración** (install escribe la nueva regla).

**Falsificación:** Gates REQUIRED ilegibles solo con micro-regla → REVISE (mantener skill como source of truth — OK).

---

## H3 — CLI unificada reemplaza ad-hoc install con política explícita

**Claim:** `Orchestrator.ps1` / `Orchestrator.sh` con subcomandos:

| Cmd | Comportamiento |
|-----|----------------|
| `init` | Wrapper de install (sandbox default); escribe lock |
| `status` | Versión lock vs remoto; lista drift |
| `update --check` | Consulta release; **máx 1/24h** (timestamp en lock o sidecar `.orchestrator-check`) |
| `update --apply` | Solo con flag explícito; verify SHA256 assets vía `gh release download` + manifest |
| `uninstall` | Remove según scope + backup (reuse lógica Install actual) |

**Verify flow:** `gh release view v1.1.0 --repo fronteraespacial/spacex-orchestrator --json assets` → download → SHA256 vs lock/checksums manifest en release.

**Test:** Rate-limit evita spam API; `--apply` nunca default; offline → status local OK, check skipped gracefully.

**Falsificación:** Sin `gh` autenticado en repo privado, update inutilizable → REVISE (documentar token + fallback zip manual en FIRST-RUN).

---

## H4 — FIRST-RUN + AGENT-BOOTSTRAP-PROMPT cierran onboarding

**Claim:**

- `start/FIRST-RUN.md` — humano: validar pack → `Orchestrator.ps1 init` → abrir sandbox → enlace canon
- `docs/agent/AGENT-BOOTSTRAP-PROMPT.md` — copy-paste para activar orquestador (header T0–T3, @ rule, skill path)

**Test:** Un maintainer nuevo completa FIRST-RUN sin leer `00–09` completos; un agente arranca con bootstrap sin inventar paths post-factorización.

---

## H5 — Repo privado v1.1.0 es viable como fuente de verdad

**Claim:** Tag `v1.1.0` en `fronteraespacial/spacex-orchestrator` (privado) con asset `spacex-orchestrator-v1.1.0.zip` + `checksums.sha256` + notas de migración desde 1.0.x.

**Test:** SemVer coherente (1.0.11 pack windows → 1.1.0 distro unificado); CHANGELOG entrada “layout factorizado + CLI + lock”.

**Falsificación:** Dos fuentes de verdad (zip windows pack + github) sin estrategia sunset → REVISE.

---

## Criterio de veredicto global

| Resultado | Condición |
|-----------|-----------|
| **APPROVE** | H1–H5 diseño coherente; path-break mitigable en oleada A; sandbox regenerable |
| **REVISE** | Diseño OK pero falta contrato (gh privado, stub policy Windows vs WSL) |
| **REJECT** | Factorización rompe bench/validador sin plan; o lock/micro-regla insuficientes |
