#invoke-pester -Script .\DirectoryUtility.Tests.ps1 -TestName DirectoryUtility

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

function  Remove-FolderSilent ($folderPath) {
    Remove-Item -Path $folderPath -Force -Recurse -ErrorAction SilentlyContinue
}

function New-TempFolder {
    #TestDrive and .Net - https://github.com/pester/Pester/wiki/TestDrive#working-with-net-objects
    New-Item -Path "$TestDrive\$(Get-Random)" -ItemType Dir
}

function TearDown($folderPath) {
    Remove-FolderSilent -folderPath $folderPath
}

Describe "DirectoryUtility" {
    Context "Get-FileNamesInFolder" {
        It "Returns the pathnames of the files in the given folder, sorted by name" {

            # arrange 
            $testFolder = New-TempFolder
            $testFileSet = "File123.txt", "File789.txt", "aardvark","File456.txt"
            $testFileSet | ForEach-Object {
                New-Item -Path "$testFolder\$_" -ItemType File
            }

            # act
            $fileNameSet = Get-FileNamesInFolder $testFolder

            # assert
            $fileNameSet.length | Should Be 4
            $fileNameSet[0] | Should Be $(Join-Path $testFolder $testFileSet[2])
            $fileNameSet[1] | Should Be $(Join-Path $testFolder $testFileSet[0])
            $fileNameSet[2] | Should Be $(Join-Path $testFolder $testFileSet[3])
            $fileNameSet[3] | Should Be $(Join-Path $testFolder $testFileSet[1])
        }
    }

    Context "Get-LowNameInFolder" {
        It "Returns the lowest-named pathname (e.g folder\aardvark) in the given folder" {
              # arrange 
              $testFolder = New-TempFolder
              $testFileSet = "File123.txt", "File789.txt", "aardvark","File456.txt"
              $testFileSet | ForEach-Object {
                  New-Item -Path "$testFolder\$_" -ItemType File
              }
  
              # act
              $file = Get-LowNameInFolder $testFolder
  
              # assert
              $file | Should Be $(Join-Path $testFolder "aardvark")
        }
    }

    Context "Get-HighNameInFolder" {
        It "Returns the highest-named pathname (e.g folder\zygote) in the given folder" {
                #arrange 
                $testFolder = New-TempFolder
                $testFileSet = "File123.txt", "File789.txt", "zygote", "aardvark","File456.txt"
                $testFileSet | ForEach-Object {
                    New-Item -Path "$testFolder\$_" -ItemType File
                }
    
                # act
                $file = Get-HighNameInFolder $testFolder
    
                # assert
                $file | Should Be $(Join-Path $testFolder "zygote")
        }
    }
}
