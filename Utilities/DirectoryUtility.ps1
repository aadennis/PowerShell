# mostly uses .Net System.IO static classes Directory and DirectoryInfo
Set-StrictMode -Version latest

<#
.SYNOPSIS
    Get names for all files inside a single folder - not recursive
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-FileNamesInFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        $Folder
    )
    $Folder
}
