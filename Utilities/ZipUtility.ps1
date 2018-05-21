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
    $fileSet | ForEach-Object {
        $file = $_
        if ($file.Directory -and $file.Length -eq 0) {
            $emptyFileCount++
        }
    }
    $emptyFileCount
}

# returns a hashtable (dictionary), containing the name and hashvalue for each file found (not folder)
function Get-FileHashForEachFileInFolder($folder) {
    $fileHashSetForFolder = [System.Collections.Specialized.OrderedDictionary] @{}
    $fileset = Get-ChildItem -Path $folder -Recurse
    $fileset | ForEach-Object {
        $file = $_
        if (-not ($file.PSIsContainer)) {
            $currHash = Get-FileHash -Path $file.FullName
            $fileHashSetForFolder.Add($file, $currHash.Hash)
        }
    }
    $fileHashSetForFolder
}

function Save-FolderHashValuesToFile($folder, $outFile) {
    $fileHashSet = Get-FileHashForEachFileInFolder $folder
    $fileHashSet.Keys | ForEach-Object {
        $key = $_
        $value = $fileHashSet.Item($key)
        "$key`: $value" | Out-File -Append $outFile
   }
}