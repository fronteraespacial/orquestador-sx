# SpaceX Orchestrator — Validate-OrchestratorPack.ps1

[CmdletBinding()]
param(
    [Parameter()]
    [string] $PackRoot = '',

    [Parameter()]
    [string] $TargetPath = '',

    [Parameter()]
    [switch] $Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

if (-not $PackRoot) {
    $PackRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
}

$script:Errors = [System.Collections.Generic.List[string]]::new()
$script:Warnings = [System.Collections.Generic.List[string]]::new()
$script:Passed = 0
$script:ErrorCountAtStart = $Error.Count

function Add-Error { param([string] $Msg) $script:Errors.Add($Msg); Write-Host "FAIL: $Msg" -ForegroundColor Red }
function Add-Warn  { param([string] $Msg) $script:Warnings.Add($Msg); Write-Host "WARN: $Msg" -ForegroundColor Yellow }
function Add-Pass  { param([string] $Msg) $script:Passed++; Write-Host "PASS: $Msg" -ForegroundColor Green }

function Test-RuntimeErrors {
    $newErrors = @($Error | Select-Object -Skip $script:ErrorCountAtStart)
    foreach ($entry in $newErrors) {
        $origin = $entry.InvocationInfo.ScriptName
        if ($origin -and $origin -like '*Validate-OrchestratorPack.ps1*') {
            Add-Error "Runtime error: $($entry.Exception.Message)"
        }
    }
}

$RequiredRuntimeAssets = @(
    'runtime/cursor/agents/orchestrator.md',
    'runtime/cursor/agents/verifier-like-human.md',
    'runtime/cursor/agents/diagnostic.md',
    'runtime/cursor/agents/skeptic.md',
    'runtime/cursor/agents/deletion.md',
    'runtime/cursor/rules/cj-orchestrator-bootstrap.mdc',
    'runtime/cursor/rules/cj-orchestrator-mandatory.mdc',
    'runtime/cursor/rules/cj-criollo-changelog.mdc',
    'runtime/antigravity/agents/skeptic/agent.md',
    'runtime/antigravity/agents/deletion/agent.md',
    'runtime/antigravity/rules/spacex-orchestrator.md',
    'runtime/antigravity/rules/cj-orchestrator-bootstrap.md',
    'runtime/antigravity/GEMINI.user.md',
    'runtime/antigravity/scaffold-manifest.json',
    'runtime/antigravity/SCAFFOLD-FETCH.md',
    'runtime/project/AGENTS.md',
    'runtime/skills/orchestrator/reference.wsl.md',
    'runtime/skills/orchestrator/reference.antigravity.md',
    'runtime/opencode/opencode.jsonc.example',
    'runtime/codex/config.toml.example',
    'runtime/codex/agents/orchestrator.toml',
    'runtime/codex/agents/verifier_like_human.toml',
    'runtime/lock/orchestrator-lock.json.example'
)

$RequiredCliScripts = @(
    'tooling/scripts/Orchestrator.ps1',
    'tooling/scripts/orchestrator.sh',
    'tooling/scripts/orchestrator',
    'tooling/scripts/install-orchestrator.sh'
)

$RequiredDocsWaveB = @(
    'docs/human/FIRST-RUN.md',
    'docs/human/TEAM-SHARE.md',
    'docs/agent/AGENT-BOOTSTRAP-PROMPT.md',
    'docs/agent/DEVICE-INSTALL-PROMPT.md',
    'docs/agent/UPDATE-PHRASE.md',
    'docs/maintainer/RELEASE.md'
)

$LegacyExcludeFiles = @(
    'reference.cj-linux.md'
)

function Test-RequiredPaths {
    $canonDocs = @(
        'canon/00-README-INSTALL-AGENT.md', 'canon/01-METHODOLOGY-SPACEX.md', 'canon/02-ROLES-HANDOFFS-GATES.md',
        'canon/07-MODELS-MATRIX.md', 'canon/09-VERIFY-CHECKLIST.md'
    )
    foreach ($doc in $canonDocs) {
        if (Test-Path (Join-Path $PackRoot $doc)) { Add-Pass "Canon: $doc" }
        else { Add-Error "Missing canon doc: $doc" }
    }

    $installDocs = @(
        'docs/human/install/cursor-windows.md',
        'docs/human/install/antigravity-windows.md',
        'docs/human/install/opencode-windows.md',
        'docs/human/install/codex-windows.md',
        'docs/human/TEAM-ONBOARDING.md'
    )
    foreach ($doc in $installDocs) {
        if (Test-Path (Join-Path $PackRoot $doc)) { Add-Pass "Human doc: $doc" }
        else { Add-Error "Missing human doc: $doc" }
    }

    $stubDocs = @(
        '00-README-INSTALL-AGENT.md', '01-METHODOLOGY-SPACEX.md', '02-ROLES-HANDOFFS-GATES.md',
        '03-INSTALL-CURSOR-WINDOWS.md', '04-INSTALL-ANTIGRAVITY-WINDOWS.md',
        '05-INSTALL-OPENCODE-WINDOWS.md', '06-INSTALL-CODEX-WINDOWS.md',
        '07-MODELS-MATRIX.md', '08-IMPROVEMENTS-FUTURE-AGENTS.md', '09-VERIFY-CHECKLIST.md',
        'TEAM-ONBOARDING.md'
    )
    foreach ($doc in $stubDocs) {
        if (Test-Path (Join-Path $PackRoot $doc)) { Add-Pass "Stub: $doc" }
        else { Add-Warn "Missing root stub: $doc" }
    }

    foreach ($rel in @('canon', 'runtime', 'runtime/cursor/agents', 'runtime/antigravity/agents',
        'runtime/antigravity/rules', 'runtime/codex/agents', 'runtime/lock', 'tooling/scripts',
        'tooling/bench', 'tooling/sandbox', 'docs/human', 'docs/agent', 'docs/maintainer', 'start')) {
        if (Test-Path (Join-Path $PackRoot $rel)) { Add-Pass "Dir: $rel" }
        else { Add-Error "Missing dir: $rel" }
    }

    foreach ($asset in $RequiredRuntimeAssets) {
        if (Test-Path (Join-Path $PackRoot $asset)) { Add-Pass "Asset: $asset" }
        else { Add-Error "Missing runtime asset: $asset" }
    }

    foreach ($script in $RequiredCliScripts) {
        if (Test-Path (Join-Path $PackRoot $script)) { Add-Pass "CLI: $script" }
        else { Add-Error "Missing CLI script: $script" }
    }

    foreach ($doc in $RequiredDocsWaveB) {
        if (Test-Path (Join-Path $PackRoot $doc)) { Add-Pass "Doc: $doc" }
        else { Add-Error "Missing doc: $doc" }
    }

    if (Test-Path (Join-Path $PackRoot 'VERSION')) { Add-Pass 'VERSION present' }
    else { Add-Error 'Missing VERSION' }

    if (Test-Path (Join-Path $PackRoot 'AGENTS.md')) { Add-Pass 'Root AGENTS.md present' }
    else { Add-Error 'Missing root AGENTS.md' }
}

function Test-NoOperationalLabDir {
    $lab = Join-Path $PackRoot 'projects\.lab'
    if (-not (Test-Path -LiteralPath $lab)) {
        Add-Pass 'No projects/.lab directory in pack root'
        return
    }
    $entries = Get-ChildItem -LiteralPath $lab -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notin @('README.md', '.gitkeep') }
    if ($entries.Count -gt 0) {
        Add-Error "Operational projects/.lab content ($($entries.Count) entries)"
    }
    else {
        Add-Pass 'projects/.lab placeholder only'
    }
}

