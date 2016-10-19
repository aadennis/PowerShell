$Global:configFilePath = "C:\tempo\PowerShell\Utilities\Tests\RealFriendsSpec2.json"
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
        $fieldSet = @(  "@{pos=0; length=4; name=Id; datatype=integer}",
                        "@{pos=4; length=11; name=FirstName; datatype=string}",
                        "@{pos=15; length=10; name=LastName; datatype=string}",
                        "@{pos=25; length=34; name=Email; datatype=string}",
                        "@{pos=59; length=6; name=Gender; datatype=string}"
                        )

        $index = 0;
        $configObject.FriendsSpec.Fields | % {
            $field = $_
            Add-PsLogMessage -LogName "youtubedemo" -Message "fieldthing is: $field)"
            $field | should be $fieldSet[$index]
            $position = $field.pos
            Add-PsLogMessage -LogName "youtubedemo" -Message "Pos is: $position"
            $index++
        }
    } 
}