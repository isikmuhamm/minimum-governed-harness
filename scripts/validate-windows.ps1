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

function Get-RecordIds {
    param([string]$Path)
    $Ids = @()
    foreach ($Line in Get-Content -LiteralPath $Path) {
        if ($Line -match '^## ((TASK|DEC|REQ|RISK)-[0-9]{4})[ ]') {
            $Ids += $Matches[1]
        }
    }
    return $Ids
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

$SystemLines = Get-Content -LiteralPath $SystemPath
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
    if ($SystemLines -cnotcontains $Heading) {
        Report-Error "SYSTEM.md missing section: $Heading"
    }
}

foreach ($Line in $SystemLines) {
    if ($Line -match '^## (TASK|DEC|REQ|RISK)-[0-9]{4}([ ]|$)') {
        Report-Error "SYSTEM.md must not contain lifecycle records: $Line"
    }
}

$BoardIds = @(Get-RecordIds $BoardPath)
$NotesIds = @(Get-RecordIds $NotesPath)
$HistoryIds = @(Get-RecordIds $HistoryPath)
$NoteTaskIds = @($NotesIds | Where-Object { $_ -like 'TASK-*' })
$KnownIds = @($BoardIds + $NotesIds + $HistoryIds | Sort-Object -Unique)

foreach ($Group in @(
    @{ Name = 'Board'; Ids = $BoardIds },
    @{ Name = 'Notes'; Ids = $NotesIds },
    @{ Name = 'History'; Ids = $HistoryIds }
)) {
    foreach ($Duplicate in @($Group.Ids | Group-Object | Where-Object { $_.Count -gt 1 })) {
        Report-Error "Duplicate ID in $($Group.Name): $($Duplicate.Name)"
    }
}

foreach ($Id in $BoardIds) {
    if ($Id -notlike 'TASK-*') { Report-Error "Board may contain only TASK records: $Id" }
    if ($HistoryIds -contains $Id) { Report-Error "$Id exists in both BOARD.md and HISTORY.md" }
    if ($NoteTaskIds -notcontains $Id) { Report-Warning "$Id is on the Board but has no Notes detail" }
}

foreach ($Id in $HistoryIds) {
    if ($Id -notlike 'TASK-*') { Report-Error "History may contain only TASK records: $Id" }
}

foreach ($Id in $NoteTaskIds) {
    if (($BoardIds -notcontains $Id) -and ($HistoryIds -notcontains $Id)) {
        Report-Warning "$Id has Notes detail but no lifecycle record"
    }
}

$HistoryText = Get-Content -LiteralPath $HistoryPath -Raw
if ($HistoryText -match '(?m)^- Status:[ ]*completed[ ]*$') {
    if ($HistoryText -notmatch '(?m)^- Completed:[ ]*[0-9]{4}-[0-9]{2}-[0-9]{2}[ ]*$') {
        Report-Error "Completed History record requires Completed: YYYY-MM-DD"
    }
    if ($HistoryText -notmatch '(?m)^- Evidence:[ ]*\S.+$') {
        Report-Warning "Completed History record has no Evidence"
    }
}

foreach ($Path in @($BoardPath, $NotesPath, $HistoryPath)) {
    $CurrentId = ""
    foreach ($Line in Get-Content -LiteralPath $Path) {
        if ($Line -match '^## ((TASK|DEC|REQ|RISK)-[0-9]{4})[ ]') {
            $CurrentId = $Matches[1]
            continue
        }
        if (($CurrentId -ne "") -and ($Line -match '^- (Related|Supersedes|Replacement):[ ]*(.+)$')) {
            foreach ($Match in [regex]::Matches($Matches[2], '(TASK|DEC|REQ|RISK)-[0-9]{4}')) {
                if ($KnownIds -notcontains $Match.Value) {
                    Report-Error "$CurrentId references missing $($Match.Value)"
                }
            }
        }
    }
}

Write-Host ""
Write-Host "Summary: $($script:ErrorCount) error(s), $($script:WarningCount) warning(s)"

if ($script:ErrorCount -gt 0) { exit 1 }
if ($Strict -and $script:WarningCount -gt 0) { exit 2 }
Write-Host "PASS  Project memory contract is valid" -ForegroundColor Green
exit 0
