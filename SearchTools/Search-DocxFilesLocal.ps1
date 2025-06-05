# This script searches for specific text in all .docx files within a specified folder and its subfolders.
# It assumes Word is installed

$word = New-Object -ComObject Word.Application
$word.Visible = $false

$folder = "D:\OneDrive\Documents"
$files = Get-ChildItem -Path $folder -Filter *.docx -Recurse

foreach ($file in $files) {
    $doc = $word.Documents.Open($file.FullName, $false, $true)
    $text = $doc.Content.Text
    if ($text -match "welcome to my") {
        Write-Output $file.FullName
    }
    $doc.Close()
}

$word.Quit()
