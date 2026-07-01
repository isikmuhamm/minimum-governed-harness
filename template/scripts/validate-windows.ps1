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

function Normalize-Title {
    param([string]$Title)
    if ([string]::IsNullOrWhiteSpace($Title)) { return "" }
    $Value = $Title.ToLowerInvariant()
    $Value = [regex]::Replace($Value, '[^\p{L}\p{Nd}]+', ' ')
    return [regex]::Replace($Value.Trim(), '\s+', ' ')
}

function Parse-Records {
    param([string]$Path)
    $Records = @()
    $Current = $null
    foreach ($Line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        if ($Line -match '^## ((TASK|DEC|REQ|RISK)-[0-9]{4})(?:[ ]+[—-])?[ ]*(.*)$') {
            $Current = [PSCustomObject]@{
                Id = $Matches[1]
                Type = $Matches[2]
                Title = $Matches[3].Trim()
                NormalizedTitle = (Normalize-Title $Matches[3])
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

$AllRecords = @($Board + $Notes + $History)
foreach ($Group in @($AllRecords | Group-Object Id)) {
    $Titles = @($Group.Group | ForEach-Object { $_.NormalizedTitle } | Where-Object { $_ } | Sort-Object -Unique)
    if ($Titles.Count -gt 1) {
        $TitleList = $Titles -join "' and '"
        Report-Error "$($Group.Name) has inconsistent normalized titles: '$TitleList'"
    }
}
foreach ($Group in @($AllRecords | Where-Object { $_.NormalizedTitle } | Group-Object -Property Type, NormalizedTitle)) {
    $Ids = @($Group.Group | ForEach-Object { $_.Id } | Sort-Object -Unique)
    if ($Ids.Count -gt 1) {
        $Type = $Group.Group[0].Type
        $Title = $Group.Group[0].NormalizedTitle
        Report-Error "Duplicate normalized $Type title '$Title' under $($Ids -join ' and ')"
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
$LifecycleIds = @($BoardIds + $HistoryIds | Sort-Object -Unique)
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

$RootPrefix = $Root.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$ExcludedDirectoryPattern = '(^|/)(\.git|node_modules|vendor|dist|build|coverage|project-memory|handoffs|docs|fixtures)(/|$)'
$ExcludedExtensions = @('.md','.markdown','.rst','.txt','.lock','.map','.png','.jpg','.jpeg','.gif','.webp','.ico','.pdf','.zip','.gz','.tar','.7z','.jar','.dll','.exe','.so','.dylib','.class','.pyc','.pyo','.wasm')
$ExcludedValidatorNames = @('validate-linux.sh','validate-macos.sh','validate-windows.ps1')

foreach ($File in Get-ChildItem -LiteralPath $Root -Recurse -File -Force) {
    $Relative = $File.FullName.Substring($RootPrefix.Length).Replace('\','/')
    if ($Relative -match $ExcludedDirectoryPattern) { continue }

    $LowerName = $File.Name.ToLowerInvariant()
    if ($ExcludedValidatorNames -contains $LowerName) { continue }
    if ($ExcludedExtensions -contains $File.Extension.ToLowerInvariant()) { continue }
    if ($LowerName -match '\.min\.(js|css)$') { continue }

    try {
        $Lines = @(Get-Content -LiteralPath $File.FullName -Encoding UTF8)
    } catch {
        continue
    }

    for ($Index = 0; $Index -lt $Lines.Count; $Index++) {
        $Line = [string]$Lines[$Index]
        if ($Line -notmatch 'ContextRail:\s*TASK-') { continue }

        $LineNumber = $Index + 1
        if ($Line -notmatch 'ContextRail:\s*(TASK-[0-9]{4})(?![0-9])') {
            Report-Error "$Relative`:$LineNumber has malformed ContextRail TASK marker"
            continue
        }

        $Task = $Matches[1]
        if ($LifecycleIds -notcontains $Task) {
            Report-Error "$Relative`:$LineNumber references $Task without Board or History lifecycle record"
        }
        if ($NoteTaskIds -notcontains $Task) {
            Report-Error "$Relative`:$LineNumber references $Task without Notes detail"
        }

        $WindowEnd = [Math]::Min($Index + 2, $Lines.Count - 1)
        $HasInvariant = $false
        for ($WindowIndex = $Index; $WindowIndex -le $WindowEnd; $WindowIndex++) {
            if ([string]$Lines[$WindowIndex] -match 'Invariant:\s*\S') {
                $HasInvariant = $true
                break
            }
        }
        if (-not $HasInvariant) {
            Report-Warning "$Relative`:$LineNumber has no non-empty Invariant within the next two lines"
        }
    }
}

Write-Host ""
Write-Host "Summary: $($script:ErrorCount) error(s), $($script:WarningCount) warning(s)"
if ($script:ErrorCount -gt 0) { exit 1 }
if ($Strict -and $script:WarningCount -gt 0) { exit 2 }
Write-Host "PASS  Project memory and code trace contract is valid" -ForegroundColor Green
exit 0
