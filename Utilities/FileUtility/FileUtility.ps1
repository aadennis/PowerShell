Set-StrictMode -Version latest

function Check-EmptyFile($fileToCheck){
    $content = Get-Content $fileToCheck
    if ([string]::IsNullOrEmpty($content)) {
        throw("[$fileToCheck] is empty")
    }
}

function Get-FixedWidthJsonConfig {
[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $configFilePath=$(throw "configFilePath is mandatory")
)
    Get-Content -Raw $configFilePath | ConvertFrom-Json
}


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
            [string] $currentField = $_
            if ($currentField.length -eq 0) {
                break
            }
            $currentRecordOut += $currentField.PadRight($fields[$index++].Length)
        }
        $fwFileContent += $currentRecordOut
    }

    $fwFileContent | out-file -FilePath $outputFWPath -Force
}

