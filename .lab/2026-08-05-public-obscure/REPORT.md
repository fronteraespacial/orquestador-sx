# REPORT — Public obscure distro

**Veredicto:** `APPROVE`  
**Lab path:** `.lab/2026-08-05-public-obscure/`  
**Fecha:** 2026-08-05

---

## Resumen

La hipótesis es **implementable en una oleada acotada** sin breaking changes en locks, zip assets ni canon interno. El pack ya evita PAT embebido y verifica SHA256SUMS; el cuello de botella era documentación + repo privado + `$DefaultRepo` apuntando a slug obsoleto.

**Listo para implementer** con prerequisito maintainer M0 (rename + visibility en GitHub).

---

## Evidencia por claim

| Claim | Resultado | Notas |
|-------|-----------|-------|
| H1 Rename + public | **PASS (diseño)** | 15 refs URL inventariadas; redirect GitHub estándar |
| H2 Metadata neutra | **PASS (diseño)** | Comandos `gh repo edit` propuestos en HYPOTHESIS |
| H3 README neutro | **PASS (diseño)** | Solo 2 landing files; canon/skill sin cambio |
| H4 DefaultRepo + docs | **PASS (diseño)** | 2 constantes + 11 archivos listados |
| H5 Sin invite / gh opcional | **PASS (smoke parcial)** | `gh release view` anónimo OK en repo público (`cli/cli`); FIRST-RUN rewrite definido |
| H6 SHA256SUMS / no PAT | **PASS** | Ya cumplido en v1.1.0; zip name estable |

---

## Diff conceptual clave (implementer)

### Orchestrator.ps1 / orchestrator.sh

```diff
- $DefaultRepo = 'fronteraespacial/spacex-orchestrator'
+ $DefaultRepo = 'fronteraespacial/orquestador-sx'
```

Opcional mejora (no bloqueante): suavizar error cuando `gh` ausente en `update -Check` → sugerir descarga manual en lugar de exit 1 duro.

### README.md (root)

```diff
- # SpaceX Orchestrator — Windows Pack
+ # Orquestador SX — Windows Pack

- **Repo canónico:** …/spacex-orchestrator
+ **Repo canónico:** …/orquestador-sx
```

Cuerpo puede mencionar “metodología SpaceX” en párrafo 2 **sin** repetir en H1 ni GitHub topics.

### FIRST-RUN.md

- Quitar §“acceso org / gh auth login obligatorio”
- Añadir path manual: Release → zip → `SHA256SUMS` → `init -Source local`
- Mantener comandos init/status/update idénticos

### RELEASE.md

- Reemplazar título slug
- **Eliminar** §“Invitar colaboradores” (~líneas 66–132)
- Añadir nota: repo público; verificación post-release sin auth

### TEAM-SHARE.md

- URLs nuevas
- Prerrequisitos: Cursor + PowerShell; gh **opcional**
- Quitar fila “repo privado / invite”

### SECURITY.md

Añadir subsección (~5 líneas):

```markdown
## Repositorio público

- Releases y assets son públicos; no se requiere token del pack.
- `gh auth login` es opcional para `update`; alternativa: descarga manual verificada con SHA256SUMS.
- Reporte de vulnerabilidades: preferir GitHub Security Advisories o contacto maintainer (sin detalles explotables en issues públicos).
```

---

## Maintainer M0 (pre-implementer merge)

Ejecutar **antes** o **en paralelo** con wave A:

```powershell
gh repo rename orquestador-sx --repo fronteraespacial/spacex-orchestrator
gh repo edit fronteraespacial/orquestador-sx --visibility public `
  --description "Metodología de orquestación de agentes LLM (Windows pack)." `
  --homepage "https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md" `
  --enable-wiki=false --enable-discussions=false
# topics: ai-agents, cursor, llm, agent-orchestration, methodology
```

Re-publicar o re-attach release v1.1.0 bajo nuevo slug si el rename no arrastra assets (verificar en UI).

---

## Smoke post-implementación

```powershell
# Sin gh auth (logout o máquina limpia)
gh auth status  # debe fallar o “not logged in”

.\tooling\scripts\Orchestrator.ps1 update -Check -TargetPath .\tooling\sandbox\pilot
# Esperado: consulta fronteraespacial/orquestador-sx, exit 0

# Manual fallback
# curl -L release asset zip + SHA256SUMS → Verify-Sha256Sums
```

---

## No hacer (anti-scope)

- Renombrar `spacex-orchestrator-v*.zip` en CI (breaking para locks/hash publicados)
- Rebrand masivo de agents/skill/canon en esta oleada
- Embeber `GH_TOKEN` / PAT en scripts
- Eliminar SHA256SUMS

---

## Veredicto final

**`APPROVE`** — Diseño completo, riesgos acotados, oleadas A–E + M0 definidas. Implementer puede ejecutar con el mapa de HYPOTHESIS.md sin lab adicional salvo fallo del smoke anónimo post-rename real.
