@echo off
title Install to Windows Startup
cd /d "%~dp0"

echo =======================================================
echo   Installing Portronics Audio Keeper to Windows Startup...
echo =======================================================

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$wsh = New-Object -ComObject WScript.Shell;" ^
    "$startupFolder = [System.Environment]::GetFolderPath('Startup');" ^
    "$shortcutPath = Join-Path $startupFolder 'PortronicsAudioKeeper.lnk';" ^
    "$targetVbs = Join-Path '%~dp0' 'run_silent.vbs';" ^
    "$shortcut = $wsh.CreateShortcut($shortcutPath);" ^
    "$shortcut.TargetPath = 'wscript.exe';" ^
    "$shortcut.Arguments = '\"' + $targetVbs + '\"';" ^
    "$shortcut.WorkingDirectory = '%~dp0';" ^
    "$shortcut.Description = 'Keeps Portronics AUX speaker awake by playing an inaudible background stream';" ^
    "$shortcut.Save();" ^
    "Write-Host '[SUCCESS] Shortcut created in Startup folder:' -ForegroundColor Green;" ^
    "Write-Host $shortcutPath -ForegroundColor Cyan;" ^
    "Write-Host 'Portronics Audio Keeper will now start automatically whenever Windows boots.' -ForegroundColor White;"

echo.
pause