function Test-OperationalProjectsLabInFile {
    param([string] $FilePath)

    $name = Split-Path $FilePath -Leaf
    foreach ($ex in $LegacyExcludeFiles) {
        if ($name -eq $ex) { return }
    }

    $rel = $FilePath
    if ($FilePath.StartsWith($PackRoot)) {
        $rel = $FilePath.Substring($PackRoot.Length).TrimStart('\', '/')
    }

    $lines = Get-Content -LiteralPath $FilePath -ErrorAction SilentlyContinue
    $i = 0
    foreach ($line in $lines) {
        $i++
        if ($line -notmatch 'projects/\.lab|projects\\\.lab') { continue }

        # Allow explicit legacy warnings / negations / anti-pattern lists
        if ($line -match '(?i)(do\s+not|don''t|never|nunca|no usar|NOT|legacy|invalid|\*\*not\*\*)') { continue }
        if ($line -match '(?i)(anti.?pattern|forbidden|reject|avoid using|do not use|as operational path|operativo en el pack)') { continue }
        if ($line -match '(?i)^-\s+Using\s+`projects/\.lab') { continue }

        # Operational usage patterns
        if ($line -match '(?i)(projects/\.lab/[\w`<\-/]+|under projects/\.lab|in projects/\.lab|only projects/\.lab|projects/\.lab/<|live in `projects/\.lab|viven en `projects/\.lab)') {
            Add-Error "Operational projects/.lab at ${rel}:${i}"
        }
    }
}

function Test-OperationalProjectsLab {
    param([string[]] $ScanRoots)

    foreach ($root in $ScanRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                ($_.Extension -match '^\.(md|mdc|json|jsonc|toml|example)$' -or $_.Name -match '\.(md|mdc|json|toml)$') -and
                $_.FullName -notmatch '\\\.install-backup\\'
            } |
            ForEach-Object { Test-OperationalProjectsLabInFile -FilePath $_.FullName }
    }

    $errCount = @($script:Errors | Where-Object { $_ -like 'Operational projects/.lab*' }).Count
    if ($errCount -eq 0) {
        Add-Pass "No operational projects/.lab in scanned roots"
    }
}

