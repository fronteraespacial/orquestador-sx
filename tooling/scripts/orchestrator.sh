#!/usr/bin/env bash
# SpaceX Orchestrator — orchestrator.sh (Linux / macOS / WSL)
# Unified CLI: init | status | update | uninstall

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install-orchestrator.sh"
DEFAULT_REPO="fronteraespacial/orquestador-sx"
CACHE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/spacex-orchestrator"
USER_LOCK_DIR="$HOME/.spacex-orchestrator"
CHECK_THROTTLE_HOURS=24

COMMAND="status"
SCOPE="project"
SOURCE="local"
VERSION=""
TARGET=""
CONFIRM_USER=false
YES=false
UPDATE_CHECK=false
UPDATE_APPLY=false
WHATIF=false

usage() {
  cat <<'EOF'
Usage: orchestrator.sh <command> [options]

Commands:
  init       Install templates + write lock
  status     Read lock + manifest (no network)
  update     --check (release, 24h throttle) | --apply (verify SHA256, reinstall)
  uninstall  Remove lock files

Options:
  --scope user|project       Default: project
  --source release|local     Default: local (init)
  --version vX.Y.Z           Override version (init)
  --target PATH              Repo root
  --confirm-user-scope       Required for user scope init/uninstall
  --yes                      Skip install confirmation (init)
  --check                    update --check
  --apply                    update --apply
  --whatif                   Preview only (init/apply)
  -h, --help

Release download: gh CLI or HTTPS public assets (no auth).
SHA256: sha256sum or shasum -a 256 (macOS).
EOF
}

log() { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "ERROR: sha256sum or shasum required" >&2
    exit 1
  fi
}

verify_hash_line() {
  local hash="$1" file="$2"
  if command -v sha256sum >/dev/null 2>&1; then
    echo "$hash  $file" | sha256sum -c - >/dev/null
  else
    echo "$hash  $file" | shasum -a 256 -c - >/dev/null
  fi
}

project_lock_path() { echo "$1/.orchestrator-lock.json"; }
user_lock_path() { echo "$USER_LOCK_DIR/lock.json"; }

pack_version() {
  if [[ -n "$VERSION" ]]; then
    echo "${VERSION#v}"
  else
    tr -d ' \r\n' < "$PACK_ROOT/VERSION"
  fi
}

local_pack_sha256() {
  sha256_file "$PACK_ROOT/VERSION"
}

fetch_latest_tag() {
  if command -v gh >/dev/null 2>&1; then
    gh release view --repo "$DEFAULT_REPO" --json tagName -q .tagName
    return
  fi
  command -v curl >/dev/null 2>&1 || { echo "ERROR: gh or curl required for update --check" >&2; exit 1; }
  curl -fsSL "https://api.github.com/repos/$DEFAULT_REPO/releases/latest" |
    python3 -c "import json,sys; print(json.load(sys.stdin)['tag_name'])"
}

download_release_assets() {
  local tag="$1" dest="$2"
  mkdir -p "$dest"
  if command -v gh >/dev/null 2>&1; then
    (cd "$dest" && gh release download "$tag" --repo "$DEFAULT_REPO" --pattern 'SHA256SUMS' --pattern '*.zip')
    return
  fi
  command -v curl >/dev/null 2>&1 || { echo "ERROR: gh or curl required for update --apply" >&2; exit 1; }
  local ver="${tag#v}" base="https://github.com/$DEFAULT_REPO/releases/download/$tag"
  curl -fsSL -o "$dest/SHA256SUMS" "$base/SHA256SUMS"
  local zip=""
  for candidate in "orquestador-sx-v${ver}.zip" "spacex-orchestrator-v${ver}.zip"; do
    if curl -fsSL -o "$dest/$candidate" "$base/$candidate" 2>/dev/null; then
      zip="$candidate"
      break
    fi
  done
  [[ -n "$zip" ]] || { echo "ERROR: release zip not found for $tag" >&2; exit 1; }
}

read_lock_field() {
  local file="$1" field="$2"
  [[ -f "$file" ]] || return 1
  python3 - "$file" "$field" <<'PY'
import json, sys
data = json.load(open(sys.argv[1], encoding='utf-8'))
print(data.get(sys.argv[2], ''))
PY
}

write_lock() {
  local path="$1" ver="$2" sha="$3" src="$4" enabled="${5:-true}" last_check="${6:-}"
  local dir
  dir="$(dirname "$path")"
  mkdir -p "$dir"
  local now
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  python3 - "$path" "$ver" "$sha" "$src" "$enabled" "$now" "$last_check" <<'PY'
import json, sys
path, ver, sha, src, enabled, installed, last_check = sys.argv[1:8]
obj = {
    "schemaVersion": "1.0",
    "version": ver,
    "sha256": sha,
    "source": src,
    "policy": "track-stable",
    "enabled": enabled.lower() == "true",
    "installed_at": installed,
    "last_check_at": last_check or None,
}
with open(path, "w", encoding="utf-8") as f:
    json.dump(obj, f, indent=2)
    f.write("\n")
PY
  log "Lock: $path"
}

