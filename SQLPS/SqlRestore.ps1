<#
    This is just to illustrate backup and restore in the SqlServer PowerShell package.
    This also works against just LocalDB, although the warnings I see may be due to that.
    SqlServer (note that SQLPS is now deprecated) - Restore databases.
    This is just to show the very basics of Backup-SqlDatabase and Restore-SqlDatabase.
    It will restore any user databases it finds in the given set of database files.
    Only ever run this script as-is on a play server

    Dependencies for executing the SqlServer package:
      Install-PackageProvider -Name NuGet
      Install-Module -Name SqlServer -AllowClobber

    If credentials are required, then add this kind of thing...
    if ($creds -eq $null) {
        $creds = get-credentials
    }
    Then plug $creds into the -credential switch in backup-database and restore-database

#>
# This changes depending on the location of your backups, der...
$backupLocation = "c:/temp/DbBackup434"

# dodgy, naive...
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Import-Module SqlServer
$sqlInstance = "`(Localdb`)\MSSQLLocalDB"

"Location of backup files is [$backupLocation]"

# Principle now is that you don't know or care what name the databases have - that is carried in metadata and the file name...
cd $backupLocation
gci | % {
    $currentDatabase = $_.name
    "Restoring... [$currentDatabase]"
    $backupFile = $backupLocation + "/${currentDatabase}"
    $backupFile
    Restore-SqlDatabase -ServerInstance $sqlInstance -Database $currentDatabase -BackupFile $backupFile
}