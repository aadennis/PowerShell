<#
    Guts of a tutorial about PowerShell Desired State Configuration (DSC) that assumes a push server 
    (from where this script runs), and 2 "client" servers accessed via private ip address on the same subnet.
    This script/push server pushes an instruction to set up a folder on each of the 2 client servers,
    as required.
    On the evidence, it is enough that the client servers are on the same subnet as the push server,
    and importantly, in the TrustedHosts: no credentials seem to be required.
#>

$sandbox = "C:\sandbox\PowerShell"
$allowedNodeSet = "10.0.2.4","10.0.2.5"
$folderToCreate = "c:\sandbox\Books01"

# change values above pre-runtime - public
#-----------------------------
# do not change anything below here - private

if (-not (Test-Path $sandbox)) {
    New-Item -Type directory $sandbox
}

# The "client" server list is entered in the Trusted Hosts list...
$trustedHostSet = $allowedNodeSet -join ","
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $trustedHostSet -Force

cd $sandbox

<#
# assumption that creds are same for each server
if ($cred -eq $null) {
    $cred = Get-Credential -Message "Enter username and password"
}
#>

$allowedNodeSet | % {
    $currentNode = $_

    Write-Host "Processing [$currentNode]..." -BackgroundColor DarkMagenta
    $testWsmanResult = Test-WSMan -ComputerName $currentNode
    $testWsmanResult
    if ($testWsmanResult -eq $null) {
        Write-Error "$currentNode messed up"
        return
    }

    Configuration BasicDscConfig {
        Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
        node $currentNode {
            File MyRandomDir {
                DestinationPath = $folderToCreate
                Type = "Directory"
                Recurse = $false
            }

            # see - https://msdn.microsoft.com/en-us/powershell/dsc/serviceresource
            # Windows audio is a useful example of a service under DSC as it seems quite maleable
            Service ServiceTesty {
                Name = "AudioSrv"
                State = "Stopped" #"Running"
                StartupType = "Disabled" #"Manual"
            }
        }
    }

    BasicDscConfig -InstanceName $currentNode
    Start-DscConfiguration -Path .\BasicDscConfig -Wait -Verbose -Force #-Credential $cred
}
