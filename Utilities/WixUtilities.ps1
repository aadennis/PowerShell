<#
.Synopsis
    List the file names in a WIX file
.Example
    Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi"
.Example
    Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi" -OutputFilePath "c:\temp\mylistings.log"
#>
function Get-FileListFromWIX
{
[CmdletBinding(SupportsShouldProcess=$true)]
Param (
[Parameter(Mandatory=$true)]
$WixFullPath,
[Parameter()]
$OutputFilePath
)
    Begin {
        if (-not (Test-Path $WixFullPath)) {
            "Wix [$WixFullPath] not found. Exiting..."
            throw
        }
        if (-not $OutputFilePath) {
            $OutputFilePath = [System.IO.Path]::GetTempFileName()
        }
    }
    Process {
        $wixFileTxt = $WixFullPath + ".txt"
        $xml = [xml] (Get-Content $WixFullPath)
        $xml.Wix.Fragment.ComponentGroup.Component.File.Name | sort | Out-File $wixFileTxt
        
    }
    End {
        Write-Host "Filenames for [$WixFullPath] are in [$OutputFilePath] " -BackgroundColor Yellow -ForegroundColor Black
    }
}



# Example calls which are executed on building of this ps1:
#Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi"
Get-FileListFromWix -wixfullpath "C:\temp\x.wix" -OutputFilePath "c:\temp\mylistings.log"