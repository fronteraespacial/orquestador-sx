# SpaceX Orchestrator — Orchestrator.ps1
# Unified CLI: init | status | update | uninstall
# Delegates install to Install-Orchestrator.ps1

[CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'status')]
param(
    [Parameter(Position = 0, ParameterSetName = 'init')]
    [Parameter(Position = 0, ParameterSetName = 'status')]
    [Parameter(Position = 0, ParameterSetName = 'update')]
    [Parameter(Position = 0, ParameterSetName = 'uninstall')]
    [ValidateSet('init', 'status', 'update', 'uninstall')]
    [string] $Command = 'status',

    [Parameter(ParameterSetName = 'init')]
    [Parameter(ParameterSetName = 'uninstall')]
    [ValidateSet('user', 'project')]
    [string] $Scope = 'project',

    [Parameter(ParameterSetName = 'init')]
    [ValidateSet('release', 'local')]
    [string] $Source = 'local',

    [Parameter(ParameterSetName = 'init')]
    [string] $Version = '',

    [Parameter(ParameterSetName = 'init')]
    [Parameter(ParameterSetName = 'status')]
    [Parameter(ParameterSetName = 'update')]
    [Parameter(ParameterSetName = 'uninstall')]
    [string] $TargetPath = '',

    [Parameter(ParameterSetName = 'init')]
    [switch] $ConfirmUserScope,

    [Parameter(ParameterSetName = 'update')]
    [switch] $Check,

    [Parameter(ParameterSetName = 'update')]
    [switch] $Apply
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$PackRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$InstallScript = Join-Path $ScriptDir 'Install-Orchestrator.ps1'
$DefaultRepo = 'fronteraespacial/orquestador-sx'
$CacheRoot = Join-Path $env:LOCALAPPDATA 'spacex-orchestrator\cache'
$UserLockDir = Join-Path $env:USERPROFILE '.spacex-orchestrator'
$CheckThrottleHours = 24

function Get-PackVersion {
    $v = (Get-Content (Join-Path $PackRoot 'VERSION') -Raw).Trim()
    if ($Version) { return $Version.TrimStart('v') }
    return $v
}

function Get-ProjectLockPath {
    param([string] $Root)
    Join-Path $Root '.orchestrator-lock.json'
}

function Get-UserLockPath {
    Join-Path $UserLockDir 'lock.json'
}

function Read-LockFile {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Write-LockFile {
    param(
        [string] $Path,
        [hashtable] $Lock
    )
    $dir = Split-Path -Parent $Path
    if ($dir -and -not (Test-Path -LiteralPath $dir)) {
        if ($PSCmdlet.ShouldProcess($dir, 'Create lock directory')) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    if ($PSCmdlet.ShouldProcess($Path, 'Write orchestrator lock')) {
        ($Lock | ConvertTo-Json -Depth 4) + "`n" | Set-Content -LiteralPath $Path -Encoding UTF8 -NoNewline
        Write-Host "Lock: $Path" -ForegroundColor DarkGray
    }
}

function Get-LocalPackSha256 {
    $versionPath = Join-Path $PackRoot 'VERSION'
    if (-not (Test-Path -LiteralPath $versionPath)) {
        throw "VERSION file not found under pack root: $PackRoot"
    }
    if ($WhatIfPreference) { return '(whatif)' }
    $hashObj = Get-FileHash -LiteralPath $versionPath -Algorithm SHA256
    return $hashObj.Hash.ToLowerInvariant()
}

function Resolve-InitTarget {
    param([string] $ScopeName, [string] $ExplicitTarget)

    switch ($ScopeName) {
        'project' {
            if (-not $ExplicitTarget) {
                throw 'init --scope project requires --target PATH (repo root).'
            }
            return (Resolve-Path -LiteralPath $ExplicitTarget -ErrorAction Stop).Path
        }
        'user' {
            if (-not $ConfirmUserScope) {
                throw 'init --scope user requires -ConfirmUserScope.'
            }
            if ($ExplicitTarget) {
                return (Resolve-Path -LiteralPath $ExplicitTarget -ErrorAction Stop).Path
            }
            return $env:USERPROFILE
        }
    }
}

function New-LockObject {
    param(
        [string] $Ver,
        [string] $Sha,
        [string] $Src,
        [bool] $Enabled = $true,
        [string] $LastCheck = $null
    )
    return [ordered]@{
        schemaVersion  = '1.0'
        version        = $Ver
        sha256         = $Sha
        source         = $Src
        policy         = 'track-stable'
        enabled        = $Enabled
        installed_at   = (Get-Date).ToUniversalTime().ToString('o')
        last_check_at  = $LastCheck
    }
}

function Invoke-Init {
    $ver = Get-PackVersion
    $target = Resolve-InitTarget -ScopeName $Scope -ExplicitTarget $TargetPath
    $sha = if ($Source -eq 'local') { Get-LocalPackSha256 } else { 'pending-release-apply' }

    Write-Host "`nOrchestrator init (scope=$Scope, source=$Source, version=$ver)" -ForegroundColor White
    Write-Host "Target: $target`n"

    if ($WhatIfPreference) {
        Write-Host "WhatIf: would install templates and write lock (sha256=$sha)" -ForegroundColor Cyan
        return
    }

    $installScope = if ($Scope -eq 'user') { 'User' } else { 'Project' }
    $installArgs = @{
        Scope      = $installScope
        TargetPath = if ($Scope -eq 'user' -and -not $TargetPath) { '' } else { $target }
    }
    if ($ConfirmUserScope) { $installArgs['ConfirmUserScope'] = $true }

    & $InstallScript @installArgs
    if (-not $?) { throw 'Install-Orchestrator.ps1 failed' }

    $lock = New-LockObject -Ver $ver -Sha $sha -Src $Source

    if ($Scope -eq 'project' -or $TargetPath) {
        $projectRoot = if ($Scope -eq 'project') { $target } else { $TargetPath }
        if ($projectRoot) {
            Write-LockFile -Path (Get-ProjectLockPath -Root $projectRoot) -Lock $lock
        }
    }

    if ($Scope -eq 'user') {
        Write-LockFile -Path (Get-UserLockPath) -Lock $lock
        if ($TargetPath) {
            Write-LockFile -Path (Get-ProjectLockPath -Root $target) -Lock $lock
        }
    }
}

function Invoke-Status {
    param([string] $Root = '')

    if (-not $Root) {
        $Root = if ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath -ErrorAction SilentlyContinue).Path } else { (Get-Location).Path }
    }

    $projectLockPath = Get-ProjectLockPath -Root $Root
    $userLockPath = Get-UserLockPath
    $manifestPath = Join-Path $Root '.install-manifest.json'

    Write-Host "`nOrchestrator status (no network)`n" -ForegroundColor White
    Write-Host "Root: $Root"

    $lock = Read-LockFile -Path $projectLockPath
    if ($lock) {
        Write-Host "`nProject lock ($projectLockPath):" -ForegroundColor Cyan
        Write-Host "  version:       $($lock.version)"
        Write-Host "  source:        $($lock.source)"
        Write-Host "  policy:        $($lock.policy)"
        Write-Host "  enabled:       $($lock.enabled)"
        Write-Host "  sha256:        $($lock.sha256)"
        Write-Host "  installed_at:  $($lock.installed_at)"
        Write-Host "  last_check_at: $($lock.last_check_at)"
    }
    else {
        Write-Host "`nProject lock: MISSING ($projectLockPath)" -ForegroundColor Yellow
    }

    $userLock = Read-LockFile -Path $userLockPath
    if ($userLock) {
        Write-Host "`nUser lock ($userLockPath):" -ForegroundColor Cyan
        Write-Host "  version: $($userLock.version)  enabled: $($userLock.enabled)"
    }

    if (Test-Path -LiteralPath $manifestPath) {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
        Write-Host "`nInstall manifest:" -ForegroundColor Cyan
        Write-Host "  pack_version: $($manifest.pack_version)"
        Write-Host "  scope:        $($manifest.scope)"
        Write-Host "  installed_at: $($manifest.installed_at)"
    }
    else {
        Write-Host "`nInstall manifest: not found" -ForegroundColor Yellow
    }

    $skillPath = Join-Path $Root '.agents\skills\orchestrator\SKILL.md'
    if ($lock -and $lock.enabled -eq $true) {
        if (Test-Path -LiteralPath $skillPath) {
            Write-Host "`nSkill: present ($skillPath)" -ForegroundColor Green
        }
        else {
            Write-Host "`nSkill: MISSING (enabled lock requires skill)" -ForegroundColor Red
            exit 1
        }
    }
    elseif (Test-Path -LiteralPath $skillPath) {
        Write-Host "`nSkill: present (lock disabled or missing)" -ForegroundColor DarkGray
    }
}

function Get-LatestReleaseTag {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        $releaseJson = gh release view --repo $DefaultRepo --json tagName 2>&1
        if ($LASTEXITCODE -ne 0) { throw "gh release view failed: $releaseJson" }
        return ($releaseJson | ConvertFrom-Json).tagName
    }

    $api = "https://api.github.com/repos/$DefaultRepo/releases/latest"
    try {
        $release = Invoke-RestMethod -Uri $api -Method Get -Headers @{ 'User-Agent' = 'orquestador-sx' }
        return [string]$release.tag_name
    }
    catch {
        throw "Failed to fetch latest release (install gh CLI or ensure HTTPS access): $($_.Exception.Message)"
    }
}

