# 09 — Checklist de verificación (post-instalación)

Marcar **después** de copiar archivos. No omitir filas.

## A. Archivos presentes

```text
[ ] .agents/skills/orchestrator/SKILL.md  (zero-exec + Run/Oleada O1–O3/Fase/Batch + Discovery/Harvest)
[ ] .agents/skills/orchestrator/reference.md  (portable; no CJ como primario)
[ ] reference.cj-linux.md NO instalado como wiring activo (archivo archivado)
[ ] Cursor: .cursor/agents/{explore,scout,maverick,implementer,lab-runner,verifier,verifier-like-human}.md
[ ] Cursor: .cursor/rules/*orchestrator*.mdc (o equivalente)
[ ] Antigravity: .agents/agents/{explore,scout,maverick,implementer,lab-runner,verifier,verifier-like-human}/agent.md
[ ] Antigravity: GEMINI.md con gates + zero-exec
[ ] OpenCode: default_agent=orchestrator + workers (incl. VLH); edit/bash deny en orch si el runtime lo permite
[ ] Codex: stubs OR “deferred” documentado (incl. VLH cuando exista)
[ ] .lab/README.md en raíz (NO projects/.lab)
[ ] AGENTS.md con sección Orchestration (desde runtime/project/AGENTS.md)
```

## B. Superficie y enforcement

```text
[ ] Cursor: Task/slash — NO invoke_subagent; zero-exec documentado como best-effort/audit
[ ] Antigravity: invoke_subagent; Cursor agents no se asumen cargados
[ ] OpenCode/Codex: deny más fuerte al orch cuando esté disponible
[ ] Modelos listados y remapeados (07); Maverick + VLH = Grok Fast en Cursor
[ ] Paths de lab = .lab/ únicamente
[ ] Plan policy ask-only (humano abre Plan Mode / Artifact / Plan→Build / /plan) — agentes no auto-switch
```

## C. Smoke funcional

| # | Pedido | Esperado |
|---|--------|----------|
| 1 | “Clasifica y no implementes: ¿dónde está X?” | Fase **prep** → explore; padre sin edits; header compacto `### Orch` |
| 2 | Greenfield chico | WorkType greenfield; scout soft + **Discovery/lab** bajo `.lab/` antes de implementer; YIELD_PLAN→humano Build si T2+ |
| 3 | Anomalía env T2 (proxy/container/WSL) | **maverick** sin que el usuario diga maverick |
| 4 | Tras edit real | **verifier** antes de “listo” |
| 5 | Implementer 2× same fail | ESCALATE → scout / Discovery → retry\|STOP |
| 6 | Pedido borroso “automatizar todo” | **freno** humano o triage; no fan-out ciego |
| 7 | Antigravity | idle subagents killed al cerrar |
| 8 | T2/T3 user-facing tras tech PASS | **VerifierLikeHuman** con Evidence-class; UNAVAILABLE → INCONCLUSIVE |
| 9 | T2/T3 PASS completo | Harvest + **Maverick CONSULT** → `NO_CHANGE`\|`YIELD_OPT` (humano; no auto O2) |
| 10 | ops-diagnostic | Sin feature lab/pipeline; sin mutaciones paralelas |

## D. Handoffs y deltas

```text
[ ] Hijo ≤40 líneas con sección canónica (02)
[ ] Orquestador reenvió deltas, no transcripts
[ ] Scout SKIPPED con motivo
[ ] Lab YIELD/REJECT ≠ APPROVE; YIELD ≠ YIELD_PLAN
[ ] Lab Batch: isolation paths/ports/services/data; multi-APPROVE → human brake
[ ] ANOMALIA clasificada (bloqueante/P1/backlog) si apareció
[ ] VLH: Evidence-class + Serves-ask + PASS|FAIL|INCONCLUSIVE; no edit / no self-O2
[ ] Algorithm Ledger parent-only (Prep/DECIDE Need-Delete-Simplify; Harvest Automate)
```

## E. Entrega al humano

```text
[ ] Paths instalados
[ ] MODELS.local.md o tabla de IDs (VLH + Maverick Grok Fast)
[ ] Nota best-effort (Cursor) vs deny (OpenCode/Codex)
[ ] Diffs de merge GEMINI/opencode/AGENTS
```

## F. VerifierLikeHuman (runtime gate)

Tras **verifier técnico PASS**, solo si T2/T3 **user-facing**:

```text
[ ] Spawn VerifierLikeHuman (rol dedicado; modelo Grok 4.5 High Fast en Cursor)
[ ] Handoff order: Verdict → Serves-ask → Evidence-class → Evidence / artifact paths → Ask Orchestrator
[ ] Verdict: PASS | FAIL | INCONCLUSIVE
[ ] Serves-ask: yes | partial | no
[ ] Evidence-class: CAPTURED | BROWSER | COMPUTER | PROXY | UNAVAILABLE
[ ] UNAVAILABLE → INCONCLUSIVE (nunca PASS visual inventado)
[ ] No edit prod; no auto O2 (orch clasifica FAIL/INCONCLUSIVE)
```

## Fallo = no “instalado”

Si falta A/B, o falla C.1/C.2/C.4: **REVISE**. Si C.8/C.9 fallan en host con VLH instalado: **REVISE** metodología 1.3.1.
