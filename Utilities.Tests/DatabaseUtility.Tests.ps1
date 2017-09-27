$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

Describe "DatabaseUtilityx" {

    # todo - store a test pdf in the test artifacts folder, and use that.
    Context "Open-DbConnection" {
        It "opens the default database when no arguments are passed" {
            Open-DbConnection
        }
    }
}
