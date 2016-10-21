Set-StrictMode -Version latest

<#
.Synopsis
    If the passed file is empty, throw an exception
.Example
    Check-EmptyFile -f "c:\temp\empty.txt"
#>
function Check-EmptyFile($fileToCheck){
    $content = Get-Content $fileToCheck
    if ([string]::IsNullOrEmpty($content)) {
        throw("[$fileToCheck] is empty")
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
        Check-EmptyFile $file
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
            if ($currentField.length -eq 0) {
                break
            }
            $currentRecordOut += $currentField.PadRight($fields[$index++].Length)
        }
        $fwFileContent += $currentRecordOut
    }

    $fwFileContent | out-file -FilePath $outputFWPath -Force
}