cmd_init() {
  local ver target sha install_scope
  ver="$(pack_version)"
  [[ "$SCOPE" == "user" && "$CONFIRM_USER" != true ]] && { echo "ERROR: --confirm-user-scope required" >&2; exit 1; }
  [[ "$SCOPE" == "project" && -z "$TARGET" ]] && { echo "ERROR: --target required for project scope" >&2; exit 1; }

  if [[ "$SCOPE" == "project" ]]; then
    target="$(cd "$TARGET" && pwd)"
  elif [[ -n "$TARGET" ]]; then
    target="$(cd "$TARGET" && pwd)"
  else
    target="$HOME"
  fi

  sha="$(local_pack_sha256)"
  [[ "$SOURCE" == "release" ]] && sha="pending-release-apply"

  log ""
  log "Orchestrator init (scope=$SCOPE, source=$SOURCE, version=$ver)"
  log "Target: $target"
  log ""

  if [[ "$WHATIF" == true ]]; then
    log "WhatIf: would install and write lock (sha256=$sha)"
    return 0
  fi

  install_scope="$SCOPE"
  local yes_flag=""
  [[ "$YES" == true || "$CONFIRM_USER" == true ]] && yes_flag="--yes"
  bash "$INSTALL_SCRIPT" --scope "$install_scope" --target "$target" $yes_flag

  if [[ "$SCOPE" == "project" || -n "$TARGET" ]]; then
    write_lock "$(project_lock_path "$target")" "$ver" "$sha" "$SOURCE"
  fi
  if [[ "$SCOPE" == "user" ]]; then
    write_lock "$(user_lock_path)" "$ver" "$sha" "$SOURCE"
    [[ -n "$TARGET" ]] && write_lock "$(project_lock_path "$target")" "$ver" "$sha" "$SOURCE"
  fi
}

cmd_status() {
  local root="${TARGET:-$(pwd)}"
  root="$(cd "$root" 2>/dev/null && pwd || echo "$root")"
  local plock ulock manifest skill
  plock="$(project_lock_path "$root")"
  ulock="$(user_lock_path)"
  manifest="$root/.install-manifest.json"

  log ""
  log "Orchestrator status (no network)"
  log "Root: $root"

  if [[ -f "$plock" ]]; then
    log ""
    log "Project lock ($plock):"
    log "  version:       $(read_lock_field "$plock" version || true)"
    log "  source:        $(read_lock_field "$plock" source || true)"
    log "  enabled:       $(read_lock_field "$plock" enabled || true)"
    log "  sha256:        $(read_lock_field "$plock" sha256 || true)"
  else
    warn "Project lock MISSING: $plock"
  fi

  [[ -f "$ulock" ]] && log "User lock: $(read_lock_field "$ulock" version || true)"

  if [[ -f "$manifest" ]]; then
    log "Install manifest: present"
  else
    warn "Install manifest: not found"
  fi

  skill="$root/.agents/skills/orchestrator/SKILL.md"
  local enabled
  enabled="$(read_lock_field "$plock" enabled 2>/dev/null || echo "")"
  if [[ "$enabled" == "True" || "$enabled" == "true" ]]; then
    [[ -f "$skill" ]] || { echo "FAIL: skill missing but lock enabled" >&2; exit 1; }
    log "Skill: present"
  fi
}

check_throttled() {
  local plock="$1"
  local last=""
  if [[ -f "$plock" ]]; then
    last="$(read_lock_field "$plock" last_check_at 2>/dev/null || true)"
  fi
  [[ -z "$last" || "$last" == "None" ]] && last=""
  if [[ -z "$last" && -f "$CACHE_ROOT/last-check.json" ]]; then
    last="$(python3 - "$CACHE_ROOT/last-check.json" <<'PY'
import json, sys
print(json.load(open(sys.argv[1])).get("last_check_at") or "")
PY
)"
  fi
  if [[ -n "$last" ]]; then
    python3 - "$last" "$CHECK_THROTTLE_HOURS" <<'PY'
import sys
from datetime import datetime, timedelta, timezone
last = datetime.fromisoformat(sys.argv[1].replace("Z", "+00:00"))
if datetime.now(timezone.utc) < last + timedelta(hours=int(sys.argv[2])):
    sys.exit(0)
sys.exit(1)
PY
    if [[ $? -eq 0 ]]; then
      log "Check skipped (24h throttle)"
      exit 0
    fi
  fi
}

