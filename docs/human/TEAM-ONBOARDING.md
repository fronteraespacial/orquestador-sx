# Team onboarding — SpaceX Orchestrator Windows Pack

Bienvenido. Este documento resume el primer día con el pack: qué leer, qué instalar y cómo verificar que todo funciona.

**Reanudar sesión / continuidad agente:** ver [`../agent/AGENT-HANDOFF.md`](../agent/AGENT-HANDOFF.md) (instalación real, modelos, JSONL, pendientes).

## Día 0 — Antes de tocar producción

1. **Leer** [`../../canon/00-README-INSTALL-AGENT.md`](../../canon/00-README-INSTALL-AGENT.md) y [`../../canon/01-METHODOLOGY-SPACEX.md`](../../canon/01-METHODOLOGY-SPACEX.md) (algorithm, T0–T3, `.lab`).
2. **Validar** el pack sin instalar:

   ```powershell
   .\tooling\scripts\Validate-OrchestratorPack.ps1 -Strict
   ```

3. **Instalar en sandbox** (no afecta tu `%USERPROFILE%`):

   ```powershell
   .\tooling\scripts\Install-Orchestrator.ps1
   ```

4. Abrir `tooling/sandbox/pilot/` en Cursor y ejecutar el smoke de [`../../canon/09-VERIFY-CHECKLIST.md`](../../canon/09-VERIFY-CHECKLIST.md) sección C.

## Roles que debes conocer

| Rol | Cuándo aparece | Gate |
|-----|----------------|------|
| **Orchestrator** | Siempre (tú o el agente raíz) | Clasifica T0–T3, abre sobres |
| **explore** | “¿Dónde está X?” | Sin writer |
| **scout** | Greenfield / docs externas | Soft (documentar SKIPPED) |
| **lab-runner** | Feature nueva | **REQUIRED** antes de implementer |
| **maverick** | Atascos T2, anomalías de entorno | **REQUIRED** en env-anomaly |
| **implementer** | Único writer de prod | Tras lab APPROVE |
| **verifier** | Cierre de tarea | Antes de declarar “listo” |

Detalle completo: [`../../canon/02-ROLES-HANDOFFS-GATES.md`](../../canon/02-ROLES-HANDOFFS-GATES.md).

## Instalación en un repo real

Solo después de PASS en sandbox:

```powershell
.\tooling\scripts\Install-Orchestrator.ps1 -Scope Project -TargetPath C:\path\to\your-repo
```

Para configs globales de usuario (Cursor agents, skills):

```powershell
.\tooling\scripts\Install-Orchestrator.ps1 -Scope User -ConfirmUserScope
```

**Merge, no overwrite:** si ya tienes `GEMINI.md` u `opencode.json`, el instalador copia solo archivos ausentes y registra conflictos en el manifiesto.

## Modelos

Listar modelos vivos en tu host y remapear según [`../../canon/07-MODELS-MATRIX.md`](../../canon/07-MODELS-MATRIX.md) + [`../agent/MODEL-ROUTING-POLICY.md`](../agent/MODEL-ROUTING-POLICY.md). Documentar IDs finales en `MODELS.local.md` (gitignored).

```powershell
agent --list-models   # Cursor CLI
```

**Defaults Cursor del pack:** parent `cursor-grok-4.5-high`; maverick + **verifier** + **verifier-like-human** + **single lab-runner** siempre `cursor-grok-4.5-high-fast`; **Lab Batch (≥2 parallel labs)** → cada lab-runner `composer-2.5-fast`; implementer/explore/scout/ligeros `composer-2.5-fast`. Si Composer no satisface verifier: conservar delta → **una** pasada Grok High Fast (no repetición ciega). OpenCode mav/ver/VLH: `opencode-go/grok-4.5` when exposed; else **Host remap** nearest high-reasoning. Decisión operativa; no hay “ganador” local Grok-vs-Composer.

## Benchmark (opcional — no bloquea onboarding)

El entrypoint **orchestrator** clasifica y delega via Task. El piloto (si se corre) mide **por separado**:

1. **routing** — modelo padre + Task stream_proven  
2. **direct_role_control** — modelo root del rol (observable); **no** telemetría de hijo nested  

```powershell
.\tooling\bench\Run-Benchmark.ps1                              # dry-run: preflight, sin artefactos
.\tooling\bench\Run-Benchmark.ps1 -Run -Replicas 1 -CaseFilter direct-scout-contrast-grok
.\tooling\bench\Run-Benchmark.ps1 -Run -Replicas 3             # grid completo solo con cuota; no requerido para usar el pack
```

Ver [`../../tooling/bench/README.md`](../../tooling/bench/README.md). JSONL trust-blocked / interrupted = inconclusos — no usar para ranking.

## Escalación

| Situación | Acción |
|-----------|--------|
| Validador falla en secretos | Rotar credencial, no commitear, re-ejecutar |
| Instalador reporta conflictos | Merge manual usando diffs en `.install-manifest.json` |
| Gate REQUIRED omitido en prod | STOP — verifier + revisar rules/GEMINI |
| Preguntas de seguridad | [`SECURITY.md`](SECURITY.md) |

## Checklist primer merge

- [ ] Validador PASS
- [ ] Sandbox instalado y smoke C.1–C.4 PASS
- [ ] MODELS.local.md anotado
- [ ] Handoff en `docs/agent/AGENT-HANDOFF.md` del repo (si aplica)
- [ ] Sin secretos en el diff
