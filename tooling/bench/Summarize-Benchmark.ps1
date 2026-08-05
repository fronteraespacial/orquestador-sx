# SpaceX Orchestrator — Summarize-Benchmark.ps1
# Reads a bench JSONL and emits a markdown report. Does not declare winners from inconclusive data.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string] $JsonlPath,

    [Parameter()]
    [string] $OutputPath = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$StreamLimitationNote = 'Nested Task subagent model telemetry unavailable in this CLI stream-json; direct_role_control uses root stream model only.'

function Get-RecordExecutionMode {
    param($Record)
    $mt = if ($Record.PSObject.Properties.Name -contains 'measurement_type') { [string]$Record.measurement_type } else { $null }
    if ($Record.PSObject.Properties.Name -contains 'execution_mode' -and $Record.execution_mode) {
        return [string]$Record.execution_mode
    }
    if ($mt -eq 'routing') { return 'orchestrator_delegate' }
    if ($mt -eq 'direct_role_control') { return 'direct_role_control' }
    if ($mt -eq 'role') { return 'legacy_role_delegate' }
    return 'unknown'
}

function Get-RecordPassStatus {
    param($Record)

    if ($Record.case_id -match '^_') { return $null }
    if ($Record.PSObject.Properties.Name -contains 'case_passed' -and $Record.case_passed) {
        return [string]$Record.case_passed
    }

    $mode = Get-RecordExecutionMode -Record $Record
    if ($mode -eq 'legacy_role_delegate') { return 'inconclusive' }
    $trustBlocked = ($Record.PSObject.Properties.Name -contains 'workspace_trust_blocked' -and $Record.workspace_trust_blocked) `
        -or ($Record.PSObject.Properties.Name -contains 'error' -and $Record.error -eq 'workspace_trust_required')
    if ($trustBlocked) { return 'failed' }
    if ($Record.PSObject.Properties.Name -contains 'exit_code' -and $null -ne $Record.exit_code -and [int]$Record.exit_code -ne 0) { return 'failed' }
    if ($Record.PSObject.Properties.Name -contains 'tests_failed' -and [int]$Record.tests_failed -gt 0) { return 'failed' }

    if ($mode -eq 'orchestrator_delegate') {
        $ds = if ($Record.PSObject.Properties.Name -contains 'delegation_status') { [string]$Record.delegation_status } else { 'unverified' }
        if ($ds -ne 'stream_proven') { return 'failed' }
        return 'passed'
    }
    if ($mode -eq 'direct_role_control') {
        $rs = if ($Record.PSObject.Properties.Name -contains 'role_model_resolved_status') { [string]$Record.role_model_resolved_status } else { 'unverified' }
        if ($rs -ne 'stream_proven') { return 'failed' }
        return 'passed'
    }
    return 'inconclusive'
}

if (-not (Test-Path -LiteralPath $JsonlPath)) {
    Write-Error "JSONL not found: $JsonlPath"
}

$lines = Get-Content -LiteralPath $JsonlPath -Encoding UTF8
$all = @()
foreach ($line in $lines) {
    $t = $line.Trim()
    if (-not $t) { continue }
    try { $all += ($t | ConvertFrom-Json) } catch { }
}

if ($all.Count -eq 0) {
    Write-Error 'No parseable JSONL records.'
}

$preflight = $all | Where-Object { $_.case_id -eq '_preflight' } | Select-Object -First 1
$summaryRec = $all | Where-Object { $_.case_id -eq '_summary' } | Select-Object -First 1
$cases = @($all | Where-Object { $_.case_id -and $_.case_id -notmatch '^_' })

$runId = if ($preflight) { $preflight.run_id } elseif ($cases.Count -gt 0) { $cases[0].run_id } else { 'unknown' }
$wave = if ($preflight) { $preflight.wave } elseif ($cases.Count -gt 0) { $cases[0].wave } else { 'unknown' }

$routing = @($cases | Where-Object { (Get-RecordExecutionMode -Record $_) -eq 'orchestrator_delegate' })
$direct = @($cases | Where-Object { (Get-RecordExecutionMode -Record $_) -eq 'direct_role_control' })
$legacy = @($cases | Where-Object { (Get-RecordExecutionMode -Record $_) -eq 'legacy_role_delegate' })
$unknown = @($cases | Where-Object { (Get-RecordExecutionMode -Record $_) -eq 'unknown' })

function New-Bucket {
    return @{
        total        = 0
        passed       = 0
        failed       = 0
        inconclusive = 0
        durations    = [System.Collections.ArrayList]@()
        models       = @{}
    }
}

$routingStats = New-Bucket
$directStats = New-Bucket
$overall = New-Bucket

foreach ($rec in $cases) {
    $mode = Get-RecordExecutionMode -Record $rec
    $status = Get-RecordPassStatus -Record $rec
    if (-not $status) { continue }

    $bucket = switch ($mode) {
        'orchestrator_delegate' { $routingStats }
        'direct_role_control' { $directStats }
        default { $null }
    }

    $overall.total++
    switch ($status) {
        'passed' { $overall.passed++ }
        'failed' { $overall.failed++ }
        default { $overall.inconclusive++ }
    }
    if ($rec.duration_ms) { [void]$overall.durations.Add([int]$rec.duration_ms) }

    if ($bucket) {
        $bucket.total++
        switch ($status) {
            'passed' { $bucket.passed++ }
            'failed' { $bucket.failed++ }
            default { $bucket.inconclusive++ }
        }
        if ($rec.duration_ms) { [void]$bucket.durations.Add([int]$rec.duration_ms) }

        $modelKey = if ($mode -eq 'direct_role_control') {
            if ($rec.PSObject.Properties.Name -contains 'role_model_resolved' -and $rec.role_model_resolved) {
                [string]$rec.role_model_resolved
            } else { 'unverified' }
        }
        else {
            if ($rec.PSObject.Properties.Name -contains 'parent_model_resolved' -and $rec.parent_model_resolved) {
                [string]$rec.parent_model_resolved
            } elseif ($rec.PSObject.Properties.Name -contains 'model_resolved' -and $rec.model_resolved) {
                [string]$rec.model_resolved
            } else { 'unverified' }
        }
        if (-not $bucket.models.ContainsKey($modelKey)) { $bucket.models[$modelKey] = 0 }
        $bucket.models[$modelKey]++
    }
}

function Get-AvgMs {
    param([int[]] $Values)
    if (-not $Values -or $Values.Count -eq 0) { return $null }
    return [math]::Round(($Values | Measure-Object -Average).Average, 0)
}

function Format-BucketSection {
    param([string] $Title, [hashtable] $Bucket, [string] $PassCriteria)

    $avg = Get-AvgMs -Values @($Bucket.durations)
    $lines = @(
        "## $Title",
        '',
        "| Metric | Count |",
        '|--------|------:|',
        "| Total executions | $($Bucket.total) |",
        "| Passed | $($Bucket.passed) |",
        "| Failed | $($Bucket.failed) |",
        "| Inconclusive | $($Bucket.inconclusive) |",
        $(if ($avg -ne $null) { "| Avg latency (ms) | $avg |" } else { '| Avg latency (ms) | n/a |' }),
        '',
        "**Pass criteria:** $PassCriteria",
        ''
    )
    if ($Bucket.models.Count -gt 0) {
        $lines += '**Models resolved (stream root/parent):**', ''
        foreach ($k in ($Bucket.models.Keys | Sort-Object)) {
            $lines += "- ``$k``: $($Bucket.models[$k])"
        }
        $lines += ''
    }
    return $lines
}

$trustBlocked = @($cases | Where-Object {
    ($_.PSObject.Properties.Name -contains 'workspace_trust_blocked' -and $_.workspace_trust_blocked) `
        -or ($_.PSObject.Properties.Name -contains 'error' -and $_.error -eq 'workspace_trust_required')
}).Count
$runStatus = if ($summaryRec -and $summaryRec.run_status) { $summaryRec.run_status } else { 'unknown' }

