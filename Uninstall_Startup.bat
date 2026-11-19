@echo off
title Uninstall from Windows Startup
cd /d "%~dp0"

echo =======================================================
echo   Removing Portronics Audio Keeper from Windows Startup...
echo =======================================================

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$startupFolder = [System.Environment]::GetFolderPath('Startup');" ^
    "$shortcutPath = Join-Path $startupFolder 'PortronicsAudioKeeper.lnk';" ^
    "if (Test-Path $shortcutPath) {" ^
    "    Remove-Item $shortcutPath -Force;" ^
    "    Write-Host '[SUCCESS] Removed from Startup folder:' -ForegroundColor Green;" ^
    "    Write-Host $shortcutPath -ForegroundColor Cyan;" ^
    "} else {" ^
    "    Write-Host '[INFO] No startup shortcut was found.' -ForegroundColor Yellow;" ^
    "};"

echo.
pause
