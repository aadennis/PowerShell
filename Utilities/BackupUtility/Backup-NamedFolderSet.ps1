# Build a name for a backup directory and a dated subfolder
function Get-BackupDirName(
    $backupRootDir = "\temp" ,
    $dirPrefix = "BU"
) {
    [string] $today = ([datetime]::Today).ToString("yyyyMMdd")
    "$backupRootDir\$dirPrefix$today"
    
}

function Get-MaxAge(
    $daysInPastToBackUp = 30
){
    return ([datetime]::Today).AddDays(-$daysInPastToBackUp).ToString("yyyyMMdd") 
}

# Backup up a set of folders to a backup destination, optionally giving
# a) the root backup folder, b) the prefix for the backup folder beneath that (which has the current
# date appended), c) and the number of days in the past to save
function Backup-NamedFolderSet (
    $srcFolderSet,
    $rootBackupFolder = "c:\backup",
    $backupFolderPrefix = "bu",
    $daysBackToSave = 30
) {
    $dirName = Get-BackupDirName $rootBackupFolder $backupFolderPrefix
    $maxAge = Get-MaxAge $daysBackToSave
    Write-Host "Files modified up to [$daysBackToSave] days old will be backed up to [$dirName]" -BackgroundColor Magenta
    Write-Host "Source Folders:" -BackgroundColor Magenta

    $srcFolderSet | % {
        $currDir = $_
        write-host "processing folder [$currDir]" -BackgroundColor Magenta
        robocopy $currDir $dirName *.* /MaxAge:$maxAge /XO /S /NFL /NDL
    }
    Write-Host "Finishing backing up to $dirName" -BackgroundColor Magenta
}

#entry point
$srcFolderSet = "C:\database","c:\SQLServer2016Media"
Backup-NamedFolderSet $srcFolderSet "c:\bu" "bux" 100




