param([string]$Root = "", [switch]$Strict)
$ErrorActionPreference = "Stop"
if (-not $Root) { $Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path } else { $Root = (Resolve-Path $Root).Path }
$Memory = Join-Path $Root "project-memory"
$Errors = [System.Collections.Generic.List[string]]::new()
$Warnings = [System.Collections.Generic.List[string]]::new()
function Add-Error([string]$Message) { $Errors.Add($Message); Write-Error $Message -ErrorAction Continue }
function Add-Warn([string]$Message) { $Warnings.Add($Message); Write-Warning $Message }
$System = Join-Path $Memory "SYSTEM.md"; $Board = Join-Path $Memory "BOARD.md"; $Notes = Join-Path $Memory "NOTES.md"; $History = Join-Path $Memory "HISTORY.md"
foreach ($File in @($System,$Board,$Notes,$History)) { if (-not (Test-Path $File -PathType Leaf)) { Add-Error "Missing required file: $File" } }
if ($Errors.Count) { exit 1 }
$Required = @("## Purpose and Scope","## Components","## Primary Flows","## Boundaries and Sources of Truth","## Invariants","## External Interfaces","## Known Limits")
$SystemLines = Get-Content $System
foreach ($Heading in $Required) { if ($SystemLines -cnotcontains $Heading) { Add-Error "SYSTEM.md missing section: $Heading" } }
foreach ($Line in $SystemLines) { if ($Line -match '^## (TASK|DEC|REQ|RISK)-\d{4}(\s|$)') { Add-Error "SYSTEM.md must not contain lifecycle records: $Line" } }
function Parse-Records([string]$Path) {
  $Records = @(); $Current = $null
  foreach ($Line in Get-Content $Path) {
    if ($Line -match '^## ((TASK|DEC|REQ|RISK)-\d{4})\s+[—-]\s+(.+)$') { $Current = [ordered]@{ Id=$Matches[1]; Title=$Matches[3]; Status=""; Completed=""; Evidence=""; Related=@() }; $Records += $Current; continue }
    if ($null -ne $Current -and $Line -match '^- Status:\s*(.+)$') { $Current.Status=$Matches[1].Trim().ToLower(); continue }
    if ($null -ne $Current -and $Line -match '^- Completed:\s*(.+)$') { $Current.Completed=$Matches[1].Trim(); continue }
    if ($null -ne $Current -and $Line -match '^- Evidence:\s*(.*)$') { $Current.Evidence=$Matches[1].Trim(); continue }
    if ($null -ne $Current -and $Line -match '^- (Related|Supersedes|Replacement):\s*(.+)$') { $Current.Related += [regex]::Matches($Matches[2],'(TASK|DEC|REQ|RISK)-\d{4}') | ForEach-Object Value }
  }
  return $Records
}
$B = @(Parse-Records $Board); $N = @(Parse-Records $Notes); $H = @(Parse-Records $History)
foreach ($Set in @(@('Board',$B),@('Notes',$N),@('History',$H))) { $Set[1] | Group-Object Id | Where-Object Count -gt 1 | ForEach-Object { Add-Error "Duplicate ID in $($Set[0]): $($_.Name)" } }
foreach ($R in $B) { if ($R.Id -notmatch '^TASK-') { Add-Error "Board may contain only TASK records: $($R.Id)" }; if ($R.Status -notin @('proposed','active','blocked')) { Add-Error "$($R.Id) has invalid Board status: $($R.Status)" } }
foreach ($R in $H) { if ($R.Id -notmatch '^TASK-') { Add-Error "History may contain only TASK records: $($R.Id)" }; if ($R.Status -notin @('completed','cancelled')) { Add-Error "$($R.Id) has invalid History status: $($R.Status)" }; if ($R.Status -eq 'completed' -and $R.Completed -notmatch '^\d{4}-\d{2}-\d{2}$') { Add-Error "$($R.Id) requires Completed: YYYY-MM-DD" }; if ($R.Status -eq 'completed' -and -not $R.Evidence) { Add-Warn "$($R.Id) has no Evidence" } }
$BoardIds=@($B.Id); $HistoryIds=@($H.Id); $NoteTaskIds=@($N | Where-Object Id -like 'TASK-*' | ForEach-Object Id); $Known=@($B.Id+$N.Id+$H.Id | Sort-Object -Unique)
foreach ($Id in $BoardIds) { if ($HistoryIds -contains $Id) { Add-Error "$Id exists in both BOARD.md and HISTORY.md" }; if ($NoteTaskIds -notcontains $Id) { Add-Warn "$Id is on the Board but has no Notes detail" } }
foreach ($Id in $NoteTaskIds) { if (($BoardIds -notcontains $Id) -and ($HistoryIds -notcontains $Id)) { Add-Warn "$Id has Notes detail but no lifecycle record" } }
foreach ($R in @($B+$N+$H)) { foreach ($Ref in $R.Related) { if ($Known -notcontains $Ref) { Add-Error "$($R.Id) references missing $Ref" } } }
Write-Host "`nSummary: $($Errors.Count) error(s), $($Warnings.Count) warning(s)"
if ($Errors.Count) { exit 1 }; if ($Strict -and $Warnings.Count) { exit 2 }; Write-Host "PASS  Project memory contract is valid"; exit 0
