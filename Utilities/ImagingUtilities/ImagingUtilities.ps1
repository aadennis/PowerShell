
# private function
$gsDir = "C:\Program Files\gs\gs9.21\bin\" 

#Quality of conversion an issue
#https://stackoverflow.com/questions/5085710/how-to-improve-the-quality-of-jpeg-images-that-are-generated-from-pdfs-using-gho
$argumentListStart = "-dNOPAUSE -dBATCH -sDEVICE=png16m -r600 -dDownScaleFactor=3 -sOutputFile="
#$argumentListStart = "-dNOPAUSE -dBATCH -sDEVICE=jpeg -dJPEGQ=100 -sOutputFile="

function Get-FileNameNoExtension ($fileName) {
    $($fileName.Split("."))[0]
}

function ConvertTo-PngFromPdf {
    Param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
            $pdfFile = $(Throw "You must enter the name of the file to convert"),
        [Parameter()]
        [ValidateNotNullOrEmpty()]
            $folder = $(Throw "You must enter the name of the folder that contains the files")
    ) 
       $fileNameNoExtension = Get-FileNameNoExtension -fileName $pdfFile
       $argumentList = $argumentListStart + "$folder/$fileNameNoExtension.jpg $folder/$fileNameNoExtension.pdf"
       Start-Process -FilePath $gsDir/gswin64.exe -ArgumentList $argumentList
    }
    
# end of private functions
<#
.SYNOPSIS
Given a folder, convert all the PDF files in the folder to PNG format.
From to a PNG file from a PDF file (assumes single page right now)

.DESCRIPTION
If a file is e.g. MyFile.pdf, then if MyFile.png already exists, then it will be overwritten.
Dependency: GhostScript installed

.EXAMPLE
An example

.NOTES
#>
#https://stackoverflow.com/questions/5085710/how-to-improve-the-quality-of-jpeg-images-that-are-generated-from-pdfs-using-gho
function ConvertTo-PngSetFromPdf {
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
        $PdfPngFolder = $(Throw "You must enter the name of the folder containing the files")
) 
    $pdfSet = Get-ChildItem -Path $PdfPngFolder -Filter *.pdf
   foreach ($pdf in $pdfSet) {

    Write-Host $pdf.FullName
     ConvertTo-PngFromPdf -pdfFile $pdf.Name -folder $PdfPngFolder
   }
}
