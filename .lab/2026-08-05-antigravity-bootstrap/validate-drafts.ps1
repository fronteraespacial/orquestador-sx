# Lab-only: validate Antigravity bootstrap drafts contain required wiring tokens.
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$draftDir = Join-Path $labRoot 'draft'
$required = @{
    'cj-orchestrator-bootstrap.md' = @(
        '.orchestrator-lock.json'
        '.agents/skills/orchestrator/SKILL.md'
        'Always On'
        'Orchestrator init'
    )
    'cj-criollo-changelog.md' = @(
        '## En criollo'
        'Always On'
    )
    'GEMINI-bootstrap-delta.md' = @(
        '.orchestrator-lock.json'
        'cj-orchestrator-bootstrap'
        'cj-criollo-changelog'
    )
    'spacex-orchestrator-bootstrap-delta.md' = @(
        '.orchestrator-lock.json'
        'En criollo'
    )
    'FIRST-RUN-antigravity-section.md' = @(
        'init -Scope project'
        'Always On'
        'playground'
    )
    'antigravity-windows-delta.md' = @(
        'init -Scope project'
        'Always On'
        'cj-orchestrator-bootstrap'
    )
    'home-gemini-micro-OPTIN.md' = @(
        'OPT-IN'
        'must NOT'
        '.orchestrator-lock.json'
    )
}

$fail = 0
foreach ($file in $required.Keys) {
    $path = Join-Path $draftDir $file
    if (-not (Test-Path $path)) {
        Write-Host "FAIL missing $file"
        $fail++
        continue
    }
    $content = Get-Content $path -Raw
    foreach ($token in $required[$file]) {
        if ($content -notmatch [regex]::Escape($token)) {
            Write-Host "FAIL $file missing token: $token"
            $fail++
        }
    }
}

# Coherence: install map paths (read-only grep from pack)
$installPs1 = Join-Path (Split-Path $labRoot -Parent | Split-Path -Parent) 'tooling\scripts\Install-Orchestrator.ps1'
if (Test-Path $installPs1) {
    $map = Get-Content $installPs1 -Raw
    @(
        'antigravity\rules\spacex-orchestrator.md'
        '.agents\rules\spacex-orchestrator.md'
        'GEMINI.md'
    ) | ForEach-Object {
        if ($map -notmatch [regex]::Escape($_)) {
            Write-Host "WARN install map check: $_ not found in Install-Orchestrator.ps1"
        }
    }
}

if ($fail -gt 0) {
    Write-Host "VALIDATE: FAIL ($fail issues)"
    exit 1
}
Write-Host 'VALIDATE: PASS'
exit 0
