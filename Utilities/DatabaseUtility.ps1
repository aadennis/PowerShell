Set-StrictMode -Version latest
function Open-DbConnection($sqlConnectionString) {
    [System.Data.SqlClient.SqlConnection] $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = $sqlConnectionString
    $conn.Open()
    $conn
}

function Close-DbConnection($conn) {
    $conn.Close()
    $conn = $null
    start-sleep 1
    $conn
}
