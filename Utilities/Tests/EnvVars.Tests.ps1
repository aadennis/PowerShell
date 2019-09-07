#https://github.com/pester/Pester/wiki/Invoke-Pester
# Execute this from the folder [Tests]
Set-Location $PSScriptRoot

write-host $pwd

. ..\XmlParser\EnvVars.ps1

Describe "Get and Set environment variables" {
    $payLoad = 
@'
<?xml version="1.0" encoding="utf-8"?>
    <MyVars>
        <ShoeSize>42</ShoeSize>
        <Team>Accrington Stanley</Team>
    </MyVars>
'@
    It "reads a string property value set by Set-EnvVars" {

        # Arrange
        Remove-Variable -Name Team -ErrorAction Ignore
        $xml = [xml] $payLoad

        # Act
        Set-EnvVars -xml $xml -root "MyVars"
        $team = Get-EnvVar -propertyKey "Team"

        # Assert - dynamic creation and population of variables
        $team | Should be  "Accrington Stanley"
    }

    It "reads an integer property value set by Set-EnvVars" {
        # Arrange
        Remove-Variable -Name ShoeSize -ErrorAction Ignore
        $xml = [xml] $payLoad

        # Act
        Set-EnvVars -xml $xml -root "MyVars"
        $ShoeSize = Get-EnvVar -propertyKey "ShoeSize"

        # Assert - dynamic creation and population of variables
        $ShoeSize | Should be  "42"
    }

    It "returns null for a property that has not been set" {
        # Arrange
        $xml = [xml] $payLoad

        # Act
        Set-EnvVars -xml $xml -root "MyVars"
        $nonsense = Get-EnvVar -propertyKey "nonsense"

        # Assert
        $nonsense | Should be $null
   }
}