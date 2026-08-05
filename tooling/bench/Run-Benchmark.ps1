# SpaceX Orchestrator — Run-Benchmark.ps1
# Dry-run: preflight only. -Run: stream-json execution.
# routing = orchestrator delegate (requires Task stream). direct_role_control = role invoked directly (root model only).
# --trust applies only to generated paths under bench/worktrees/. Never pass --yolo.

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter()]
    [switch] $Run,

    [Parameter()]
    [int] $Replicas = 0,

    [Parameter()]
    [string] $Wave = '',

    [Parameter()]
    [string] $CaseFilter = '',

    [Parameter()]
    [string] $ResultsDir = '',

    [Parameter()]
    [switch] $NoTrustWorktree
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$BenchRoot = $PSScriptRoot
$PackRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$CasesDir = Join-Path $BenchRoot 'cases'
$ManifestPath = Join-Path $CasesDir 'manifest.json'
$WorktreesRoot = Join-Path $BenchRoot 'worktrees'
$ResultsRoot = if ($ResultsDir) { $ResultsDir } else { Join-Path $BenchRoot 'results' }
$SandboxPilot = Join-Path $PackRoot 'tooling\sandbox\pilot'
$SchemaVersion = '1.3.0'
$StreamLimitationNote = 'Nested Task subagent model telemetry unavailable in this CLI stream-json; direct_role_control uses root stream model only.'

function Write-Record {
    param([hashtable] $Record, [string] $JsonlPath)
    $json = ($Record | ConvertTo-Json -Compress -Depth 12)
    Add-Content -LiteralPath $JsonlPath -Value $json -Encoding UTF8
}

function Test-CursorCli {
    $cmd = Get-Command agent -ErrorAction SilentlyContinue
    if (-not $cmd) { return @{ available = $false; path = $null; version = $null } }
    $version = try { (& agent --version 2>&1 | Out-String).Trim() } catch { 'unknown' }
    return @{ available = $true; path = $cmd.Source; version = $version }
}

function Test-CursorAuth {
    try {
        $out = & agent --list-models 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0 -and $out -match '(?i)(auth|login|unauthorized|not logged)') {
            return @{ ok = $false; detail = $out.Trim() }
        }
        if ($out.Length -gt 10) { return @{ ok = $true; detail = 'list-models returned data' } }
        return @{ ok = $false; detail = $out.Trim() }
    }
    catch { return @{ ok = $false; detail = $_.Exception.Message } }
}

function Get-AvailableModels {
    try {
        $raw = & agent --list-models 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { return @() }
        return @($raw -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '^(Model|Available|--)' })
    }
    catch { return @() }
}

function Get-CaseOptionalProperty {
    param(
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object] $CaseObj,

        [Parameter(Mandatory = $true)]
        [Alias('PropertyName')]
        [string] $Name
    )
    # StrictMode-safe: never dereference missing note properties (throws under -Version Latest).
    if ($null -eq $CaseObj -or [string]::IsNullOrEmpty($Name)) { return $null }
    $prop = $CaseObj.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $null }
    return $prop.Value
}

function Get-ManifestOptionalProperty {
    param(
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object] $ManifestObj,

        [Parameter(Mandatory = $true)]
        [Alias('PropertyName')]
        [string] $Name
    )
    if ($null -eq $ManifestObj -or [string]::IsNullOrEmpty($Name)) { return $null }
    $prop = $ManifestObj.PSObject.Properties[$Name]
    if ($null -eq $prop) { return $null }
    return $prop.Value
}

function Get-CaseExecutionMode {
    param([pscustomobject] $CaseObj)
    $mode = Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'execution_mode'
    if ($mode) { return [string]$mode }
    $mt = Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'measurement_type'
    if ($mt -eq 'direct_role_control') { return 'direct_role_control' }
    if ($mt -eq 'routing') { return 'orchestrator_delegate' }
    return 'unknown'
}

function Get-CaseModelRequested {
    param([pscustomobject] $CaseObj)
    $mode = Get-CaseExecutionMode -CaseObj $CaseObj
    if ($mode -eq 'direct_role_control') {
        return Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'role_model_requested'
    }
    return Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'parent_model_requested'
}

