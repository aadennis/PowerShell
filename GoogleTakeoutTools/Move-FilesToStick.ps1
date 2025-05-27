# Move files from a source directory to a USB drive based on a specific naming pattern.
# This script moves files with a specific 3-digit number in their names from a source directory to a USB drive.
# It also ejects the USB drive after moving the files.

# Global variable for number of files to move
$Global:MaxFilesToMove = 15

# Source and destination paths
$sourcePath = "C:\temp\takeout"
$destPath = "D:\"

# Counter for files moved
$filesMoved = 0

# Move up to MaxFilesToMove files based on 3-digit number before ".zip"
Get-ChildItem -Path $sourcePath -Filter "*.zip" | Where-Object {
    $_.Name -match '-(\d{3})\.zip$'
} | Sort-Object {
    [int]($_.Name -replace '^.*-(\d{3})\.zip$', '$1')
} | ForEach-Object {
    if ($filesMoved -ge $Global:MaxFilesToMove) {
        break
    }

    $sourceFile = $_.FullName
    $destinationFile = Join-Path -Path $destPath -ChildPath $_.Name

    Move-Item -Path $sourceFile -Destination $destinationFile
    $filesMoved++
}

# Eject USB drive (D:) using WMI
Start-Sleep -Seconds 5 # Wait for files to finish moving

$driveLetter = "D:"
$volume = Get-WmiObject -Query "SELECT * FROM Win32_Volume WHERE DriveLetter = '$driveLetter'"
if ($volume) {
    $result = $volume.Dismount($false, $false)
    if ($result.ReturnValue -eq 0) {
        $volume.DriveLetter = $null
        $volume.Put() | Out-Null
        Write-Host "USB drive $driveLetter successfully ejected."
    } else {
        Write-Warning "Failed to eject USB drive $driveLetter. Error code: $($result.ReturnValue)"
    }
} else {
    Write-Warning "Drive $driveLetter not found."
}
