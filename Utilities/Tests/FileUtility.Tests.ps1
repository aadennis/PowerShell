$Global:configFilePath = "C:\tempo\PowerShell\Utilities\Tests\RealFriendsSpec2.json"
Describe "Basic File Checks" {
    #https://github.com/pester/Pester/wiki/TestDrive
    It "throws an exception if the file is empty" { 
        $emptyFile = "TestDrive:\empty.txt" # Join-Path "$TestDrive" "empty.txt"
        New-Item -Path $emptyFile
        try {
            $ranOk = $false
            Check-EmptyFile($emptyFile)
            $ranOk = $true
        }
        catch{}
        $ranOk | Should be $false
    }

    It "does nothing if the file has content" {
        $fileWithContent = "TestDrive:\stuff.txt"
        New-Item -Path $fileWithContent
        Set-Content -Value "stuff" -Path $fileWithContent
        try {
            Check-EmptyFile($fileWithContent)
            $ranOk = $true
        } 
        catch{
            $ranOk = $false
        }
        $ranOK | Should be $true
    }
}

Describe "Config File Utility" {
    It "fails when no config file is included" {
        try {
            $ranOk = $false
            $jsonSpecFile = Get-FixedWidthJsonConfig 
            $ranOk = $true
        } 
        catch {}
        $ranOk | should be $false
    }

    It "succeeds when a config file is included" {
        try {
            $ranOk = $false
            $jsonSpecFile = Get-FixedWidthJsonConfig $Global:configFilePath
            $ranOk = $true
        } 
        catch {}
        $ranOk | should be $true
    }

    It "returns a valid object when converting from Json" {
        $configObject = Get-FixedWidthJsonConfig $Global:configFilePath
        $fields = $configObject.FriendsSpec.Fields

        $configObject.GetType() | should be "System.Management.Automation.PSCustomObject"
        $fields.GetType() | should be "System.Object[]"

        $configObject.FriendsSpec.Fields.Count | should be 5
        $fields[0].datatype | should be "integer"
        $fields[1].name | should be "FirstName"
        $fields[2].length | should be "10"
        $fields[4].pos | should be "59"
    } 

    
}

Describe "Data File Utility" {
    It "gets data into an object" {
        $configFilePath = ".\data\FixedWidthFile.config"
        $csvPath = ".\data\TestData\SmallFile.csv"
        $outputFWPath = ".\data\TestData\FWFile001.txt"
        Copy-CsvWithConfigToFixedWidth $configFilePath $csvPath $outputFWPath
        $content = Get-Content $outputFWPath
        $content | should be "asdfafd"
        $content -match "a" | should be $true 
    }
}