function Test-CursorFrontmatter {
    param([string[]] $Files)
    foreach ($file in $Files) {
        if (-not (Test-Path -LiteralPath $file)) { Add-Error "Missing cursor agent: $file"; continue }
        $content = Get-Content -LiteralPath $file -Raw
        if ($content -notmatch '(?s)^---\r?\n(.+?)\r?\n---') {
            Add-Error "No YAML frontmatter: $(Split-Path $file -Leaf)"; continue
        }
        $fm = $Matches[1]
        Add-Pass "Cursor frontmatter: $(Split-Path $file -Leaf)"
        if ($fm -notmatch '(?m)^\s*name\s*:') { Add-Warn "Missing name: $(Split-Path $file -Leaf)" }
        if (($file -notmatch 'orchestrator') -and ($fm -notmatch '(?m)^\s*model\s*:')) {
            Add-Warn "Missing model: $(Split-Path $file -Leaf)"
        }
    }
}

function Test-AntigravityFrontmatter {
    param([string[]] $Files)
    foreach ($file in $Files) {
        if (-not (Test-Path -LiteralPath $file)) { Add-Error "Missing antigravity agent: $file"; continue }
        $content = Get-Content -LiteralPath $file -Raw
        if ($content -notmatch '(?s)^---\r?\n(.+?)\r?\n---') {
            Add-Error "No YAML frontmatter: $file"; continue
        }
        $fm = $Matches[1]
        Add-Pass "Antigravity frontmatter: $(Split-Path (Split-Path $file -Parent) -Leaf)"
        if ($fm -notmatch '(?m)^\s*(description|model)\s*:') {
            Add-Warn "Missing description/model: $file"
        }
    }
}

