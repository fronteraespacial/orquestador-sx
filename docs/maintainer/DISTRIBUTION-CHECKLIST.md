# Distribution checklist

Usar antes de zippear, taggear o compartir el pack.

## Pre-release

- [ ] `VERSION` actualizado (SemVer)
- [ ] `CHANGELOG.md` entrada para la versión
- [ ] `.\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict` → PASS
- [ ] Sin `projects/.lab/` operativo en el pack
- [ ] Sin secretos en diff (`git diff` / validador)
- [ ] `runtime/lock/orchestrator-lock.json.example` schema completo
- [ ] `runtime/cursor/rules/cj-orchestrator-bootstrap.mdc` (`alwaysApply: true`, ≤10 líneas)

## Smoke CLI + instalador

- [ ] `.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot -WhatIf`
- [ ] `.\tooling\scripts\Orchestrator.ps1 init --scope project --source local --target .\tooling\sandbox\pilot`
- [ ] `.\tooling\scripts\Orchestrator.ps1 status -TargetPath .\tooling\sandbox\pilot`
- [ ] `.orchestrator-lock.json` generado en target
- [ ] Re-ejecutar init — idempotente (skipped ≥ copied en manifiesto)
- [ ] Manifiesto `.install-manifest.json` generado
- [ ] Ambas rules instaladas: `cj-orchestrator-bootstrap.mdc` + `cj-orchestrator-mandatory.mdc`

## Smoke benchmark (opcional — no bloquea release)

- [ ] `.\tooling\bench\Run-Benchmark.ps1` — preflight sin `-Run`
- [ ] Con CLI autenticado (opcional): `.\tooling\bench\Run-Benchmark.ps1 -Run -Replicas 1 -CaseFilter direct-scout-contrast-grok`
- [ ] No declarar ganador con JSONL inconclusos; ver `docs/agent/MODEL-ROUTING-POLICY.md`

## Entrega

- [ ] README + `docs/human/FIRST-RUN.md` + TEAM-ONBOARDING + SECURITY + NOTICE
- [ ] `docs/agent/AGENT-BOOTSTRAP-PROMPT.md` incluido
- [ ] `docs/maintainer/RELEASE.md` revisado
- [ ] Orchestrator template `model: cursor-grok-4.5-high` (no `inherit`)
- [ ] `.gitignore` excluye `tooling/bench/results/`, sandbox instalado, secretos
- [ ] Tag `vX.Y.Z` + SHA256SUMS en release GitHub (`fronteraespacial/spacex-orchestrator`)