function Save-ReleaseAssets {
    param(
        [string] $Tag,
        [string] $WorkDir
    )

    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        Push-Location $WorkDir
        try {
            gh release download $Tag --repo $DefaultRepo --pattern 'SHA256SUMS' --pattern '*.zip' 2>&1 | Out-Host
            if ($LASTEXITCODE -ne 0) { throw 'gh release download failed' }
        }
        finally {
            Pop-Location
        }
        return
    }

    $ver = $Tag.TrimStart('v')
    $base = "https://github.com/$DefaultRepo/releases/download/$Tag"
    $sumsPath = Join-Path $WorkDir 'SHA256SUMS'
    Invoke-WebRequest -Uri "$base/SHA256SUMS" -OutFile $sumsPath -UseBasicParsing

    $zipNames = @("orquestador-sx-v$ver.zip", "spacex-orchestrator-v$ver.zip")
    $downloaded = $false
    foreach ($name in $zipNames) {
        try {
            Invoke-WebRequest -Uri "$base/$name" -OutFile (Join-Path $WorkDir $name) -UseBasicParsing
            $downloaded = $true
            break
        }
        catch {
            continue
        }
    }
    if (-not $downloaded) {
        throw "Release zip not found for tag $Tag"
    }
}

function Test-CheckThrottle {
    param([object] $Lock)

    $cacheMeta = Join-Path $CacheRoot 'last-check.json'
    $lastCheck = $null

    if ($Lock -and $Lock.last_check_at) {
        $lastCheck = [datetime]::Parse($Lock.last_check_at)
    }
    elseif (Test-Path -LiteralPath $cacheMeta) {
        $meta = Get-Content -LiteralPath $cacheMeta -Raw | ConvertFrom-Json
        if ($meta.last_check_at) { $lastCheck = [datetime]::Parse($meta.last_check_at) }
    }

    if ($lastCheck) {
        $next = $lastCheck.AddHours($CheckThrottleHours)
        if ((Get-Date).ToUniversalTime() -lt $next) {
            Write-Host "Check skipped (24h throttle). Next allowed: $($next.ToString('o'))" -ForegroundColor Yellow
            return $false
        }
    }
    return $true
}

