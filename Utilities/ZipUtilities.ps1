<# 
.Synopsis
    Compression utility functions
.Description 
    Collection of Compression utility related functions - see individual functions for examples
#>

Set-StrictMode -Version latest

<#
.Synopsis
   Return the filenames in the passed zip file, and write the same set to the clipboard
.Example
   Get-NamesInZipFile -zipFileLocation "c:\temp\my.zip"
#>
function Get-NamesInZipFile {
[CmdletBinding()]
    Param (
        [Parameter(mandatory = $true)] $zipFileLocation,
        [switch] $numberedList
    )

    if (-not (Test-Path $zipFileLocation)) {
        Write-Host "File [$zipFileLocation] not found. Exiting..." -BackgroundColor Yellow -ForegroundColor Red
        throw
    }
    $entries = $null
    [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
    $entries = [IO.Compression.ZipFile]::OpenRead($zipFileLocation).Entries
    Write-Host "[$($entries.count)] File names found in [$zipFileLocation]:" -BackgroundColor Black -ForegroundColor White
  
    Write-ArrayContentToScreen $entries "stuf and stuff" -numberedList
    Write-Host "File names found in [$zipFileLocation] are in your clipboard" -BackgroundColor Black -ForegroundColor White

}

function Write-ArrayContentToScreen {
[CmdletBinding()]
Param (
    [Parameter(mandatory = $true)] $ArrayToDisplay,
    [Parameter(mandatory = $true)] $Message,
    [switch] $numberedList
) 
    foreach ($filename in  $ArrayToDisplay) {
        $filename.FullName
    }
    $ArrayToDisplay | % {"$_"} | clip
}

#Get-NamesInZipFile "C:\scratch\CreateADBDC.ps1.zip"
Get-NamesInZipFile "C:\scratch\CreateADBDC.ps1.zip" -numberedList