$canCompare = ($routingStats.passed -gt 0 -or $directStats.passed -gt 0) -and ($legacy.Count -eq 0) -and ($trustBlocked -eq 0) -and ($unknown.Count -eq 0)

$md = [System.Collections.ArrayList]@()
[void]$md.Add("# Benchmark report: $runId")
[void]$md.Add('')
[void]$md.Add("- **Wave:** $wave")
[void]$md.Add("- **Source:** ``$JsonlPath``")
[void]$md.Add("- **Run status (recorded):** $runStatus")
[void]$md.Add("- **Generated:** $((Get-Date).ToUniversalTime().ToString('o'))")
[void]$md.Add('')
[void]$md.Add('## Stream limitation')
[void]$md.Add('')
[void]$md.Add($StreamLimitationNote)
[void]$md.Add('')
[void]$md.Add('> **Do not** use smoke runs blocked by Workspace Trust or legacy `role` delegate cases for routing/model conclusions.')
[void]$md.Add('')

if ($trustBlocked -gt 0) {
    [void]$md.Add("WARNING: $trustBlocked record(s) blocked by Workspace Trust - evidence only, excluded from comparisons.")
    [void]$md.Add('')
}
if ($legacy.Count -gt 0) {
    [void]$md.Add("WARNING: $($legacy.Count) legacy measurement_type=role record(s) - inconclusive for nested subagent model (use direct_role_control runs).")
    [void]$md.Add('')
}

