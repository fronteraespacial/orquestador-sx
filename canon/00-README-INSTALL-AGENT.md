# SpaceX Orchestrator Windows Pack — Brief para el agente instalador

**Versión:** 2026-08-05  
**Origen:** metodología SpaceX multi-CLI (contrato transversal portable)  
**Destino:** Windows Desktop — Cursor IDE/CLI, Antigravity, OpenCode, Codex  
**Idioma:** español (instalación) + prompts de roles ES/EN mixtos

## Objetivo

Instalar (o adaptar) el **Orquestador universal de ejecución directa cero** + subagentes en las instancias Windows del usuario: misma filosofía, spawn/paths/modelos adaptados por CLI.

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
| `runtime/cursor/rules/*.mdc` | `.cursor/rules/` |
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
## Complexity: T2 — Install SpaceX orchestrator on Windows multi-CLI
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
6. Documentado: Cursor = best-effort audit; OpenCode/Codex = deny más fuerte si está cableado.

## Paths Windows (resumen)

| Pieza | Ubicación típica |
|-------|------------------|
| Cursor user/project agents | `%USERPROFILE%\.cursor\agents\` / `<repo>\.cursor\agents\` |
| Cursor rules | `%USERPROFILE%\.cursor\rules\` o repo |
| Skills | `%USERPROFILE%\.agents\skills\orchestrator\` o repo |
| Antigravity agents | `<repo>\.agents\agents\<role>\agent.md` |
| OpenCode | `%USERPROFILE%\.config\opencode\` o `%APPDATA%\opencode\` + repo |
| Codex | `%USERPROFILE%\.codex\agents\` |
| Lab | **`<repo>\.lab\`** (canónico; no `projects\.lab`) |
| AGENTS.md | `<repo>\AGENTS.md` |

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
