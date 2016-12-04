<#
.Synopsis
Copy files from a source server to a target server.
This version assumes that the target folder exists.
Its deault is to assume the target folder is d:\import.
.Example
Copy-DataFiles -targetServer "AcmeTarget" -wildcard "*.dat" -targetDriveFolder "z:\myImport"
#>

function Copy-DataFiles {
[CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(mandatory = $true)] $sourceRootFolder,
        [Parameter(mandatory = $true)] $targetServer,
        [Parameter(mandatory = $true)] $wildcard,
        [Parameter(mandatory = $true)] $leafFolder,
        [Parameter(mandatory = $true)] $targetDriveFolder = "d$\Import"
        
        
    )   
    Write-Host $sourceRootFolder
    Push-Location $sourceRootFolder
    $combinedTargetDriveFolder = "\\domainroot" + $targetServer + ".WorldOfShoes.com\" + $targetDriveFolder  + "\" + $leafFolder
    Write-Host $combinedTargetDriveFolder
    $wildcard | gci -Recurse | Copy-Item -Force -Destination $combinedTargetDriveFolder
    Pop-Location
}

#Example call
$srcRoot = "c:\temp"
$targetServer = "8761"
$leafFolder = "HikingBoots"
$wildcard = "*.dat"
Copy-DataFiles -sourceRootFolder $srcRoot -targetServer $targetServer -wildcard $wildcard -leafFolder $leafFolder
    
}"

