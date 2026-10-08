$VideosDir = "D:\onedrive\Pictures\Camera Roll\Videos"
$DiscardDir = Join-Path $VideosDir "discard"

# Get all files (non-recursive)
$files = Get-ChildItem -Path $VideosDir -File

foreach ($file in $files) {
    if ($file.Name -match '^(\d{4})(\d{2})(\d{2})') {
        $year = $matches[1]
        $month = $matches[2]
        $yearFolder = Join-Path $VideosDir $year
        $yearMonthFolder = Join-Path $yearFolder "${year}_$month"
        
        # Print what would happen
        Write-Host "Would move '$($file.Name)' to '$yearMonthFolder'"
    }
    else {
        Write-Host "Would move '$($file.Name)' to '$DiscardDir'"
    }
}
