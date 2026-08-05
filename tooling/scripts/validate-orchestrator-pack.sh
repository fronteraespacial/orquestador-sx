#!/usr/bin/env bash
# SpaceX Orchestrator — validate-orchestrator-pack.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET=""
STRICT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --strict) STRICT=true; shift ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) TARGET="$1"; shift ;;
  esac
done

ERRORS=0
WARNINGS=0
PASSED=0

pass() { PASSED=$((PASSED + 1)); printf 'PASS: %s\n' "$1"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf 'WARN: %s\n' "$1" >&2; }
fail() { ERRORS=$((ERRORS + 1)); printf 'FAIL: %s\n' "$1" >&2; }

REQUIRED_ASSETS=(
  runtime/cursor/agents/orchestrator.md
  runtime/cursor/agents/skeptic.md
  runtime/cursor/agents/deletion.md
  runtime/cursor/rules/cj-orchestrator-bootstrap.mdc
  runtime/cursor/rules/cj-orchestrator-mandatory.mdc
  runtime/cursor/rules/cj-criollo-changelog.mdc
  runtime/antigravity/agents/skeptic/agent.md
  runtime/antigravity/agents/deletion/agent.md
  runtime/antigravity/rules/spacex-orchestrator.md
  runtime/antigravity/rules/cj-orchestrator-bootstrap.md
  runtime/project/AGENTS.md
  runtime/skills/orchestrator/reference.wsl.md
  runtime/opencode/opencode.jsonc.example
  runtime/codex/config.toml.example
  runtime/codex/agents/orchestrator.toml
  runtime/lock/orchestrator-lock.json.example
)

REQUIRED_CLI=(
  tooling/scripts/Orchestrator.ps1
  tooling/scripts/orchestrator.sh
)

REQUIRED_DOCS=(
  docs/human/FIRST-RUN.md
  docs/human/TEAM-SHARE.md
  docs/agent/AGENT-BOOTSTRAP-PROMPT.md
  docs/maintainer/RELEASE.md
)

is_legacy_exclude() {
  [[ "$(basename "$1")" == "reference.cj-linux.md" ]]
}

check_operational_projects_lab_file() {
  local file="$1"
  is_legacy_exclude "$file" && return 0
  local rel="${file#$PACK_ROOT/}"
  local line_num=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line_num=$((line_num + 1))
    [[ "$line" == *projects/.lab* ]] || [[ "$line" == *projects\\.lab* ]] || continue
    echo "$line" | grep -qiE '(do not|don.t|never|nunca|no usar|NOT|legacy|invalid|\*\*not\*\*|anti.?pattern|forbidden|reject|avoid using|as operational path|operativo en el pack)' && continue
    echo "$line" | grep -qiE '^- Using `projects/\.lab' && continue
    if echo "$line" | grep -qiE 'projects/\.lab/[[:alnum:]_./`-]+|under projects/\.lab|in projects/\.lab|only projects/\.lab|projects/\.lab/<|live in `projects/\.lab|viven en `projects/\.lab'; then
      fail "Operational projects/.lab at ${rel}:${line_num}"
    fi
  done < "$file"
}

scan_operational_projects_lab() {
  local root="$1"
  [[ -d "$root" ]] || return 0
  local found=0
  while IFS= read -r -d '' f; do
    is_legacy_exclude "$f" && continue
    case "$f" in
      */reference.cj-linux.md) continue ;;
    esac
    before=$ERRORS
    check_operational_projects_lab_file "$f"
    [[ $ERRORS -gt $before ]] && found=1
  done < <(find "$root" -type f \( -name '*.md' -o -name '*.mdc' -o -name '*.json' -o -name '*.jsonc' -o -name '*.toml' -o -name '*.example' \) ! -path '*/.install-backup/*' -print0 2>/dev/null)
  [[ $found -eq 0 ]] && pass "No operational projects/.lab under ${root#$PACK_ROOT/}"
}

check_json() {
  local f="$1" label="$2"
  [[ -f "$f" ]] || { warn "JSON missing: $label"; return; }
  if python3 - "$f" <<'PY' 2>/dev/null
import json, sys
json.load(open(sys.argv[1], encoding='utf-8'))
PY
  then
    pass "Valid JSON: $label"
  else
    fail "Invalid JSON: $label"
  fi
}

