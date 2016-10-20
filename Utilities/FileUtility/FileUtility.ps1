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

