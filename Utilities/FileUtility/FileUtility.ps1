Set-StrictMode -Version latest

function Get-FixedWidthJsonConfig {
[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $configFilePath=$(throw "configFilePath is mandatory")
)
    Get-Content -Raw $configFilePath | ConvertFrom-Json
}


function Copy-CsvWithConfigToFixedWidth {
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
    $fileLengthSet = Get-FixedWidthJsonConfig $configFilePath
    $dataContent = Get-Content -Path $csvPath
    $fixedWidthFileContent = @()

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

