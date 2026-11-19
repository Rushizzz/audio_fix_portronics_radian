@echo off
title Restore Realtek Default Sleep Settings (Admin Required)
cd /d "%~dp0"

echo ===================================================================
echo   Restore Realtek Default PowerSettings
echo ===================================================================

:: Check for administrative permissions
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [REQUESTING ADMIN RIGHTS] Relaunching as Administrator...
    powershell -Command "Start-Process cmd -ArgumentList '/c `\"%~f0`\"' -Verb RunAs"
    exit /b
)

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$basePath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}';" ^
    "$subKeys = Get-ChildItem -Path $basePath -ErrorAction SilentlyContinue;" ^
    "$restored = 0;" ^
    "foreach ($k in $subKeys) {" ^
    "    $psPath = Join-Path $k.PSPath 'PowerSettings';" ^
    "    if (Test-Path $psPath) {" ^
    "        $fiveBytes = [byte[]]@(5, 0, 0, 0);" ^
    "        $threeBytes = [byte[]]@(3, 0, 0, 0);" ^
    "        Set-ItemProperty -Path $psPath -Name 'ConservationIdleTime' -Value $fiveBytes -Type Binary -Force;" ^
    "        Set-ItemProperty -Path $psPath -Name 'PerformanceIdleTime' -Value $fiveBytes -Type Binary -Force;" ^
    "        Set-ItemProperty -Path $psPath -Name 'IdlePowerState' -Value $threeBytes -Type Binary -Force;" ^
    "        Write-Host ('[RESTORED] Default PowerSettings in: ' + $k.PSChildName) -ForegroundColor Green;" ^
    "        $restored++;" ^
    "    }" ^
    "};" ^
    "if ($restored -gt 0) {" ^
    "    Write-Host '' ;" ^
    "    Write-Host ('[COMPLETE] Restored default settings on ' + $restored + ' key(s).') -ForegroundColor Green;" ^
    "} else {" ^
    "    Write-Host '[INFO] No Realtek PowerSettings keys found.' -ForegroundColor Yellow;" ^
    "}"

echo.
pause
