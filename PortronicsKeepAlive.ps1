# Portronics Keep-Alive Background Service
# Prevents Bluetooth / AUX speaker auto-shutdown during movie silence

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$pidFile = Join-Path $scriptDir "keepalive.pid"
$logFile = Join-Path $scriptDir "keepalive.log"
$wavFile = Join-Path $scriptDir "inaudible_keepalive.wav"
$mutexName = "PortronicsAudioKeepAliveMutex"

try {
    # 1. Enforce single instance via named Mutex
    $createdNew = $false
    $mutex = New-Object System.Threading.Mutex($true, $mutexName, [ref]$createdNew)
    if (-not $createdNew) {
        # Check if previous process is truly alive
        if (Test-Path $pidFile) {
            $prevPid = Get-Content $pidFile -ErrorAction SilentlyContinue
            if ($prevPid) {
                $p = Get-Process -Id ([int]$prevPid) -ErrorAction SilentlyContinue
                if ($p) {
                    # Alive and well, exit this duplicate
                    exit 0
                }
            }
        }
    }

    # 2. Record PID
    [System.IO.File]::WriteAllText($pidFile, $PID.ToString())
    [System.IO.File]::WriteAllText($logFile, "Started PID $PID at $(Get-Date)`r`n")

    # 3. Ensure tone exists
    if (-not (Test-Path $wavFile)) {
        & "$scriptDir\generate_tone.ps1" -OutputPath $wavFile
    }

    # 4. Initialize SoundPlayer and start looping
    $player = New-Object System.Media.SoundPlayer($wavFile)
    $player.Load()
    $player.PlayLooping()
    [System.IO.File]::AppendAllText($logFile, "PlayLooping started successfully`r`n")

    # 5. Keep alive in background
    while ($true) {
        Start-Sleep -Seconds 30
    }
}
catch {
    [System.IO.File]::AppendAllText($logFile, "FATAL ERROR: $($_.ToString())`r`n")
}
finally {
    if ($player -ne $null) {
        $player.Stop()
        $player.Dispose()
    }
    if (Test-Path $pidFile) {
        Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
    }
    if ($mutex -ne $null) {
        try { $mutex.ReleaseMutex() } catch {}
        $mutex.Dispose()
    }
    [System.IO.File]::AppendAllText($logFile, "Exited at $(Get-Date)`r`n")
}