[void]$md.Add('## Overall')
[void]$md.Add('')
[void]$md.Add("| Metric | Count |")
[void]$md.Add('|--------|------:|')
[void]$md.Add("| Case executions | $($overall.total) |")
[void]$md.Add("| Passed | $($overall.passed) |")
[void]$md.Add("| Failed | $($overall.failed) |")
[void]$md.Add("| Inconclusive | $($overall.inconclusive) |")
$overallAvg = Get-AvgMs -Values @($overall.durations)
[void]$md.Add("| Avg latency (ms) | $(if ($overallAvg -ne $null) { $overallAvg } else { 'n/a' }) |")
[void]$md.Add('')

[void]$md.AddRange((Format-BucketSection -Title 'Routing (orchestrator_delegate)' -Bucket $routingStats -PassCriteria 'exit 0, Task/delegation stream_proven, role DoD heuristics'))
[void]$md.AddRange((Format-BucketSection -Title 'Direct role control' -Bucket $directStats -PassCriteria 'exit 0, root role_model stream_proven, role DoD heuristics (not nested subagent telemetry)'))

[void]$md.Add('## Comparison verdict')
[void]$md.Add('')
if (-not $canCompare) {
    [void]$md.Add('**Inconclusive - no winner declared.** Insufficient passed runs and/or contaminated by trust blocks, legacy role delegate mode, or unknown execution modes.')
}
else {
    [void]$md.Add('Passed runs available for review by category/model arm. This report does **not** auto-rank Grok vs Composer - inspect per-category passed counts and latencies above.')
    if ($routingStats.passed -gt 0 -and $directStats.passed -gt 0) {
        [void]$md.Add('')
        [void]$md.Add("- Routing passed: $($routingStats.passed)/$($routingStats.total)")
        [void]$md.Add("- Direct role passed: $($directStats.passed)/$($directStats.total)")
    }
}
[void]$md.Add('')

$report = ($md -join "`n")
if ($OutputPath) {
    $dir = Split-Path -Parent $OutputPath
    if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    Set-Content -LiteralPath $OutputPath -Value $report -Encoding UTF8
    Write-Host "Report written: $OutputPath"
}
else {
    Write-Output $report
}
