$Global:configFilePath = "C:\tempo\PowerShell\Utilities\Tests\RealFriendsSpec2.json"
Describe "File Utility" {
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