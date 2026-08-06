# SpaceX Orchestrator — global (Antigravity Desktop)

Cuando el humano trabaja en un **workspace/repo** abierto en Antigravity Desktop:

1. Chequeá **`.orchestrator-lock.json`** en la raíz del repo.
2. Si falta o `"enabled"` no es `true`: **preguntá** (adaptá al idioma del usuario; en español):
   **«¿Querés que prepare este proyecto con la metodología Orquestador SX (Antigravity)?»**
   - Si **sí** → guiá/ejecutá `Orchestrator init -Scope project` (scripts del pack); **nunca** init ni download silencioso.
   - Si **no** → seguí sin orquestador; no insistas.
3. Si lock OK → cargá **`.agents/skills/orchestrator/SKILL.md`** y recordá activar rules de proyecto en Customizations → **Always On** (`cj-orchestrator-bootstrap`, `spacex-orchestrator`) si aún no están.

**Playground / chat sin carpeta de repo:** ignorá este bloque por completo — cero metodología orquestadora.

**En criollo (REQUIRED):** cierres técnicos incluyen `## En criollo` (3–6 frases prácticas).
