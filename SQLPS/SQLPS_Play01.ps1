<#
    SQLPS - Backup databases... and restore them.
    This is just to show the very basics of Backup-SqlDatabase and Restore-SqlDatabase.
    It will backup and restore any user databases it finds for the given instance.
    The purpose of the Sleep 30 is to give you a chance to drop the databases to proved
    that they do get written back.
    Only ever run this script as-is on a play server
#>
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
#Import-Module SQLPS

$sqlInstance = "`(Localdb`)\MSSQLLocalDB"
$randomName = Get-Random(1..1000)
$randomName

gci SQLSERVER:\\
gci SQLSERVER:\SQL\$sqlInstance 
gci SQLSERVER:\SQL\$sqlInstance\Databases
$dbSet = gci SQLSERVER:\SQL\$sqlInstance\Databases
$dbset | % {
    $currentDatabase = $_.name
    "This is [$currentDatabase]"
    $backupFile = "c:/sandbox/$($currentDatabase)_$($randomName).bak"
    $backupFile
    Backup-SqlDatabase -ServerInstance $sqlInstance -Database $currentDatabase -BackupFile $backupFile 
    sleep 3
}

"Sleeping for 30 seconds..."
sleep 30

$dbSet | % {
     $currentDatabase = $_.name
    "This is [$currentDatabase] - restore phase"
    $backupFile = "c:/sandbox/$($currentDatabase)_$($randomName).bak"
    $backupFile
     Restore-SqlDatabase -ServerInstance $sqlInstance -Database $currentDatabase -BackupFile $backupFile
    sleep 3
}





