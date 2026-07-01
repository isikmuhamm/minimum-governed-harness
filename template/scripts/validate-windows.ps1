param(
    [string]$Root = "",
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $Root = (Resolve-Path $Root).Path
}

$script:ErrorCount = 0
$script:WarningCount = 0

function Report-Error {
    param([string]$Message)
    $script:ErrorCount++
    Write-Host "ERROR $Message" -ForegroundColor Red
}

function Report-Warning {
    param([string]$Message)
    $script:WarningCount++
    Write-Host "WARN  $Message" -ForegroundColor Yellow
}

function Get-Field {
    param($Record, [string]$Name)
    if ($Record.Fields.ContainsKey($Name)) { return [string]$Record.Fields[$Name] }
    return ""
}

function Require-Field {
    param($Record, [string]$Name)
    if ([string]::IsNullOrWhiteSpace((Get-Field $Record $Name))) {
        Report-Error "$($Record.Id) missing required field: $Name"
    }
}

function Parse-Records {
    param([string]$Path)
    $Records = @()
    $Current = $null
    foreach ($Line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        if ($Line -match '^## ((TASK|DEC|REQ|RISK)-[0-9]{4})[ ]') {
            $Current = [PSCustomObject]@{
                Id = $Matches[1]
                Type = $Matches[2]
                Fields = @{}
                References = @()
            }
            $Records += $Current
            continue
        }
        if ($null -ne $Current -and $Line -match '^- ([A-Za-z][A-Za-z ]*):[ ]*(.*)$') {
            $Key = $Matches[1].Trim()
            $Value = $Matches[2].Trim()
            $Current.Fields[$Key] = $Value
            if ($Key -in @('Related','Supersedes','Replacement')) {
                foreach ($Match in [regex]::Matches($Value, '(TASK|DEC|REQ|RISK)-[0-9]{4}')) {
                    $Current.References += $Match.Value
                }
            }
        }
    }
    return $Records
}

$Memory = Join-Path $Root "project-memory"
$SystemPath = Join-Path $Memory "SYSTEM.md"
$BoardPath = Join-Path $Memory "BOARD.md"
$NotesPath = Join-Path $Memory "NOTES.md"
$HistoryPath = Join-Path $Memory "HISTORY.md"

foreach ($Path in @($SystemPath, $BoardPath, $NotesPath, $HistoryPath)) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Report-Error "Missing required file: $Path"
    }
}
if ($script:ErrorCount -gt 0) { exit 1 }

$SystemLines = Get-Content -LiteralPath $SystemPath -Encoding UTF8
$RequiredHeadings = @(
    "## Purpose and Scope",
    "## Components",
    "## Primary Flows",
    "## Boundaries and Sources of Truth",
    "## Invariants",
    "## External Interfaces",
    "## Known Limits"
)
foreach ($Heading in $RequiredHeadings) {
    if ($SystemLines -cnotcontains $Heading) { Report-Error "SYSTEM.md missing section: $Heading" }
}
foreach ($Line in $SystemLines) {
    if ($Line -match '^## (TASK|DEC|REQ|RISK)-[0-9]{4}([ ]|$)') {
        Report-Error "SYSTEM.md must not contain lifecycle records: $Line"
    }
}
if ($SystemLines.Count -gt 250) {
    Report-Warning "SYSTEM.md has $($SystemLines.Count) lines; review whether it is still a bounded system map"
}

$Board = @(Parse-Records $BoardPath)
$Notes = @(Parse-Records $NotesPath)
$History = @(Parse-Records $HistoryPath)

foreach ($Set in @(
    @{ Name = 'Board'; Records = $Board },
    @{ Name = 'Notes'; Records = $Notes },
    @{ Name = 'History'; Records = $History }
)) {
    foreach ($Duplicate in @($Set.Records | Group-Object Id | Where-Object { $_.Count -gt 1 })) {
        Report-Error "Duplicate ID in $($Set.Name): $($Duplicate.Name)"
    }
}

foreach ($Record in $Board) {
    if ($Record.Type -ne 'TASK') { Report-Error "Board may contain only TASK records: $($Record.Id)" }
    foreach ($Name in @('Status','Priority','Owner','Related','Summary','Acceptance')) { Require-Field $Record $Name }
    $Status = (Get-Field $Record 'Status').ToLowerInvariant()
    if ($Status -and $Status -notin @('proposed','active','blocked')) {
        Report-Error "$($Record.Id) has invalid Board status: $Status"
    }
}

foreach ($Record in $Notes) {
    foreach ($Name in @('Status','Related','Last updated')) { Require-Field $Record $Name }
    if ($Record.Type -eq 'DEC') {
        $Status = (Get-Field $Record 'Status').ToLowerInvariant()
        if ($Status -eq 'accepted' -and [string]::IsNullOrWhiteSpace((Get-Field $Record 'Reflected in'))) {
            Report-Warning "$($Record.Id) is accepted but has no Reflected in field"
        }
    }
}

foreach ($Record in $History) {
    if ($Record.Type -ne 'TASK') { Report-Error "History may contain only TASK records: $($Record.Id)" }
    foreach ($Name in @('Status','Related','Evidence','Outcome')) { Require-Field $Record $Name }
    $Status = (Get-Field $Record 'Status').ToLowerInvariant()
    if ($Status -and $Status -notin @('completed','cancelled')) {
        Report-Error "$($Record.Id) has invalid History status: $Status"
    }
    if ($Status -eq 'completed' -and (Get-Field $Record 'Completed') -notmatch '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') {
        Report-Error "$($Record.Id) requires Completed: YYYY-MM-DD"
    }
    if ($Status -eq 'cancelled' -and (Get-Field $Record 'Cancelled') -notmatch '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') {
        Report-Error "$($Record.Id) requires Cancelled: YYYY-MM-DD"
    }
}

$BoardIds = @($Board | ForEach-Object { $_.Id })
$HistoryIds = @($History | ForEach-Object { $_.Id })
$NoteTaskIds = @($Notes | Where-Object { $_.Type -eq 'TASK' } | ForEach-Object { $_.Id })
$KnownIds = @($BoardIds + ($Notes | ForEach-Object { $_.Id }) + $HistoryIds | Sort-Object -Unique)

foreach ($Id in $BoardIds) {
    if ($HistoryIds -contains $Id) { Report-Error "$Id exists in both BOARD.md and HISTORY.md" }
    if ($NoteTaskIds -notcontains $Id) { Report-Warning "$Id is on the Board but has no Notes detail" }
}
foreach ($Id in $NoteTaskIds) {
    if (($BoardIds -notcontains $Id) -and ($HistoryIds -notcontains $Id)) {
        Report-Warning "$Id has Notes detail but no Board or History lifecycle record"
    }
}

foreach ($Record in @($Board + $Notes + $History)) {
    foreach ($Reference in $Record.References) {
        if ($KnownIds -notcontains $Reference) {
            Report-Error "$($Record.Id) references missing $Reference"
        }
    }
}

Write-Host ""
Write-Host "Summary: $($script:ErrorCount) error(s), $($script:WarningCount) warning(s)"
if ($script:ErrorCount -gt 0) { exit 1 }
if ($Strict -and $script:WarningCount -gt 0) { exit 2 }
Write-Host "PASS  Project memory contract is valid" -ForegroundColor Green
exit 0
