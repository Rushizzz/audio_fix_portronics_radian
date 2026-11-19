@echo off
title Stop Portronics Audio Keeper
cd /d "%~dp0"

echo =======================================================
echo   Stopping Portronics AUX Anti-Sleep Keeper...
echo =======================================================

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$pidFile = '%~dp0keepalive.pid';" ^
    "$stopped = $false;" ^
    "if (Test-Path $pidFile) {" ^
    "    $targetPid = Get-Content $pidFile -ErrorAction SilentlyContinue;" ^
    "    if ($targetPid) {" ^
    "        Stop-Process -Id ([int]$targetPid) -Force -ErrorAction SilentlyContinue;" ^
    "        $stopped = $true;" ^
    "    }" ^
    "    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue;" ^
    "};" ^
    "Get-CimInstance Win32_Process -Filter 'Name=''powershell.exe''' | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -like '*PortronicsKeepAlive.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force; $stopped = $true };" ^
    "if ($stopped) { Write-Host '[SUCCESS] Portronics Audio Keeper has been stopped.' -ForegroundColor Green } else { Write-Host '[INFO] Audio Keeper was not running.' -ForegroundColor Yellow }"

echo.
pause