strip_jsonc_and_validate() {
  local f="$1" label="$2"
  [[ -f "$f" ]] || { warn "JSONC missing: $label"; return; }
  if python3 - "$f" <<'PY' 2>/dev/null
import json, sys

def strip_jsonc(text):
    out = []
    i = 0
    in_string = False
    escape = False
    while i < len(text):
        c = text[i]
        if escape:
            out.append(c)
            escape = False
            i += 1
            continue
        if in_string:
            out.append(c)
            if c == '\\':
                escape = True
            elif c == '"':
                in_string = False
            i += 1
            continue
        if c == '"':
            in_string = True
            out.append(c)
            i += 1
            continue
        if c == '/' and i + 1 < len(text):
            if text[i + 1] == '/':
                while i < len(text) and text[i] != '\n':
                    i += 1
                continue
            if text[i + 1] == '*':
                i += 2
                while i + 1 < len(text) and not (text[i] == '*' and text[i + 1] == '/'):
                    i += 1
                i += min(2, len(text) - i)
                continue
        out.append(c)
        i += 1
    return ''.join(out)

json.loads(strip_jsonc(open(sys.argv[1], encoding='utf-8').read()))
PY
  then
    pass "Valid JSONC: $label"
  else
    fail "Invalid JSONC: $label"
  fi
}

check_toml() {
  local f="$1" label="$2"
  [[ -f "$f" ]] || { warn "TOML missing: $label"; return; }
  if python3 - "$f" <<'PY' 2>/dev/null
import sys
path = sys.argv[1]
try:
    import tomllib
    with open(path, 'rb') as fb:
        tomllib.load(fb)
    sys.exit(0)
except ImportError:
    pass
text = open(path, encoding='utf-8').read()
for key in ('name', 'description'):
    import re
    if not re.search(rf'^\s*{key}\s*=', text, re.M):
        sys.exit(1)
sys.exit(0)
PY
  then
    pass "Valid TOML: $label"
  elif grep -qE '^\s*name\s*=' "$f" && grep -qE '^\s*description\s*=' "$f"; then
    pass "TOML fallback OK: $label"
  else
    fail "Invalid/missing TOML fields: $label"
  fi
}

check_cursor_frontmatter() {
  local f="$1"
  [[ -f "$f" ]] || { fail "Missing cursor agent: $f"; return; }
  head -n1 "$f" | grep -q '^---$' || { fail "No frontmatter: $f"; return; }
  pass "Cursor frontmatter: $(basename "$f")"
}

check_antigravity_frontmatter() {
  local f="$1"
  [[ -f "$f" ]] || { fail "Missing antigravity agent: $f"; return; }
  head -n1 "$f" | grep -q '^---$' || { fail "No frontmatter: $f"; return; }
  pass "Antigravity frontmatter: $(basename "$(dirname "$f")")"
}

check_lock_example_schema() {
  local f="$PACK_ROOT/runtime/lock/orchestrator-lock.json.example"
  [[ -f "$f" ]] || { fail "Missing lock example"; return; }
  python3 - "$f" <<'PY' || { fail "Lock example schema invalid"; return; }
import json, sys
data = json.load(open(sys.argv[1], encoding='utf-8'))
for key in ('schemaVersion', 'version', 'sha256', 'source', 'policy', 'enabled', 'installed_at', 'last_check_at'):
    if key not in data:
        raise SystemExit(1)
if data.get('policy') != 'track-stable':
    raise SystemExit(2)
PY
  pass "Lock example schema OK"
}

check_bootstrap_rule() {
  local f="$PACK_ROOT/runtime/cursor/rules/cj-orchestrator-bootstrap.mdc"
  [[ -f "$f" ]] || { fail "Missing bootstrap rule"; return; }
  grep -q '^alwaysApply: true' "$f" || { fail "Bootstrap rule must have alwaysApply: true"; return; }
  pass "Bootstrap rule present"
}

