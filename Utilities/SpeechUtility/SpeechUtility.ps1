function Get-FileName($extension = "txt") {
    "{0}{1}_{2}.{3}" -f ($outputRootDir, $outputFileNamePrefix, $chunk, $extension)
}
function Write-WavFile($textToSpeak) {
    $speech = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    $speech.SelectVoice("Microsoft Hazel Desktop")
    #$textToSpeak = Get-Content -Path $(Get-FileName) -Encoding UTF8
    $speech.SetOutputToWaveFile($(Get-FileName "wav"))
    $speech.Speak($textToSpeak)
    $speech.Dispose()
    $speech = $null
}
function Split-File (
    $fileToSplit = 'C:\Temp\917-0.txt',
    $splitMarker = "SPLITHERE",
    $outputFileNamePrefix = "BarnabyRudge",
    $outputRootDir = "c:\temp\"
) {
    Add-Type -AssemblyName System.Speech
    $reader = New-Object -TypeName System.IO.StreamReader($fileToSplit)
    $chunk = 1
    $speech = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    $speech.SelectVoice("Microsoft Hazel Desktop")
    while (($line = $reader.ReadLine()) -ne $null) {
        if ($line -match $splitMarker) {
            Write-WavFile $speechBlock
            $chunk++
            $speechBlock = [String]::Empty
        }
        else {
            $speechBlock += $line + " "
        }
    }
    Write-WavFile
    $reader.Close()
    $reader.Dispose()
    $reader = $null
}
#entry point...
Split-File