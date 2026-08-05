# BRIEF — Orchestrator distro v1.1.0 (diseño)

## Goal

Validar **solo en diseño** si el pack `spacex-orchestrator-windows-pack` (v1.0.11) puede evolucionar a un distro versionado **`fronteraespacial/spacex-orchestrator` v1.1.0** con:

1. Layout factorizado `start/` · `canon/` · `runtime/` · `tooling/` · `docs/{human,agent,maintainer}` + **stubs en root**
2. Micro-regla Cursor `alwaysApply: true` (≤10 líneas) + lock `.orchestrator-lock.json`
3. CLI unificada `Orchestrator.ps1` / `Orchestrator.sh`: `init` · `status` · `update` · `uninstall` (check ≤1/24h; apply explícito; SHA256 vía `gh release`)
4. Docs `FIRST-RUN.md` + `AGENT-BOOTSTRAP-PROMPT.md`
5. Release privado GitHub tag `v1.1.0`

## Constraints

- **Lab-only:** artefactos bajo `.lab/2026-08-05-orchestrator-distro/` — cero edits de producción
- No tocar plan file del orquestador padre
- Compatibilidad: instalaciones existentes (user scope Jul 2026), `sandbox/pilot/`, bench worktrees, validadores actuales
- SemVer: 1.1.0 = cambio estructural **minor** (stubs + lock), no breaking sin migración documentada
- Repo destino **privado** — update requiere `gh auth` + acceso org

## Baseline (pack actual)

| Área | Ubicación hoy | Consumidores |
|------|---------------|--------------|
| Metodología | `00–09` en root | README, TEAM-ONBOARDING, agent prompts |
| Templates instalables | `templates/` | `Install-Orchestrator.ps1`, validador |
| Scripts | `scripts/` | README quick start, DISTRIBUTION-CHECKLIST |
| Docs aux | `docs/` | AGENT-HANDOFF, MODEL-ROUTING-POLICY |
| Piloto | `sandbox/pilot/` | default install, `-RefreshSandbox` |
| Benchmark | `bench/` | Run-Benchmark.ps1, worktrees |
| Regla Cursor | `templates/cursor-rules/cj-orchestrator-mandatory.mdc` | `alwaysApply: false`, ~45 líneas |

## Acceptance (diseño)

- Mapa origen→destino completo para los 5 pilares
- Lista de **path-break** con mitigación (stub vs rewrite)
- Esquema lock JSON + micro-regla ≤10 líneas coherente con skill existente
- Contrato CLI (subcomandos, flags, rate-limit, verify SHA256)
- Outline FIRST-RUN + AGENT-BOOTSTRAP-PROMPT
- Veredicto `APPROVE` | `REVISE` | `REJECT` + oleadas A/B si procede

## Out of scope (implementer)

- Mover archivos reales, publicar release, editar validadores/bench
- Cambiar política de modelos o gates del orquestador
