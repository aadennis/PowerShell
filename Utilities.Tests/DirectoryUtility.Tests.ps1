$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

$Global:configFilePath = "$here\Metadata\Friends.spec.json"
Describe "DirectoryUtility" {

    Context "Get-FileNamesInFolder" {
        It "Returns (right now) the folder name it was passed" {
            $folder = "testingFolder"
            $fileNameNoExt = Get-FileNamesInFolder $folder
            $fileNameNoExt | Should Be $folder
        }
    }
}
