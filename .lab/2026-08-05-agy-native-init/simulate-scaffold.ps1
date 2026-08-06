# Lab-only: dry-run agent-native scaffold against pack runtime (temp dir)
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$packRoot = Split-Path (Split-Path $labRoot -Parent) -Parent
$draftDir = Join-Path $labRoot 'draft'
$runtimeRoot = Join-Path $packRoot 'runtime'
$manifestPath = Join-Path $draftDir 'scaffold-manifest.json'
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

$temp = Join-Path ([IO.Path]::GetTempPath()) ("agy-native-scaffold-" + [guid]::NewGuid().ToString('n').Substring(0, 8))
New-Item -ItemType Directory -Path $temp -Force | Out-Null

try {
    # Write lock
    $lock = $manifest.lock.template | ConvertTo-Json -Depth 5
    $lockObj = $manifest.lock.template
    $lockObj.installed_at = (Get-Date).ToUniversalTime().ToString('o')
    $versionFile = Join-Path $packRoot 'VERSION'
    if (Test-Path $versionFile) { $lockObj.version = (Get-Content $versionFile -Raw).Trim() }
    $lockObj | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $temp '.orchestrator-lock.json') -Encoding UTF8

    $copied = 0
    $missingOptional = 0
    foreach ($entry in $manifest.paths) {
        if ($entry.path -eq '.orchestrator-lock.json') { continue }
        $dest = Join-Path $temp ($entry.path -replace '/', '\')
        $destDir = Split-Path $dest -Parent
        if ($destDir -and -not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        $srcRel = $entry.source
        if ($srcRel) {
            $src = Join-Path $runtimeRoot ($srcRel -replace '^runtime/', '' -replace '/', '\')
            if (-not (Test-Path $src)) {
                if ($entry.required) { throw "Required source missing: $srcRel" }
                $missingOptional++
                continue
            }
            Copy-Item $src $dest -Force
            $copied++
        } elseif ($entry.path -match '\.agents/agents/.+/agent\.md$') {
            $role = ($entry.path -split '/')[2]
            $src = Join-Path $runtimeRoot "antigravity\agents\$role\agent.md"
            if (-not (Test-Path $src)) { throw "Agent source missing: $role" }
            Copy-Item $src $dest -Force
            $copied++
        }
    }

    # Assert minimum tree
    $mustExist = @(
        '.orchestrator-lock.json'
        '.agents\skills\orchestrator\SKILL.md'
        '.agents\rules\cj-orchestrator-bootstrap.md'
        '.agents\rules\spacex-orchestrator.md'
        '.agents\agents\explore\agent.md'
        '.agents\agents\verifier\agent.md'
        '.lab\README.md'
    )
    foreach ($rel in $mustExist) {
        $p = Join-Path $temp $rel
        if (-not (Test-Path $p)) { throw "Simulate missing: $rel" }
    }

    $lockRead = Get-Content (Join-Path $temp '.orchestrator-lock.json') -Raw | ConvertFrom-Json
    if ($lockRead.source -ne 'agent-native') { throw 'Lock source not agent-native' }
    if ($lockRead.enabled -ne $true) { throw 'Lock not enabled' }

    Write-Host "SIMULATE: PASS temp=$temp copied=$copied optional_skip=$missingOptional"
    exit 0
}
catch {
    Write-Host "SIMULATE: FAIL $_"
    exit 1
}
finally {
    if (Test-Path $temp) { Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue }
}
