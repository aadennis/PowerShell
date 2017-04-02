Configuration foo {
    Node ("localhost")
    {
        Registry r {

            Key = "HKEY_CURRENT_USER\\Software\Microsoft\\CommandProcessor"
            ValueName = “DefaultColor”
            ValueData = ‘1F’
            ValueType = “DWORD”
            Ensure = “Present”
            Force = $true
            Hex = $true
            PsDscRunAsCredential = (Get-Credential)
        }
    }
}
 
$configData = @{
    AllNodes = @(
        @{
            NodeName = “localhost”;
            PSDscAllowPlainTextPassword = $true
        }
    )
}
foo -ConfigurationData $configData