function Remove-JsoncComments {
    param([string] $Text)
    $out = [System.Text.StringBuilder]::new()
    $i = 0
    $inString = $false
    $escape = $false
    while ($i -lt $Text.Length) {
        $c = $Text[$i]
        if ($escape) { [void]$out.Append($c); $escape = $false; $i++; continue }
        if ($c -eq '\' -and $inString) { [void]$out.Append($c); $escape = $true; $i++; continue }
        if ($c -eq '"') { $inString = -not $inString; [void]$out.Append($c); $i++; continue }
        if (-not $inString -and $c -eq '/' -and ($i + 1) -lt $Text.Length -and $Text[$i + 1] -eq '/') {
            while ($i -lt $Text.Length -and $Text[$i] -ne "`n") { $i++ }
            continue
        }
        if (-not $inString -and $c -eq '/' -and ($i + 1) -lt $Text.Length -and $Text[$i + 1] -eq '*') {
            $i += 2
            while ($i -lt ($Text.Length - 1) -and -not ($Text[$i] -eq '*' -and $Text[$i + 1] -eq '/')) { $i++ }
            $i += 2
            continue
        }
        [void]$out.Append($c)
        $i++
    }
    return $out.ToString()
}

function Test-JsonFile {
    param([string] $Path, [string] $Label)
    if (-not (Test-Path -LiteralPath $Path)) { Add-Warn "JSON missing: $Label"; return }
    try {
        Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json | Out-Null
        Add-Pass "Valid JSON: $Label"
    }
    catch { Add-Error "Invalid JSON ($Label): $_" }
}

function Test-JsoncFile {
    param([string] $Path, [string] $Label)
    if (-not (Test-Path -LiteralPath $Path)) { Add-Warn "JSONC missing: $Label"; return }
    try {
        $raw = Get-Content -LiteralPath $Path -Raw
        $stripped = Remove-JsoncComments -Text $raw
        $stripped | ConvertFrom-Json | Out-Null
        Add-Pass "Valid JSONC: $Label"
    }
    catch { Add-Error "Invalid JSONC ($Label): $_" }
}

function Test-TomlFile {
    param([string] $Path, [string] $Label)
    if (-not (Test-Path -LiteralPath $Path)) { Add-Warn "TOML missing: $Label"; return }

    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        $script = @"
import sys
try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib
    except ImportError:
        tomllib = None
path = sys.argv[1]
if tomllib:
    with open(path, 'rb') as f:
        tomllib.load(f)
    sys.exit(0)
sys.exit(2)
"@
        $exit = 0
        $null = $script | & python - $Path 2>&1
        $exit = $LASTEXITCODE
        if ($exit -eq 0) { Add-Pass "Valid TOML (tomllib): $Label"; return }
        if ($exit -eq 2) { Write-Verbose 'tomllib unavailable — fallback field check' }
        else { Add-Error "Invalid TOML ($Label) per tomllib"; return }
    }

    $text = Get-Content -LiteralPath $Path -Raw
    $required = @('name', 'description')
    foreach ($key in $required) {
        if ($text -notmatch "(?m)^\s*$key\s*=") {
            Add-Error "TOML fallback: missing '$key' in $Label"
            return
        }
    }
    Add-Pass "TOML fallback fields OK: $Label"
}

