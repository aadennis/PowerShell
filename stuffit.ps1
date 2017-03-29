function Set-IEHomePage() {
    [CmdletBinding()]
    Param()
    if ($cred -eq $null) {
        $cred = get-credential -UserName "adguy" -Message "give the password"
    }
   
    $session = New-PSSession -ComputerName "I7" -Credential $cred
    Invoke-Command -Session $session -ScriptBlock {
        $VerbosePreference = $using:VerbosePreference
        Write-Verbose "Test"
        Get-ChildItem -Path c:\ -Filter *.txt

        Configuration SetIEHomePage {
            Import-dscresource -modulename xInternetExplorerHomePage
            Node "localhost" {
                xInternetExplorerHomePage IEHomePage {
                    StartPage = "www.weather.com"
                    SecondaryStartPages = "www.google.com"
                    Ensure = $SetEnsure
                }
            }

        }

        SetIEHomePage 
        Start-dscconfiguration -Path .\SetIEHomePage -Wait -Force -Verbose -Credential $cred
    }
}

Set-IEHomePage
 

