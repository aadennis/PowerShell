$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

$Global:configFilePath = "$here\Metadata\Friends.spec.json"
Describe "FileUtility" {

    # todo - store a test pdf in the test artifacts folder, and use that.
    Context "Get-FileNameNoExtension" {
        It "Returns the name of a file without its extension" {
            $file = "testingFile.xxxisx"
            $fileNameNoExt = Get-FileNameNoExtension $file
            $fileNameNoExt | Should Be "testingFile"
        }
    }


    Context "Test-EmptyFile" {
        #https://github.com/pester/Pester/wiki/TestDrive
        It "throws an exception if the file is empty" { 
            $emptyFile = "TestDrive:\empty.txt" 
            New-Item -Path $emptyFile
            # Note that the test call must be wrapped in script braces {}
            {Test-EmptyFile($emptyFile)} | Should Throw "[$emptyFile] is empty"
        }

        It "does nothing if the file has content" {
            $fileWithContent = "TestDrive:\stuff.txt"
            New-Item -Path $fileWithContent
            Set-Content -Value "stuff" -Path $fileWithContent
            {Test-EmptyFile($fileWithContent)} | Should Not Throw
        }
    }

    Context "Get-FixedWidthJsonConfig" {
        It "fails when no config file is included" {
            try {
                $ranOk = $false
                Get-FixedWidthJsonConfig 
                $ranOk = $true
            } 
            catch {}
            $ranOk | should be $false
        }

        It "succeeds when a config file is included" {
            try {
                $ranOk = $false
                Get-FixedWidthJsonConfig $Global:configFilePath
                $ranOk = $true
            } 
            catch {}
            $ranOk | should be $true
        }

        It "returns a valid object when converting from Json" {
            $configObject = Get-FixedWidthJsonConfig $Global:configFilePath
            $fields = $configObject.Friends.Fields

            $configObject.GetType() | should be "System.Management.Automation.PSCustomObject"
            $fields.GetType() | should be "System.Object[]"

            $configObject.Friends.Fields.Count | should be 5
            $fields[0].datatype | should be "integer"
            $fields[1].name | should be "FirstName"
            $fields[2].length | should be "10"
            $fields[4].pos | should be "59"
        } 
    }

    Context " Copy-CsvWithJsonConfigToFixedWidth" {
        It "gets data into an object" {
            
            $csvPath = "$here\Data\SmallFile.csv"
            $outputFWPath = "$here\Data\FWFile001.txt"
            Remove-Item -Path $outputFWPath -Force -ErrorAction SilentlyContinue

            Copy-CsvWithJsonConfigToFixedWidth $Global:configFilePath $csvPath $outputFWPath
            $content = Get-Content $outputFWPath
            # Next line is a full match, not a partial string
            $content | should be "0001James      Thurber   jt@mail.com                       male  9988Jeanne     Darc      jd@franceinter.fr                 female"
            # Next line is a match for the search string, anywhere inside the $content string.
            # -match is case-INsensitive
            $content -match "urB" | should be $true 
        }
    }

    Context "Compare-ReferenceFolderTreeToAnotherTree" {
        It "returns one thing if the folder comparison has no differences" {

        }
        It "returns another thing if the folder comparison have no differences" {

        }
    }
}
