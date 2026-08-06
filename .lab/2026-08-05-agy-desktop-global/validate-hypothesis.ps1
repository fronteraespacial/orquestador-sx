# Lab-only: validate AGY desktop global hypothesis against pack working tree (read-only)
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$packRoot = Split-Path (Split-Path $labRoot -Parent) -Parent
$fail = 0

function Fail($msg) { Write-Host "FAIL $msg"; $script:fail++ }
function Pass($msg) { Write-Host "PASS $msg" }

$ps1 = Join-Path $packRoot 'tooling\scripts\Install-Orchestrator.ps1'
$sh = Join-Path $packRoot 'tooling\scripts\install-orchestrator.sh'
$geminiUser = Join-Path $packRoot 'runtime\antigravity\GEMINI.user.md'
$proposed = Join-Path $labRoot 'draft\GEMINI.user-proposed.md'

# C1
if (-not (Test-Path $geminiUser)) { Fail 'C1 missing runtime/antigravity/GEMINI.user.md' }
else { Pass 'C1 template exists' }

$ps1Text = Get-Content $ps1 -Raw
$shText = Get-Content $sh -Raw
if ($ps1Text -notmatch 'Merge-SpacexGeminiUser' -or $ps1Text -notmatch '\.gemini\\GEMINI\.md') {
    Fail 'C1 Install-Orchestrator.ps1 missing user GEMINI merge'
} else { Pass 'C1 PS1 merge wired' }

if ($shText -notmatch 'merge_spacex_gemini_user' -or $shText -notmatch '\.gemini/GEMINI\.md') {
    Fail 'C1 install-orchestrator.sh missing user GEMINI merge'
} else { Pass 'C1 sh merge wired' }

if ($ps1Text -notmatch 'ConfirmUserScope') { Fail 'C1 missing ConfirmUserScope gate' }
else { Pass 'C1 ConfirmUserScope required for user scope' }

# C2
$geminiBody = Get-Content $geminiUser -Raw
$c2Tokens = @(
    '.orchestrator-lock.json'
    'ask'
    'Never init alone'
    'Playground'
)
foreach ($t in $c2Tokens) {
    if ($geminiBody -notmatch [regex]::Escape($t)) { Fail "C2 runtime template missing: $t" }
}
if ($geminiBody -match 'silent') { Fail 'C2 runtime mentions silent install positively' }
Pass 'C2 runtime ask-first + playground guard'

$proposedBody = Get-Content $proposed -Raw
if ($proposedBody -notmatch 'Orquestador SX \(Antigravity\)') { Fail 'C2 proposed draft missing Spanish ask phrase' }
else { Pass 'C2 proposed Spanish ask phrase present' }

# C3 optional
$agentsStub = Join-Path $labRoot 'draft\AGENTS.user-stub.md'
if (Test-Path $agentsStub) { Pass 'C3 optional AGENTS stub drafted in lab' }
else { Write-Host 'WARN C3 AGENTS stub not in runtime (optional)' }

if ($ps1Text -notmatch '\.gemini\\AGENTS\.md') {
    Write-Host 'WARN C3 install does not yet write .gemini/AGENTS.md (optional)'
}

# C4
if ($geminiBody -match 'Always On') { Fail 'C4 runtime user GEMINI requires Always On (should not)' }
else { Pass 'C4 global micro-bootstrap avoids Always On instruction' }

# C5
$projectTokens = @(
    'antigravity\\rules\\spacex-orchestrator.md'
    'antigravity\\rules\\cj-orchestrator-bootstrap.md'
    '\.agents\\agents\\'
)
foreach ($t in $projectTokens) {
    if ($ps1Text -notmatch $t) { Fail "C5 project map missing: $t" }
}
if ($ps1Text -match 'Get-UserTemplateMap[\s\S]*antigravity\\agents') {
    Fail 'C5 user map incorrectly includes antigravity agents'
} else { Pass 'C5 project-only AGY agents/rules; user map excludes them' }

# F2 backup
if ($ps1Text -notmatch 'Backup-ExistingFile') { Fail 'F2 no backup before GEMINI merge' }
else { Pass 'F2 backup before merge' }

# Run simulate
& (Join-Path $labRoot 'simulate-merge.ps1')
if ($LASTEXITCODE -ne 0) { Fail 'simulate-merge.ps1' }

if ($fail -gt 0) {
    Write-Host "VALIDATE: FAIL ($fail issues)"
    exit 1
}
Write-Host 'VALIDATE: PASS'
exit 0
