# 09 — Checklist de verificación (post-instalación)

Marcar **después** de copiar archivos. No omitir filas.

## A. Archivos presentes

```text
[ ] .agents/skills/orchestrator/SKILL.md  (zero-exec + Run/Oleada O1–O3/Fase/Batch)
[ ] .agents/skills/orchestrator/reference.md  (portable; no CJ como primario)
[ ] reference.cj-linux.md NO instalado como wiring activo (archivo archivado)
[ ] Cursor: .cursor/agents/{explore,scout,maverick,implementer,lab-runner,verifier}.md
[ ] Cursor: .cursor/rules/*orchestrator*.mdc (o equivalente)
[ ] Antigravity: .agents/agents/{explore,scout,maverick,implementer,lab-runner,verifier}/agent.md
[ ] Antigravity: GEMINI.md con gates + zero-exec
[ ] OpenCode: default_agent=orchestrator + workers; edit/bash deny en orch si el runtime lo permite
[ ] Codex: stubs OR “deferred” documentado
[ ] .lab/README.md en raíz (NO projects/.lab)
[ ] AGENTS.md con sección Orchestration (desde runtime/project/AGENTS.md)
```

## B. Superficie y enforcement

```text
[ ] Cursor: Task/slash — NO invoke_subagent; zero-exec documentado como best-effort/audit
[ ] Antigravity: invoke_subagent; Cursor agents no se asumen cargados
[ ] OpenCode/Codex: deny más fuerte al orch cuando esté disponible
[ ] Modelos listados y remapeados (07)
[ ] Paths de lab = .lab/ únicamente
```

## C. Smoke funcional

| # | Pedido | Esperado |
|---|--------|----------|
| 1 | “Clasifica y no implementes: ¿dónde está X?” | Fase **prep** → explore; padre sin edits |
| 2 | Greenfield chico | scout soft + **lab** bajo `.lab/` antes de implementer |
| 3 | Anomalía env T2 (proxy/container/WSL) | **maverick** sin que el usuario diga maverick |
| 4 | Tras edit real | **verifier** antes de “listo” |
| 5 | Implementer 2× same fail | ESCALATE → scout → retry\|STOP |
| 6 | Pedido borroso “automatizar todo” | **freno** humano o triage; no fan-out ciego |
| 7 | Antigravity | idle subagents killed al cerrar |

## D. Handoffs y deltas

```text
[ ] Hijo ≤40 líneas con sección canónica (02)
[ ] Orquestador reenvió deltas, no transcripts
[ ] Scout SKIPPED con motivo
[ ] Lab YIELD/REJECT ≠ APPROVE
[ ] ANOMALIA clasificada (bloqueante/P1/backlog) si apareció
```

## E. Entrega al humano

```text
[ ] Paths instalados
[ ] MODELS.local.md o tabla de IDs
[ ] Nota best-effort (Cursor) vs deny (OpenCode/Codex)
[ ] Diffs de merge GEMINI/opencode/AGENTS
```

## Fallo = no “instalado”

Si falta A/B, o falla C.1/C.2/C.4: **REVISE**.
