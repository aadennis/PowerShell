Set-StrictMode -Version latest

function Get-FixedWidthJsonConfig {
[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $configFilePath=$(throw "configFilePath is mandatory")
)

    $configContent = Get-Content $configFilePath
    $configContent | ConvertFrom-Json

}

