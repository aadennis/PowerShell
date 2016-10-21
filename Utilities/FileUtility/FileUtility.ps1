Set-StrictMode -Version latest

function Check-EmptyFile($fileToCheck){
    $content = Get-Content $fileToCheck
    if ([string]::IsNullOrEmpty($content)) {
        "22"
        throw("[$fileToCheck] is empty")
    }
    "44"
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
    foreach ($file in $configFilePath, $csvPath) {
        Check-EmptyFile $configFilePath
    }

    $fileLengthSet = Get-FixedWidthJsonConfig $configFilePath
    $dataContent = Get-Content -Path $csvPath
   
    $fixedWidthFileContent = @()
    $fwFileContent = [string]::Empty

    $dataContent | select -Skip 2 | % {
        $currentRecordIn = $_
        $currentRecordOut = [string]::Empty
        $index = 0

        $currentRecordIn -split "," | % {
            $currentField = $_
            $currentRecordOut += $currentField.PadRight($fileLengthSet[$index++])

        }
        $fwFileContent += $currentRecordOut
    }

    $fwFileContent | out-file -FilePath $outputFWPath -Force
}

