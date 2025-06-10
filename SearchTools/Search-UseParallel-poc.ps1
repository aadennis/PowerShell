# This script searches for a specific phrase in all .docx files within a specified folder and its subfolders.
# It uses a cache to speed up subsequent searches by storing the text content of each file.
# It assumes Word is installed and uses the .NET System.IO.Compression namespace to read .docx files as ZIP archives.
# This script searches for a specific phrase in all .docx files within a specified folder and its subfolders.
# It uses parallel processing and a thread-safe cache to optimize performance.

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

# Load cache if exists and create a synchronized hashtable for thread safety
$cache = @{}
if (Test-Path $CacheFile) {
    try {
        $json = Get-Content $CacheFile -Raw | ConvertFrom-Json
        if ($json -is [System.Collections.IDictionary]) {
            foreach ($key in $json.PSObject.Properties.Name) {
                $cache[$key] = $json.$key
            }
        }
    }
    catch {
        Write-Warning "Failed to load cache file; starting fresh."
    }
}
$synchronizedCache = [System.Collections.Hashtable]::Synchronized($cache)

# Get all .docx files in folder and subfolders
$files = Get-ChildItem -Path $Folder -Filter *.docx -Recurse -File

Write-Host "Found $($files.Count) .docx files."

# PowerShell version check
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or later for parallel processing. Please run with pwsh.exe."
    exit 1
}

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

# Test extraction on a single file before parallel block
$testFile = $files | Select-Object -First 1
if ($testFile) {
    $testText = Get-DocxText -filePath $testFile.FullName
    Write-Host "Single file test extraction: $($testFile.FullName)"
    Write-Host "Extracted text: $testText"
}

# Use ForEach-Object -Parallel to process only the test file
$matchedFiles = $files | Where-Object { $_.FullName -eq $testFile.FullName } | ForEach-Object -Parallel {
    param($file)
    if (-not $file -or -not $file.FullName) { return }

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

    $phrase = $using:Phrase

    $text = (Get-DocxText -filePath $file.FullName)
    if ($text) {
        Write-Host "DEBUG: [$($file.FullName)] Text: $($text.Substring(0, [Math]::Min(100, $text.Length)))..." -ForegroundColor Yellow
        Write-Host "DEBUG: Phrase: $phrase" -ForegroundColor Yellow
    }
    else {
        Write-Warning "No text extracted from $($file.FullName)"
    }
    if ($text -and $text.ToLower().Contains($phrase.ToLower())) {
        Write-Host "MATCH: $($file.FullName)" -ForegroundColor Green
        return $file.FullName
    }
} -ThrottleLimit 1

# Collect and filter matches
$matchedFiles = $matchedFiles | Where-Object { $_ -ne $null }

# Save updated cache
try {
    $synchronizedCache | ConvertTo-Json -Depth 4 | Set-Content -Path $CacheFile -Encoding UTF8
}
catch {
    Write-Warning "Failed to save cache file: $_"
}

# Output results
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