save_check_ts() {
  local root="$1"
  mkdir -p "$CACHE_ROOT"
  local now
  now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "{\"last_check_at\": \"$now\"}" > "$CACHE_ROOT/last-check.json"
  local plock
  plock="$(project_lock_path "$root")"
  if [[ -f "$plock" ]]; then
    local ver sha src enabled installed
    ver="$(read_lock_field "$plock" version)"
    sha="$(read_lock_field "$plock" sha256)"
    src="$(read_lock_field "$plock" source)"
    enabled="$(read_lock_field "$plock" enabled)"
    installed="$(read_lock_field "$plock" installed_at)"
    write_lock "$plock" "$ver" "$sha" "$src" "$enabled" "$now"
    python3 - "$plock" "$installed" <<'PY'
import json, sys
p, inst = sys.argv[1], sys.argv[2]
d = json.load(open(p, encoding="utf-8"))
d["installed_at"] = inst
json.dump(d, open(p, "w", encoding="utf-8"), indent=2)
open(p, "a").write("\n")
PY
  fi
}

cmd_update_check() {
  local root="${TARGET:-$(pwd)}"
  root="$(cd "$root" && pwd)"
  local plock
  plock="$(project_lock_path "$root")"
  check_throttled "$plock"

  local current remote
  current="$(read_lock_field "$plock" version 2>/dev/null || pack_version)"
  remote="$(fetch_latest_tag | sed 's/^v//')"
  save_check_ts "$root"

  if [[ "$current" == "$remote" ]]; then
    log "Up to date ($remote)."
  else
    log "Update available: $current -> $remote"
    log "Run: orchestrator.sh update --apply --target $root"
  fi
}

verify_sha256sums() {
  local dir="$1"
  local sums
  sums="$(find "$dir" -maxdepth 1 -name 'SHA256SUMS' | head -1)"
  [[ -n "$sums" ]] || { echo "ERROR: SHA256SUMS missing" >&2; exit 1; }
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    local hash file
    hash="${line%%  *}"
    file="${line#*  }"
    file="${file// /}"
    verify_hash_line "$hash" "$file"
    log "  verified $file"
  done < "$sums"
}

cmd_update_apply() {
  local root="${TARGET:-$(pwd)}"
  root="$(cd "$root" && pwd)"

  local tag ver work_dir
  tag="$(fetch_latest_tag)"
  ver="${tag#v}"
  work_dir="$CACHE_ROOT/apply-$tag"
  rm -rf "$work_dir"
  mkdir -p "$work_dir"

  log "Downloading $tag..."
  download_release_assets "$tag" "$work_dir"
  (cd "$work_dir" && verify_sha256sums ".")

  local zip extract
  zip="$(find "$work_dir" -maxdepth 1 -name '*.zip' | head -1)"
  extract="$work_dir/extract"
  mkdir -p "$extract"
  unzip -q "$zip" -d "$extract"
  local extracted
  extracted="$(find "$extract" -mindepth 1 -maxdepth 1 -type d | head -1)"

  if [[ "$WHATIF" == true ]]; then
    log "WhatIf: would reinstall from $(basename "$zip")"
    return 0
  fi

  bash "$extracted/tooling/scripts/install-orchestrator.sh" --scope project --target "$root" --yes
  local zip_hash
  zip_hash="$(sha256_file "$zip")"
  write_lock "$(project_lock_path "$root")" "$ver" "$zip_hash" "release" true "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  log "Update applied: $ver"
}

cmd_uninstall() {
  [[ "$SCOPE" == "user" && "$CONFIRM_USER" != true ]] && { echo "ERROR: --confirm-user-scope required" >&2; exit 1; }
  if [[ "$SCOPE" == "user" ]]; then
    rm -f "$(user_lock_path)"
    log "Removed user lock"
  fi
  if [[ "$SCOPE" == "project" || -n "$TARGET" ]]; then
    local root
    root="$(cd "${TARGET:?--target required}" && pwd)"
    rm -f "$(project_lock_path "$root")"
    log "Removed project lock"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    init|status|update|uninstall) COMMAND="$1"; shift ;;
    --scope) SCOPE="$2"; shift 2 ;;
    --source) SOURCE="$2"; shift 2 ;;
    --version) VERSION="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --confirm-user-scope) CONFIRM_USER=true; shift ;;
    --yes) YES=true; shift ;;
    --check) UPDATE_CHECK=true; shift ;;
    --apply) UPDATE_APPLY=true; shift ;;
    --whatif) WHATIF=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown: $1" >&2; usage; exit 1 ;;
  esac
done

case "$COMMAND" in
  init) cmd_init ;;
  status) cmd_status ;;
  update)
    if [[ "$UPDATE_APPLY" == true ]]; then cmd_update_apply
    else cmd_update_check
    fi
    ;;
  uninstall) cmd_uninstall ;;
  *) usage; exit 1 ;;
esac
