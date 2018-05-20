$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

$Global:configFilePath = "$here\Metadata\Friends.spec.json"
Describe "ZipUtility" {

    # Using TestDrive to temp up folders is great... but when you want to debug you have no persistent
    # output to analyze. For that kind of debugging set $useTestDrive to $false. Always commit as $true.
    $useTestDrive = $true

    if ($useTestDrive) {
        $outputFolder = "TestDrive:/TestArchiveRoot"
    } else {
        $tempRoot = [System.IO.Path]::GetTempPath()
        $tempFolder = Get-Random -Minimum 1 -Maximum 1000000
        $outputFolder = "$tempRoot$tempFolder"
    }

   Context "ConvertTo-ExpandedFileSetFromZipFile" {
        It "expands all entries in a zip file to the named folder" {
            # arrange
            $inputFileName = "TestArchive.zip"
            New-Item -Path $outputFolder -ItemType Directory
            $inputZipPath = "$here/Data/$inputFileName"
            $outputfolder | should exist
            $inputZipPath | should exist

            # act
            ConvertTo-ExpandedFileSetFromZipFile -zipFile $inputZipPath -outputfolder $outputFolder

            #assert
            $fileSet = gci $outputFolder -Recurse
            $fileSet.Count | should be 8
        }
    }

    Context "Test-EmptyFileInZipFile" {
        It "Tests for 1 or more empty files in a zip file" {
              # arrange
              $inputFileName = "TestArchive.zip"
              $outputFolder = "TestDrive:/TestArchiveRoot"
              New-Item -Path $outputFolder -ItemType Directory
              $inputZipPath = "$here/Data/$inputFileName"
              $inputZipPath | should exist
  
              # act
              $emptyFileCount = Test-EmptyFileInZipFile -zipFile $inputZipPath
              
              # assert
              $emptyFileCount | Should be 1

        }
    }
}
