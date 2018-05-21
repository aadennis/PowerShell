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
            $fileSet = Get-ChildItem $outputFolder -Recurse
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

    Context "Get-FileHashForEachFileInFolder" {
        It "Gets the (SHA-256) hash value for each file in the given directory" {
            #arrange
            $expectedList = [System.Collections.ArrayList]@()
            $expectedList.Add("NpmInit04.JPG: 73215B239E4658A4AD45A594B529C6ECF3BBE226B6D49A74C4709B2F56CE93DB")
             $expectedList.Add("CW136.pdf: 3D6C376391FCBBF3271C5653542A37B63F670F563FF4553190431A6B9E42AEF4")
            $expectedList.Add("EmptyFile.txt: E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855")
            $expectedList.Add("1537.pdf: 2314487C9336A2AD64D1169F8C7D29CCA03D4E6CD5335FAAA99A125279D33C5A")
            $expectedList.Add("Get-HelloWorld.ps1: CC5FFC55AD0EC511BC241FC92E7E088B94C5C5CEDCDD8B8A006DED28E63E050E")

            $inputFileName = "TestArchive.zip"
            New-Item -Path $outputFolder -ItemType Directory
            $inputZipPath = "$here/Data/$inputFileName"
            $outputfolder | should exist
            $inputZipPath | should exist
            ConvertTo-ExpandedFileSetFromZipFile -zipFile $inputZipPath -outputfolder $outputFolder

            #act
            $fileHashSet = Get-FileHashForEachFileInFolder -folder $outputfolder
           
            #assert
            $count = 0
            $fileHashSet.Keys | ForEach-Object {
                $key = $_
                $value = $fileHashSet.Item($key)
                "$key`: $value" | should be $expectedList[$count]
                $count++
           }
        }
    }
}
