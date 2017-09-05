<#
.SYNOPSIS
ConvertTo-ExpandedFileSetFromZipFile 

.DESCRIPTION
PowerShell 5 and above...

.PARAMETER zipFile
Parameter description

.PARAMETER outputFolder
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function ConvertTo-ExpandedFileSetFromZipFile ($zipFile, $outputFolder) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    Expand-Archive -Path $zipFile -DestinationPath $outputFolder

}

function Test-EmptyFileInZipFile ($zipFile) {
    $rand = Get-Random -Minimum 1 -Maximum 9999
    $tempFolderLeaf = "temp$rand"
    $tempOutputFolderName = "$env:TEMP" + "/" + "$tempFolderLeaf"

    $emptyFileCount = 0
    ConvertTo-ExpandedFileSetFromZipFile $zipFile $tempOutputFolderName
    $fileSet = Get-ChildItem -path $tempOutputFolderName -Recurse
    $fileSet | foreach {
        $file = $_
        if ($file.Directory -and $file.Length -eq 0) {
            $emptyFileCount++
        }
    }
    $emptyFileCount
}