function Save-CheckTimestamp {
    param([string] $ProjectRoot = '')

    $now = (Get-Date).ToUniversalTime().ToString('o')
    if (-not (Test-Path -LiteralPath $CacheRoot)) {
        New-Item -ItemType Directory -Path $CacheRoot -Force | Out-Null
    }
    @{ last_check_at = $now } | ConvertTo-Json | Set-Content (Join-Path $CacheRoot 'last-check.json') -Encoding UTF8

    if ($ProjectRoot) {
        $lockPath = Get-ProjectLockPath -Root $ProjectRoot
        $lock = Read-LockFile -Path $lockPath
        if ($lock) {
            $lock.last_check_at = $now
            Write-LockFile -Path $lockPath -Lock ([ordered]@{
                    schemaVersion = $lock.schemaVersion
                    version       = $lock.version
                    sha256        = $lock.sha256
                    source        = $lock.source
                    policy        = $lock.policy
                    enabled       = $lock.enabled
                    installed_at  = $lock.installed_at
                    last_check_at = $now
                })
        }
    }
}

function Invoke-UpdateCheck {
    $root = if ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath).Path } else { (Get-Location).Path }
    $lock = Read-LockFile -Path (Get-ProjectLockPath -Root $root)

    if (-not (Test-CheckThrottle -Lock $lock)) { exit 0 }

    $currentVer = if ($lock) { $lock.version } else { Get-PackVersion }
    Write-Host "Checking release for $DefaultRepo (current: $currentVer)..." -ForegroundColor Cyan

    $tagName = Get-LatestReleaseTag
    $remoteTag = $tagName.TrimStart('v')
    Save-CheckTimestamp -ProjectRoot $root

    if ($remoteTag -eq $currentVer) {
        Write-Host "Up to date ($remoteTag)." -ForegroundColor Green
    }
    else {
        Write-Host "Update available: $currentVer -> $remoteTag (tag $tagName)" -ForegroundColor Yellow
        Write-Host "Run: Orchestrator.ps1 update --apply -TargetPath `"$root`"" -ForegroundColor Yellow
    }
}

function Verify-Sha256Sums {
    param([string] $SumsFile, [string] $Dir)

    $lines = Get-Content -LiteralPath $SumsFile
    foreach ($line in $lines) {
        if ($line -match '^\s*$' -or $line -match '^\s*#') { continue }
        if ($line -notmatch '^([a-fA-F0-9]{64})\s{2}(.+)$') {
            throw "Invalid SHA256SUMS line: $line"
        }
        $expected = $Matches[1].ToLowerInvariant()
        $fileName = $Matches[2].Trim()
        $filePath = Join-Path $Dir $fileName
        if (-not (Test-Path -LiteralPath $filePath)) {
            throw "SHA256SUMS references missing file: $fileName"
        }
        $actual = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -ne $expected) {
            throw "SHA256 mismatch for ${fileName}: expected $expected got $actual"
        }
        Write-Host "  verified $fileName" -ForegroundColor Green
    }
}

function Invoke-UpdateApply {
    $root = if ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath).Path } else { (Get-Location).Path }
    $lock = Read-LockFile -Path (Get-ProjectLockPath -Root $root)

    if (-not (Test-Path -LiteralPath $CacheRoot)) {
        New-Item -ItemType Directory -Path $CacheRoot -Force | Out-Null
    }

    $tag = Get-LatestReleaseTag
    $ver = $tag.TrimStart('v')

    $workDir = Join-Path $CacheRoot "apply-$tag"
    if (Test-Path -LiteralPath $workDir) { Remove-Item -LiteralPath $workDir -Recurse -Force }
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null

    Write-Host "Downloading $tag from $DefaultRepo..." -ForegroundColor Cyan
    Save-ReleaseAssets -Tag $tag -WorkDir $workDir
    Push-Location $workDir
    try {
        $sums = Get-ChildItem -Filter 'SHA256SUMS' | Select-Object -First 1
        if (-not $sums) { throw 'SHA256SUMS not found in release assets' }
        Verify-Sha256Sums -SumsFile $sums.FullName -Dir $workDir

        $zip = Get-ChildItem -Filter '*.zip' | Select-Object -First 1
        if (-not $zip) { throw 'Release zip not found' }

        $extractDir = Join-Path $workDir 'extract'
        Expand-Archive -LiteralPath $zip.FullName -DestinationPath $extractDir -Force

        $extractedPack = Get-ChildItem -LiteralPath $extractDir -Directory | Select-Object -First 1
        if (-not $extractedPack) { throw 'Empty zip extract' }

        $remoteInstall = Join-Path $extractedPack.FullName 'tooling\scripts\Install-Orchestrator.ps1'
        if (-not (Test-Path -LiteralPath $remoteInstall)) {
            throw "Install script not found in release: $remoteInstall"
        }

        if ($WhatIfPreference) {
            Write-Host "WhatIf: would reinstall from $($zip.Name) and rewrite lock" -ForegroundColor Cyan
            return
        }

        & $remoteInstall -Scope Project -TargetPath $root -Force
        $zipHash = (Get-FileHash -LiteralPath $zip.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
        $newLock = New-LockObject -Ver $ver -Sha $zipHash -Src 'release' -LastCheck (Get-Date).ToUniversalTime().ToString('o')
        Write-LockFile -Path (Get-ProjectLockPath -Root $root) -Lock $newLock
        Write-Host "Update applied: $ver" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

function Invoke-Uninstall {
    param([string] $ScopeName, [string] $Root)

    Write-Host "`nOrchestrator uninstall (scope=$ScopeName)" -ForegroundColor White

    if ($ScopeName -eq 'user') {
        if (-not $ConfirmUserScope) { throw 'uninstall --scope user requires -ConfirmUserScope.' }
        $userLock = Get-UserLockPath
        if ($PSCmdlet.ShouldProcess($userLock, 'Remove user lock')) {
            if (Test-Path -LiteralPath $userLock) { Remove-Item -LiteralPath $userLock -Force }
            Write-Host 'Removed user lock (templates not auto-deleted - see .install-manifest.json)' -ForegroundColor Yellow
        }
    }

    if ($ScopeName -eq 'project' -or $TargetPath) {
        $projectRoot = if ($Root) { $Root } elseif ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath).Path } else { throw 'uninstall --scope project requires --target PATH' }
        $lockPath = Get-ProjectLockPath -Root $projectRoot
        if ($PSCmdlet.ShouldProcess($lockPath, 'Remove project lock')) {
            if (Test-Path -LiteralPath $lockPath) { Remove-Item -LiteralPath $lockPath -Force }
            Write-Host "Removed project lock: $lockPath" -ForegroundColor Yellow
        }
    }
}

# --- Main ---
switch ($Command) {
    'init' { Invoke-Init }
    'status' { Invoke-Status -Root $(if ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath -ErrorAction SilentlyContinue).Path }) }
    'update' {
        if ($Apply) { Invoke-UpdateApply }
        elseif ($Check -or -not $Apply) { Invoke-UpdateCheck }
        else { throw 'Use update --check or update --apply' }
    }
    'uninstall' {
        $t = if ($TargetPath) { (Resolve-Path -LiteralPath $TargetPath -ErrorAction SilentlyContinue).Path } else { '' }
        Invoke-Uninstall -ScopeName $Scope -Root $t
    }
    default { throw "Unknown command: $Command" }
}
