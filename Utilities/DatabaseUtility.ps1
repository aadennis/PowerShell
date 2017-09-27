Set-StrictMode -Version latest
function Open-DbConnection($sqlConnectionString = $defaultDatabaseConnection) {
    [System.Data.SqlClient.SqlConnection] $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = $sqlConnectionString
    $conn.Open()
    $conn
}