check_agy_bootstrap_rule() {
  local f="$PACK_ROOT/runtime/antigravity/rules/cj-orchestrator-bootstrap.md"
  [[ -f "$f" ]] || { fail "Missing Antigravity bootstrap rule"; return; }
  grep -qiE 'Always On|Customizations' "$f" || { fail "Antigravity bootstrap must mention Always On / Customizations"; return; }
  grep -q 'orchestrator-lock.json' "$f" || { fail "Antigravity bootstrap must mention .orchestrator-lock.json"; return; }
  grep -qi 'En criollo' "$f" || { fail "Antigravity bootstrap must mention En criollo"; return; }
  pass "Antigravity bootstrap rule present"
}

printf '\nSpaceX Orchestrator Pack Validator\n\n'

for a in "${REQUIRED_ASSETS[@]}"; do
  [[ -f "$PACK_ROOT/$a" ]] && pass "Asset: $a" || fail "Missing asset: $a"
done

for c in "${REQUIRED_CLI[@]}"; do
  [[ -f "$PACK_ROOT/$c" ]] && pass "CLI: $c" || fail "Missing CLI: $c"
done

for d in "${REQUIRED_DOCS[@]}"; do
  [[ -f "$PACK_ROOT/$d" ]] && pass "Doc: $d" || fail "Missing doc: $d"
done

check_lock_example_schema
check_bootstrap_rule
check_agy_bootstrap_rule

[[ -f "$PACK_ROOT/VERSION" ]] && pass "VERSION" || fail "Missing VERSION"

scan_operational_projects_lab "$PACK_ROOT/runtime"
scan_operational_projects_lab "$PACK_ROOT/tooling/sandbox"

for f in "$PACK_ROOT"/runtime/cursor/agents/*.md; do
  [[ -e "$f" ]] && check_cursor_frontmatter "$f"
done
for f in "$PACK_ROOT"/runtime/antigravity/agents/*/agent.md; do
  [[ -e "$f" ]] && check_antigravity_frontmatter "$f"
done

check_json "$PACK_ROOT/runtime/opencode/opencode.json.example" "opencode.json.example"
strip_jsonc_and_validate "$PACK_ROOT/runtime/opencode/opencode.jsonc.example" "opencode.jsonc.example"

for f in "$PACK_ROOT"/runtime/codex/agents/*.toml; do
  [[ -e "$f" ]] && check_toml "$f" "$(basename "$f")"
done
check_toml "$PACK_ROOT/runtime/codex/config.toml.example" "config.toml.example"

if [[ -n "$TARGET" && -d "$TARGET" ]]; then
  for rel in \
    .cursor/agents/orchestrator.md \
    .cursor/agents/skeptic.md \
    .cursor/agents/deletion.md \
    .cursor/rules/cj-orchestrator-bootstrap.mdc \
    .cursor/rules/cj-orchestrator-mandatory.mdc \
    .cursor/rules/cj-criollo-changelog.mdc \
    .agents/agents/skeptic/agent.md \
    .agents/agents/deletion/agent.md \
    .agents/rules/spacex-orchestrator.md \
    .agents/rules/cj-orchestrator-bootstrap.md \
    .agents/skills/orchestrator/reference.wsl.md \
    AGENTS.md \
    .lab/README.md; do
    [[ -f "$TARGET/$rel" ]] && pass "Installed: $rel" || fail "Not installed: $rel"
  done
  if [[ -f "$TARGET/.orchestrator-lock.json" ]]; then
    pass "Project lock present"
    enabled="$(python3 - "$TARGET/.orchestrator-lock.json" <<'PY'
import json, sys
print(json.load(open(sys.argv[1], encoding='utf-8')).get('enabled', False))
PY
)"
    if [[ "$enabled" == "True" || "$enabled" == "true" ]]; then
      [[ -f "$TARGET/.agents/skills/orchestrator/SKILL.md" ]] && pass "Skill present (lock enabled)" || fail "Lock enabled but skill missing"
    fi
  fi
  scan_operational_projects_lab "$TARGET"
fi

printf '\n--- Results ---\n  Passed: %s\n  Warnings: %s\n  Errors: %s\n' "$PASSED" "$WARNINGS" "$ERRORS"

[[ "$STRICT" == true && $WARNINGS -gt 0 ]] && exit 1
[[ $ERRORS -gt 0 ]] && exit 1
printf '\nValidation PASSED.\n'
exit 0
