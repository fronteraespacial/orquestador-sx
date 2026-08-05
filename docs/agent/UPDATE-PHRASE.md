# UPDATE-PHRASE — frase canónica de actualización

Cuando el humano quiere actualizar la metodología orquestadora en cualquier chat (con o sin lock previo).

---

## Frase canónica (ES)

```text
Actualizá la metodología orquestadora desde GitHub
```

Variantes aceptadas: pegar link a [releases/latest](https://github.com/fronteraespacial/orquestador-sx/releases/latest) con intención explícita de update.

---

## Comportamiento del agente

1. **Detectar OS** — mismo entrypoint que install (`Orchestrator.ps1` / `orchestrator.sh`).
2. **`update --check`** (o `-Check`) en el repo con lock — respeta throttle 24h.
3. Si hay versión nueva: narrar delta y pedir un **“sí”** corto (o repetir la frase canónica con `--apply`).
4. **`update --apply`** — descarga release público (HTTPS o `gh`), verifica `SHA256SUMS`, reinstall, reescribe lock con `source: release`.
5. **`status`** — confirmar versión y skill presente.

## Prohibiciones

- No `--apply` silencioso sin confirmación.
- No PAT embebido; no `curl | bash`.
- No tocar repos distintos al path confirmado.

## Opt-out

`No uses orquestador aquí` → respetar `"enabled": false` en lock; no insistir.
