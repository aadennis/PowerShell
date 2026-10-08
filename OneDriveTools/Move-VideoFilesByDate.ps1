$VideosDir = "D:\onedrive\Pictures\Camera Roll\Videos"
$DiscardDir = Join-Path $VideosDir "discard"

# Create discard folder if it doesn't exist
if (-not (Test-Path $DiscardDir)) {
    New-Item -ItemType Directory -Path $DiscardDir | Out-Null
}

# Get all files (non-recursive)
$files = Get-ChildItem -Path $VideosDir -File

foreach ($file in $files) {
    # Try to match date pattern YYYYMMDD at the start of the filename
    if ($file.Name -match '^(\d{4})(\d{2})(\d{2})') {
        $year = $matches[1]
        $month = $matches[2]
        # Build year and year_month folders
        $yearFolder = Join-Path $VideosDir $year
        $yearMonthFolder = Join-Path $yearFolder "${year}_$month"
        
        # Create folders if they don't exist
        if (-not (Test-Path $yearMonthFolder)) {
            New-Item -ItemType Directory -Path $yearMonthFolder | Out-Null
        }
        
        # Move the file
        $target = Join-Path $yearMonthFolder $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "Moved $($file.Name) to $yearMonthFolder"
    }
    else {
        # Move to discard folder
        $target = Join-Path $DiscardDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "Moved $($file.Name) to discard folder"
    }
}
