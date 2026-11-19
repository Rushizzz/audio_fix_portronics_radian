param(
    [string]$OutputPath = "$PSScriptRoot\inaudible_keepalive.wav",
    [double]$Frequency = 20.0,
    [double]$DurationSeconds = 2.0,
    [int]$Amplitude = 1200
)

# A clean, seamless 20 Hz sine wave tone in standard 16-bit 44.1kHz Stereo PCM WAV.
# 20 Hz is at the extreme lower boundary of human hearing.
# Small portable speakers (like the Portronics Radian) physically rolloff below 80-100 Hz,
# making this completely inaudible to human ears and pets, while maintaining
# active AC line voltage (~35mV RMS) on the 3.5mm AUX jack to prevent hardware auto-sleep.

$sampleRate = 44100
$channels = 2
$bitsPerSample = 16

$numSamples = [int]($sampleRate * $DurationSeconds)
$subchunk2Size = $numSamples * $channels * ($bitsPerSample / 8)
$chunkSize = 36 + $subchunk2Size

$fs = [System.IO.File]::Create($OutputPath)
$bw = New-Object System.IO.BinaryWriter($fs)

try {
    # RIFF chunk header
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
    $bw.Write([uint32]$chunkSize)
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))

    # fmt subchunk
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
    $bw.Write([uint32]16)
    $bw.Write([uint16]1) # PCM
    $bw.Write([uint16]$channels)
    $bw.Write([uint32]$sampleRate)
    $bw.Write([uint32]($sampleRate * $channels * ($bitsPerSample / 8)))
    $bw.Write([uint16]($channels * ($bitsPerSample / 8)))
    $bw.Write([uint16]$bitsPerSample)

    # data subchunk
    $bw.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
    $bw.Write([uint32]$subchunk2Size)

    for ($i = 0; $i -lt $numSamples; $i++) {
        $val = [int16]($Amplitude * [Math]::Sin(2 * [Math]::PI * $Frequency * $i / $sampleRate))
        $bw.Write($val) # Left
        $bw.Write($val) # Right
    }
} finally {
    $bw.Close()
    $fs.Close()
}

Write-Host "Generated inaudible keep-alive WAV at: $OutputPath" -ForegroundColor Green
Write-Host "Frequency: $Frequency Hz | Duration: $DurationSeconds s | Amplitude: $Amplitude (-28 dBFS)" -ForegroundColor Gray
