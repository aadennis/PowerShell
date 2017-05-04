<#
    SQLPS - Given a previously created backup set with a known file name pattern... restore them.
    This is just to show the very basics of Restore-SqlDatabase.
    It will restore the user databases named in the $dbSet below, back to the given instance $sqlInstance.
    Only ever run this script as-is on a play server
#>
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#Import-Module SQLPS

$sqlInstance = "`(Localdb`)\MSSQLLocalDB"
$randomName = Get-Random(1..1000)
$randomName = "322"

gci SQLSERVER:\\
gci SQLSERVER:\SQL\$sqlInstance 
gci SQLSERVER:\SQL\$sqlInstance\Databases
$dbSet = gci SQLSERVER:\SQL\$sqlInstance\Databases
$dbSet = "MyDb01", "MyDb02"

$dbSet | % {
     $currentDatabase = $_.name
     $currentDatabase = $_
    "This is [$currentDatabase] - restore phase"
    $backupFile = "c:/sandbox/$($currentDatabase)_$($randomName).bak"
    $backupFile
     Restore-SqlDatabase -ServerInstance $sqlInstance -Database $currentDatabase -BackupFile $backupFile
    sleep 3
}





