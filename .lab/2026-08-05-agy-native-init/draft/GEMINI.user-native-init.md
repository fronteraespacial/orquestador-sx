# SpaceX Orchestrator — global (Antigravity Desktop, agent-native)

Cuando el humano trabaja en un **workspace/repo** abierto en Antigravity Desktop:

1. Chequeá **`.orchestrator-lock.json`** en la raíz del repo.
2. Si falta o `"enabled"` no es `true`: **preguntá** (adaptá al idioma del usuario; en español):
   **«¿Querés que prepare este proyecto con la metodología Orquestador SX (Antigravity)?»**
   - Si **sí** → **materializá el scaffold agent-native** (ver abajo). **Nunca** init silencioso.
   - Si **no** → seguí sin orquestador; no insistas.
3. Si lock OK → cargá **`.agents/skills/orchestrator/SKILL.md`**, registrá roles con **`define_subagent`** si faltan, delegá con **`invoke_subagent`** (nunca Cursor `Task`).

**Playground / chat sin carpeta de repo:** ignorá este bloque por completo.

**En criollo (REQUIRED):** cierres técnicos incluyen `## En criollo` **al final** (3–6 frases prácticas).

---

## Agent-native scaffold (tras «sí» del humano)

**No uses `Orchestrator.ps1 init` como prerequisito.** El agente escribe:

| Path | Acción |
|------|--------|
| `.orchestrator-lock.json` | Crear (`enabled: true`, `source: agent-native`, `version` del pack si visible) |
| `.agents/skills/orchestrator/SKILL.md` | Copiar desde pack en workspace o plantilla mínima embebida en skill |
| `.agents/skills/orchestrator/reference.antigravity.md` | Opcional si existe en pack |
| `.agents/rules/cj-orchestrator-bootstrap.md` | Materializar |
| `.agents/rules/spacex-orchestrator.md` | Materializar |
| `.agents/agents/<role>/agent.md` | 8 roles base (explore…deletion) |
| `GEMINI.md` | Merge (no overwrite human rules) |
| `AGENTS.md` | Stub si falta |
| `.lab/README.md` | Crear dir + README |

Luego: **`define_subagent`** por rol usando plantillas en SKILL § Antigravity 2.0 Desktop; confirmá al humano y recordá **Always On** en Customizations para rules de proyecto.

**CLI pack** (`Orchestrator.ps1 init/update`): solo si el humano pegó frase canónica install/update — no como gate AGY Desktop.
