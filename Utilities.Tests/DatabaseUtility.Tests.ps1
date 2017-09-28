# SqlServer integration tests in PowerShell 

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"
. "$here\Configuration\DbConfig.ps1"

$workingDbName = [string]::Empty

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
                Open-DbConnection
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
          
            Execute-SQL $dbConnection $("create database {0}" -f  $workingDbName)
            Execute-SQL $dbConnection $("create table [{0}].[dbo].[mahTable] (id bigint identity, description nvarchar(80))" -f $workingDbName)
            Execute-SQL $dbConnection $("insert into [{0}].[dbo].[mahTable] (description) values ('Twenty three pied pipers')" -f $workingDbName)
            Execute-SQL $dbConnection $("insert into [{0}].[dbo].[mahTable] (description) values ('Twenty four pied pipers')" -f $workingDbName)
            
           
        }
    }

    Context "Read-SQL" {
        It "Selects SQL" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnection
            $result = Read-SQL $dbConnection $("select * from  [{0}].[dbo].[mahTable]" -f $workingDbName)
            $formattedResult = Format-sql $result
            $formattedResult[0] | Should -Be "1^Twenty three pied pipers"
            $formattedResult[1] | Should -Be "2^Twenty four pied pipers"
        }
    }

    
    BeforeAll {

            $workingDbName = "TestDb_{0}" -f $(Get-Random)

    }

    AfterEach {
        #$afterEachVariable = 'AfterEach has been executed'
    }
#>

}