function Test-CodexHostWiring {
    $agentsDir = Join-Path $PackRoot 'runtime\codex\agents'
    $example = Join-Path $PackRoot 'runtime\codex\config.toml.example'
    $skill = Join-Path $PackRoot 'runtime\skills\orchestrator\SKILL.md'
    $reference = Join-Path $PackRoot 'runtime\skills\orchestrator\reference.md'

    Get-ChildItem (Join-Path $agentsDir '*.toml') -ErrorAction SilentlyContinue | ForEach-Object {
        $text = Get-Content -LiteralPath $_.FullName -Raw
        $label = $_.Name
        if ($text -match 'remap-after-codex') {
            Add-Error "Codex agent still has placeholder remap-after-codex: $label"
        }
        if ($text -match '(?i)STATUS:\s*deferred') {
            Add-Error "Codex agent still STATUS deferred: $label"
        }
        if ($text -notmatch '(?m)^\s*model\s*=\s*"gpt-5\.6-') {
            Add-Error "Codex agent missing gpt-5.6 model pin: $label"
        }
        if ($text -notmatch '(?m)^\s*model_reasoning_effort\s*=') {
            Add-Error "Codex agent missing model_reasoning_effort: $label"
        }
        else {
            Add-Pass "Codex model+effort pins: $label"
        }
    }

    if (Test-Path -LiteralPath $example) {
        $ex = Get-Content -LiteralPath $example -Raw
        if ($ex -match '(?m)^\s*max_depth\s*=') {
            Add-Error 'config.toml.example must not set max_depth (not in official schema)'
        }
        if ($ex -notmatch 'default_subagent_model\s*=\s*"gpt-5\.6-luna"') {
            Add-Error 'config.toml.example must set default_subagent_model = "gpt-5.6-luna"'
        }
        if ($ex -notmatch 'default_subagent_reasoning_effort\s*=\s*"medium"') {
            Add-Error 'config.toml.example must set default_subagent_reasoning_effort = "medium"'
        }
        if ($ex -notmatch 'max_concurrent_threads_per_session\s*=\s*4') {
            Add-Error 'config.toml.example must set max_concurrent_threads_per_session = 4'
        }
        else {
            Add-Pass 'Codex config.toml.example [agents] defaults OK'
        }
    }

    foreach ($pair in @(
            @{ Path = $skill; Label = 'SKILL.md' },
            @{ Path = $reference; Label = 'reference.md' }
        )) {
        if (-not (Test-Path -LiteralPath $pair.Path)) {
            Add-Error "Missing $($pair.Label) for Codex wiring check"
            continue
        }
        $t = Get-Content -LiteralPath $pair.Path -Raw
        if ($t -notmatch 'Codex') {
            Add-Error "$($pair.Label) must mention Codex"
        }
        if ($t -notmatch 'gpt-5\.6' -and $t -notmatch 'default_subagent') {
            Add-Error "$($pair.Label) must mention gpt-5.6 or default_subagent (Codex Host remap)"
        }
        else {
            Add-Pass "Codex wiring documented in $($pair.Label)"
        }
    }

    $installer = Join-Path $PackRoot 'tooling\scripts\Install-Orchestrator.ps1'
    if (Test-Path -LiteralPath $installer) {
        $inst = Get-Content -LiteralPath $installer -Raw
        if ($inst -notmatch 'Test-CodexHostReady' -or $inst -notmatch 'Merge-CodexAgentsConfig') {
            Add-Error 'Install-Orchestrator.ps1 must define Test-CodexHostReady and Merge-CodexAgentsConfig'
        }
        else {
            Add-Pass 'Installer Codex Desktop-first + merge helpers present'
        }
    }
}

function Test-GatesDocumented {
    $gateFiles = @(
        'runtime\cursor\rules\cj-orchestrator-mandatory.mdc',
        'runtime\GEMINI.md',
        'runtime\antigravity\rules\spacex-orchestrator.md',
        'canon\02-ROLES-HANDOFFS-GATES.md'
    )
    $patterns = @('REQUIRED', 'lab', 'maverick', 'verifier', 'APPROVE')
    foreach ($gf in $gateFiles) {
        $p = Join-Path $PackRoot $gf
        if (-not (Test-Path -LiteralPath $p)) { Add-Warn "Gate file missing: $gf"; continue }
        $text = Get-Content -LiteralPath $p -Raw
        $found = ($patterns | Where-Object { $text -match $_ }).Count
        if ($found -ge 3) { Add-Pass "Gates in $(Split-Path $gf -Leaf) ($found/5)" }
        else { Add-Warn "Few gates in $(Split-Path $gf -Leaf)" }
    }
}

function Test-SecretPatterns {
    param([string[]] $ScanRoots)
    $patterns = @(
        '(?i)\bsk-[a-zA-Z0-9]{20,}\b',
        '(?i)\bghp_[a-zA-Z0-9]{20,}\b',
        '(?i)\bAKIA[0-9A-Z]{16}\b',
        '(?i)(api[_-]?key|secret[_-]?key|password)\s*=\s*[''"][^''"\s]{8,}[''"]'
    )
    $skipDirs = @('node_modules', '.git', 'tooling\bench\results', 'tooling\bench\worktrees', '.install-backup')
    $foundSecret = $false
    foreach ($root in $ScanRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $rel = $_.FullName.Substring($root.Length)
                (-not ($skipDirs | Where-Object { $rel -like "*$_*" })) -and
                ($_.FullName -notmatch '\\\.install-backup\\')
            } |
            ForEach-Object {
                $lines = Get-Content -LiteralPath $_.FullName -ErrorAction SilentlyContinue
                $i = 0
                foreach ($line in $lines) {
                    $i++
                    foreach ($pat in $patterns) {
                        if ($line -match $pat) {
                            $relPath = $_.FullName.Substring($PackRoot.Length).TrimStart('\', '/')
                            Add-Error "Possible secret ${relPath}:${i}"
                            $foundSecret = $true
                            break
                        }
                    }
                }
            }
    }
    if (-not $foundSecret) { Add-Pass 'No common secret patterns' }
}

