# This example requires PowerShell 5.1, and not just the Dsc components from PowerShellGallery.com
# 
cd C:\sandbox\PowerShell

function Set-Cred($username, $password) {
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
}

Configuration Set-Color {
    param (
        [String[]] $ComputerName,
        [pscredential] $Credential
    )
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

    Node $ComputerName
    {
        Registry registryColorSetting {

            Key = "HKEY_CURRENT_USER\\Software\Microsoft\\Command Processor"
            ValueName = "DefaultColor"
            ValueData = '1F' # http://www.computerhope.com/color.htm 5F purple, 1F black
            ValueType = "DWORD"
            Ensure = "Present"
            Force = $true
            Hex = $true
            PsDscRunAsCredential = $Credential # requires WMF 5.1
        }
    }
}

$configData =  @{
    AllNodes = @(
        @{
            NodeName = "10.0.2.4"
            PSDscAllowPlainTextPassword = $true
        },
        @{
            NodeName = "10.0.2.5"
            PSDscAllowPlainTextPassword = $true
        }
    )
}

$cred = Set-Cred "auser" "apassword"
Set-Color -ComputerName "10.0.2.4", "10.0.2.5" -Credential $cred -ConfigurationData $configData
Start-DscConfiguration -Path .\Set-Color -Wait -Verbose -Force 

