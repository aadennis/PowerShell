<#
    This is just to illustrate backup in the SqlServer PowerShell package.
    This also works against just LocalDB, although the warnings I see may be due to that.
    SqlServer (note that SQLPS is now deprecated) - Backup databases (a sibling script restores).
    This is just to show the very basics of Backup-SqlDatabase.
    It will backup any user databases it finds for the given instance, saving the files to a naive (in that it may not
    be unique) temporary location.
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
# dodgy, naive...
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Import-Module SqlServer

$sqlInstance = "`(Localdb`)\MSSQLLocalDB"
# naive...
$tempDirName = "c:/temp/DbBackup" + $(Get-Random(1..1000))

"Temporary location of backup files is [$tempDirName]"
New-Item -Path $tempDirName -ItemType Directory

# This gets all user databases...
$dbSet = gci SQLSERVER:\SQL\$sqlInstance\Databases
$dbset | % {
    $currentDatabase = $_.name
    "Backing up... [$currentDatabase]"
    $backupFile = $tempDirName + "/${currentDatabase}"
    $backupFile
    Backup-SqlDatabase -ServerInstance $sqlInstance -Database $currentDatabase -BackupFile $backupFile 
}

