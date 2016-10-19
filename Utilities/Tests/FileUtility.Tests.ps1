$Global:configFilePath = "C:\tempo\PowerShell\Utilities\Tests\data\TestData\RealFriendsSpec2.json"
Describe "File Utility" {
    It "should fail when no config file is included" {
        try {
            $ranOk = $false
            $jsonSpecFile = Get-FixedWidthJsonConfig 
            $ranOk = $true
        } 
        catch {}
        $ranOk | should be $false
    }

    It "should succeed when a config file is included" {
        try {
            $ranOk = $false
            $jsonSpecFile = Get-FixedWidthJsonConfig $Global:configFilePath
            $ranOk = $true
        } 
        catch {}
        $ranOk | should be $true
    }

    It "should return a valid Json object" {
        $configObject = Get-FixedWidthJsonConfig $Global:configFilePath
        $fieldSet = @("@{pos=0; length=4; name=Id}",
            "@{pos=4; length=11; name=FirstName}","@{pos=65; length=20; name=IPAddress}")

        $index = 0;
        foreach ($field in $configObject.FriendsSpec.Fields) {
            
            Add-PsLogMessage -LogName "youtubedemo" -Message "field is: $field"
            Add-PsLogMessage -LogName "youtubedemo" -Message "fieldthing is: $($field[$index])"
            $field[$index] | should be $fieldSet[$index]


            $position = $field.pos
            Add-PsLogMessage -LogName "youtubedemo" -Message "Pos is: $position"




            $index++
        }
      
    } 

}