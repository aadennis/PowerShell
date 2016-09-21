<# 
.Synopsis
    Compression utility functions
.Description 
    Collection of Compression utility related functions - see individual functions for examples
#>

Set-StrictMode -Version latest

<#
.Synopsis
   Return the filenames in the passed zip file
.Example
   Get-NamesInZipFile -zipFileLocation "c:\temp\my.zip"
#>
function Get-NamesInZipFile {
[CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(mandatory = $true)] $zipFileLocation
    )

    if (-not (Test-Path $zipFileLocation)) {
        Write-Host "File [$zipFileLocation] not found. Exiting..." -BackgroundColor Yellow -ForegroundColor Red
        throw
    }

    [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
    $entries = [IO.Compression.ZipFile]::OpenRead($zipFileLocation).Entries
    $entries | % {
        "[$($_.FullName)] size:[$($_.Length)]"}

    $response = Read-Host -Prompt "Enter [y] if you want the output in your clipboard" 
    if ($response -eq "y") {
        $entries | % {"[$($_.FullName)] size:[$($_.Length)]"} | clip
        "Content is in your clipboard"
    }

}


Get-NamesInZipFile "C:\scratch\CreateADBDC.ps1.zip"