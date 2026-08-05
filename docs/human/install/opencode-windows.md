# 05 — Instalar en OpenCode (Windows)

OpenCode usa agents en JSON/JSONC con `mode: primary|subagent`, `permission`, `model`, `prompt`.

Este pack endurece el **orquestador sin ejecución directa** y la sala canónica **`.lab/`** (raíz del repo, no `projects/.lab/`).

## 1. Paths Windows

Probar en orden:

1. `%USERPROFILE%\.config\opencode\opencode.jsonc` (estilo XDG)
2. `%APPDATA%\opencode\opencode.jsonc`
3. Proyecto: `<repo>\opencode.json`

Comando: `opencode models` para IDs vivos.  
Global config = cualquier CWD; project config = instrucciones + MCP del repo.

## 2. Nombres de integración (`sx-*`)

OpenCode trae built-ins **Explore**, **Scout** y **General**. Para evitar colisiones, el pack define workers con prefijo **`sx-`**:

| Rol lógico | Agent key (pack) | Built-in a no usar vía Task |
|------------|------------------|-----------------------------|
| orchestrator | `orchestrator` (primary) | — |
| explore | `sx-explore` | `explore` |
| scout | `sx-scout` | `scout` |
| implementer / executor | `sx-executor` | — |
| lab-runner | `sx-lab` | — |
| maverick | `sx-maverick` | — |
| verifier | `sx-verifier` | — |
| skeptic | `sx-skeptic` | — |
| expert | `sx-expert` | — |

El Task allowlist del orchestrator **niega `*`** y solo permite las keys `sx-*` de arriba. Los built-ins siguen disponibles por `@` manual si el usuario quiere, pero el protocolo del pack no los spawnea.

## 3. Pasos

1. Backup de config existente.
2. **Merge** agents del ejemplo `runtime/opencode/opencode.json.example` (o `.jsonc.example`):
   - Conservar MCP/instructions del usuario.
   - Reemplazar/añadir: `orchestrator` + todos los `sx-*` de la tabla.
   - Si tenías agents legacy (`executor`, `lab`, `scout`, …), migrar a `sx-*` o dejarlos fuera del allowlist.
3. `default_agent: "orchestrator"`.
4. Orchestrator (contrato duro):
   - `edit: deny`, `bash: deny`, `webfetch/websearch: deny`
   - `task`: deny `*`, allow solo `sx-explore|sx-scout|sx-executor|sx-lab|sx-maverick|sx-skeptic|sx-expert|sx-verifier`
5. Permisos granulares de workers (ya en el example):
   - Read-only + sin web: `sx-explore`, `sx-skeptic`, `sx-expert`
   - Web allow, edit/bash deny: `sx-scout`
   - Edit solo `.lab/**`: `sx-lab`, `sx-maverick`
   - Writer prod: `sx-executor` (web deny)
   - Verifier: edit/web deny, bash allow (tests)
6. Modelos (matriz CJ 2026-08-04 — **no** DeepSeek V4 Flash Free en writers; remapear con `opencode models`):

| Agent | Model |
|-------|--------|
| sx-executor, sx-lab, sx-verifier, sx-maverick, sx-expert | `opencode/nemotron-3-ultra-free` (alt `opencode-go/grok-4.5`) |
| sx-scout, sx-explore | `opencode/north-mini-code-free` |
| sx-skeptic | `opencode/mimo-v2.5-free` |
| orchestrator | sin model fijo (picker TUI) |

7. Copiar skill a `.agents/skills/orchestrator/SKILL.md` y referenciarla en `instructions`.
8. Crear/asegurar `.lab/README.md` (naming + APPROVE) en el repo objetivo.
9. Reiniciar OpenCode / nueva sesión.
10. Smoke: sesión empieza en orchestrator; Task/`@sx-executor` o `@sx-scout` responde; orchestrator no edita.

## 4. Prompts y gates

Los prompts largos ya están en el `.example` (incluidos **sx-skeptic** y **sx-expert**). Si mergeás a mano, **no truncar** prompts de scout/maverick/orchestrator (gates viven ahí).

El `orchestrator.prompt` del pack ya incluye:

- Zero direct execution (también T0)
- Scout gate soft + SKIPPED
- **Lab greenfield REQUIRED** (APPROVE before `sx-executor`)
- **Maverick env anomaly T2+ REQUIRED**
- **Verifier post-writer REQUIRED**
- **ESCALATE@2** → `sx-scout` → retry|STOP
- `.lab/` canónico

## 5. Caveats

- Zen free tiene límites diarios; si Nemotron satura, alt Go `opencode-go/grok-4.5` o bajar verifier a north-mini **solo** si el usuario acepta.
- No redefinir built-ins `explore`/`scout`/`general` en este pack; usá `sx-*`.
- JSONC: comentarios `//` OK en `.jsonc`; en `.json` del proyecto, sin comentarios (usar `opencode.json.example`).

## 6. MCP

El example del pack **no** incluye MCP de CJ-linux. En Windows, el usuario conecta sus MCP (filesystem, browser, etc.) aparte.
