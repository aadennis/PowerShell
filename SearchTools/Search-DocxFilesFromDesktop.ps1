# This script searches for a specific phrase in all .docx files within a specified folder and its subfolders.
# It assumes Microsoft Word is installed on the system.
# # Usage:
# ./Search-DocxFilesFromDesktop.ps1 -Folder "D:\dummy" -Phrase "welcome to my"
# In the desktop shortcut version, there is no need to add quotes around the phrase - PS will handle it.

param (
    [string]$Folder = "D:\dummy"
)

# Prompt user for the phrase
$Phrase = Read-Host "Enter the phrase to search for in .docx files"

if ([string]::IsNullOrWhiteSpace($Phrase)) {
    Write-Error "No phrase entered. Exiting..."
    exit 1
}

# Kill existing Word processes
Write-Host "Killing existing WINWORD.EXE processes..." -ForegroundColor DarkYellow
Get-Process WINWORD -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
Start-Sleep -Seconds 1

# Create Word COM object
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# Get all .docx files in folder and subfolders
$files = Get-ChildItem -Path $Folder -Filter *.docx -Recurse -File

# Initialize a list to collect matched file paths
$matchedFiles = @()

foreach ($file in $files) {
    try {
        Write-Host "Searching: $($file.FullName)" -ForegroundColor Cyan
        $doc = $word.Documents.Open($file.FullName, $false, $true)
        $text = $doc.Content.Text
        if ($text -match [regex]::Escape($Phrase)) {
            Write-Host "MATCH: $($file.FullName)" -ForegroundColor Green
            $matchedFiles += $file.FullName
        }
        $doc.Close()
    } catch {
        Write-Warning "Failed to open $($file.FullName): $_"
    }
}

$word.Quit()

# Final match summary
Write-Host "`n========================="
Write-Host "Matched Files:" -ForegroundColor Yellow
Write-Host "========================="

if ($matchedFiles.Count -eq 0) {
    Write-Host "No matches found." -ForegroundColor Red
} else {
    foreach ($match in $matchedFiles) {
        Write-Host $match -ForegroundColor Green
    }
}
