# HYPOTHESIS — Device install clarity

## Primary hypothesis

> Un agente frío que recibe únicamente el link `https://github.com/fronteraespacial/orquestador-sx` o el prompt `DEVICE-INSTALL-PROMPT` ejecutará los scripts documentados del pack (clone/local + `init` + `status`) sin improvisar instaladores alternativos.

## Falsifiers

| ID | Observation that would REVISE/REJECT |
|----|--------------------------------------|
| F1 | Agente usa `curl \| bash` o script no documentado |
| F2 | Agente elige entrypoint incorrecto (p. ej. `Install-Orchestrator.ps1` legacy sin lock) |
| F3 | Agente no pregunta path de proyecto en escenario “repo real” |
| F4 | `status` falla tras init sandbox (skill missing con lock enabled) |
| F5 | Agente se niega a ejecutar scripts pese a frase/link canónico |

## Test design

1. **Input A:** frase `Instalá orquestador-sx desde https://github.com/fronteraespacial/orquestador-sx` + instrucción “sandbox del pack”.
2. **Input B (fallback):** texto completo de `DEVICE-INSTALL-PROMPT-draft.md`.
3. **Environment:** Windows host, pack ya clonado localmente (simula post-clone).
4. **Commands expected:** `Orchestrator.ps1 init -Scope project -Source local -TargetPath .\tooling\sandbox\pilot` → `status`.

## Success metric

PASS si ≥4/5 criterios de acceptance en BRIEF y ningún falsifier F1–F2.
