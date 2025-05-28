# This script concatenates multiple AVI files into a single MP4 file using FFmpeg.
# It checks if the video and audio codecs are compatible for stream copying.
# If not, it re-encodes the files with medium quality settings.
# Requires FFmpeg and FFprobe to be installed and available in the system PATH.

$inputFolder = "x"
$outputFile = "y"


###
$tempFolder = "$inputFolder\temp_concat"
$logFile = "$inputFolder\concat_log.txt"


function Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Write-Host $logEntry
    Add-Content -Path $logFile -Value $logEntry
}

function IsCopyCompatible($filePath) {
    $videoCodec = (& ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$filePath").Trim()
    $audioCodec = (& ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$filePath").Trim()

    return ($videoCodec -eq "h264" -and $audioCodec -eq "aac")
}


# Begin
Log "Starting smart concatenation process..."
if (!(Test-Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
    Log "Created temp folder: $tempFolder"
}

$aviFiles = Get-ChildItem -Path $inputFolder -Filter "*.avi" | Sort-Object Name
$index = 0
foreach ($file in $aviFiles) {
    $tempFile = Join-Path $tempFolder ("temp_$index.mp4")
    Log "Checking codecs for $($file.Name)..."
    if (IsCopyCompatible $file.FullName) {
        Log "Using stream copy for $($file.Name)"
        ffmpeg -hide_banner -loglevel error -i $file.FullName -c copy -movflags +faststart $tempFile
    } else {
        Log "Re-encoding $($file.Name) with medium quality settings"
        ffmpeg -hide_banner -loglevel error -i $file.FullName -c:v libx264 -crf 23 -preset faster -c:a aac -b:a 128k -movflags +faststart $tempFile
    }
    if (Test-Path $tempFile) {
        Log "Successfully created: $tempFile"
    } else {
        Log "ERROR: Failed to create: $tempFile"
    }
    $index++
}

# Create concat list
$listFile = Join-Path $tempFolder "concat_list.txt"
Log "Creating concat list at: $listFile"
Remove-Item -Path $listFile -ErrorAction SilentlyContinue
for ($i = 0; $i -lt $aviFiles.Count; $i++) {
    Add-Content -Path $listFile -Value ("file 'temp_$i.mp4'")
}
Log "Concat list complete with $($aviFiles.Count) files"

# Final concat
Log "Concatenating intermediate MP4s..."
ffmpeg -hide_banner -loglevel error -f concat -safe 0 -i $listFile -c copy $outputFile

if (Test-Path $outputFile) {
    Log "✅ Concatenation successful: $outputFile"
} else {
    Log "❌ Concatenation failed!"
}

# Optional cleanup
# Log "Cleaning up..."
# Remove-Item -Recurse -Force $tempFolder
# Log "Cleanup done."

Log "All done!"