function Get-CaseModelInfoForDisplay {
    param([pscustomobject] $CaseObj)
    $mode = Get-CaseExecutionMode -CaseObj $CaseObj
    if ($mode -eq 'direct_role_control') {
        return ' role_model=' + (Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'role_model_requested')
    }
    return ' parent=' + (Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'parent_model_requested')
}

function Resolve-BenchCaseFilePath {
    param([string] $RelativePath, [string] $Label = 'case file')
    if (-not $RelativePath) {
        throw "Missing $Label path under $CasesDir"
    }
    return Join-Path $CasesDir $RelativePath
}

function Build-CaseRecordModels {
    param(
        [pscustomobject] $CaseObj,
        [string] $ExecutionMode
    )
    return @{
        parent_model_requested = if ($ExecutionMode -eq 'orchestrator_delegate') {
            Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'parent_model_requested'
        } else { $null }
        role_model_requested = if ($ExecutionMode -eq 'direct_role_control') {
            Get-CaseOptionalProperty -CaseObj $CaseObj -Name 'role_model_requested'
        } else { $null }
    }
}

function Get-AgentContractBody {
    param([string] $WorktreePath, [string] $DelegateRole)

    $agentPath = Join-Path $WorktreePath ".cursor\agents\$DelegateRole.md"
    if (-not (Test-Path -LiteralPath $agentPath)) { return '' }
    $raw = Get-Content -LiteralPath $agentPath -Raw
    if ($raw -match '(?ms)\A---\r?\n.*?\r?\n---\r?\n(.*)\z') {
        return $Matches[1].Trim()
    }
    return $raw.Trim()
}

function Build-RoutingPrompt {
    param(
        [pscustomobject] $CaseManifest,
        [pscustomobject] $BenchManifest
    )
    $wrapperPath = Resolve-BenchCaseFilePath -RelativePath (Get-ManifestOptionalProperty -ManifestObj $BenchManifest -Name 'wrapper_file') -Label 'wrapper_file'
    $envelopePath = Resolve-BenchCaseFilePath -RelativePath (Get-CaseOptionalProperty -CaseObj $CaseManifest -Name 'envelope_file') -Label 'envelope_file'
    $wrapper = if (Test-Path $wrapperPath) { Get-Content $wrapperPath -Raw } else { '' }
    $envelope = if (Test-Path $envelopePath) { Get-Content $envelopePath -Raw } else { '' }
    $role = Get-CaseOptionalProperty -CaseObj $CaseManifest -Name 'delegate_role'
    return ($wrapper -replace '\{\{DELEGATE_ROLE\}\}', $role) -replace '\{\{ENVELOPE\}\}', $envelope
}

function Build-DirectRolePrompt {
    param(
        [pscustomobject] $CaseManifest,
        [pscustomobject] $BenchManifest,
        [string] $WorktreePath
    )
    $wrapperPath = Resolve-BenchCaseFilePath -RelativePath (Get-ManifestOptionalProperty -ManifestObj $BenchManifest -Name 'direct_role_wrapper_file') -Label 'direct_role_wrapper_file'
    $envelopePath = Resolve-BenchCaseFilePath -RelativePath (Get-CaseOptionalProperty -CaseObj $CaseManifest -Name 'envelope_file') -Label 'envelope_file'
    $wrapper = if (Test-Path $wrapperPath) { Get-Content $wrapperPath -Raw } else { '' }
    $envelope = if (Test-Path $envelopePath) { Get-Content $envelopePath -Raw } else { '' }
    $role = Get-CaseOptionalProperty -CaseObj $CaseManifest -Name 'delegate_role'
    $contract = Get-AgentContractBody -WorktreePath $WorktreePath -DelegateRole $role
    return ($wrapper -replace '\{\{DELEGATE_ROLE\}\}', $role) `
        -replace '\{\{ROLE_CONTRACT\}\}', $contract `
        -replace '\{\{ENVELOPE\}\}', $envelope
}

