@echo off
setlocal
set "REPO_ROOT=%~dp0.."
where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (py -3 "%REPO_ROOT%\scripts\check.py" --root "%REPO_ROOT%" %* & exit /b %ERRORLEVEL%)
where python >nul 2>nul
if %ERRORLEVEL% EQU 0 (python "%REPO_ROOT%\scripts\check.py" --root "%REPO_ROOT%" %* & exit /b %ERRORLEVEL%)
echo ERROR: Python 3 is required. 1>&2
exit /b 127
