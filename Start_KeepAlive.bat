@echo off
title Start Portronics Audio Keeper
cd /d "%~dp0"

echo =======================================================
echo   Starting Portronics AUX Anti-Sleep Keeper...
echo =======================================================

wscript.exe "%~dp0run_silent.vbs"

REM Wait 1 second to let process initialize
ping 127.0.0.1 -n 2 >nul

if exist "%~dp0keepalive.pid" (
    echo [SUCCESS] Audio Keeper is now running silently in the background!
    echo Your Portronics speaker will stay awake during quiet scenes.
) else (
    echo [INFO] Audio Keeper triggered or was already running.
)

echo(
pause
