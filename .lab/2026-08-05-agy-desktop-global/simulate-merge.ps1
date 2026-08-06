# Lab-only: simulate user-scope GEMINI merge (temp dir; no %USERPROFILE% writes)
$ErrorActionPreference = 'Stop'
$labRoot = $PSScriptRoot
$packRoot = Split-Path (Split-Path $labRoot -Parent) -Parent
$runtimeRoot = Join-Path $packRoot 'runtime'
$template = Join-Path $runtimeRoot 'antigravity\GEMINI.user.md'
$begin = '<!-- spacex-orchestrator-sx BEGIN -->'
$end = '<!-- spacex-orchestrator-sx END -->'

if (-not (Test-Path $template)) {
    Write-Host "FAIL missing runtime template: $template"
    exit 1
}

function Build-Block {
    param([string] $TemplateFile)
    $body = (Get-Content -LiteralPath $TemplateFile -Raw).TrimEnd()
    return "$begin`r`n$body`r`n$end"
}

function Merge-Gemini {
    param([string] $DestFile, [string] $Block, [string] $ExistingContent)
    if (-not $ExistingContent) {
        Set-Content -LiteralPath $DestFile -Value "$Block`r`n" -Encoding UTF8
        return 'fresh'
    }
    if ($ExistingContent -match '(?s)<!--\s*spacex-orchestrator-sx BEGIN\s*-->.*?<!--\s*spacex-orchestrator-sx END\s*-->') {
        $new = [regex]::Replace(
            $ExistingContent,
            '(?s)<!--\s*spacex-orchestrator-sx BEGIN\s*-->.*?<!--\s*spacex-orchestrator-sx END\s*-->',
            $Block
        )
        Set-Content -LiteralPath $DestFile -Value $new -Encoding UTF8
        return 'refresh'
    }
    $trimmed = $ExistingContent.TrimEnd()
    Set-Content -LiteralPath $DestFile -Value "$trimmed`r`n`r`n$Block`r`n" -Encoding UTF8
    return 'append'
}

$tmpdir = Join-Path ([System.IO.Path]::GetTempPath()) ("agy-global-lab-" + [guid]::NewGuid().ToString('n'))
New-Item -ItemType Directory -Path $tmpdir -Force | Out-Null
try {
    $block = Build-Block -TemplateFile $template
    $dest = Join-Path $tmpdir '.gemini\GEMINI.md'
    New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null

    $r1 = Merge-Gemini -DestFile $dest -Block $block -ExistingContent ''
    $c1 = Get-Content $dest -Raw
    if ($r1 -ne 'fresh' -or $c1 -notmatch 'spacex-orchestrator-sx BEGIN') { throw 'fresh merge failed' }

    $r2 = Merge-Gemini -DestFile $dest -Block $block -ExistingContent "# user rules`nkeep me"
    $c2 = Get-Content $dest -Raw
    if ($r2 -ne 'append' -or $c2 -notmatch 'keep me' -or $c2 -notmatch 'spacex-orchestrator-sx BEGIN') { throw 'append merge failed' }

    $r3 = Merge-Gemini -DestFile $dest -Block ($block + "`r`n<!-- v2 -->") -ExistingContent $c2
    $c3 = Get-Content $dest -Raw
    if ($r3 -ne 'refresh' -or $c3 -notmatch 'v2' -or $c3 -notmatch 'keep me') { throw 'refresh merge failed' }

    Write-Host "SIMULATE: PASS (fresh=$r1 append=$r2 refresh=$r3)"
    exit 0
}
catch {
    Write-Host "SIMULATE: FAIL $_"
    exit 1
}
finally {
    Remove-Item -LiteralPath $tmpdir -Recurse -Force -ErrorAction SilentlyContinue
}
