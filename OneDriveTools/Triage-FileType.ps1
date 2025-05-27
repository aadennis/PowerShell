# This script organizes files in the OneDrive Camera Roll folder by moving photos and videos into their respective subfolders.

$Root = "D:\onedrive\Pictures\Camera Roll"
$PhotosDir = Join-Path $Root "Photos"
$VideosDir = Join-Path $Root "Videos"

# Create folders if they don't exist (will show output)
New-Item -ItemType Directory -Path $PhotosDir -Force
New-Item -ItemType Directory -Path $VideosDir -Force

# Define extensions
$photoExts = @(".jpg", ".jpeg", ".png", ".heic", ".bmp", ".gif", ".tif", ".webp")
$videoExts = @(".mp4", ".mov", ".avi", ".mkv", ".wmv", ".3gp")

# Get all files in root folder (non-recursive)
$files = Get-ChildItem -Path $Root -File

foreach ($file in $files) {
    $ext = $file.Extension.ToLower()

    if ($photoExts -contains $ext) {
        $target = Join-Path $PhotosDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "📷 Moved photo: $($file.Name)"
    }
    elseif ($videoExts -contains $ext) {
        $target = Join-Path $VideosDir $file.Name
        Move-Item -Path $file.FullName -Destination $target -Force
        Write-Host "🎞️ Moved video: $($file.Name)"
    }
    else {
        Write-Host " Skipped (unknown type): $($file.Name)"
    }
}

