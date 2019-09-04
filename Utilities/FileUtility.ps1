Set-StrictMode -Version latest

<#
.Synopsis
   Compare a reference folder and children, with another folder and children.
.Example
   Compare-ReferenceFolderTreeToAnotherTree -r "G:\VideosCollection\TheRest\MP4" -c "e:\set3"
#>
function Compare-ReferenceFolderTreeToAnotherTree ($referenceFolder, $targetFolder) {
   $refSet = Get-ChildItem -Recurse -path $referenceFolder
   $targetSet = Get-ChildItem -Recurse -path $targetFolder

   Compare-Object -ReferenceObject $refSet -DifferenceObject $targetSet
}

<#
.Synopsis
   Rename all the files in the given folder to have the given extension.
   It handles the source extension, and the new extension, being empty. In this case, make sure you do not supply a 
   trailing dot (#todo - support this possibility)
.Example
   Move-FileSetToNewExtension $currDir $originalExtension $newExtension
#>
function Move-FileSetToNewExtension ($currDir, $originalExtension, $newExtension) {
   cd $currDir
   $fileSet = gci -Path . -Filter *
   #$fileSet
   
   $fileSet | % {
      $currFile = $_.Name
      if ($currFile.Contains(".")) {
         $currFileBase = $($currFile.Split("."))[0]
      } else {
         $currFileBase = $currFile
      }
      
      if (!$currFile.EndsWith($originalExtension)) {
         "skipping..."
         return
      }
      $newFile = "$currFileBase$newExtension"
      #$newFile
      move-item -Path $currDir\$currFile $currDir\$newFile
   }
}

<#
.Synopsis
   Given a root folder, list the sizes in MB, sorted by descending size,
   of each of the child folders, but not *their" children
#>   
function Get-FolderSizeOfFirstLevelChildren {

$rootDir = "C:\"
   $fso = New-Object -ComObject Scripting.FileSystemObject
   $fx = [ordered] @{}

   $folderSet = gci -Path $currDir -Directory
   $folderSet | % { 
       $childDir = $_.FullName

       $msg = "[$childDir] {0:N2}" -f (($fso.GetFolder($childDir).Size) / 1MB) + " MB"
       $size = $fso.GetFolder($childDir).Size
       try {
           $fx.Add([long] $size, $msg)
       } catch {
           "stuff went bad"
       }
   }

   $fso = $null

   "root folder: [$rootDir]"
   $foldersBySizeDescending = $fx.GetEnumerator() | Sort-Object Key -Descending
   $foldersBySizeDescending
   "Folders originally counted: [$($folderSet.Count)]"
   "Folders in the dictionary: [$($foldersBySizeDescending.Count)]"


   if ($foldersBySizeDescending.Count -lt $folderSet.Count) {
       "Fewer items in the hashtable than in the original folder set. Likely size duplicate" 
   } 

}

<#
.Synopsis
   Compare a reference folder and children, with a copy of that reference, to bring out any diffs
.Description
   A wrapper for Compare-Object for recursed folders
.Example
   Compare-FolderPair "c:\MyRefFolder" "c:\MyTargetFolder"
#>
function Compare-FolderPair ($refPath, $copyPath) {
   $refSet = Get-ChildItem -Recurse -path $refPath
   $copySet = Get-ChildItem -Recurse -path $copyPath
   Compare-Object -ReferenceObject $refSet -DifferenceObject $copySet
}

<#
.Synopsis
   Copy the timestamp from a source AVI file to the converted equivalent MP4 file.
.Description
   The purpose is so that I can easily associate the AVI and the equivalent MP4 file by timestamp, 
   when sorting or searching.
.Example
   Copy-SourceTimeStampToTarget "c:\temp\source.avi" "c:\temp\target.mp4"
#>
function Copy-SourceTimeStampToTarget ($sourceAvi, $targetMp4) {
    $srcTime = Get-Item  $sourceAvi
    $targetTime = Get-Item $targetMp4
    $targetTime.LastWriteTime = $srcTime.LastWriteTime
    $targetTime.CreationTime = $srcTime.CreationTime
}

<#
.Synopsis
   Given the named folder, count the number of files of the named type
.Example
   Get-FileTypeCount "c:\temp" "mp4"
#>
function Get-FileTypeCount ($folder, $extension) {
    $set = (Get-ChildItem $folder -Filter "*.$extension") | Measure-Object
    $setCount = $set.Count
    "In folder [$folder], there are [$setCount] files of type [$extension]"
    start-sleep 2
}

<#
.Synopsis
   Given the full path of a file, return its name only, including extension.
   For the example below, "source.avi" would be returned.
.Example
   Get-FileNameFromFullPath "c:\temp\source.avi"
#>
function Get-FileNameFromFullPath ($file) {
    Split-Path -Path $file -Leaf
}

<#
.Synopsis
   Given the full path of a file, return all parent folders, but not the filename.
   For the example below, "c:\temp" would be returned.
.Example
   Remove-FileNameFromFullPath "c:\temp\source.avi"
#>
function Remove-FileNameFromFullPath ($file) {
    [System.IO.Path]::GetDirectoryName($file)
}

<#
.Synopsis
    If the passed file is empty, throw an exception
.Example
    Test-EmptyFile -f "c:\temp\empty.txt"
#>
function Test-EmptyFile($fileToCheck){
    $content = Get-Content $fileToCheck
    if ([string]::IsNullOrEmpty($content)) {
        $errorMessage = "[$fileToCheck] is empty"
        throw($errorMessage)
    }
}

<#
.Synopsis
    Given a file in Json format, extract the content to a PSCustomObject
.Example
    Get-FixedWidthJsonConfig -c "c:\temp\spec.json"
#>
function Get-FixedWidthJsonConfig {
[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $configFilePath=$(throw "configFilePath is mandatory")
)
    Get-Content -Raw $configFilePath | ConvertFrom-Json
}

<#
.Synopsis
    Given a csv data file, use the passed json spec file to build 
    a fixed width structure, and save it to disk.
    It can handle trailing commas.
    Right now a) it only supports commas and b) assumes no header rows
