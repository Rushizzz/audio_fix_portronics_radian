@echo off
title Check Audio Keeper Status
cd /d "%~dp0"

echo =======================================================
echo   Checking Portronics Audio Keeper Status...
echo =======================================================

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$pidFile = '%~dp0keepalive.pid';" ^
    "$running = $false;" ^
    "if (Test-Path $pidFile) {" ^
    "    $targetPid = Get-Content $pidFile -ErrorAction SilentlyContinue;" ^
    "    if ($targetPid) {" ^
    "        $p = Get-Process -Id ([int]$targetPid) -ErrorAction SilentlyContinue;" ^
    "        if ($p) { $running = $true; $activeId = $p.Id; } else { Remove-Item $pidFile -Force -ErrorAction SilentlyContinue; }" ^
    "    }" ^
    "};" ^
    "if (-not $running) {" ^
    "    $found = Get-CimInstance Win32_Process -Filter 'Name=''powershell.exe''' | Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -like '*PortronicsKeepAlive.ps1*' };" ^
    "    if ($found) { $running = $true; $activeId = ($found | Select-Object -First 1).ProcessId; }" ^
    "};" ^
    "if ($running) {" ^
    "    Write-Host '[STATUS: ACTIVE]' -ForegroundColor Green -NoNewline;" ^
    "    Write-Host ' Keeper is currently RUNNING in the background (PID: ' -NoNewline;" ^
    "    Write-Host $activeId -ForegroundColor Cyan -NoNewline;" ^
    "    Write-Host '). Your speaker is protected from auto-sleeping.';" ^
    "} else {" ^
    "    Write-Host '[STATUS: STOPPED]' -ForegroundColor Red -NoNewline;" ^
    "    Write-Host ' Keeper is NOT running. Double-click Start_KeepAlive.bat to start it.';" ^
    "}"

echo.
pause
