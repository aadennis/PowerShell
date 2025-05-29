# Concatenate multiple MP4 files into a single MP4 file using FFmpeg.
# It takes all MP4 files in the Set-Location directory, sorts them by name,
# and outputs a single MP4 file.

$targetFilename = "CornwallTrip_January2024.mp4"

# Save current location
Push-Location

try {
    Set-Location "C:\temp\CornwallTrip\temp_concat"

    # Create concat_list.txt from all MP4s in order
    Get-ChildItem -Filter "*.mp4" | Sort-Object Name |
        ForEach-Object { "file '$($_.Name)'" } |
        Set-Content "concat_list.txt"

    Start-Sleep -Seconds 3 # Ensure the list is ready before concatenation

    ffmpeg -hide_banner -loglevel error -f concat -safe 0 -i concat_list.txt -c copy $targetFilename

    if (Test-Path $targetFilename) {
        Write-Host "✅ Concatenation successful: $targetFilename"
    } else {
        Write-Host "❌ Concatenation failed!"
    }
}
finally {
    # Always return to the original location, even if an error occurs
    Pop-Location
}
