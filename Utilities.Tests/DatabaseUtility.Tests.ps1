# SqlServer integration tests in PowerShell 

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$featureType = "Utilities"
. "$here\..\$featureType\$sut"
. "$here\Configuration\DbConfig.ps1"

$workingDbName = [string]::Empty
$defaultDatabaseConnectionString = "Server=(localdb)\MSSQLLocalDB;Initial Catalog=tempdb;User Id = sa; Password={0};Connection Timeout=3;" -f $dbPassword

function Teardown-TestDatabase($dbConnection, $workingDbName) {
    Execute-SQL $dbConnection $("drop database {0}" -f $workingDbName)
}

Describe "DatabaseUtility" {

    Context "Open-DbConnection" {
        #Set-WorkingDbName
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
 
        # don't want to hang around waiting for 30 seconds...
        #https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectiontimeout(v=vs.110).aspx
        It "opens the specified database (the items in the passed connection string must be right for the environment under test)" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnectionString
            $dbConnection.database | Should -Be "tempdb"
        }
    }

    Context "Close-DbConnection" {
        It "closes the specified database connection" {
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnectionString
            Write-Host $dbConnection.GetType()
 
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

    Context "Execute-SQL, Read-SQL" {
        It "creates a database then a table, inserts rows, then fetches and formats those rows" {
            # arrange
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnectionString
            $workingDbName = "TestDb_{0}" -f $(Get-Random)

            Execute-SQL $dbConnection $("create database {0}" -f $workingDbName)
            Execute-SQL $dbConnection $("create table [{0}].[dbo].[mahTable] (id bigint identity, description nvarchar(80), shoeSize int)" -f $workingDbName)
            Execute-SQL $dbConnection $("insert into [{0}].[dbo].[mahTable] (description, shoeSize) values ('Twenty three pied pipers',8)" -f $workingDbName)
            Execute-SQL $dbConnection $("insert into [{0}].[dbo].[mahTable] (description, shoeSize) values ('Twenty four pied pipers',12)" -f $workingDbName)
            
            # test default call
            # act 2
            $result = Read-SQL $dbConnection $("select id, description, shoeSize from [{0}].[dbo].[mahTable] order by 1" -f $workingDbName)
            $formattedResult = Format-sql $result
           
            # assert
            $formattedResult[0] | Should -Be "1^Twenty three pied pipers"
            $formattedResult[1] | Should -Be "2^Twenty four pied pipers"

            # test reading of columns 1 to 3
            # arrange
            $expectedRows = @(
                "1", "2",
                "1^Twenty three pied pipers", "2^Twenty four pied pipers",
                "1^Twenty three pied pipers^8", "2^Twenty four pied pipers^12"
            )

            # act / assert
            $i = 0
            1..3 | ForEach-Object {
                $numberOfColumns = $_
                $formattedResult = Format-Sql -dataset $result -columnCount $numberOfColumns
                $formattedResult | % {
                    $currentRow = $_
                    $currentRow | Should be $expectedRows[$i++]
                }
            }
            Teardown-TestDatabase $dbConnection $workingDbName
        }
    }

    Context "Insert-SQLWithScope" {
        It "inserts a row and returns the scope_identity" {

            # arrange
            $dbConnection = Open-DbConnection -sqlConnectionString $defaultDatabaseConnectionString
            $workingDbName = "TestDb_{0}" -f $(Get-Random)
            Execute-SQL $dbConnection $("create database {0}" -f $workingDbName)
            Execute-SQL $dbConnection $("create table [{0}].[dbo].[mahTable] (id bigint identity, shoeSize int)" -f $workingDbName)
            1..10 | ForEach-Object {
                Insert-SQLWithScope $dbConnection $("insert into [{0}].[dbo].[mahTable] (shoeSize) values (99)" -f $workingDbName)
            }

            # act
            $identity = Insert-SQLWithScope $dbConnection $("insert into [{0}].[dbo].[mahTable] (shoeSize) values (99)" -f $workingDbName)

            # assert - Having done 10 inserts on a new table, the next identity value returned should be 11
            $identity | Should -Be 11

            Close-DbConnection $dbConnection
        }
    }
}