function Test-LockExampleSchema {
    $path = Join-Path $PackRoot 'runtime\lock\orchestrator-lock.json.example'
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Error 'Missing lock example'
        return
    }
    try {
        $lock = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
    }
    catch {
        Add-Error "Invalid lock example JSON: $_"
        return
    }

    $required = @('schemaVersion', 'version', 'sha256', 'source', 'policy', 'enabled', 'installed_at', 'last_check_at')
    foreach ($key in $required) {
        if ($null -eq $lock.PSObject.Properties[$key]) {
            Add-Error "Lock example missing field: $key"
            return
        }
    }
    if ($lock.policy -ne 'track-stable') {
        Add-Warn "Lock example policy is not track-stable: $($lock.policy)"
    }
    Add-Pass 'Lock example schema OK'
}

function Test-BootstrapRule {
    $path = Join-Path $PackRoot 'runtime\cursor\rules\cj-orchestrator-bootstrap.mdc'
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Error 'Missing bootstrap rule'
        return
    }
    $raw = Get-Content -LiteralPath $path -Raw
    if ($raw -notmatch '(?m)^alwaysApply:\s*true') {
        Add-Error 'Bootstrap rule must have alwaysApply: true'
        return
    }
    $parts = @($raw -split '(?m)^---\s*$' | Where-Object { $null -ne $_ })
    if ($parts.Count -lt 2) {
        Add-Error 'Bootstrap rule missing frontmatter/body'
        return
    }
    $body = if ($parts.Count -ge 3) { $parts[2] } else { '' }
    $bodyLines = @($body -split '\r?\n' | Where-Object { $_.Trim() -ne '' }).Count
    if ($bodyLines -gt 10) {
        Add-Warn "Bootstrap rule body has $bodyLines lines (target <=10)"
    }
    Add-Pass 'Bootstrap rule present'
}

function Test-AgyBootstrapRule {
    $path = Join-Path $PackRoot 'runtime\antigravity\rules\cj-orchestrator-bootstrap.md'
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Error 'Missing Antigravity bootstrap rule'
        return
    }
    $raw = Get-Content -LiteralPath $path -Raw
    if ($raw -notmatch '(?i)Always On|Customizations') {
        Add-Error 'Antigravity bootstrap must mention Always On / Customizations'
        return
    }
    if ($raw -notmatch '(?i)orchestrator-lock\.json') {
        Add-Error 'Antigravity bootstrap must mention .orchestrator-lock.json'
        return
    }
    if ($raw -notmatch '(?i)En criollo') {
        Add-Error 'Antigravity bootstrap must mention En criollo'
        return
    }
    $bodyLines = @($raw -split '\r?\n' | Where-Object { $_.Trim() -ne '' }).Count
    if ($bodyLines -gt 20) {
        Add-Warn "Antigravity bootstrap has $bodyLines lines (target micro rule)"
    }
    Add-Pass 'Antigravity bootstrap rule present'
}

