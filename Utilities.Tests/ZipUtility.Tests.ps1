$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

$Global:configFilePath = "$here\Metadata\Friends.spec.json"
Describe "ZipUtility" {

   Context "ConvertTo-ExpandedFileSetFromZipFile" {
        It "expands all entries in a zip file to the named folder" {
            # arrange
            $inputFileName = "TestArchive.zip"
            $outputFolder = "TestDrive:/TestArchiveRoot"
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
