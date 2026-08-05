# SpaceX Orchestrator — Brief para el agente instalador (multi-OS)

**Versión:** 2026-08-05 (pack 1.2.0)  
**Origen:** metodología SpaceX multi-CLI (contrato transversal portable)  
**Destino:** Windows, Linux, macOS — Cursor IDE/CLI, Antigravity, OpenCode, Codex  
**Idioma:** español (instalación) + prompts de roles ES/EN mixtos

## Objetivo

Instalar (o adaptar) el **Orquestador universal de ejecución directa cero** + subagentes en el dispositivo del usuario: misma filosofía, spawn/paths/modelos adaptados por CLI y SO.

**Install vía agente:** frase `Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx` o [`docs/agent/DEVICE-INSTALL-PROMPT.md`](../docs/agent/DEVICE-INSTALL-PROMPT.md). El agente **puede** ejecutar `Orchestrator.ps1` / `orchestrator.sh` documentados; sin frase/link, solo ofrecer init.

El Orquestador **recibe el prompt crudo**, clasifica, traduce a gate corto, planifica oleadas, delega y fusiona handoffs. **Jamás** edita, corre tests, despliega, hace web research ni explora el sistema (incluido T0). Los hijos ejecutan. Cursor solo puede **auditar** esta política (best-effort), no imponerla por completo.

## Orden de lectura OBLIGATORIO

| # | Archivo | Qué hace |
|---|---------|----------|
| 0 | Este `00-README-INSTALL-AGENT.md` | Brief + DoD + mapa |
| 1 | [`01-METHODOLOGY-SPACEX.md`](01-METHODOLOGY-SPACEX.md) | Zero-exec, Algorithm, T0–T3, oleadas, `.lab`, umbrales |
| 2 | [`02-ROLES-HANDOFFS-GATES.md`](02-ROLES-HANDOFFS-GATES.md) | Roles, envelopes, handoffs, gates |
| 3 | [`../docs/human/install/cursor-windows.md`](../docs/human/install/cursor-windows.md) | Paths, Task, agents, rules, skills |
| 4 | [`../docs/human/install/antigravity-windows.md`](../docs/human/install/antigravity-windows.md) | GEMINI, invoke_subagent, cleanup |
| 5 | [`../docs/human/install/opencode-windows.md`](../docs/human/install/opencode-windows.md) | opencode.json(c), allowlist |
| 6 | [`../docs/human/install/codex-windows.md`](../docs/human/install/codex-windows.md) | stubs Codex |
| 7 | [`07-MODELS-MATRIX.md`](07-MODELS-MATRIX.md) | Modelos por rol (remapear al host) |
| 8 | [`../docs/human/08-IMPROVEMENTS-FUTURE-AGENTS.md`](../docs/human/08-IMPROVEMENTS-FUTURE-AGENTS.md) | Backlog |
| 9 | [`09-VERIFY-CHECKLIST.md`](09-VERIFY-CHECKLIST.md) | Smoke post-install |

**Runtime:** [`../runtime/`](../runtime/) — copiar, no regenerar de memoria.

| Pack (`runtime/`) | Destino típico |
|----------|----------------|
| `runtime/cursor/agents/*.md` | `.cursor/agents/` |
| `runtime/cursor/rules/*.mdc` | `.cursor/rules/` (incl. `cj-criollo-changelog.mdc` — `## En criollo` obligatorio) |
| `runtime/antigravity/agents/*/agent.md` | `.agents/agents/<role>/` |
| `runtime/skills/orchestrator/SKILL.md` + `reference.md` | `.agents/skills/orchestrator/` |
| `runtime/skills/orchestrator/reference.wsl.md` | Copiar si el host es WSL; opcional en Windows |
| `runtime/archive/reference.cj-linux.md` | **Archivo archivado — no instalar / no usar** |
| `runtime/project/AGENTS.md` | `<repo>/AGENTS.md` (merge) |
| `runtime/GEMINI.md` | `GEMINI.md` (merge) |
| `runtime/opencode/*` | merge a `opencode.json(c)` |
| `runtime/project/lab/README.md` | **`.lab/README.md`** (raíz del repo) |

## Envelope del instalador

```markdown
## Complexity: T2 — Install SpaceX orchestrator multi-OS multi-CLI
## Role: implementer
## Wave: 2 — execute
**Objetivo:** Instalar Orquestador zero-exec + 6 roles (+ OpenCode skeptic/expert) en Cursor, Antigravity, OpenCode y Codex (stubs).
**Fuente:** esta carpeta; NO omitir 01–09 ni templates listados.
**Archivos / No tocar:** secrets; preguntar antes de sobrescribir (merge preferido).
**Aceptación:** checklist 09 PASS en Cursor + OpenCode + Antigravity; Codex stub si binario existe.
**Lab previo:** none
```

## DoD

1. Skill orquestadora cargable; contrato = zero-exec + oleadas 0–3.
2. Subagentes `explore`, `scout`, `maverick`, `implementer`/`executor`, `lab-runner`/`lab`, `verifier`.
3. Gates activos: Scout soft, Lab greenfield REQUIRED bajo **`.lab/`**, Maverick env-anomaly REQUIRED, Verifier close-gate, ESCALATE/ANOMALIA.
4. Header `## Complexity` + `## Wave` en skill/rules.
5. `AGENTS.md` mergeado desde template; checklist 09 reportada.
6. Regla **`cj-criollo-changelog`** presente en `.cursor/rules/` (metodología `## En criollo`).
7. Documentado: Cursor = best-effort audit; OpenCode/Codex = deny más fuerte si está cableado.

## Paths por SO (resumen)

| Pieza | Windows | Linux / macOS |
|-------|---------|---------------|
| CLI entry | `Orchestrator.ps1` | `orchestrator.sh` / `orchestrator` |
| Cursor agents | `%USERPROFILE%\.cursor\agents\` / repo | `~/.cursor/agents/` / repo |
| Skills | `%USERPROFILE%\.agents\skills\orchestrator\` | `~/.agents/skills/orchestrator/` |
| Antigravity agents | `<repo>\.agents\agents\<role>\` | `<repo>/.agents/agents/<role>/` |
| OpenCode | `%USERPROFILE%\.config\opencode\` | `~/.config/opencode/` |
| Lab | `<repo>\.lab\` | `<repo>/.lab/` |

**Antes de copiar:** resolver paths reales; **merge**, no overwrite ciego.

## Universal vs adaptado

| Universal | Adaptado por CLI |
|-----------|------------------|
| Zero-exec, Algorithm, T0–T3, oleadas, gates, handoffs ≤40, `.lab` APPROVE, cascade, freno, ANOMALIA | Spawn API, paths, model IDs |
| Contraste externo (scout), maverick, verifier | Frontmatter `model` / `readonly` |

## Anti-patrones del instalador

- Instalar solo un CLI y declarar listo.
- Regenerar prompts de memoria.
- Omitir zero-exec / oleadas / gates REQUIRED.
- Instalar o enlazar `reference.cj-linux.md` como wiring activo.
- Crear labs bajo `projects/.lab/` o Maverick sin fecha ISO.
