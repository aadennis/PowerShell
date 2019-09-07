Set-StrictMode -version latest
<#
.SYNOPSIS
    Return a property that has already been set via Set-EnvVars.
    There is nothing to say that the requested variable has been set 
    via Set-EnvVars, it is just a convenience.

.DESCRIPTION
    If the property has not been set, then return $null.
.EXAMPLE
    $dbName = Get-EnvVar -propertyKey "dbName"

.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-EnvVar($propertyKey) {
    $propertyKey = Get-Variable -Name $propertyKey -ErrorAction SilentlyContinue
    if ($null -eq $propertyKey)     {
        return $null
    }
    $propertyKey.Value
}


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
$payLoad = 
@'
<?xml version="1.0" encoding="utf-8"?>
<MyVars>
    <ShoeSize>42</ShoeSize>
    <Team>Accrington Stanley</Team>
</MyVars>
'@

# <?xml version="1.0" encoding="utf-8"?>
# <MyVars>
#     <ShoeSize>42</ShoeSize>
#     <Team>Accrington Stanley</Team>
# </MyVars>

Remove-Variable -Name ShoeSize -ErrorAction Ignore
Remove-Variable -Name Team -ErrorAction Ignore

$xml = [xml] $payLoad

# Act
Set-EnvVars -xml $xml -root "MyVars"


