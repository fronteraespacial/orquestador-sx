# REPORT — AGY Desktop global micro-bootstrap

**Veredicto:** **APPROVE**

**Fecha:** 2026-08-05

---

## Resumen

La hipótesis **se sostiene**: Antigravity Desktop carga `~/.gemini/GEMINI.md` como capa global always-on (scout). User-scope init con `-ConfirmUserScope` puede mergear un micro-bootstrap idempotente sin depender de Always On manual para esa capa. El working tree del pack ya incluye `Merge-SpacexGeminiUser` (PS1) y `merge_spacex_gemini_user` (sh) + `runtime/antigravity/GEMINI.user.md`. Simulate fresh/append/refresh PASS.

---

## Evidencia lab

| Criterio | Resultado | Notas |
|----------|-----------|-------|
| C1 User-scope merge Win/Unix | **PASS** | `.gemini/GEMINI.md` + marcadores `spacex-orchestrator-sx` |
| C2 Ask-first, never silent | **PASS** | Runtime: ask + `Never init alone` + playground guard; lab propone frase ES exacta |
| C3 AGENTS stub opcional | **REVISE note** | Draft en lab; installer aún no escribe `.gemini/AGENTS.md` |
| C4 Sin Always On global | **PASS** | `GEMINI.user.md` no pide Always On; solo post-init en project rules |
| C5 Project map intacto | **PASS** | Agents/rules solo en project scope |
| `simulate-merge.ps1` | **PASS** | fresh / append / refresh |
| `validate-hypothesis.ps1` | **PASS** | |
| F1 playground leak | **No trigger** | Snippet acota a workspace/repo |
| F2 merge destructivo | **No trigger** | Backup antes de merge |

---

## Contraste scout (incorporado)

- `~/.gemini/GEMINI.md` = global always-on en AGY Desktop → micro-bootstrap **no** necesita toggle UI.
- Pack excluía AGY de user scope → **corregido en diseño** vía merge (no copy repo-root `GEMINI.md` a home).
- Always On manual queda para `.agents/rules/*` **después** de `init -Scope project`.

---

## Gaps post-APPROVE (implementer — no bloquean)

| Prioridad | Acción |
|-----------|--------|
| P0 | Merge `draft/GEMINI.user-proposed.md` → `runtime/antigravity/GEMINI.user.md` (frase ES + pasos numerados) |
| P1 | Sync docs: `antigravity-windows.md`, `FIRST-RUN.md`, `CHANGELOG.md` (revertir “no user-scope AGY”) |
| P2 | Opcional: merge `.gemini/AGENTS.md` desde `draft/AGENTS.user-stub.md` en user init |
| P2 | Reconciliar lab previo `antigravity-bootstrap` P2 (“solo documentar”) con nueva política `-ConfirmUserScope` |
| P3 | Smoke manual AGY Desktop: user init → abrir repo sin lock → agente pregunta → init project → rules Always On |

---

## Checklist manual AGY (post-prod)

- [ ] `Orchestrator.ps1 init -Scope user -ConfirmUserScope` → `%USERPROFILE%\.gemini\GEMINI.md` contiene bloque SX
- [ ] AGY Desktop: abrir repo **sin** lock → primera respuesta **pregunta** preparación (no init solo)
- [ ] Usuario acepta → init project ejecutado/guided
- [ ] Post-init → skill + rules project; Always On en bootstrap + spacex-orchestrator
- [ ] Playground / sin repo → **sin** metodología (control negativo)
- [ ] Re-run user init → refresh bloque sin duplicar marcadores

---

## Lab handoff

- Path: `.lab/2026-08-05-agy-desktop-global/`
- Verdict: **APPROVE**
- Evidence: validate + simulate PASS; C1,C2,C4,C5 OK; C3 optional stub drafted; installer merge ya en working tree
