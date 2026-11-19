@echo off
title Test Portronics Audio Keeper
cd /d "%~dp0"

echo ===================================================================
echo   Portronics Audio Keeper - Sound Verification Test
echo ===================================================================
echo.
echo Step 1: Testing an audible chime...
echo (You SHOULD hear a quick notification sound to confirm AUX works).
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "[System.Media.SystemSounds]::Asterisk.Play(); Start-Sleep -Milliseconds 600; [System.Media.SystemSounds]::Asterisk.Play();"

echo.
echo Step 2: Testing the inaudible 20Hz keep-alive tone for 5 seconds...
echo (You should hear NOTHING. Check your Portronics speaker light:
echo  it should remain active and NOT go to sleep!)
echo.

powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$wav = '%~dp0inaudible_keepalive.wav';" ^
    "if (-not (Test-Path $wav)) { & '%~dp0generate_tone.ps1' -OutputPath $wav };" ^
    "$player = New-Object System.Media.SoundPlayer($wav);" ^
    "$player.Load();" ^
    "$player.PlayLooping();" ^
    "for ($i=5; $i -gt 0; $i--) { Write-Host ('Testing inaudible keepalive stream... ' + $i + 's remaining') -ForegroundColor Cyan; Start-Sleep -Seconds 1 };" ^
    "$player.Stop();" ^
    "$player.Dispose();" ^
    "Write-Host '[SUCCESS] Test completed! The tone is inaudible to human ears while keeping the AUX line awake.' -ForegroundColor Green;"

echo.
pause
