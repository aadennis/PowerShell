# Set the IE HomePage, aka Start Page
# This example requires PowerShell 5.1, and not just the Dsc components from PowerShellGallery.com

Set-Location C:\sandbox\PowerShell

function Set-Cred($username,  [SecureString] $password) {
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
}

Configuration Set-IEHomePage {
    param (
        [String[]] $ComputerName,
        [pscredential] $Credential,
        $HomePage
    )
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

    Node $ComputerName
    {
        Registry IEHomePage {

            Key = "HKEY_CURRENT_USER\\Software\Microsoft\\Internet Explorer\\Main"
            ValueName = "Start Page"
            ValueData = $HomePage
            ValueType = "String"
            Ensure = "Present"
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
Set-IEHomePage -ComputerName "10.0.2.4", "10.0.2.5" -Credential $cred -ConfigurationData $configData -HomePage "dennisaa.wordpress.com"
Start-DscConfiguration -Path .\Set-IEHomePage -Wait -Verbose -Force 

