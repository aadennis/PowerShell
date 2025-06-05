# This script searches for specific text in all .docx files within a specified folder and its subfolders.
# It assumes Word is installed
# IMPORTANT: Keep a copy in the search root, so it can assume '.' works.
# usage: ./Search-DocxFilesLocal.ps1 -Phrase "welcome to my"
# usage: ./Search-DocxFilesLocal.ps1 -Folder "." -Phrase "welcome to my"
# usage: ./Search-DocxFilesLocal.ps1 -Folder "C:\OD\Documents" -Phrase "welcome to my"



param (
    [string]$Folder = "d:\od\Documents",
    [string]$Phrase = "welcome to my"
)

# Create Word COM object
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# Get all .docx files in folder and subfolders
$files = Get-ChildItem -Path $Folder -Filter *.docx -Recurse -File

foreach ($file in $files) {
    # print($file.FullName)
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