.Example
    Copy-CsvWithJsonConfigToFixedWidth -co "c:\temp\spec.json" -cs "c:\temp\composers.csv" -o "c:\temp\composers.dat"
#>
function Copy-CsvWithJsonConfigToFixedWidth {
[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
        [string] $configFilePath=$(throw "configFilePath is mandatory"),
    [Parameter()]
    [ValidateNotNullOrEmpty()]
        [string] $csvPath=$(throw "csvPath is mandatory"),
    [Parameter()]
    [ValidateNotNullOrEmpty()]
        [string] $outputFWPath=$(throw "outputFWPath is mandatory")
)
    $noHeader = 0
    $1rowHeader = 1
    $2rowHeader = 2
    foreach ($file in $configFilePath, $csvPath) {
        Test-EmptyFile $file
    }

    $fileLengthSet = Get-FixedWidthJsonConfig $configFilePath
    $fields = $fileLengthSet.Friends.Fields
    $dataContent = Get-Content -Path $csvPath
   
    $fixedWidthFileContent = @()
    $fwFileContent = [string]::Empty

    $dataContent | select -Skip $noHeader | % {
        $currentRecordIn = $_
        $currentRecordOut = [string]::Empty
        $index = 0
        $currentRecordIn -split "," | % {
            $currentField = $_
            if ($currentField.length -gt 0) {
                $currentRecordOut += $currentField.PadRight($fields[$index++].Length)
            }
        }
        $fwFileContent += $currentRecordOut
    }
    $fwFileContent | out-file -FilePath $outputFWPath -Force
}

<#
.SYNOPSIS
Return a file name, without its extension

.DESCRIPTION
If the input filename is e.g. test.txt, then the function returns test.
The function works by looking for the left-most part of a string using a dot character as the delimiter.


