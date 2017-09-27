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
    $conn
}

function Execute-SQL($conn, $sql) {
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.connection = $conn
    $cmd.commandText = $sql
    $cmd.ExecuteNonQuery()
}

function Read-SQL($conn, $sql) {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $result = $cmd.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($result)
    $table
}

function Format-SQL($dataSet) {
    $dataSet | % {
        $currentRow = $_
        write-host "Content of current row:" + $currentRow[0] + "/" + $currentRow[1]
    }
}