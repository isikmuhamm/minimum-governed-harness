$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if (Get-Command py -ErrorAction SilentlyContinue) { & py -3 (Join-Path $RepoRoot "scripts/check.py") --root $RepoRoot @args; exit $LASTEXITCODE }
if (Get-Command python -ErrorAction SilentlyContinue) { & python (Join-Path $RepoRoot "scripts/check.py") --root $RepoRoot @args; exit $LASTEXITCODE }
Write-Error "Python 3 is required."
exit 127
