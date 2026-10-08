$PhotosDir = "D:\onedrive\Pictures\Camera Roll\Photos"
$DiscardDir = Join-Path $PhotosDir "discard"

# Create discard folder if it doesn't exist
if (-not (Test-Path $DiscardDir)) {
    New-Item -ItemType Directory -Path $DiscardDir | Out-Null
}

# Get all files (non-recursive)
$files = Get-ChildItem -Path $PhotosDir -File

foreach ($file in $files) {
    if ($file.Name -match '^(\d{4})(\d{2})(\d{2})') {
        $year = $matches[1]
        $month = $matches[2]
        $yearFolder = Join-Path $PhotosDir $year
        $yearMonthFolder = Join-Path $yearFolder "${year}_$month"

        # Create year/month folder if needed
        if (-not (Test-Path $yearMonthFolder)) {
            New-Item -ItemType Directory -Path $yearMonthFolder | Out-Null
        }

        # Move the file
        $target = Join-Path $yearMonthFolder $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "Moved '$($file.Name)' to '$yearMonthFolder'"
    }
    else {
        # Move to discard folder
        $target = Join-Path $DiscardDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "Moved '$($file.Name)' to discard folder"
    }
}
