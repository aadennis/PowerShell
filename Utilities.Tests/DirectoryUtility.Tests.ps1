$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

$Global:configFilePath = "$here\Metadata\Friends.spec.json"
Describe "DirectoryUtility" {

    Context "Get-FileNamesInFolder" {
        It "Returns the names of the files in the given folder, sorted by name" {
            # Sadly, Directory class does not play ball with TestDrive
            #New-Item "TestDrive:\Testfolder" -ItemType Dir
            $testFolder = New-Item -Path "C:\temp\$(Get-Random)" -ItemType Dir
            $testFileSet = "File123.txt", "File789.txt", "aardvark","File456.txt"
            $testFileSet | % {
                New-Item -Path "$testFolder\$_" -ItemType File
            }

            $fileNameSet = Get-FileNamesInFolder $testFolder
            $fileNameSet.length | Should Be 4

            $fileNameSet[0] | Should Be $(Join-Path $testFolder $testFileSet[2])
            $fileNameSet[1] | Should Be $(Join-Path $testFolder $testFileSet[0])
            $fileNameSet[2] | Should Be $(Join-Path $testFolder $testFileSet[3])
            $fileNameSet[3] | Should Be $(Join-Path $testFolder $testFileSet[1])
        }
    }
}
