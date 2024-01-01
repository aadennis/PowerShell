# Backup 1 of the 2 OneDrive accounts to the attached disk.
# The script uses Robocopy.

$accountId = $null  
Write-Host "accountName:"

$choice = Read-Host "Enter 1 for DWHotmail; Enter 2 for DWOutlook"

if ($choice -eq "1") {
    $accountId = "DWHotmail"
}
elseif ($choice -eq "2") {
    $accountId = "DWOutlook"
}
else {
    Write-Host "[$choice] is not valid. Please choose 1 or 2."
    exit
}

$srcFolder = $null  
Write-Host "source folder:"

$choice = Read-Host "Enter 1 for D:\onedrive; Enter 2 for D:\OutlookAcOneDrive"

if ($choice -eq "1") {
    $srcFolder = "D:\onedrive"
    Write-Host "Using $srcFolder as `$srcFolder"
}
elseif ($choice -eq "2") {
    $srcFolder = "D:\OutlookAcOneDrive"
    Write-Host "Using $srcFolder as `$srcFolder"
}
else {
    Write-Host "[$choice] is not valid. Please choose 1 or 2."
    exit
}

Write-Host "`$accountId is: [$accountId]"
Write-Host "`$srcFolder is: [$srcFolder]"


