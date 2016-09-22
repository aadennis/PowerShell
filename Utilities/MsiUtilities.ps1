<#
.Synopsis
    List the relative paths of the filenames of each of the files in an msi
.Example
    Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi"
.Example
    Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi" -OutputFilePath "c:\temp\mylistings.log"
#>
function Get-FileListFromMSI
{
[CmdletBinding(SupportsShouldProcess=$true)]
Param (
[Parameter(Mandatory=$true)]
$MsiFullPath,
[Parameter()]
$OutputFilePath
)
    Begin {
        if (-not (Test-Path $MsiFullPath)) {
            "Msi [$MsiFullPath] not found. Exiting..."
            throw
        }
        if (-not $OutputFilePath) {
            $OutputFilePath = [System.IO.Path]::GetTempFileName()
        }
        $expandedMsiFolder = New-TemporaryDirectory
    }
    Process {
        msiexec /a $MsiFullPath /qb TARGETDIR=$expandedMsiFolder
        Start-Sleep 5
        get-childitem $expandedMsiFolder -Recurse | Out-File $OutputFilePath
        
    }
    End {
        Write-Host "Filenames for [$MsiFullPath] are in [$OutputFilePath] " -BackgroundColor Yellow -ForegroundColor Black
    }
}

function New-TemporaryDirectory {
    $folderPath = [System.IO.Path]::GetTempPath()
    [string] $folderName = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $folderPath $folderName)
}

# Example calls which are executed on building of this ps1:
#Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi"
Get-FileListFromMSI -msifullpath "C:\temp\PackageManagement_x64.msi" -OutputFilePath "c:\temp\mylistings.log"