function Test-AgyAgentNative {
    $skillPath = Join-Path $PackRoot 'runtime\skills\orchestrator\SKILL.md'
    if (-not (Test-Path -LiteralPath $skillPath)) {
        Add-Error 'Missing SKILL.md for agent-native check'
        return
    }
    $skill = Get-Content -LiteralPath $skillPath -Raw
    if ($skill -notmatch '(?i)define_subagent') {
        Add-Error 'SKILL.md must document define_subagent for Antigravity 2.0'
        return
    }
    if ($skill -notmatch '(?i)agent-native') {
        Add-Error 'SKILL.md must document agent-native bootstrap'
        return
    }

    $refPath = Join-Path $PackRoot 'runtime\skills\orchestrator\reference.antigravity.md'
    if (-not (Test-Path -LiteralPath $refPath)) {
        Add-Error 'Missing reference.antigravity.md'
        return
    }

    $manifestPath = Join-Path $PackRoot 'runtime\antigravity\scaffold-manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        Add-Error 'Missing runtime/antigravity/scaffold-manifest.json'
        return
    }

    try {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        if (-not $manifest.rawBase) {
            Add-Error 'scaffold-manifest.json must define rawBase for GitHub fetch'
            return
        }
        if (-not $manifest.integrityMarkers) {
            Add-Error 'scaffold-manifest.json must define integrityMarkers'
            return
        }
    }
    catch {
        Add-Error "scaffold-manifest.json invalid JSON: $_"
        return
    }

    $fetchGuide = Join-Path $PackRoot 'runtime\antigravity\SCAFFOLD-FETCH.md'
    if (-not (Test-Path -LiteralPath $fetchGuide)) {
        Add-Error 'Missing runtime/antigravity/SCAFFOLD-FETCH.md'
        return
    }

    $geminiUser = Join-Path $PackRoot 'runtime\antigravity\GEMINI.user.md'
    if (Test-Path -LiteralPath $geminiUser) {
        $gu = Get-Content -LiteralPath $geminiUser -Raw
        if ($gu -match '(?i)init -Scope project' -and $gu -notmatch '(?i)agent-native|materializ|in-repo|FETCH|COPY') {
            Add-Error 'GEMINI.user.md must not mandate CLI project init without agent-native path'
            return
        }
        if ($gu -match '(?i)(?<!(never |not ))generate.*(`\.agents|SKILL\.md)') {
            Add-Error 'GEMINI.user.md must not instruct agent to generate SKILL — use FETCH/COPY'
            return
        }
        if ($gu -notmatch '(?i)FETCH|COPY') {
            Add-Error 'GEMINI.user.md must instruct FETCH/COPY for canonical scaffold'
            return
        }
        if ($gu -notmatch 'T0') {
            Add-Error 'GEMINI.user.md must document integrity markers (T0–T3)'
            return
        }
    }

    Add-Pass 'Antigravity agent-native wiring present'
}

function Test-GeminiUserTemplate {
    $path = Join-Path $PackRoot 'runtime\antigravity\GEMINI.user.md'
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Error 'Missing Antigravity user GEMINI template (runtime/antigravity/GEMINI.user.md)'
        return
    }
    $raw = Get-Content -LiteralPath $path -Raw
    if ($raw -notmatch '(?i)orchestrator-lock\.json') {
        Add-Error 'GEMINI.user.md must mention .orchestrator-lock.json'
        return
    }
    if ($raw -notmatch '(?i)Never init alone|Never initialize without user approval|Nunca init') {
        Add-Error 'GEMINI.user.md must forbid init alone'
        return
    }
    if ($raw -notmatch '(?i)En criollo') {
        Add-Error 'GEMINI.user.md must mention En criollo'
        return
    }
    if ($raw -match '(?i)(?<!(never |not ))generate.*(`\.agents|SKILL\.md)') {
        Add-Error 'GEMINI.user.md must not instruct agent to generate SKILL — use FETCH/COPY'
        return
    }
    if ($raw -notmatch '(?i)FETCH|COPY') {
        Add-Error 'GEMINI.user.md must instruct FETCH/COPY for canonical scaffold'
        return
    }
    $lineCount = @($raw -split '\r?\n').Count
    if ($lineCount -gt 15) {
        Add-Warn "GEMINI.user.md has $lineCount lines (target micro <=15)"
    }
    Add-Pass 'Antigravity user GEMINI template present'
}

