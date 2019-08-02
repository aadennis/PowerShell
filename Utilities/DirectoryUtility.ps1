# mostly uses .Net System.IO static classes Directory and DirectoryInfo
# https://docs.microsoft.com/en-us/dotnet/api/system.io.directory?view=netframework-4.8
# https://docs.microsoft.com/en-us/dotnet/api/system.io.directoryinfo?view=netframework-4.8
Set-StrictMode -Version latest

<#
.SYNOPSIS
    Get names for all files inside a single folder - not recursive.
    Note the EnumerateFiles method returns the array sorted by name

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
    #[System.IO.Directory]::EnumerateFiles($Folder, "*.txt")
    [System.IO.Directory]::EnumerateFiles($Folder)
}
