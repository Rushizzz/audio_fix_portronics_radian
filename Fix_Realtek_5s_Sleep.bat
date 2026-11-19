@echo off
title Fix Realtek 5-Second Idle Sleep (Admin Required)
cd /d "%~dp0"

echo ===================================================================
echo   Realtek Audio 5-Second Hardware Sleep Fix
echo ===================================================================
echo This script disables the 5-second aggressive idle sleep built into
echo Realtek Windows drivers that powers off the 3.5mm AUX jack.
echo.

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
    "$fixed = 0;" ^
    "foreach ($k in $subKeys) {" ^
    "    $psPath = Join-Path $k.PSPath 'PowerSettings';" ^
    "    if (Test-Path $psPath) {" ^
    "        $zeroBytes = [byte[]]@(0, 0, 0, 0);" ^
    "        Set-ItemProperty -Path $psPath -Name 'ConservationIdleTime' -Value $zeroBytes -Type Binary -Force;" ^
    "        Set-ItemProperty -Path $psPath -Name 'PerformanceIdleTime' -Value $zeroBytes -Type Binary -Force;" ^
    "        Set-ItemProperty -Path $psPath -Name 'IdlePowerState' -Value $zeroBytes -Type Binary -Force;" ^
    "        Write-Host ('[SUCCESS] Updated PowerSettings in: ' + $k.PSChildName) -ForegroundColor Green;" ^
    "        $fixed++;" ^
    "    }" ^
    "};" ^
    "if ($fixed -gt 0) {" ^
    "    Write-Host '' ;" ^
    "    Write-Host ('[COMPLETE] Successfully patched ' + $fixed + ' audio power setting(s).') -ForegroundColor Green;" ^
    "    Write-Host 'Realtek will no longer shut down the 3.5mm AUX line after 5 seconds of silence!' -ForegroundColor White;" ^
    "    Write-Host 'Note: A Windows restart is recommended for the driver to reload settings.' -ForegroundColor Yellow;" ^
    "} else {" ^
    "    Write-Host '[INFO] No Realtek PowerSettings keys found to patch.' -ForegroundColor Yellow;" ^
    "}"

echo.
pause
