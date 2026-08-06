# Lab-only: validate FETCH-not-GENERATE hypothesis against pack prod (read-only)
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$packRoot = Split-Path (Split-Path $labRoot -Parent) -Parent
$fail = 0

function Fail($msg) { Write-Host "FAIL $msg"; $script:fail++ }
function Pass($msg) { Write-Host "PASS $msg" }

$markers = @('T0-T3', 'Zero direct execution', 'lab-runner', 'invoke_subagent')

function Test-Marker($text, $marker) {
    if ($text -match [regex]::Escape($marker)) { return $true }
    if ($marker -match 'T0') { return $text -match 'T0[\u2013-]T3' }
    return $false
}

# F1 — GEMINI.user FETCH not generate
$geminiUser = Join-Path $packRoot 'runtime\antigravity\GEMINI.user.md'
if (-not (Test-Path $geminiUser)) { Fail 'missing GEMINI.user.md' }
else {
    $gu = Get-Content $geminiUser -Raw
    if ($gu -notmatch '(?i)FETCH|COPY') { Fail 'GEMINI.user missing FETCH/COPY' }
    if ($gu -match '(?i)(?<!(never |not ))generate.*(SKILL|\.agents)') { Fail 'GEMINI.user still says generate SKILL' }
    if ($gu -notmatch 'T0') { Fail 'GEMINI.user missing integrity markers' }
    Pass 'F1 GEMINI.user FETCH + integrity'
}

# F2 — manifest rawBase + rawPath
$manifestPath = Join-Path $packRoot 'runtime\antigravity\scaffold-manifest.json'
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
if (-not $manifest.rawBase) { Fail 'manifest missing rawBase' }
if (-not $manifest.integrityMarkers -or $manifest.integrityMarkers.Count -lt 4) { Fail 'manifest missing integrityMarkers' }
else {
    $markerText = (($manifest.integrityMarkers -join ' ') -replace '\u2013', '-').ToLower()
    $need = @('t0', 'zero direct execution', 'lab-runner', 'invoke_subagent')
    foreach ($n in $need) {
        if ($markerText -notmatch [regex]::Escape($n)) { Fail "manifest integrityMarkers missing: $n" }
    }
}
$required = @($manifest.paths | Where-Object { $_.required -eq $true })
foreach ($p in $required) {
    if ($p.path -ne '.orchestrator-lock.json' -and -not $p.rawPath) { Fail "required path missing rawPath: $($p.path)" }
}
Pass 'F2 manifest rawBase + rawPath'

# F2b — SCAFFOLD-FETCH exists
$fetchGuide = Join-Path $packRoot 'runtime\antigravity\SCAFFOLD-FETCH.md'
if (-not (Test-Path $fetchGuide)) { Fail 'missing SCAFFOLD-FETCH.md' }
else { Pass 'F2 SCAFFOLD-FETCH.md present' }

# F3 — local SKILL integrity
$skillPath = Join-Path $packRoot 'runtime\skills\orchestrator\SKILL.md'
$skill = Get-Content $skillPath -Raw
$lines = (Get-Content $skillPath | Measure-Object -Line).Lines
foreach ($m in $markers) {
    if (-not (Test-Marker $skill $m)) { Fail "local SKILL missing marker: $m" }
}
if ($lines -lt 100) { Fail "local SKILL too short ($lines lines)" }
Pass "F3 local SKILL markers + $lines lines"

# F4 — aligned touchpoints (sample)
$touchpoints = @(
    'runtime\GEMINI.md'
    'runtime\antigravity\rules\cj-orchestrator-bootstrap.md'
    'runtime\antigravity\rules\spacex-orchestrator.md'
    'runtime\skills\orchestrator\reference.antigravity.md'
    'docs\agent\SCAFFOLD-MANIFEST.md'
    'docs\human\install\antigravity-windows.md'
)
foreach ($rel in $touchpoints) {
    $abs = Join-Path $packRoot ($rel -replace '/', '\')
    if (-not (Test-Path $abs)) { Fail "missing touchpoint: $rel"; continue }
    $t = Get-Content $abs -Raw
    if ($t -notmatch '(?i)FETCH|COPY') { Fail "$rel missing FETCH/COPY" }
    if ($t -match '(?i)(?<!(never |not ))generate.*(`\.agents|SKILL\.md)') { Fail "$rel instructs generate SKILL" }
}
Pass 'F4 touchpoints FETCH-aligned'

# F4b — VERSION 1.2.8
$ver = (Get-Content (Join-Path $packRoot 'VERSION') -Raw).Trim()
if ($ver -ne '1.2.8') { Fail "VERSION is $ver not 1.2.8" }
else { Pass 'F4 VERSION 1.2.8' }

# F5 — remote main raw (best-effort)
$rawUrl = "$($manifest.rawBase)/runtime/skills/orchestrator/SKILL.md"
try {
    $remote = (Invoke-WebRequest -Uri $rawUrl -UseBasicParsing -TimeoutSec 20).Content
    foreach ($m in $markers) {
        if (-not (Test-Marker $remote $m)) { Fail "remote main SKILL missing: $m" }
    }
    Pass "F5 remote main raw OK ($rawUrl)"
} catch {
    Fail "F5 remote fetch failed: $($_.Exception.Message)"
}

# Fallback note (warn only)
$fallbackUrl = "$($manifest.rawBaseFallback)/runtime/skills/orchestrator/SKILL.md"
try {
    $null = Invoke-WebRequest -Uri $fallbackUrl -UseBasicParsing -TimeoutSec 10
    Pass 'F5b rawBaseFallback reachable'
} catch {
    Write-Host 'WARN rawBaseFallback 404/unreachable - pin to main or publish tag before relying on fallback'
}

# Pack validator
$validator = Join-Path $packRoot 'tooling\scripts\Validate-OrchestratorPack.ps1'
& $validator -Strict | Out-Null
if ($LASTEXITCODE -ne 0) { Fail 'Validate-OrchestratorPack -Strict failed' }
else { Pass 'Validate-OrchestratorPack -Strict' }

if ($fail -gt 0) {
    Write-Host "VALIDATE: FAIL count=$fail"
    exit 1
}
Write-Host 'VALIDATE: PASS'
exit 0
