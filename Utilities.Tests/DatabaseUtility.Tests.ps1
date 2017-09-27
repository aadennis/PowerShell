$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"

. "$here\Configuration\DbConfig.ps1"

Describe "DatabaseUtility" {
    # don't want to hang around waiting for 30 seconds...
    #https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectiontimeout(v=vs.110).aspx
    $defaultDatabaseConnection = "Server=(localdb)\MSSQLLocalDB;Initial Catalog=tempdb;User Id = sa; Password={0};Connection Timeout=3;" -f $dbPassword

    Context "Open-DbConnection" {
        It "opens the default database (the items in the passed connection string must be right for the environment under test)" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            $dbConnection.database | Should -Be "tempdb"
        }
    }
}
