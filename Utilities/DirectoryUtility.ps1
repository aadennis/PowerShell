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




<#
.SYNOPSIS
    Given a folder, return the lowest named (e.g folder/aardvark) filename in that folder.
#>
function Get-LowNameInFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        $Folder
    )
    $file = Get-FileNamesInFolder -Folder $Folder
    $file[0]
}

<#
.SYNOPSIS
    Given a folder, return the highest named (e.g folder/zygote) filename in that folder.
#>
function Get-HighNameInFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        $Folder
    )
    $file = Get-FileNamesInFolder -Folder $Folder
    $file[-1]
}

<#
.SYNOPSIS
    Get list of folders within the passed folder - no recurson

#>
function Get-FolderNamesInFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        $Folder,
        $WildCard
    )
    
    if ($null -eq $WildCard) {
    #[System.IO.Directory]::EnumerateFiles($Folder, "*.txt")
        [System.IO.Directory]::EnumerateDirectories($Folder)
    } else {
        [System.IO.Directory]::EnumerateDirectories($Folder, $WildCard)
    }
    
}
