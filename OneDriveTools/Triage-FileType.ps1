# Triage files in OneDrive Camera Roll folder by type
# This script organizes photos and videos into separate folders.

$Root = "D:\onedrive\Pictures\Camera Roll"
$PhotosDir = Join-Path $Root "Photos"
$VideosDir = Join-Path $Root "Videos"

# Create folders if they don't exist
New-Item -ItemType Directory -Path $PhotosDir -Force | Out-Null
New-Item -ItemType Directory -Path $VideosDir -Force | Out-Null

# Define extensions
$photoExts = @(".jpg", ".jpeg", ".png", ".heic", ".bmp", ".gif", ".tif", ".webp")
$videoExts = @(".mp4", ".mov", ".avi", ".mkv", ".wmv", ".3gp")

# Get all files recursively under $Root, excluding the Photos and Videos folders to avoid infinite loop
$files = Get-ChildItem -Path $Root -File -Recurse | Where-Object {
    # Exclude files already inside the Photos or Videos folders
    ($_.FullName -notlike "$PhotosDir*") -and ($_.FullName -notlike "$VideosDir*")
}

foreach ($file in $files) {
    $ext = $file.Extension.ToLower()

    if ($photoExts -contains $ext) {
        $target = Join-Path $PhotosDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "📷 Moved photo: $($file.FullName)"
    }
    elseif ($videoExts -contains $ext) {
        $target = Join-Path $VideosDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "🎞️ Moved video: $($file.FullName)"
    }
    else {
        Write-Host "? Skipped (unknown type): $($file.FullName)"
    }
}
