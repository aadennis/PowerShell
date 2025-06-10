# This script searches for a specific phrase in all .docx files within a specified folder and its subfolders.

param (
    [string]$Folder = "x"
)

# Prompt user for the phrase
$Phrase = Read-Host "Enter the phrase to search for in .docx files"

# Validate input
if ([string]::IsNullOrWhiteSpace($Phrase)) {
    Write-Error "No phrase entered. Exiting..."
    exit 1
}

# Create Word COM object
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# Get all .docx files in folder and subfolders
$files = Get-ChildItem -Path $Folder -Filter *.docx -Recurse -File

foreach ($file in $files) {
    try {
        $doc = $word.Documents.Open($file.FullName, $false, $true)
        $text = $doc.Content.Text
        if ($text -match [regex]::Escape($Phrase)) {
            Write-Output $file.FullName
        }
        $doc.Close()
    } catch {
        Write-Warning "Failed to open $($file.FullName): $_"
    }
}

$word.Quit()
