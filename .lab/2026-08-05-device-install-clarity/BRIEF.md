# BRIEF — Claridad de instalación multi-OS vía agente frío

## Goal

Validar que un agente **sin contexto previo** (sin plan, sin transcript, sin skill instalada) puede instalar el Orquestador SX en un dispositivo cuando el humano pega **solo** el link canónico o el prompt `DEVICE-INSTALL-PROMPT`.

## Hipótesis bajo prueba

| # | Claim |
|---|--------|
| H1 | El prompt autocontenido basta para detectar OS y elegir `Orchestrator.ps1` vs `orchestrator.sh` |
| H2 | El agente **no** inventa `curl \| bash` ni PAT embebido |
| H3 | El agente pregunta path de proyecto (o usa sandbox explícito del prompt) |
| H4 | Tras init, `status` es coherente (lock + skill si `enabled: true`) |
| H5 | Frases canónicas ES (`Instalá orquestador-sx desde …`) disparan el mismo flujo |

## Constraints

- **Lab-only** hasta APPROVE: draft prompt vive primero en `.lab/2026-08-05-device-install-clarity/`
- Cold agent recibe **solo** URL FIRST-RUN o texto raw de `DEVICE-INSTALL-PROMPT-draft.md`
- Sandbox: `tooling/sandbox/pilot` (no home del usuario)
- Sin acceso al plan ni al transcript de orquestación

## Acceptance (cold agent)

- [ ] Script correcto por OS (Windows → `.ps1`; Unix → `.sh` o wrapper `orchestrator`)
- [ ] Sin `curl|bash` crudo ni secrets
- [ ] Pide o confirma path de proyecto
- [ ] `init` + `status` PASS (o `--whatif` / `-WhatIf` documentado en REPORT)
- [ ] Veredicto lab: **APPROVE** | REVISE (1×) | REJECT

## Out of scope

- Release real v1.2.0 (post-APPROVE)
- Test físico macOS (checklist manual en REPORT)
