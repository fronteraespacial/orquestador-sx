# HYPOTHESIS — Public obscure distro

**Lab ID:** `.lab/2026-08-05-public-obscure/`  
**Fecha:** 2026-08-05  
**Pack baseline:** v1.1.0 (distro privado `fronteraespacial/spacex-orchestrator`)

---

## Claims

### H1 — Rename + public visibility

**Claim:** GitHub permite `gh repo rename orquestador-sx` conservando stars/issues/releases; URLs `…/spacex-orchestrator` redirigen al nuevo slug.

**Evidence (diseño):** Documentación GitHub repo rename; pack no hardcodea slug salvo `$DefaultRepo` + markdown links (inventario 15 archivos).

**Test (implementer):** Post-rename, `gh repo view fronteraespacial/orquestador-sx --json visibility,url`.

---

### H2 — Metadata neutra + wiki/discussions off

**Claim:** Una sola invocación `gh repo edit` puede fijar description/homepage/topics y desactivar wiki/discussions.

**Propuesta maintainer:**

```powershell
gh repo edit fronteraespacial/orquestador-sx `
  --description "Metodología de orquestación de agentes LLM para Cursor, OpenCode y Antigravity (Windows pack)." `
  --homepage "https://github.com/fronteraespacial/orquestador-sx/blob/main/docs/human/FIRST-RUN.md" `
  --enable-wiki=false `
  --enable-discussions=false

gh repo edit fronteraespacial/orquestador-sx `
  --add-topic ai-agents --add-topic cursor --add-topic llm `
  --add-topic agent-orchestration --add-topic methodology
```

**Evitar topics:** `spacex`, `orchestrator`, marcas registradas.

---

### H3 — README root neutro; docs profundas intactas

**Claim:** Solo el landing público (`README.md`, `start/README.md`) necesita H1 neutro; `canon/`, `runtime/`, `.agents/skills/orchestrator/SKILL.md` conservan “SpaceX Orchestrator” como nombre interno de metodología.

**Propuesta H1:**

```markdown
# Orquestador SX — Windows Pack
```

**Sustituir bloque:**

```markdown
**Repo canónico:** [github.com/fronteraespacial/orquestador-sx](https://github.com/fronteraespacial/orquestador-sx)
```

**Mantener sin cambio:** títulos en `canon/01-METHODOLOGY-SPACEX.md`, agents, skill, NOTICE (disclaimer afiliación ya existe).

---

### H4 — DefaultRepo + docs clave

**Claim:** Cambiar 2 constantes + reemplazar URLs en 6 docs es suficiente para operadores y agentes.

| Archivo | Cambio |
|---------|--------|
| `tooling/scripts/Orchestrator.ps1` L48 | `$DefaultRepo = 'fronteraespacial/orquestador-sx'` |
| `tooling/scripts/orchestrator.sh` L10 | `DEFAULT_REPO="fronteraespacial/orquestador-sx"` |
| `docs/human/FIRST-RUN.md` | URLs + prerrequisitos gh opcional |
| `docs/human/TEAM-SHARE.md` | URLs + quitar invite/privado |
| `docs/maintainer/RELEASE.md` | Slug + eliminar §Invite; nota repo público |
| `docs/agent/AGENT-BOOTSTRAP-PROMPT.md` | URL canónica |
| `docs/agent/AGENT-HANDOFF.md` | Tabla release URLs |
| `SECURITY.md` | Subsección visibilidad pública |
| Secundarios | `README.md`, `start/README.md`, `CHANGELOG.md`, `DISTRIBUTION-CHECKLIST.md`, `runtime/skills/orchestrator/SKILL.md` |

**No tocar en oleada 1:** nombres de zip CI (`spacex-orchestrator-v*.zip`), cache `%LOCALAPPDATA%\spacex-orchestrator\`, lock field names.

---

### H5 — Install/update sin invite; gh auth opcional

**Claim:** Con repo **public**, `gh release view` y `gh release download` funcionan **sin** `gh auth login` (API anónima GitHub CLI).

**Evidence (smoke local 2026-08-05):**

```text
gh release view v1.1.0 --repo cli/cli --json tagName  → exit 0 (sin auth)
```

**Implicación FIRST-RUN:**

| Modo | gh auth |
|------|---------|
| `init -Source local` | No requerido (nunca lo fue) |
| `update -Check` / `-Apply` desde release público | **Opcional** — recomendado solo para rate-limit o org SSO |
| Descarga manual zip + SHA256 | Sin gh |

**Texto propuesto FIRST-RUN §Prerrequisitos:**

```markdown
3. **Opcional — updates automáticos:** [GitHub CLI](https://cli.github.com/) (`gh`).
   No hace falta `gh auth login` para releases públicos; solo instala `gh` si vas a usar `update --check` / `--apply`.
   Alternativa sin CLI: descargá el zip del release y verificá SHA256SUMS a mano.
```

**Eliminar:** referencias a invite, acceso org, “repo privado”.

---

### H6 — SHA256SUMS; cero PAT

**Claim:** El flujo actual ya cumple — verificación local post-download; CI usa `github.token`, no PAT embebido en pack.

**Mantener:**

- Asset `SHA256SUMS` (formato GNU `hash  filename`)
- Zip `spacex-orchestrator-v1.1.0.zip` (nombre artefacto estable)
- Validadores anti-secreto (`ghp_`, `sk-`, etc.)

**Reject:** cualquier `$env:GH_TOKEN` / PAT en scripts del pack.

---

## Oleadas implementer (si APPROVE)

| Wave | Scope | DoD |
|------|-------|-----|
| **M0** | Maintainer GitHub | Rename, public, metadata, wiki/discussions off |
| **A** | `Orchestrator.ps1` + `orchestrator.sh` | DefaultRepo nuevo; smoke `update -Check` anónimo |
| **B** | README + `start/README.md` | H1 neutro; link orquestador-sx |
| **C** | FIRST-RUN, TEAM-SHARE, RELEASE | Sin invite; gh opcional |
| **D** | AGENT-BOOTSTRAP, AGENT-HANDOFF, SECURITY, SKILL, CHANGELOG | URLs + nota pública |
| **E** | Validador `-Strict` + smoke update apply | Lock `source: release` + SHA256 OK |

## Riesgos

| Riesgo | Mitigación |
|--------|------------|
| Bookmarks rotos al rename | Redirect GitHub 301 automático |
| Rate-limit API anónima gh | Documentar descarga manual zip |
| Confusión nombre zip vs repo | Una línea en FIRST-RUN: “el zip conserva nombre histórico interno” |
| WSL sin gh (evidencia handoff exit 4) | Menor fricción post-público; opcional instalar gh |
