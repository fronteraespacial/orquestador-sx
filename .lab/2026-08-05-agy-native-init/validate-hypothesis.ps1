# Lab-only: validate AGY native-init hypothesis drafts
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$draftDir = Join-Path $labRoot 'draft'
$packRoot = Split-Path (Split-Path $labRoot -Parent) -Parent
$fail = 0

function Fail($msg) { Write-Host "FAIL $msg"; $script:fail++ }
function Pass($msg) { Write-Host "PASS $msg" }

$requiredFiles = @(
    'GEMINI.user-native-init.md',
    'cj-orchestrator-bootstrap-native.md',
    'SKILL-antigravity-2.0-section.md',
    'reference.antigravity.md',
    'antigravity-windows-native-delta.md',
    'scaffold-manifest.json',
    'GEMINI-repo-bootstrap-delta.md'
)

foreach ($f in $requiredFiles) {
    $p = Join-Path $draftDir $f
    if (-not (Test-Path $p)) { Fail "missing draft: $f" }
    else { Pass "draft exists: $f" }
}

# C1 ask + scaffold
$geminiUser = Get-Content (Join-Path $draftDir 'GEMINI.user-native-init.md') -Raw
$c1Tokens = @(
    '.orchestrator-lock.json'
    'pregunt'
    'materializ'
    'agent-native'
    'Playground'
)
foreach ($t in $c1Tokens) {
    if ($geminiUser -notmatch $t) { Fail "C1 GEMINI.user missing: $t" }
}
Pass 'C1 ask-first + agent scaffold'

# C2 no CLI gate
if ($geminiUser -match '(?<!No uses [`'']?)Orchestrator\.ps1 init -Scope project' -and $geminiUser -notmatch 'agent-native|materializ') {
    Fail 'C2 GEMINI.user mandates CLI project init without agent-native path'
}
if ($geminiUser -notmatch 'No uses|no `Orchestrator\.ps1 init`|agent-native scaffold|materializ') {
    Fail 'C2 GEMINI.user must explicitly de-prioritize CLI / promote agent-native'
}
Pass 'C2 CLI not required for AGY Desktop bootstrap'

$bootstrap = Get-Content (Join-Path $draftDir 'cj-orchestrator-bootstrap-native.md') -Raw
if ($bootstrap -match 'offer.*Orchestrator init' -and $bootstrap -notmatch 'agent-native|materialize|write lock') {
    Fail 'C2 bootstrap still CLI-only'
}
Pass 'C2 bootstrap-native allows agent write'

# C3 define_subagent templates (8 roles)
$skillDelta = Get-Content (Join-Path $draftDir 'SKILL-antigravity-2.0-section.md') -Raw
$roles = @('explore', 'scout', 'maverick', 'lab-runner', 'implementer', 'verifier', 'skeptic', 'deletion')
foreach ($r in $roles) {
    if ($skillDelta -notmatch "#### $r") { Fail "C3 SKILL delta missing template: $r" }
}
if ($skillDelta -notmatch 'define_subagent') { Fail 'C3 missing define_subagent' }
Pass 'C3 eight role templates + define_subagent'

# C4 invoke_subagent; no Task for AGY
if ($skillDelta -notmatch 'invoke_subagent') { Fail 'C4 missing invoke_subagent' }
if ($skillDelta -notmatch 'never.*Task|Never.*Task') { Fail 'C4 must forbid Cursor Task' }
$refAgy = Get-Content (Join-Path $draftDir 'reference.antigravity.md') -Raw
if ($refAgy -match 'Task tool' -and $refAgy -notmatch 'Forbidden') { Fail 'C4 reference allows Task without forbid' }
Pass 'C4 invoke_subagent primary; Task forbidden'

# C5 lock + criollo
$criolloHits = 0
@($geminiUser, $bootstrap, $skillDelta, $refAgy) | ForEach-Object {
    if ($_ -match 'En criollo') { $script:criolloHits++ }
}
if ($criolloHits -lt 3) { Fail 'C5 En criollo not preserved across drafts' }

$manifest = Get-Content (Join-Path $draftDir 'scaffold-manifest.json') -Raw | ConvertFrom-Json
if ($manifest.lock.template.source -ne 'agent-native') { Fail 'C5 lock source not agent-native' }
if ($manifest.lock.template.enabled -ne $true) { Fail 'C5 lock enabled not true' }
Pass 'C5 lock schema + En criollo preserved'

# C6 docs delta
$docsDelta = Get-Content (Join-Path $draftDir 'antigravity-windows-native-delta.md') -Raw
if ($docsDelta -notmatch 'define_subagent') { Fail 'C6 docs missing define_subagent' }
if ($docsDelta -notmatch 'Path A') { Fail 'C6 docs missing agent-native Path A' }
Pass 'C6 antigravity-windows delta coherent'

# F2 silent init
if ($geminiUser -match 'silent|silencioso.*scaffold|auto-init' -and $geminiUser -notmatch 'Nunca|never|Never') {
    Fail 'F2 possible silent init wording'
}
Pass 'F2 no silent scaffold'

# F3 manifest roles count
if ($manifest.roles.Count -ne 8) { Fail "F3 manifest roles count $($manifest.roles.Count) != 8" }
Pass 'F3 scaffold-manifest 8 roles'

# F5 playground
if ($geminiUser -notmatch 'ignor') { Fail 'F5 playground guard missing' }
Pass 'F5 playground ignored'

# Coherence: pack runtime sources exist for scaffold copy
$runtimeChecks = @(
    'runtime\skills\orchestrator\SKILL.md'
    'runtime\antigravity\rules\cj-orchestrator-bootstrap.md'
    'runtime\antigravity\agents\explore\agent.md'
)
foreach ($rel in $runtimeChecks) {
    $abs = Join-Path $packRoot ($rel -replace '/', '\')
    if (-not (Test-Path $abs)) { Fail "pack runtime missing for scaffold: $rel" }
}
Pass 'pack runtime sources available for agent copy'

# Run simulate
& (Join-Path $labRoot 'simulate-scaffold.ps1')
if ($LASTEXITCODE -ne 0) { Fail 'simulate-scaffold.ps1 failed' }

if ($fail -gt 0) {
    Write-Host "VALIDATE: FAIL ($fail issues)"
    exit 1
}
Write-Host 'VALIDATE: PASS'
exit 0
