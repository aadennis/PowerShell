Configuration Set-Color {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    $secpasswd = ConvertTo-SecureString "xxxx" -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential ("person1", $secpasswd)

    Node ("localhost")
    {
        Registry registryColorSetting {

            Key = "HKEY_CURRENT_USER\\Software\Microsoft\\Command Processor"
            ValueName = "DefaultColor"
            ValueData = '5F' # http://www.computerhope.com/color.htm 
            ValueType = "DWORD"
            Ensure = "Present"
            Force = $true
            Hex = $true
            PsDscRunAsCredential = $cred # requires WMF 5.1 / PS 5.1
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

