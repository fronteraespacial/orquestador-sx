# Security & privacy — Orquestador SX Windows Pack

## Repositorio público

- **Repo canónico:** [fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx) — **público discreto** (link-only).
- **No** incluir PAT, tokens ni credenciales en issues, PRs ni docs del pack.
- **No promocionar** el repo en redes sociales, foros ni listados públicos; compartir solo por enlace directo con quien lo necesite.

## Alcance de instalación

| Componente | Comportamiento |
|------------|----------------|
| **Default (CLI init sandbox)** | Escribe bajo `tooling/sandbox/pilot/` + `.orchestrator-lock.json` |
| **`Orchestrator init --scope project`** | Copia templates al repo; lock + manifiesto |
| **`Orchestrator init --scope user -ConfirmUserScope`** | Paths globales bajo `%USERPROFILE%` + `%USERPROFILE%\.spacex-orchestrator\lock.json` |
| **`update --apply`** | Descarga release GitHub verificada (SHA256SUMS); backup + reinstall |

El instalador / CLI **no**:

- Descarga releases ni ejecuta `update --apply` sin comando explícito del operador.
- Lee ni transmite contenido de repos del usuario fuera del target declarado.
- Sobrescribe archivos existentes (merge conservador: skip + log).
- Incrusta API keys, tokens ni credenciales en scripts del pack.

## Secretos

### Qué hace el pack

- `.gitignore` excluye `.env`, claves, `MODELS.local.md`.
- Validadores buscan patrones comunes: `sk-`, `ghp_`, `AKIA`, `Bearer eyJ`, asignaciones `api_key=`, etc.
- Si el validador reporta un hallazgo, **no distribuyas** el pack hasta limpiar.

### Qué debe hacer el operador

- Autenticar Cursor CLI / OpenCode / Antigravity con los flujos oficiales del producto.
- No pegar tokens en prompts, manifiestos de benchmark ni manifiestos de instalación.
- Rotar cualquier secreto expuesto accidentalmente.

## Agentes y consentimiento

- La micro-regla bootstrap (`alwaysApply: true`) **no** autoriza a agentes LLM a instalar ni actualizar el pack.
- Agents deben **ofrecer** `Orchestrator init` / `update --apply` y esperar acción humana.
- Lock `enabled: false` = opt-out; no insistir en orquestación.

## Benchmark

- `bench/Run-Benchmark.ps1` sin `-Run` **no invoca** agentes ni consume cuota.
- Con `-Run`, las llamadas usan la sesión autenticada del operador local; no hay claves en el repositorio.
- `--trust` se limita a worktrees generados bajo `bench/worktrees/`; el runner **nunca** pasa `--yolo`.
- Resultados en `bench/results/` pueden contener prompts — tratar como datos internos, no publicar sin revisión.

## Datos en manifiestos de instalación

Los manifiestos (`.install-manifest.json`) registran rutas, hashes y timestamps de archivos copiados. No incluyen contenido de archivos del usuario salvo metadatos.

## Backups

Backups bajo `.install-backup/<timestamp>/` conservan la **ruta relativa** al target (p. ej. `.agents/agents/explore/agent.md`) para evitar colisiones. Eliminar backups antiguos cuando ya no se necesiten.

## Reporte de vulnerabilidades

Si encuentras un problema de seguridad en scripts del pack:

1. No abrir issue público con detalles explotables.
2. Notificar al maintainer del repositorio por canal privado acordado con el equipo.
3. Incluir versión (`VERSION`), script afectado y pasos mínimos de reproducción.

## Privacidad

Este pack no incluye telemetría propia. Los CLIs subyacentes (Cursor, etc.) pueden tener políticas propias — consultar la documentación de cada producto.
