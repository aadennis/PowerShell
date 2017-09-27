# SqlServer integration tests in PowerShell 

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
        It "opens the specified database (the items in the passed connection string must be right for the environment under test)" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            $dbConnection.database | Should -Be "tempdb"
        }

        It "throws an exception if no connection string is passed" {
            try {
                $dbConnection = Open-DbConnection
                throw "Expected: database could not be opened. Actual: database was likely opened."
            } 
            catch {
                $e = $_
                $e.exception.Message | Should -Be 'Exception calling "Open" with "0" argument(s): "The ConnectionString property has not been initialized."'
            }
        }
    }
    Context "Close-DbConnection" {
        It "closes the specified database connection" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            $retConn = Close-DbConnection $dbConnection

            try {
                $retConn.database
                throw "Expected: connection to database no longer valid. Actual: Access still to initial database."
            } 
            catch {
                $e = $_
                $e.exception.Message | Should -Be "The property 'database' cannot be found on this object. Verify that the property exists."
            }
        }

    }

    Context "Execute-SQL" {
        It "executes non-select SQL" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            try {
            Execute-SQL $dbConnection  "create database mahDb" } catch {}
            try {
            Execute-SQL $dbConnection  "create table [mahDb].[dbo].[mahTable] (id bigint identity, description nvarchar(80))" } catch {}
            try {
                Execute-SQL $dbConnection  "insert into [mahDb].[dbo].[mahTable] (description) values ('Twenty three pied pipers')" } catch {}
            
        }
    }

    Context "Read-SQL" {
        It "Selects SQL" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            $x = Read-SQL $dbConnection "select * from  [mahDb].[dbo].[mahTable]" 
            Format-sql $x
            
        }
    }

}
