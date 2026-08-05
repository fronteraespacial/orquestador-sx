#!/usr/bin/env bash
# SpaceX Orchestrator — install-orchestrator.sh (Linux / macOS / WSL)
# Safe, idempotent installer. Default: sandbox/pilot. Requires confirmation.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNTIME_ROOT="$PACK_ROOT/runtime"
DEFAULT_SANDBOX="$PACK_ROOT/tooling/sandbox/pilot"

SCOPE="sandbox"
TARGET=""
YES=false
FORCE=false
REFRESH_SANDBOX=false
INCLUDE_CODEX=false

usage() {
  cat <<'EOF'
Usage: install-orchestrator.sh [OPTIONS]

Safe installer for SpaceX Orchestrator templates (Linux, macOS, WSL).
Default: sandbox/pilot — does NOT install without confirmation.

Options:
  --target PATH       Install destination (default: sandbox/pilot)
  --scope SCOPE       sandbox | project | user  (default: sandbox)
  --refresh-sandbox   Refresh pack-owned assets under pack sandbox/ (backup first)
  --include-codex     Also install Codex templates (.codex/)
  --yes               Skip interactive confirmation
  --force             Reserved; overwrite disabled except --refresh-sandbox
  -h, --help          Show this help

User scope installs ONLY global-safe paths:
  ~/.cursor/agents, ~/.cursor/rules, ~/.agents/skills/orchestrator,
  ~/.config/opencode/opencode.jsonc [, ~/.codex/ with --include-codex]

NOT under user scope (project-level Antigravity — invalid global config):
  ~/.agents/agents/*, ~/GEMINI.md, ~/AGENTS.md, ~/.lab/
EOF
}

log() { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

is_pack_sandbox() {
  local path
  path="$(cd "$1" 2>/dev/null && pwd || echo "$1")"
  local root
  root="$(cd "$PACK_ROOT/tooling/sandbox" && pwd)"
  [[ "$path" == "$root"* ]]
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --scope)  SCOPE="$2"; shift 2 ;;
    --refresh-sandbox) REFRESH_SANDBOX=true; shift ;;
    --include-codex) INCLUDE_CODEX=true; shift ;;
    --yes)    YES=true; shift ;;
    --force)  FORCE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
done

resolve_target() {
  case "$SCOPE" in
    sandbox)
      if [[ -n "$TARGET" ]]; then
        mkdir -p "$TARGET"
        local resolved
        resolved="$(cd "$TARGET" && pwd)"
        is_pack_sandbox "$resolved" || {
          echo "ERROR: --scope sandbox: --target must be under pack sandbox/. Use --scope project for other repos." >&2
          exit 1
        }
        echo "$resolved"
      else
        mkdir -p "$DEFAULT_SANDBOX"
        echo "$DEFAULT_SANDBOX"
      fi
      ;;
    project)
      [[ -n "$TARGET" ]] || { echo "ERROR: --scope project requires --target" >&2; exit 1; }
      [[ -d "$TARGET" ]] || { echo "ERROR: project target not found: $TARGET" >&2; exit 1; }
      cd "$TARGET" && pwd
      ;;
    user)
      [[ "$YES" == true ]] || { echo "ERROR: --scope user requires --yes" >&2; exit 1; }
      echo "$HOME"
      ;;
    *) echo "ERROR: invalid scope: $SCOPE" >&2; exit 1 ;;
  esac
}

confirm_install() {
  local dest="$1"
  if [[ "$YES" == true ]]; then return 0; fi
  log ""
  log "SpaceX Orchestrator will install templates to:"
  log "  $dest"
  log ""
  log "Existing files will NOT be overwritten (unless --refresh-sandbox on pack sandbox)."
  read -r -p "Proceed? [y/N] " reply
  case "$reply" in
    [yY]|[yY][eE][sS]) return 0 ;;
    *) log "Cancelled."; exit 0 ;;
  esac
}

copy_template() {
  local src="$1" dst="$2" allow_overwrite="$3" backup_root="$4" install_target="$5"
  local rel="${src#$RUNTIME_ROOT/}"

  if [[ ! -f "$src" ]]; then
    warn "Missing template: $rel"
    echo "missing:$rel"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]]; then
    if [[ "$allow_overwrite" == true ]]; then
      local backup_rel="${dst#$install_target/}"
      local backup_path="$backup_root/$backup_rel"
      mkdir -p "$(dirname "$backup_path")"
      cp "$dst" "$backup_path" 2>/dev/null || true
      cp "$src" "$dst"
      echo "refreshed:$dst"
      return 0
    fi
    [[ "$FORCE" == true ]] && warn "Force ignored - use --refresh-sandbox for pack sandbox"
    echo "skipped:$dst"
    return 0
  fi

  cp "$src" "$dst"
  echo "copied:$dst"
}

append_project_entries() {
  local -n _arr=$1
  _arr+=(
    "cursor/agents/explore.md|.cursor/agents/explore.md"
    "cursor/agents/scout.md|.cursor/agents/scout.md"
    "cursor/agents/maverick.md|.cursor/agents/maverick.md"
    "cursor/agents/implementer.md|.cursor/agents/implementer.md"
    "cursor/agents/lab-runner.md|.cursor/agents/lab-runner.md"
    "cursor/agents/verifier.md|.cursor/agents/verifier.md"
    "cursor/agents/orchestrator.md|.cursor/agents/orchestrator.md"
    "cursor/agents/skeptic.md|.cursor/agents/skeptic.md"
    "cursor/agents/deletion.md|.cursor/agents/deletion.md"
    "cursor/rules/cj-orchestrator-bootstrap.mdc|.cursor/rules/cj-orchestrator-bootstrap.mdc"
    "cursor/rules/cj-orchestrator-mandatory.mdc|.cursor/rules/cj-orchestrator-mandatory.mdc"
    "cursor/rules/cj-criollo-changelog.mdc|.cursor/rules/cj-criollo-changelog.mdc"
    "antigravity/agents/explore/agent.md|.agents/agents/explore/agent.md"
    "antigravity/agents/scout/agent.md|.agents/agents/scout/agent.md"
    "antigravity/agents/maverick/agent.md|.agents/agents/maverick/agent.md"
    "antigravity/agents/implementer/agent.md|.agents/agents/implementer/agent.md"
    "antigravity/agents/lab-runner/agent.md|.agents/agents/lab-runner/agent.md"
    "antigravity/agents/verifier/agent.md|.agents/agents/verifier/agent.md"
    "antigravity/agents/skeptic/agent.md|.agents/agents/skeptic/agent.md"
    "antigravity/agents/deletion/agent.md|.agents/agents/deletion/agent.md"
    "antigravity/rules/spacex-orchestrator.md|.agents/rules/spacex-orchestrator.md"
    "skills/orchestrator/SKILL.md|.agents/skills/orchestrator/SKILL.md"
    "skills/orchestrator/reference.md|.agents/skills/orchestrator/reference.md"
    "skills/orchestrator/reference.wsl.md|.agents/skills/orchestrator/reference.wsl.md"
    "project/AGENTS.md|AGENTS.md"
    "GEMINI.md|GEMINI.md"
    "project/lab/README.md|.lab/README.md"
    "opencode/opencode.json.example|opencode.json"
    "opencode/opencode.jsonc.example|opencode.jsonc"
  )
}

append_user_entries() {
  local -n _arr=$1
  _arr+=(
    "cursor/agents/explore.md|.cursor/agents/explore.md"
    "cursor/agents/scout.md|.cursor/agents/scout.md"
    "cursor/agents/maverick.md|.cursor/agents/maverick.md"
    "cursor/agents/implementer.md|.cursor/agents/implementer.md"
    "cursor/agents/lab-runner.md|.cursor/agents/lab-runner.md"
    "cursor/agents/verifier.md|.cursor/agents/verifier.md"
    "cursor/agents/orchestrator.md|.cursor/agents/orchestrator.md"
    "cursor/agents/skeptic.md|.cursor/agents/skeptic.md"
    "cursor/agents/deletion.md|.cursor/agents/deletion.md"
    "cursor/rules/cj-orchestrator-bootstrap.mdc|.cursor/rules/cj-orchestrator-bootstrap.mdc"
    "cursor/rules/cj-orchestrator-mandatory.mdc|.cursor/rules/cj-orchestrator-mandatory.mdc"
    "cursor/rules/cj-criollo-changelog.mdc|.cursor/rules/cj-criollo-changelog.mdc"
    "skills/orchestrator/SKILL.md|.agents/skills/orchestrator/SKILL.md"
    "skills/orchestrator/reference.md|.agents/skills/orchestrator/reference.md"
    "skills/orchestrator/reference.wsl.md|.agents/skills/orchestrator/reference.wsl.md"
    "opencode/opencode.jsonc.example|.config/opencode/opencode.jsonc"
  )
}

append_codex_entries() {
  local -n _arr=$1
  _arr+=(
    "codex/agents/orchestrator.toml|.codex/agents/orchestrator.toml"
    "codex/agents/explore.toml|.codex/agents/explore.toml"
    "codex/agents/scout.toml|.codex/agents/scout.toml"
    "codex/agents/maverick.toml|.codex/agents/maverick.toml"
    "codex/agents/lab.toml|.codex/agents/lab.toml"
    "codex/agents/executor_fast.toml|.codex/agents/executor_fast.toml"
    "codex/agents/verifier.toml|.codex/agents/verifier.toml"
    "codex/config.toml.example|.codex/config.toml"
  )
}

INSTALL_TARGET="$(resolve_target)"
VERSION="$(tr -d ' \r\n' < "$PACK_ROOT/VERSION")"

if [[ "$REFRESH_SANDBOX" == true ]]; then
  is_pack_sandbox "$INSTALL_TARGET" || {
    echo "ERROR: --refresh-sandbox only for paths under pack sandbox/" >&2
    exit 1
  }
fi

log ""
log "SpaceX Orchestrator Installer (pack $VERSION)"
log "Target: $INSTALL_TARGET (scope=$SCOPE)"
log ""

confirm_install "$INSTALL_TARGET"

BACKUP_DIR="$INSTALL_TARGET/.install-backup/$(date -u +%Y%m%d-%H%M%S)"
MANIFEST="$INSTALL_TARGET/.install-manifest.json"
mkdir -p "$BACKUP_DIR"

ENTRIES=()
COPIED=()
REFRESHED=()
SKIPPED=()
MISSING=()

copied_count=0
refreshed_count=0
skipped_count=0
missing_count=0

if [[ "$SCOPE" == "user" ]]; then
  append_user_entries ENTRIES
  [[ "$INCLUDE_CODEX" == true ]] && append_codex_entries ENTRIES
  log "User scope: Antigravity agents/GEMINI/AGENTS/.lab excluded (project-level only)."
else
  append_project_entries ENTRIES
  [[ "$INCLUDE_CODEX" == true ]] && append_codex_entries ENTRIES
fi

ALLOW_OVER=false
[[ "$REFRESH_SANDBOX" == true ]] && ALLOW_OVER=true

log "Installing (overwrite=$ALLOW_OVER)..."

for entry in "${ENTRIES[@]}"; do
  src_rel="${entry%%|*}"
  dst_rel="${entry##*|}"
  src="$RUNTIME_ROOT/$src_rel"
  dst="$INSTALL_TARGET/$dst_rel"
  result="$(copy_template "$src" "$dst" "$ALLOW_OVER" "$BACKUP_DIR" "$INSTALL_TARGET")"
  case "$result" in
    copied:*)    COPIED+=("${result#copied:}"); log "  + ${result#copied:}" ;;
    refreshed:*) REFRESHED+=("${result#refreshed:}"); log "  ~ ${result#refreshed:}" ;;
    skipped:*)   SKIPPED+=("${result#skipped:}"); log "  = skip ${result#skipped:}" ;;
    missing:*)   MISSING+=("${result#missing:}"); warn "  ! ${result#missing:}" ;;
  esac
done

copied_count=${#COPIED[@]}
refreshed_count=${#REFRESHED[@]}
skipped_count=${#SKIPPED[@]}
missing_count=${#MISSING[@]}

cat > "$MANIFEST" <<EOF
{
  "pack_version": "$VERSION",
  "installed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "scope": "$SCOPE",
  "target": "$INSTALL_TARGET",
  "refresh_mode": $REFRESH_SANDBOX,
  "copied_count": $copied_count,
  "refreshed_count": $refreshed_count,
  "skipped_count": $skipped_count,
  "missing_count": $missing_count
}
EOF

log ""
log "--- Summary ---"
log "  Copied:    $copied_count"
log "  Refreshed: $refreshed_count"
log "  Skipped:   $skipped_count"
log "  Missing:   $missing_count"
log "  Manifest:  $MANIFEST"