function Test-InstallTarget {
    param([string] $Target)
    if (-not $Target -or -not (Test-Path -LiteralPath $Target)) {
        if ($Target) { Add-Warn "Install target missing: $Target" }
        return
    }
    $expected = @(
        '.cursor\agents\orchestrator.md',
        '.cursor\agents\verifier-like-human.md',
        '.cursor\agents\diagnostic.md',
        '.cursor\agents\skeptic.md',
        '.cursor\agents\deletion.md',
        '.cursor\rules\cj-orchestrator-bootstrap.mdc',
        '.cursor\rules\cj-orchestrator-mandatory.mdc',
        '.cursor\rules\cj-criollo-changelog.mdc',
        '.agents\agents\skeptic\agent.md',
        '.agents\agents\deletion\agent.md',
        '.agents\rules\spacex-orchestrator.md',
        '.agents\rules\cj-orchestrator-bootstrap.md',
        '.agents\skills\orchestrator\reference.wsl.md',
        'AGENTS.md',
        '.lab\README.md'
    )
    foreach ($rel in $expected) {
        $p = Join-Path $Target $rel
        if (Test-Path -LiteralPath $p) { Add-Pass "Installed: $rel" }
        else { Add-Error "Not installed: $rel" }
    }

    $lockPath = Join-Path $Target '.orchestrator-lock.json'
    if (Test-Path -LiteralPath $lockPath) {
        try {
            $lock = Get-Content -LiteralPath $lockPath -Raw | ConvertFrom-Json
            Add-Pass 'Project lock present'
            if ($lock.enabled -eq $true) {
                $skill = Join-Path $Target '.agents\skills\orchestrator\SKILL.md'
                if (Test-Path -LiteralPath $skill) { Add-Pass 'Skill present (lock enabled)' }
                else { Add-Error 'Lock enabled but skill missing' }
            }
        }
        catch {
            Add-Error "Invalid project lock JSON: $_"
        }
    }

    Test-OperationalProjectsLab -ScanRoots @($Target)
}

Write-Host "`nSpaceX Orchestrator Pack Validator`n" -ForegroundColor White
Write-Host "Pack root: $PackRoot`n"

Test-RequiredPaths
Test-NoOperationalLabDir

$cursorAgents = Get-ChildItem (Join-Path $PackRoot 'runtime\cursor\agents\*.md') -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName
Test-CursorFrontmatter -Files $cursorAgents

$agyAgents = Get-ChildItem (Join-Path $PackRoot 'runtime\antigravity\agents\*\agent.md') -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty FullName
Test-AntigravityFrontmatter -Files $agyAgents

Test-JsonFile -Path (Join-Path $PackRoot 'runtime\opencode\opencode.json.example') -Label 'opencode.json.example'
Test-JsoncFile -Path (Join-Path $PackRoot 'runtime\opencode\opencode.jsonc.example') -Label 'opencode.jsonc.example'

Get-ChildItem (Join-Path $PackRoot 'runtime\codex\agents\*.toml') -ErrorAction SilentlyContinue |
    ForEach-Object { Test-TomlFile -Path $_.FullName -Label $_.Name }
Test-TomlFile -Path (Join-Path $PackRoot 'runtime\codex\config.toml.example') -Label 'config.toml.example'
Test-CodexHostWiring

Test-OperationalProjectsLab -ScanRoots @(
    (Join-Path $PackRoot 'runtime'),
    (Join-Path $PackRoot 'tooling\sandbox')
)

Test-GatesDocumented
Test-LockExampleSchema
Test-BootstrapRule
Test-AgyBootstrapRule
Test-AgyAgentNative
Test-GeminiUserTemplate
Test-SecretPatterns -ScanRoots @($PackRoot)
Test-InstallTarget -Target $TargetPath
Test-RuntimeErrors

Write-Host "`n--- Results ---" -ForegroundColor White
Write-Host "  Passed:   $Passed"
Write-Host "  Warnings: $($Warnings.Count)"
Write-Host "  Errors:   $($Errors.Count)"

if ($Strict -and $Warnings.Count -gt 0) {
    Write-Host "`nStrict: warnings fail." -ForegroundColor Yellow
    exit 1
}
if ($Errors.Count -gt 0) {
    Write-Host "`nValidation FAILED." -ForegroundColor Red
    exit 1
}
Write-Host "`nValidation PASSED." -ForegroundColor Green
exit 0
