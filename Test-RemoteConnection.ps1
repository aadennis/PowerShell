<#
    File: Test-RemoteConnection.ps1
    Basic proof that once granted credentials, you can see stuff on a remote computer.
    .Example
    Test-RemoteConnection "I7" $cred
    ... where $cred is previously populated with credentials to the remote computer
#>
function Set-TrustedHost ($remoteComputer) {
    winrm quickconfig
    Enable-PSRemoting -Force
    $trustedHost = '@{TrustedHosts="' + $remoteComputer + '"}'
    winrm s winrm/config/client $trustedHost
}

function Test-It ($remoteComputer, $cred) {
    $session = New-PSSession -ComputerName $remoteComputer -Credential $cred
    Invoke-Command -Session $session -ScriptBlock {
        Get-ChildItem -Path c:\ -Filter *.txt
    }
}

# private functions above
#------------------------
# entry point below

function Test-RemoteConnection ($remoteComputer, $cred) {
    Set-TrustedHost $remoteComputer
    Test-It -remoteComputer $remoteComputer -cred $cred
}

#--------------------------------------
# Test execution...
if ($cred -eq $null) {
    $cred =  Get-Credential -Message "Enter username and password to the remote server"
}
Test-RemoteConnection "I7" $cred






