set strict-mode latest
<#
.SYNOPSIS
    Reads name/value pairs from xml that are the children of the passed node,
    and creates (name) and populates (value) a global variable for each pair found.
.EXAMPLE
    Set-EnvVars -xml $xml -root "MyVars"
.INPUTS
    $xml - the XML payload. Example:
        <?xml version="1.0" encoding="utf-8"?>
        <MyVars>
            <ShoeSize>42</ShoeSize>
            <Team>Accrington Stanley</Team>
        </MyVars>
    $root - the root of the children to be found. Example matching the above: "MyVars"
.OUTPUTS
    The dynamically created variables. Given the example above, that would be
    ShoeSize: 42
    Team: Accrington Stanley
#>
function Set-EnvVars($xml, $root) {
    $propertySet = $xml.$root | Select-Object -ExpandProperty childnodes
    $propertySet | ForEach-Object {
        $property = $_
        Set-Variable -Name $property.Name -Value $property.InnerText -Scope Global -Option AllScope
    }
}

# Arrange
# <?xml version="1.0" encoding="utf-8"?>
# <MyVars>
#     <ShoeSize>42</ShoeSize>
#     <Team>Accrington Stanley</Team>
# </MyVars>

Remove-Variable -Name ShoeSize -ErrorAction Ignore
Remove-Variable -Name Team -ErrorAction Ignore

$xml = [xml] (Get-Content C:\Temp\EnvVars.xml)

# Act
Set-EnvVars -xml $xml -root "MyVars"

# Assert - dynamic creation and population of variables
write-host $ShoeSize
write-host $Team


