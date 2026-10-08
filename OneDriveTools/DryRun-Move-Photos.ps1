# Note: This script is a dry run and does not perform any actual file moves.
# It simply prints what would happen if the script were to run normally.
# To execute the actual move, you would replace Write-Host with Move-Item.

$PhotosDir = "D:\onedrive\Pictures\Camera Roll\Photos"
$DiscardDir = Join-Path $PhotosDir "discard"

# Get all files (non-recursive)
$files = Get-ChildItem -Path $PhotosDir -File

foreach ($file in $files) {
    if ($file.Name -match '^(\d{4})(\d{2})(\d{2})') {
        $year = $matches[1]
        $month = $matches[2]
        $yearFolder = Join-Path $PhotosDir $year
        $yearMonthFolder = Join-Path $yearFolder "${year}_$month"

        # Dry run output
        Write-Host "Would move '$($file.Name)' to '$yearMonthFolder'"
    }
    else {
        Write-Host "Would move '$($file.Name)' to '$DiscardDir'"
    }
}