function Copy-PilotAsset {
    param([string] $RelativePath, [string] $DestRoot)

    $src = Join-Path $SandboxPilot $RelativePath
    if (-not (Test-Path -LiteralPath $src)) { return $false }
    $target = Join-Path $DestRoot $RelativePath
    $dir = Split-Path -Parent $target
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Copy-Item -LiteralPath $src -Destination $target -Force
    return $true
}

function New-Worktree {
    param(
        [string] $RunId,
        [string] $CaseId,
        [int] $Replica,
        [pscustomobject] $CaseEntry
    )

    $dest = Join-Path $WorktreesRoot "$RunId\case-$CaseId-r$Replica"
    if (Test-Path -LiteralPath $dest) { return $dest }
    New-Item -ItemType Directory -Path $dest -Force | Out-Null

    $copyRoots = @(
        '.cursor\rules\cj-orchestrator-mandatory.mdc',
        '.agents\skills\orchestrator\SKILL.md',
        '.lab\README.md',
        'AGENTS.md'
    )
    foreach ($rel in $copyRoots) { [void](Copy-PilotAsset -RelativePath $rel -DestRoot $dest) }

    $agentsSrc = Join-Path $SandboxPilot '.cursor\agents'
    if (Test-Path -LiteralPath $agentsSrc) {
        Get-ChildItem -LiteralPath $agentsSrc -Filter '*.md' -File | ForEach-Object {
            $rel = ".cursor\agents\$($_.Name)"
            [void](Copy-PilotAsset -RelativePath $rel -DestRoot $dest)
        }
    }

    $metaPath = Join-Path $dest '.bench-worktree-meta.json'
    $meta = [ordered]@{
        case_id        = $CaseId
        replica        = $Replica
        execution_mode = Get-CaseExecutionMode -CaseObj $CaseEntry
        delegate_role  = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'delegate_role'
    }
    $mode = Get-CaseExecutionMode -CaseObj $CaseEntry
    if ($mode -eq 'direct_role_control') {
        $meta.role_model_requested = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'role_model_requested'
    }
    else {
        $meta.parent_model_requested = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'parent_model_requested'
    }
    ($meta | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath $metaPath -Encoding UTF8

    return $dest
}

function Parse-StreamJsonEvents {
    param([string] $RawStream)

    $events = [System.Collections.ArrayList]@()
    $rootModelResolved = $null
    $agentResolved = $null
    $delegationProven = $false

    foreach ($line in ($RawStream -split "`n")) {
        $trim = $line.Trim()
        if (-not $trim -or $trim[0] -ne '{') { continue }
        try {
            $obj = $trim | ConvertFrom-Json
        }
        catch { continue }

        $type = [string]$obj.type
        $ev = [ordered]@{ type = $type; raw_keys = @($obj.PSObject.Properties.Name) }

        $isDelegationEvent = $false
        if ($type -match '(?i)(subagent|task|tool_call|delegat|spawn)') { $isDelegationEvent = $true }
        if ($obj.PSObject.Properties.Name -contains 'subagent') { $isDelegationEvent = $true }
        if ($obj.PSObject.Properties.Name -contains 'tool' -and [string]$obj.tool -match '(?i)Task') { $isDelegationEvent = $true }

        if ($isDelegationEvent) {
            $delegationProven = $true
            $ev.delegation_signal = $true
        }

        if ($obj.PSObject.Properties.Name -contains 'model' -and $obj.model) {
            $modelVal = [string]$obj.model
            $ev.model = $modelVal
            if (-not $rootModelResolved) {
                $rootModelResolved = $modelVal
                $ev.model_scope = 'root'
            }
        }

        foreach ($key in @('subagent', 'agent', 'agent_name', 'tool', 'tool_name', 'name', 'subagent_type')) {
            if ($obj.PSObject.Properties.Name -contains $key -and $obj.$key) {
                $val = [string]$obj.$key
                if ($val -match '(?i)(explore|scout|maverick|implementer|lab-runner|lab|verifier|orchestrator|skeptic|deletion|Task)') {
                    $agentResolved = $val
                    $ev.agent_hint = $val
                }
            }
        }

        [void]$events.Add($ev)
    }

    return @{
        events            = @($events)
        root_model_resolved = $rootModelResolved
        agent_resolved    = $agentResolved
        delegation_proven = $delegationProven
    }
}

function Invoke-HeuristicTest {
    param([pscustomobject] $Test, [string] $Output)
    $matched = $Output -match $Test.pattern
    switch ($Test.expect) {
        'present' { return [bool]$matched }
        'absent_or_negated' {
            if (-not $matched) { return $true }
            return [bool]($Output -match '(?i)(no\s+implement|read.?only|without\s+writ|NOT\s+projects)')
        }
        default { return [bool]$matched }
    }
}

function Test-CasePassed {
    param(
        [string] $ExecutionMode,
        [int] $ExitCode,
        [int] $TestsFailed,
        [string] $DelegationStatus,
        [string] $RoleModelResolvedStatus,
        [bool] $WorkspaceTrustBlocked
    )
    if ($WorkspaceTrustBlocked) { return 'failed' }
    if ($ExitCode -ne 0 -or $TestsFailed -gt 0) { return 'failed' }
    if ($ExecutionMode -eq 'orchestrator_delegate') {
        if ($DelegationStatus -ne 'stream_proven') { return 'failed' }
        return 'passed'
    }
    if ($ExecutionMode -eq 'direct_role_control') {
        if ($RoleModelResolvedStatus -ne 'stream_proven') { return 'failed' }
        return 'passed'
    }
    return 'inconclusive'
}

function Test-WorkspaceTrustBlocked {
    param([string] $Output)
    return [bool]($Output -match '(?i)Workspace Trust Required')
}

function Write-RunSummary {
    param(
        [hashtable] $Stats,
        [string] $JsonlPath,
        [string] $RunId,
        [string] $WaveName,
        [string] $AbortReason = $null,
        [string] $RuntimeError = $null
    )

    $incomplete = $Stats.executions_completed -lt $Stats.executions_planned
    $failed = ($Stats.exit_code_nonzero -gt 0) -or ($Stats.routing_delegation_missing -gt 0) `
        -or ($Stats.direct_role_model_unverified -gt 0) -or ($Stats.tests_failed_total -gt 0) `
        -or $AbortReason -or $RuntimeError -or $incomplete
    $runStatus = if ($AbortReason -eq 'workspace_trust_required') { 'aborted_trust' }
                 elseif ($RuntimeError) { 'failed' }
                 elseif ($failed) { 'failed' }
                 else { 'passed' }

    $summary = [ordered]@{
        schema_version               = $SchemaVersion
        run_id                       = $RunId
        wave                         = $WaveName
        case_id                      = '_summary'
        replica                      = 0
        timestamp_utc                = (Get-Date).ToUniversalTime().ToString('o')
        dry_run                      = $false
        run_status                   = $runStatus
        executions_planned           = $Stats.executions_planned
        executions_completed         = $Stats.executions_completed
        cases_passed                 = $Stats.cases_passed
        cases_failed                 = $Stats.cases_failed
        exit_code_nonzero            = $Stats.exit_code_nonzero
        routing_delegation_missing   = $Stats.routing_delegation_missing
        direct_role_model_unverified = $Stats.direct_role_model_unverified
        tests_failed_total           = $Stats.tests_failed_total
        abort_reason                 = $AbortReason
        stream_limitation_note       = $StreamLimitationNote
        error                        = $RuntimeError
        heuristic_notes              = @($StreamLimitationNote)
    }
    Write-Record -Record $summary -JsonlPath $JsonlPath

    Write-Host "`n--- Run summary ---" -ForegroundColor White
    Write-Host "  Status:    $runStatus" -ForegroundColor $(if ($runStatus -eq 'passed') { 'Green' } else { 'Red' })
    Write-Host "  Completed: $($Stats.executions_completed)/$($Stats.executions_planned)  Passed: $($Stats.cases_passed)  Failed: $($Stats.cases_failed)"
    Write-Host "  Note:      $StreamLimitationNote" -ForegroundColor DarkGray
    if ($Stats.exit_code_nonzero -gt 0) {
        Write-Host "  Non-zero exit codes: $($Stats.exit_code_nonzero)" -ForegroundColor Red
    }
    if ($Stats.routing_delegation_missing -gt 0) {
        Write-Host "  Routing without Task stream: $($Stats.routing_delegation_missing)" -ForegroundColor Red
    }
    if ($Stats.direct_role_model_unverified -gt 0) {
        Write-Host "  Direct role model unverified: $($Stats.direct_role_model_unverified)" -ForegroundColor Red
    }
    if ($Stats.tests_failed_total -gt 0) {
        Write-Host "  Heuristic failures: $($Stats.tests_failed_total)" -ForegroundColor Red
    }
    if ($AbortReason) {
        Write-Host "  Abort reason: $AbortReason" -ForegroundColor Red
    }
    if ($RuntimeError) {
        Write-Host "  Runtime error: $RuntimeError" -ForegroundColor Red
    }
    if ($incomplete) {
        Write-Host "  Incomplete: $($Stats.executions_completed)/$($Stats.executions_planned) executions finished" -ForegroundColor Red
    }

    return @{
        run_status = $runStatus
        exit_code  = if ($runStatus -eq 'passed') { 0 } else { 1 }
    }
}

function Invoke-CaseExecution {
    param(
        [pscustomobject] $CaseEntry,
        [pscustomobject] $ManifestRoot,
        [string] $RunId,
        [string] $WaveName,
        [int] $Replica,
        [string] $JsonlPath,
        [string[]] $AvailableModels,
        [bool] $TrustWorktree
    )

    $executionMode = Get-CaseExecutionMode -CaseObj $CaseEntry
    $worktree = New-Worktree -RunId $RunId -CaseId $CaseEntry.id -Replica $Replica -CaseEntry $CaseEntry

    $prompt = if ($executionMode -eq 'direct_role_control') {
        Build-DirectRolePrompt -CaseManifest $CaseEntry -BenchManifest $ManifestRoot -WorktreePath $worktree
    }
    else {
        Build-RoutingPrompt -CaseManifest $CaseEntry -BenchManifest $ManifestRoot
    }

    $modelArg = Get-CaseModelRequested -CaseObj $CaseEntry
    $modelFields = Build-CaseRecordModels -CaseObj $CaseEntry -ExecutionMode $executionMode

    $record = [ordered]@{
        schema_version               = $SchemaVersion
        run_id                       = $RunId
        wave                         = $WaveName
        case_id                      = $CaseEntry.id
        measurement_type             = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'measurement_type'
        execution_mode               = $executionMode
        category                     = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'category'
        envelope_file                = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'envelope_file'
        replica                      = $Replica
        timestamp_utc                = (Get-Date).ToUniversalTime().ToString('o')
        dry_run                      = $false
        parent_model_requested       = $modelFields.parent_model_requested
        parent_model_resolved        = $null
        parent_model_resolved_status = if ($executionMode -eq 'orchestrator_delegate') { 'unverified' } else { $null }
        role_model_requested         = $modelFields.role_model_requested
        role_model_resolved          = $null
        role_model_resolved_status   = if ($executionMode -eq 'direct_role_control') { 'unverified' } else { $null }
        agent_requested              = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'delegate_role'
        agent_resolved               = $null
        agent_resolved_status        = 'unverified'
        delegation_status            = if ($executionMode -eq 'orchestrator_delegate') { 'unverified' } else { 'not_applicable' }
        model_requested              = $modelArg
        model_resolved               = $null
        model_resolved_status        = 'unverified'
        case_passed                  = 'inconclusive'
        subagent_events              = @()
        stream_json_line_count       = 0
        duration_ms                  = $null
        tests_passed                 = 0
        tests_failed                 = 0
        worktree_path                = $worktree
        exit_code                    = $null
        stdout_preview               = $null
        heuristic_notes              = @()
        stream_limitation_note       = if ($executionMode -eq 'direct_role_control') { $StreamLimitationNote } else { $null }
        error                        = $null
        trust_worktree               = $TrustWorktree
        workspace_trust_blocked      = $false
    }

    if (-not $PSCmdlet.ShouldProcess($CaseEntry.id, "Execute benchmark case (replica $Replica)")) {
        $record.error = 'cancelled_by_shouldprocess'
        $record.case_passed = 'failed'
        Write-Record -Record $record -JsonlPath $JsonlPath
        return @{ trust_blocked = $false; case_passed = 'failed'; execution_mode = $executionMode; exit_code = -1; tests_failed = 0; delegation_status = $record.delegation_status; role_model_resolved_status = $record.role_model_resolved_status }
    }

    if ($AvailableModels.Count -gt 0 -and $modelArg -and -not ($AvailableModels | Where-Object { $_ -match [regex]::Escape($modelArg) })) {
        $record.heuristic_notes += 'model_requested not found in list-models'
    }

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $rawOut = ''
    try {
        Push-Location $worktree
        $argList = @('-p', $prompt, '--output-format', 'stream-json', '--model', $modelArg)
        if ($TrustWorktree) { $argList += '--trust' }
        $rawOut = (& agent @argList 2>&1 | Out-String)
        $exitCode = $LASTEXITCODE
    }
    catch {
        $record.error = $_.Exception.Message
        $exitCode = -1
    }
    finally { Pop-Location }

    $sw.Stop()
    $parsed = Parse-StreamJsonEvents -RawStream $rawOut
    $record.stream_json_line_count = $parsed.events.Count
    $record.subagent_events = $parsed.events

    if ($parsed.root_model_resolved) {
        $record.model_resolved = $parsed.root_model_resolved
        $record.model_resolved_status = 'stream_proven'
        if ($executionMode -eq 'direct_role_control') {
            $record.role_model_resolved = $parsed.root_model_resolved
            $record.role_model_resolved_status = 'stream_proven'
        }
        else {
            $record.parent_model_resolved = $parsed.root_model_resolved
            $record.parent_model_resolved_status = 'stream_proven'
        }
    }
    if ($parsed.agent_resolved) {
        $record.agent_resolved = $parsed.agent_resolved
        $record.agent_resolved_status = 'stream_proven'
    }
    if ($executionMode -eq 'orchestrator_delegate' -and $parsed.delegation_proven) {
        $record.delegation_status = 'stream_proven'
    }

    $textOut = ($rawOut -split "`n" | Where-Object { $_ -notmatch '^\s*\{' } | Out-String)
    $record.duration_ms = [int]$sw.ElapsedMilliseconds
    $record.exit_code = $exitCode
    $record.stdout_preview = if ($rawOut.Length -gt 2000) { $rawOut.Substring(0, 2000) } else { $rawOut }

    if (Test-WorkspaceTrustBlocked -Output $rawOut) {
        $record.workspace_trust_blocked = $true
        $record.error = 'workspace_trust_required'
        $record.case_passed = 'failed'
        $record.heuristic_notes += 'Workspace Trust Required; pilot aborted'
        Write-Record -Record $record -JsonlPath $JsonlPath
        Write-Host "  $($CaseEntry.id) r$Replica - ABORT: Workspace Trust Required" -ForegroundColor Red
        return @{ trust_blocked = $true; case_passed = 'failed'; execution_mode = $executionMode; exit_code = $exitCode; tests_failed = 0; delegation_status = $record.delegation_status; role_model_resolved_status = $record.role_model_resolved_status }
    }

    $rawTests = Get-CaseOptionalProperty -CaseObj $CaseEntry -Name 'tests'
    $caseTests = if ($null -ne $rawTests) { @($rawTests) } else { @() }
    foreach ($test in $caseTests) {
        $pass = Invoke-HeuristicTest -Test $test -Output ($textOut + "`n" + $rawOut)
        if ($pass) { $record.tests_passed++ } else { $record.tests_failed++ }
    }

    $record.case_passed = Test-CasePassed -ExecutionMode $executionMode -ExitCode $exitCode `
        -TestsFailed $record.tests_failed -DelegationStatus $record.delegation_status `
        -RoleModelResolvedStatus $record.role_model_resolved_status -WorkspaceTrustBlocked $false

    Write-Record -Record $record -JsonlPath $JsonlPath

    $modeTag = if ($executionMode -eq 'direct_role_control') {
        " role_model:$($record.role_model_resolved_status)"
    }
    else {
        " deleg:$($record.delegation_status) parent:$($record.parent_model_resolved_status)"
    }
    $color = if ($record.case_passed -eq 'passed') { 'Green' } elseif ($record.case_passed -eq 'failed') { 'Red' } else { 'Yellow' }
    Write-Host "  $($CaseEntry.id) r$Replica [$executionMode]$modeTag pass:$($record.case_passed)" -ForegroundColor $color

    return @{
        trust_blocked               = $false
        case_passed                 = $record.case_passed
        execution_mode              = $executionMode
        exit_code                   = $exitCode
        tests_failed                = $record.tests_failed
        delegation_status           = $record.delegation_status
        role_model_resolved_status  = $record.role_model_resolved_status
    }
}

# --- Main ---
Write-Host "`nSpaceX Orchestrator - Cursor Benchmark (routing + direct role)`n" -ForegroundColor White

$manifestRoot = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$waveName = if ($Wave) { $Wave } else { $manifestRoot.wave_default }
$replicaCount = if ($Replicas -gt 0) { $Replicas } else { [int]$manifestRoot.default_replicas }
$trustWorktree = -not $NoTrustWorktree

Write-Host "Wave:     $waveName"
Write-Host "Replicas: $replicaCount"
Write-Host "Mode:     $(if ($Run) { 'EXECUTE (-Run)' } else { 'DRY-RUN (preflight only)' })"
if ($Run) {
    Write-Host ("Trust:    " + $(if ($trustWorktree) { 'ON (agent --trust per worktree)' } else { 'OFF (-NoTrustWorktree)' }))
}
Write-Host "Note:     $StreamLimitationNote" -ForegroundColor DarkGray
Write-Host ''

$cli = Test-CursorCli
Write-Host '--- Preflight ---' -ForegroundColor White
if ($cli.available) {
    Write-Host "  CLI:     OK ($($cli.path))" -ForegroundColor Green
    Write-Host "  Version: $($cli.version)"
}
else {
    Write-Host '  CLI:     NOT FOUND' -ForegroundColor Red
}

$auth = @{ ok = $false; detail = 'skipped' }
$models = @()
if ($cli.available) {
    $auth = Test-CursorAuth
    if ($auth.ok) {
        Write-Host '  Auth:    OK' -ForegroundColor Green
        $models = Get-AvailableModels
        Write-Host "  Models:  $($models.Count) reported"
    }
    else {
        Write-Host "  Auth:    FAIL - $($auth.detail)" -ForegroundColor Yellow
    }
}

$cases = @($manifestRoot.cases)
if ($CaseFilter) {
    $cases = @($cases | Where-Object {
        if ($CaseFilter -match '[\*\?\[]') { $_.id -like "*$CaseFilter*" }
        else { $_.id -eq $CaseFilter }
    })
}

$routingCases = @($cases | Where-Object { (Get-CaseExecutionMode -CaseObj $_) -eq 'orchestrator_delegate' })
$directCases = @($cases | Where-Object { (Get-CaseExecutionMode -CaseObj $_) -eq 'direct_role_control' })

Write-Host "`n--- Cases ($($cases.Count) = $($routingCases.Count) routing + $($directCases.Count) direct_role_control) ---" -ForegroundColor White

if (-not $Run) {
    foreach ($caseEntry in $cases) {
        $modelInfo = Get-CaseModelInfoForDisplay -CaseObj $caseEntry
        Write-Host "  [dry-run] $($caseEntry.id) mode=$(Get-CaseExecutionMode -CaseObj $caseEntry) cat=$(Get-CaseOptionalProperty -CaseObj $caseEntry -Name 'category')$modelInfo delegate=$(Get-CaseOptionalProperty -CaseObj $caseEntry -Name 'delegate_role')" -ForegroundColor Cyan
    }
    Write-Host "`nPreflight complete. Re-run with -Run to execute." -ForegroundColor Yellow
    exit 0
}

if (-not $cli.available) { Write-Host "`nCannot -Run without Cursor CLI." -ForegroundColor Red; exit 1 }
if (-not $auth.ok) { Write-Host "`nCannot -Run: authentication failed." -ForegroundColor Red; exit 1 }

$runId = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + ([guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $ResultsRoot -Force | Out-Null
New-Item -ItemType Directory -Path $WorktreesRoot -Force | Out-Null
$jsonlPath = Join-Path $ResultsRoot "$runId.jsonl"

Write-Host "Run ID:   $runId"
Write-Host "Results:  $jsonlPath`n"

$runStats = @{
    executions_planned           = $cases.Count * $replicaCount
    executions_completed         = 0
    cases_passed                 = 0
    cases_failed                 = 0
    exit_code_nonzero            = 0
    routing_delegation_missing   = 0
    direct_role_model_unverified = 0
    tests_failed_total           = 0
}
$abortReason = $null
$runtimeError = $null
$finalExit = 1

try {
    Write-Record -Record ([ordered]@{
        schema_version         = $SchemaVersion
        run_id                 = $runId
        wave                   = $waveName
        case_id                = '_preflight'
        replica                = 0
        timestamp_utc          = (Get-Date).ToUniversalTime().ToString('o')
        dry_run                = $false
        cli_available          = $cli.available
        auth_ok                = $auth.ok
        trust_worktree         = $trustWorktree
        routing_cases          = $routingCases.Count
        direct_role_cases      = $directCases.Count
        default_replicas       = $replicaCount
        stream_limitation_note = $StreamLimitationNote
        heuristic_notes        = @("models_count=$($models.Count)")
    }) -JsonlPath $jsonlPath

    for ($r = 1; $r -le $replicaCount; $r++) {
        if ($abortReason) { break }
        Write-Host "Replica $r/$replicaCount"
        foreach ($caseEntry in $cases) {
            if ($abortReason) { break }
            $caseResult = Invoke-CaseExecution -CaseEntry $caseEntry -ManifestRoot $manifestRoot -RunId $runId `
                -WaveName $waveName -Replica $r -JsonlPath $jsonlPath -AvailableModels $models -TrustWorktree $trustWorktree

            $runStats.executions_completed++
            if ($caseResult.case_passed -eq 'passed') { $runStats.cases_passed++ }
            elseif ($caseResult.case_passed -eq 'failed') { $runStats.cases_failed++ }

            if ($caseResult.trust_blocked) { $abortReason = 'workspace_trust_required'; break }
            if ($null -ne $caseResult.exit_code -and $caseResult.exit_code -ne 0) { $runStats.exit_code_nonzero++ }
            if ($caseResult.execution_mode -eq 'orchestrator_delegate' -and $caseResult.delegation_status -ne 'stream_proven') {
                $runStats.routing_delegation_missing++
            }
            if ($caseResult.execution_mode -eq 'direct_role_control' -and $caseResult.role_model_resolved_status -ne 'stream_proven') {
                $runStats.direct_role_model_unverified++
            }
            if ($caseResult.tests_failed -gt 0) { $runStats.tests_failed_total += $caseResult.tests_failed }
        }
    }

    $summary = Write-RunSummary -Stats $runStats -JsonlPath $jsonlPath -RunId $runId -WaveName $waveName `
        -AbortReason $abortReason -RuntimeError $null
    $finalExit = $summary.exit_code
}
catch {
    $runtimeError = $_.Exception.Message
    Write-Host "`nRuntime error: $runtimeError" -ForegroundColor Red
    Write-RunSummary -Stats $runStats -JsonlPath $jsonlPath -RunId $runId -WaveName $waveName `
        -AbortReason $abortReason -RuntimeError $runtimeError | Out-Null
    $finalExit = 1
}

Write-Host "`nResults: $jsonlPath" -ForegroundColor White
exit $finalExit
