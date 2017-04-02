function Set-Cred($username, $password) {
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
}

Configuration Set-Color {
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
    $cred = Set-Cred "auser" "apassword"

    Node ("localhost")
    {
        Registry registoryColorSetting {

            Key = "HKEY_CURRENT_USER\\Software\Microsoft\\Command Processor"
            ValueName = "DefaultColor"
            ValueData = '5F' # http://www.computerhope.com/color.htm 
            ValueType = "DWORD"
            Ensure = "Present"
            Force = $true
            Hex = $true
            PsDscRunAsCredential = $cred # requires WMF 5.1
        }
    }
}
 
$configData = @{
    AllNodes = @(
        @{
            NodeName = "localhost";
            PSDscAllowPlainTextPassword = $true
        }
    )
}
Set-Color -ConfigurationData $configData
Start-DscConfiguration -Path .\Set-Color -Wait -Verbose -Force 