.PARAMETER fileName
$fileNameNoExt =  Get-FileNameNoExtension -fileName "test.txt"

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-FileNameNoExtension ($fileName) {
    $($fileName.Split("."))[0]
}

<#
.SYNOPSIS
Show the content of a file, converted from fixed width to csv, in order to display
   it through out-gridview.

.DESCRIPTION
    You must specify the data file, a file containing the widths of each of the columns,
   and optionally the number of header lines to ignore from the format file (default 0) and the maximum number of
   records to return from the input data file (in case the file is very large, and you just want
   a sample of the data).

.PARAMETER dataFile
Parameter description

.PARAMETER formatFile
Parameter description

.PARAMETER formatHeaderLinesToIgnore
Parameter description

.PARAMETER maxRecords
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Show-File
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ })]
        [string] $dataFile,
 
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ })]
        [string] $formatFile,
 
        [Parameter(Mandatory=$false)]
        [int] $formatHeaderLinesToIgnore = 0,
 
        [Parameter(Mandatory=$false)]
        [int] $maxRecords = 100
    )
    $outputDataFile = New-Item -ItemType File $env:Temp\output.dat -Force
 
    $columnNameIndex = 0
    $columnWidthIndex = 1
 
    $formatRuleSet = Get-Content $formatFile | Select-Object -Skip $formatHeaderLinesToIgnore
 
    $formatRulesArray = @()
    $first = $True
    $formatRuleSet | % {
        $columnOffset =
            if ($first -eq $true) {
                0
            } else {
                $columnOffset + $rule[$columnWidthIndex]
            }
        $first = $false
        $rule = $_.split(",")
        $formatRulesArray += New-Object psobject -Property @{
            columnName =
                if ([System.String]::IsNullOrEmpty($rule[$columnNameIndex])) {
                    [string]::format("dummy{0}", [system.guid]::NewGuid()) } else {
                    $rule[$columnNameIndex]
                }
            columnWidth = $rule[$columnWidthIndex]
            colOffset = $columnOffset
        }
    }
 
    $msg = [string]::Format("Starting to write data... [{0}]", [System.DateTime]::utcnow); Write-Verbose $msg
 
    Clear-Content $outputDataFile
 
    Get-Content $dataFile | Select-Object -First $maxRecords | foreach {
        $tempData = $_
        $currentRow = $formatRulesArray | foreach {
            [string]::format("`"{0}`"", [string]($tempData.substring($_.colOffSet,$_.columnWidth)).Trim());
        }
        $tidiedData = [System.String]::Join(",", $currentRow)
        Add-Content $outputDataFile $tidiedData
    }
    $quoteHeader = $formatRulesArray | % {
        [string]::format("`"{0}`"", [string]$_.columnName)
    } 
 
    $msg = [string]::Format("Finished writing data; starting import for rendering... [{0}]", [System.DateTime]::utcnow); Write-Verbose $msg
 
    Import-Csv -Path $outputDataFile -Header $quoteHeader | Out-GridView
 
    $msg = [string]::Format("Finished rendering... [{0}]", [System.DateTime]::utcnow); Write-Verbose $msg
}

<#
.SYNOPSIS
    RUN FROM THE COMMAND LINE.
   Get a folder using a Windows dialog
.DESCRIPTION
    See these entries for some challenges:
    https://www.powershellmagazine.com/2013/06/28/pstip-using-the-system-windows-forms-folderbrowserdialog-class/
    https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog?view=netframework-4.8
    https://stackoverflow.com/questions/7809370/is-it-possible-to-set-folderbrowserdialog-rootfolder-to-an-arbitrary-path-from-a

.EXAMPLE
   $folder = Get-Folder
   Write-Host "Selected folder is [$folder]" -BackgroundColor Cyan -ForegroundColor DarkGreen
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-Folder {
    $((New-Object -ComObject "Shell.Application").BrowseForFolder(0,"Select a folder:",0)).Self.Path
}



