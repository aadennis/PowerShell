# This script searches for a specific phrase in all .docx files within a specified folder and its subfolders.
# It uses a cache to speed up subsequent searches by storing the text content of each file.
# It assumes Word is installed and uses the .NET System.IO.Compression namespace to read .docx files as ZIP archives.

param(
    [string]$Folder = "D:\OneDrive",
    [string]$CacheFile = "$env:TEMP\DocxTextCache.json"
)

# Prompt user for phrase
$Phrase = Read-Host "Enter the phrase to search for in .docx files"
if ([string]::IsNullOrWhiteSpace($Phrase)) {
    Write-Error "No phrase entered. Exiting..."
    exit 1
}

# Load cache if exists
$cache = @{}
if (Test-Path $CacheFile) {
    try {
        $json = Get-Content $CacheFile -Raw | ConvertFrom-Json
        if ($json -is [System.Collections.IDictionary]) {
            $cache = @{}
            foreach ($key in $json.PSObject.Properties.Name) {
                $cache[$key] = $json.$key
            }
        }
    }
    catch {
        Write-Warning "Failed to load cache file, starting fresh."
        $cache = @{
        }
    }
}

# Helper: Extract text from .docx (ZIP + XML) fast
function Get-DocxText {
    param($filePath)

    try {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($filePath)
        $entry = $zip.GetEntry("word/document.xml")
        if ($entry -ne $null) {
            $stream = $entry.Open()
            $reader = New-Object System.IO.StreamReader($stream)
            $xmlContent = $reader.ReadToEnd()
            $reader.Close()
            $stream.Close()
            $zip.Dispose()

            # Strip XML tags and normalize whitespace to get raw text
            $text = [regex]::Replace($xmlContent, "<[^>]+>", " ")
            $text = $text -replace '\s+', ' '
            return $text
        }
        else {
            $zip.Dispose()
            return $null
        }
    }
    catch {
        Write-Warning ("Failed to extract text from {0}: {1}" -f $filePath, $_)
        return $null
    }
}

# Get all .docx files in folder and subfolders
$files = Get-ChildItem -Path $Folder -Filter *.docx -Recurse -File

$f1 = $files.Count
Write-Host $f1
# Sequential processing for debugging
$matchedFiles = @()
foreach ($file in $files) {
    # Check cache
    $cacheKey = $file.FullName.ToLower()
    $lastWrite = $file.LastWriteTimeUtc.ToString("o")

    $cachedEntry = $null
    if ($cache.Keys -contains $cacheKey) {
        $cachedEntry = $cache[$cacheKey]
    }

    if ($cachedEntry -and $cachedEntry.LastWriteTime -eq $lastWrite) {
        # Use cached text
        $text = $cachedEntry.Text
    }
    else {
        # Extract fresh text
        $text = Get-DocxText -filePath $file.FullName
        # Update cache entry
        $cache[$cacheKey] = @{ Text = $text; LastWriteTime = $lastWrite }
    }

    if ($text -and $text -match [regex]::Escape($Phrase)) {
        Write-Host "MATCH: $($file.FullName)" -ForegroundColor Green
        $matchedFiles += $file.FullName
    }
}

# Update cache file
try {
    $cache | ConvertTo-Json -Depth 4 | Set-Content -Path $CacheFile -Encoding UTF8
}
catch {
    Write-Warning "Failed to save cache file: $_"
}

Write-Host "`n========================="
Write-Host "Matched Files for phrase: '$Phrase'" -ForegroundColor Yellow
Write-Host "========================="

if (-not $matchedFiles -or $matchedFiles.Count -eq 0) {
    Write-Host "No matches found." -ForegroundColor Red
}
else {
    $matchedFiles | ForEach-Object { Write-Host $_ -ForegroundColor Green }
}
Read-Host "Press Enter to exit"