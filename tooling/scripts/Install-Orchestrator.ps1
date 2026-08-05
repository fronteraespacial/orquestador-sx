# SpaceX Orchestrator — Install-Orchestrator.ps1
#
# Safe installer. Default: sandbox/pilot. User scope uses explicit global paths only.
# -RefreshSandbox: regenerate pack-owned assets under sandbox/ with backup.

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [ValidateSet('Sandbox', 'Project', 'User')]
    [string] $Scope = 'Sandbox',

    [Parameter()]
    [string] $TargetPath = '',

    [Parameter()]
    [switch] $ConfirmUserScope,

    [Parameter()]
    [switch] $RefreshSandbox,

    [Parameter()]
    [switch] $IncludeCodex,

    [Parameter()]
    [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$PackRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$RuntimeRoot = Join-Path $PackRoot 'runtime'
$DefaultSandbox = Join-Path $PackRoot 'tooling\sandbox\pilot'
$SpacexGeminiBegin = '<!-- spacex-orchestrator-sx BEGIN -->'
$SpacexGeminiEnd = '<!-- spacex-orchestrator-sx END -->'
$GeminiUserTemplateRel = 'antigravity\GEMINI.user.md'

function Get-ProjectTemplateMap {
    $map = [System.Collections.Generic.List[hashtable]]::new()

    $cursorAgents = @(
        'explore', 'scout', 'maverick', 'implementer', 'lab-runner', 'verifier',
        'orchestrator', 'skeptic', 'deletion'
    )
    foreach ($a in $cursorAgents) {
        $map.Add(@{ Src = "cursor\agents\$a.md"; Dst = ".cursor\agents\$a.md" })
    }

    $map.Add(@{ Src = 'cursor\rules\cj-orchestrator-bootstrap.mdc'; Dst = '.cursor\rules\cj-orchestrator-bootstrap.mdc' })
    $map.Add(@{ Src = 'cursor\rules\cj-orchestrator-mandatory.mdc'; Dst = '.cursor\rules\cj-orchestrator-mandatory.mdc' })
    $map.Add(@{ Src = 'cursor\rules\cj-criollo-changelog.mdc'; Dst = '.cursor\rules\cj-criollo-changelog.mdc' })

    $agyAgents = @(
        'explore', 'scout', 'maverick', 'implementer', 'lab-runner', 'verifier',
        'skeptic', 'deletion'
    )
    foreach ($a in $agyAgents) {
        $map.Add(@{ Src = "antigravity\agents\$a\agent.md"; Dst = ".agents\agents\$a\agent.md" })
    }

    $map.Add(@{ Src = 'antigravity\rules\spacex-orchestrator.md'; Dst = '.agents\rules\spacex-orchestrator.md' })
    $map.Add(@{ Src = 'antigravity\rules\cj-orchestrator-bootstrap.md'; Dst = '.agents\rules\cj-orchestrator-bootstrap.md' })

    $skills = @('SKILL.md', 'reference.md', 'reference.wsl.md', 'reference.antigravity.md')
    foreach ($s in $skills) {
        $map.Add(@{ Src = "skills\orchestrator\$s"; Dst = ".agents\skills\orchestrator\$s" })
    }

    $map.Add(@{ Src = 'project\AGENTS.md'; Dst = 'AGENTS.md' })
    $map.Add(@{ Src = 'GEMINI.md'; Dst = 'GEMINI.md' })
    $map.Add(@{ Src = 'project\lab\README.md'; Dst = '.lab\README.md' })
    $map.Add(@{ Src = 'opencode\opencode.json.example'; Dst = 'opencode.json' })
    $map.Add(@{ Src = 'opencode\opencode.jsonc.example'; Dst = 'opencode.jsonc' })

    return @($map)
}

function Get-UserTemplateMap {
    param([switch] $WithCodex)

    $map = [System.Collections.Generic.List[hashtable]]::new()

    $cursorAgents = @(
        'explore', 'scout', 'maverick', 'implementer', 'lab-runner', 'verifier',
        'orchestrator', 'skeptic', 'deletion'
    )
    foreach ($a in $cursorAgents) {
        $map.Add(@{ Src = "cursor\agents\$a.md"; Dst = ".cursor\agents\$a.md" })
    }
    $map.Add(@{ Src = 'cursor\rules\cj-orchestrator-bootstrap.mdc'; Dst = '.cursor\rules\cj-orchestrator-bootstrap.mdc' })
    $map.Add(@{ Src = 'cursor\rules\cj-orchestrator-mandatory.mdc'; Dst = '.cursor\rules\cj-orchestrator-mandatory.mdc' })
    $map.Add(@{ Src = 'cursor\rules\cj-criollo-changelog.mdc'; Dst = '.cursor\rules\cj-criollo-changelog.mdc' })

    $skills = @('SKILL.md', 'reference.md', 'reference.wsl.md', 'reference.antigravity.md')
    foreach ($s in $skills) {
        $map.Add(@{ Src = "skills\orchestrator\$s"; Dst = ".agents\skills\orchestrator\$s" })
    }

    # OpenCode global (prefer .config/opencode)
    $map.Add(@{ Src = 'opencode\opencode.jsonc.example'; Dst = '.config\opencode\opencode.jsonc' })

    if ($WithCodex) {
        $codexAgents = @(
            'orchestrator', 'explore', 'scout', 'maverick', 'lab', 'executor_fast', 'verifier'
        )
        foreach ($a in $codexAgents) {
            $map.Add(@{ Src = "codex\agents\$a.toml"; Dst = ".codex\agents\$a.toml" })
        }
        $map.Add(@{ Src = 'codex\config.toml.example'; Dst = '.codex\config.toml' })
    }

    return @($map)
}

function Get-CodexTemplateEntries {
    $entries = [System.Collections.Generic.List[hashtable]]::new()
    $codexAgents = @(
        'orchestrator', 'explore', 'scout', 'maverick', 'lab', 'executor_fast', 'verifier'
    )
    foreach ($a in $codexAgents) {
        $entries.Add(@{ Src = "codex\agents\$a.toml"; Dst = ".codex\agents\$a.toml" })
    }
    $entries.Add(@{ Src = 'codex\config.toml.example'; Dst = '.codex\config.toml' })
    return @($entries)
}

function Test-IsPackSandbox {
    param([string] $Path)
    $normalized = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $sandboxRoot = [System.IO.Path]::GetFullPath((Join-Path $PackRoot 'tooling\sandbox')).TrimEnd('\', '/')
    return $normalized.StartsWith($sandboxRoot, [StringComparison]::OrdinalIgnoreCase)
}

function Get-InstallTarget {
    param([string] $ScopeName, [string] $ExplicitTarget)

    switch ($ScopeName) {
        'Sandbox' {
            if ($ExplicitTarget) {
                $resolved = Resolve-Path -LiteralPath $ExplicitTarget -ErrorAction SilentlyContinue
                $targetPath = if ($resolved) { $resolved.Path } else {
                    (New-Item -ItemType Directory -Path $ExplicitTarget -Force).FullName
                }
                if (-not (Test-IsPackSandbox -Path $targetPath)) {
                    throw 'Scope Sandbox: -TargetPath must be under pack sandbox/. Use -Scope Project -TargetPath for arbitrary repos.'
                }
                return $targetPath
            }
            return $DefaultSandbox
        }
        'Project' {
            if (-not $ExplicitTarget) {
                throw 'Scope Project requires -TargetPath pointing to a repository root.'
            }
            return (Resolve-Path -LiteralPath $ExplicitTarget -ErrorAction Stop).Path
        }
        'User' {
            if (-not $ConfirmUserScope) {
                throw 'Scope User touches global paths under %USERPROFILE%. Pass -Scope User -ConfirmUserScope.'
            }
            return $env:USERPROFILE
        }
    }
}

function New-InstallManifest {
    param([string] $Target, [string] $ScopeName, [bool] $Refresh)
    return [ordered]@{
        pack_version   = (Get-Content (Join-Path $PackRoot 'VERSION') -Raw).Trim()
        installed_at   = (Get-Date).ToUniversalTime().ToString('o')
        scope          = $ScopeName
        target         = $Target
        refresh_mode   = $Refresh
        hostname       = $env:COMPUTERNAME
        user           = $env:USERNAME
        copied         = [System.Collections.ArrayList]@()
        refreshed      = [System.Collections.ArrayList]@()
        skipped        = [System.Collections.ArrayList]@()
        missing_source = [System.Collections.ArrayList]@()
        excluded_user  = @(
            'Antigravity .agents/agents/* (project-level only — not valid under $HOME)',
            'AGENTS.md, repo-root GEMINI.md, .lab/ (project-level only)',
            'User Antigravity global: ~/.gemini/GEMINI.md (merged block, not excluded)'
        )
    }
}

function Backup-ExistingFile {
    param(
        [string] $FilePath,
        [string] $BackupRoot,
        [string] $InstallTargetRoot
    )

    if (-not (Test-Path -LiteralPath $FilePath)) { return }

    $targetRoot = [System.IO.Path]::GetFullPath($InstallTargetRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
    $fullFile = [System.IO.Path]::GetFullPath($FilePath)

    if ($fullFile.StartsWith($targetRoot, [StringComparison]::OrdinalIgnoreCase)) {
        $rel = $fullFile.Substring($targetRoot.Length).TrimStart('\', '/')
    }
    else {
        $rel = [System.IO.Path]::GetFileName($FilePath)
    }

    $backupDest = Join-Path $BackupRoot $rel
    $backupDir = Split-Path -Parent $backupDest
    if ($backupDir -and -not (Test-Path -LiteralPath $backupDir)) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    }
    Copy-Item -LiteralPath $FilePath -Destination $backupDest -Force
}

function Get-SpacexGeminiUserBlock {
    param([string] $TemplateFile)

    if (-not (Test-Path -LiteralPath $TemplateFile)) {
        throw "Missing Antigravity user GEMINI template: $TemplateFile"
    }
    $body = (Get-Content -LiteralPath $TemplateFile -Raw).TrimEnd()
    return "$SpacexGeminiBegin`r`n$body`r`n$SpacexGeminiEnd"
}

function Merge-SpacexGeminiUser {
    param(
        [string] $DestFile,
        [string] $TemplateFile,
        [hashtable] $Manifest,
        [string] $BackupRoot,
        [string] $InstallTargetRoot
    )

    $relSrc = $TemplateFile.Substring($RuntimeRoot.Length).TrimStart('\', '/')
    if (-not (Test-Path -LiteralPath $TemplateFile)) {
        $Manifest.missing_source.Add($relSrc) | Out-Null
        Write-Warning "Missing template source: $relSrc"
        return
    }

    $block = Get-SpacexGeminiUserBlock -TemplateFile $TemplateFile
    $destDir = Split-Path -Parent $DestFile
    if ($destDir -and -not (Test-Path -LiteralPath $destDir)) {
        if ($PSCmdlet.ShouldProcess($destDir, 'Create directory')) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }

    $exists = Test-Path -LiteralPath $DestFile
    $action = 'Copy template'
    $refreshed = $false

    if ($exists) {
        $existing = Get-Content -LiteralPath $DestFile -Raw
        if ($null -eq $existing) { $existing = '' }
        if ($existing -match '(?s)<!--\s*spacex-orchestrator-sx BEGIN\s*-->.*?<!--\s*spacex-orchestrator-sx END\s*-->') {
            if ($PSCmdlet.ShouldProcess($DestFile, 'Replace spacex-orchestrator-sx GEMINI block')) {
                Backup-ExistingFile -FilePath $DestFile -BackupRoot $BackupRoot -InstallTargetRoot $InstallTargetRoot
            }
            $newContent = [regex]::Replace(
                $existing,
                '(?s)<!--\s*spacex-orchestrator-sx BEGIN\s*-->.*?<!--\s*spacex-orchestrator-sx END\s*-->',
                $block
            )
            $action = 'Refresh spacex-orchestrator-sx GEMINI block'
            $refreshed = $true
        }
        else {
            if ($PSCmdlet.ShouldProcess($DestFile, 'Append spacex-orchestrator-sx GEMINI block')) {
                Backup-ExistingFile -FilePath $DestFile -BackupRoot $BackupRoot -InstallTargetRoot $InstallTargetRoot
            }
            $trimmed = $existing.TrimEnd()
            $newContent = if ($trimmed) { "$trimmed`r`n`r`n$block`r`n" } else { "$block`r`n" }
            $action = 'Append spacex-orchestrator-sx GEMINI block'
        }
    }
    else {
        $newContent = "$block`r`n"
    }

    if ($PSCmdlet.ShouldProcess($DestFile, $action)) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($DestFile, $newContent, $utf8NoBom)
        $hash = if (-not $WhatIfPreference) { (Get-FileHash -LiteralPath $DestFile -Algorithm SHA256).Hash } else { '(whatif)' }
        $entry = @{
            source = $relSrc
            dest   = $DestFile
            sha256 = $hash
            merge  = 'spacex-orchestrator-sx block'
        }
        if ($refreshed) {
            $Manifest.refreshed.Add($entry) | Out-Null
            Write-Host "  ~ refresh $DestFile (GEMINI block)" -ForegroundColor Yellow
        }
        else {
            $Manifest.copied.Add($entry) | Out-Null
            Write-Host "  + $DestFile (GEMINI block)" -ForegroundColor Green
        }
    }
}

function Copy-TemplateSafe {
    param(
        [string] $SourceFile,
        [string] $DestFile,
        [hashtable] $Manifest,
        [string] $BackupRoot,
        [string] $InstallTargetRoot,
        [bool] $AllowOverwrite
    )

    $relSrc = $SourceFile.Substring($RuntimeRoot.Length).TrimStart('\', '/')

    if (-not (Test-Path -LiteralPath $SourceFile)) {
        $Manifest.missing_source.Add($relSrc) | Out-Null
        Write-Warning "Missing template source: $relSrc"
        return
    }

    $destDir = Split-Path -Parent $DestFile
    if (-not (Test-Path -LiteralPath $destDir)) {
        if ($PSCmdlet.ShouldProcess($destDir, 'Create directory')) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }

    $exists = Test-Path -LiteralPath $DestFile
    if ($exists -and -not $AllowOverwrite) {
        if ($Force) {
            Write-Warning "Force ignored - overwrite disabled outside -RefreshSandbox; skipping: $DestFile"
        }
        $Manifest.skipped.Add(@{ path = $DestFile; reason = 'exists_no_overwrite' }) | Out-Null
        Write-Verbose "Skip (exists): $DestFile"
        return
    }

    if ($exists -and $AllowOverwrite) {
        if ($PSCmdlet.ShouldProcess($DestFile, 'Backup and refresh pack-owned file')) {
            Backup-ExistingFile -FilePath $DestFile -BackupRoot $BackupRoot -InstallTargetRoot $InstallTargetRoot
        }
    }

    $action = if ($AllowOverwrite -and $exists) { 'Refresh template' } else { 'Copy template' }
    if ($PSCmdlet.ShouldProcess($DestFile, $action)) {
        Copy-Item -LiteralPath $SourceFile -Destination $DestFile -Force
        $hash = if (-not $WhatIfPreference) { (Get-FileHash -LiteralPath $DestFile -Algorithm SHA256).Hash } else { '(whatif)' }
        $entry = @{ source = $relSrc; dest = $DestFile; sha256 = $hash }
        if ($AllowOverwrite -and $exists) {
            $Manifest.refreshed.Add($entry) | Out-Null
            Write-Host "  ~ refresh $DestFile" -ForegroundColor Yellow
        }
        else {
            $Manifest.copied.Add($entry) | Out-Null
            Write-Host "  + $DestFile" -ForegroundColor Green
        }
    }
}

function Save-InstallManifest {
    param([string] $Target, [hashtable] $Manifest)

    $manifestPath = Join-Path $Target '.install-manifest.json'
    if ($PSCmdlet.ShouldProcess($manifestPath, 'Write install manifest')) {
        $backupParent = Join-Path $Target '.install-backup'
        if (-not (Test-Path -LiteralPath $backupParent)) {
            New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
        }
        $Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
        Write-Host "Manifest: $manifestPath" -ForegroundColor DarkGray
    }
}

# --- Main ---
$packVersion = (Get-Content (Join-Path $PackRoot 'VERSION') -Raw).Trim()
Write-Host "`nSpaceX Orchestrator Installer (pack $packVersion)" -ForegroundColor White
Write-Host "Pack root: $PackRoot`n"

if (-not (Test-Path -LiteralPath $RuntimeRoot)) {
    throw "Runtime directory not found: $RuntimeRoot"
}

$installTarget = Get-InstallTarget -ScopeName $Scope -ExplicitTarget $TargetPath
$allowOverwrite = $false
$backupTimestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $installTarget ".install-backup\$backupTimestamp"

if ($RefreshSandbox) {
    if (-not (Test-IsPackSandbox -Path $installTarget)) {
        throw '-RefreshSandbox requires target under pack sandbox/ (e.g. sandbox/pilot).'
    }
    $allowOverwrite = $true
    Write-Host "Refresh mode: pack-owned assets under $installTarget" -ForegroundColor Yellow
    if ($WhatIfPreference) {
        Write-Host 'WhatIf: previewing refresh (per-file actions below).' -ForegroundColor Cyan
    }
    elseif (-not $PSCmdlet.ShouldProcess($installTarget, 'Refresh pack-owned sandbox assets')) {
        Write-Host 'Cancelled.' -ForegroundColor Yellow
        return
    }
}

if ($Scope -eq 'User') {
    Write-Warning "USER SCOPE - global paths only under $installTarget"
    Write-Warning '  Installs: .cursor/agents, .cursor/rules, .agents/skills/orchestrator, .config/opencode/opencode.jsonc'
    Write-Warning '  Antigravity Desktop: merge ~/.gemini/GEMINI.md (spacex-orchestrator-sx block)'
    if ($IncludeCodex) { Write-Warning '  Also: .codex/agents, .codex/config.toml ( -IncludeCodex )' }
    Write-Warning 'NOT installed under User scope (project-level - invalid global config):'
    Write-Warning '  .agents/agents/*, repo-root GEMINI.md, AGENTS.md, .lab/'
    if (-not $WhatIfPreference -and -not $PSCmdlet.ShouldProcess($installTarget, 'Install orchestrator (User scope - global paths only)')) {
        Write-Host 'Cancelled.' -ForegroundColor Yellow
        return
    }
}
elseif ($Scope -eq 'Sandbox') {
    if (-not (Test-Path -LiteralPath $installTarget)) {
        if ($PSCmdlet.ShouldProcess($installTarget, 'Create sandbox pilot directory')) {
            New-Item -ItemType Directory -Path $installTarget -Force | Out-Null
        }
    }
    Write-Host "Target (sandbox): $installTarget" -ForegroundColor Cyan
}
else {
    Write-Host "Target (project): $installTarget" -ForegroundColor Cyan
}

$templateMap = if ($Scope -eq 'User') {
    Get-UserTemplateMap -WithCodex:$IncludeCodex
}
else {
    $entries = [System.Collections.Generic.List[hashtable]]::new()
    Get-ProjectTemplateMap | ForEach-Object { $entries.Add($_) }
    if ($IncludeCodex) {
        Get-CodexTemplateEntries | ForEach-Object { $entries.Add($_) }
    }
    @($entries)
}

$manifest = New-InstallManifest -Target $installTarget -ScopeName $Scope -Refresh:$allowOverwrite

Write-Host "`nCopying templates ($(if ($allowOverwrite) { 'refresh enabled for pack-owned paths' } else { 'no overwrite' }))...`n"

foreach ($entry in $templateMap) {
    $src = Join-Path $RuntimeRoot $entry.Src
    $dst = Join-Path $installTarget $entry.Dst
    Copy-TemplateSafe -SourceFile $src -DestFile $dst -Manifest $manifest `
        -BackupRoot $backupRoot -InstallTargetRoot $installTarget -AllowOverwrite:$allowOverwrite
}

if ($Scope -eq 'User') {
    $geminiUserDest = Join-Path $installTarget '.gemini\GEMINI.md'
    $geminiUserSrc = Join-Path $RuntimeRoot $GeminiUserTemplateRel
    Merge-SpacexGeminiUser -DestFile $geminiUserDest -TemplateFile $geminiUserSrc `
        -Manifest $manifest -BackupRoot $backupRoot -InstallTargetRoot $installTarget
}

Write-Verbose 'Skipped archive: runtime/archive/reference.cj-linux.md'

Save-InstallManifest -Target $installTarget -Manifest $manifest

Write-Host "`n--- Summary ---" -ForegroundColor White
Write-Host "  Copied:    $($manifest.copied.Count)"
Write-Host "  Refreshed: $($manifest.refreshed.Count)"
Write-Host "  Skipped:   $($manifest.skipped.Count) (existing)"
Write-Host "  Missing:   $($manifest.missing_source.Count) (source)"

if ($Scope -eq 'Sandbox') {
    Write-Host "`nNext: .\tooling\scripts\Validate-OrchestratorPack.ps1 -TargetPath `"$installTarget`" -Strict" -ForegroundColor Yellow
}

Write-Host ''
