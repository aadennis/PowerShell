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

function Insert-SQLWithScope($conn, $sql) {
    $sql += "; select cast(scope_identity() as bigint)"
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.connection = $conn
    $cmd.commandText = $sql
    $identity = $cmd.ExecuteScalar()
    $identity
}

function Read-SQL($conn, $sql) {
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = $sql
    $result = $cmd.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($result)
    $table
}

function Format-SQL($dataSet, $columnCount = 2, $delimiter = "^") {
    $result = @()
    $dataSet | ForEach-Object {
        $currentRow = $_
        switch ($columnCount) {
            1 {
                $result += "{0}" -f $currentRow[0]
            }
            2 {
                $result += "{0}{1}{2}" -f $currentRow[0], $delimiter, $currentRow[1]
            }
            3 {
                $result += "{0}{1}{2}{3}{4}" -f $currentRow[0], $delimiter, $currentRow[1], $delimiter, $currentRow[2]
            }
        }
    }
    $result
}