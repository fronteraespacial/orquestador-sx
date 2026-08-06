# BRIEF — Repo público con identidad neutra (`orquestador-sx`)

## Goal

Validar **solo en diseño** si el pack v1.1.0 puede migrar de un distro **privado** (`fronteraespacial/spacex-orchestrator`) a uno **público** con nombre menos visible (`fronteraespacial/orquestador-sx`), sin romper:

1. Flujo `init` / `status` / `update` (SHA256SUMS + zip release)
2. Onboarding humano (FIRST-RUN, TEAM-SHARE) **sin invites**
3. Docs profundas / canon / skill con nombres internos “SpaceX Orchestrator”
4. Política de seguridad (cero PAT embebido; agentes no auto-update)

## Hipótesis bajo prueba

| # | Claim |
|---|--------|
| H1 | Rename GitHub → `fronteraespacial/orquestador-sx` + visibility **public** es viable (redirect automático GitHub) |
| H2 | Description / homepage / topics neutros + wiki/discussions off son baratos vía `gh repo edit` |
| H3 | README root puede ser neutro (H1 sin “SpaceX” ni “orchestrator” en título público) sin tocar `canon/`, `runtime/`, skill |
| H4 | `$DefaultRepo` / `DEFAULT_REPO` + 6 docs clave alcanzan para coherencia de URLs |
| H5 | FIRST-RUN / update funcionan **sin invite**; `gh auth login` pasa a **opcional** si releases son públicos |
| H6 | Asset `SHA256SUMS` + zip `spacex-orchestrator-vX.Y.Z.zip` pueden mantenerse (nombre interno del artefacto ≠ slug repo) |

## Constraints

- **Lab-only:** cero edits fuera de `.lab/2026-08-05-public-obscure/`
- No renombrar carpetas del pack (`spacex-orchestrator-windows-pack`, zip interno) en esta oleada — solo slug GitHub + docs públicas
- Compatibilidad: locks existentes (`source: local|release`), sandbox pilot, validador `-Strict`
- Maintainer ejecuta rename/visibility en GitHub; implementer solo pack + docs

## Baseline (referencias actuales)

| Área | Valor hoy | Problema |
|------|-----------|----------|
| `$DefaultRepo` | `fronteraespacial/spacex-orchestrator` | Privado; requiere acceso org |
| README H1 | `# SpaceX Orchestrator — Windows Pack` | Marketing visible en landing GitHub |
| FIRST-RUN §Prerrequisitos | `gh auth login` + acceso org | Bloquea adopción anónima |
| RELEASE.md §Invite | ~70 líneas colaboradores | Obsoleto si público |
| TEAM-SHARE | “Repo **privado**… maintainer te invita” | Contradice H5 |
| SECURITY.md | Sin mención visibilidad pública | Falta nota gh opcional |

**Inventario URL hardcoded (15 archivos prod):**

`tooling/scripts/Orchestrator.ps1`, `tooling/scripts/orchestrator.sh`, `README.md`, `start/README.md`, `CHANGELOG.md`, `docs/human/FIRST-RUN.md`, `docs/human/TEAM-SHARE.md`, `docs/maintainer/RELEASE.md`, `docs/maintainer/DISTRIBUTION-CHECKLIST.md`, `docs/agent/AGENT-BOOTSTRAP-PROMPT.md`, `docs/agent/AGENT-HANDOFF.md`, `runtime/skills/orchestrator/SKILL.md`

## Acceptance (diseño → implementer)

- [ ] Mapa rename + settings GitHub documentado (comandos maintainer)
- [ ] Propuesta README neutro con diff conceptual H1 + bloque “Repo canónico”
- [ ] Parches textuales FIRST-RUN / TEAM-SHARE / RELEASE (sin sección invite)
- [ ] DefaultRepo → `fronteraespacial/orquestador-sx` en ps1 + sh
- [ ] SECURITY: releases públicos, gh opcional, sin PAT
- [ ] Smoke plan: `update -Check` / `--apply` sin `gh auth` en máquina limpia
- [ ] Veredicto lab `APPROVE` | `REVISE` | `REJECT`

## Out of scope (implementer / maintainer)

- Renombrar zip release o paths `%LOCALAPPDATA%\spacex-orchestrator\` (breaking; oleada futura)
- Rebrand completo canon 00–09 / skill / agents (nombres internos se mantienen)
- Publicar release real en repo renombrado (paso maintainer post-merge)
