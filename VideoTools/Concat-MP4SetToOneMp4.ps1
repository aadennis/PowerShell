# Concatenate multiple MP4 files into a single MP4 file using FFmpeg.
# It takes all MP4 files in the Set-Location directory, sorts them
# (numerically, not lexically) by name,
# and outputs a single MP4 file.

$targetFilename = "CornwallTrip_January2024.mp4"

# Save current location
Push-Location

try {
    Set-Location "C:\temp\CornwallTrip\temp_concat"

   # Find all temp_*.mp4 files and sort by numeric suffix
    $mp4Files = Get-ChildItem -Filter "temp_*.mp4" | 
    Sort-Object { 
        if ($_ -match "temp_(\d+)\.mp4") { 
            [int]$matches[1] 
        } else { 
            0 
        }
    }

    # Build concat_list.txt
    $mp4Files | ForEach-Object { "file '$($_.Name)'" } | Set-Content "concat_list.txt"
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
