Set-StrictMode -Version latest

# Have to make this global for now... as passing the connection around seems to close it
[System.Data.SqlClient.SqlConnection] $conn = New-Object System.Data.SqlClient.SqlConnection

# don't want to hang around waiting for 30 seconds...
$defaultDatabaseConnection = "Server=(localdb)\MSSQLLocalDB;Initial Catalog=tempdb;User Id = sa; Password=asfa;Connection Timeout=3;"

#https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlconnection.connectiontimeout(v=vs.110).aspx
function Open-DbConnection($sqlConnectionString = $defaultDatabaseConnection) {
    $conn.ConnectionString = $sqlConnectionString
    $conn.Open()
}