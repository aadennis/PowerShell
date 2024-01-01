# Backup 1 of the 2 OneDrive accounts to the attached disk.
# The script uses Robocopy.

$accountId = $null  
# Displaying the options to the user
Write-Host "accountName:"

$accountName = Read-Host "Enter 1 for DWHotmail; Enter 2 for DWOutlook"

if ($accountName -eq "1") {
    $accountId = "DWHotmail"
}
elseif ($accountName -eq "2") {
    $accountId = "DWOutlook"
}
else {
    Write-Host "[$accountName] is not valid. Please choose 1 or 2."
    exit
}



##########

$srcFolder = $null  
# Displaying the options to the user
Write-Host "srcChoice:"

$srcChoice = Read-Host "Enter 1 for D:\onedrive; Enter 2 for D:\OutlookAcOneDrive"

if ($srcChoice -eq "1") {
    $srcFolder = "D:\onedrive"
    Write-Host "Using $srcFolder as `$srcFolder"
}
elseif ($srcChoice -eq "2") {
    $srcFolder = "D:\OutlookAcOneDrive"
    Write-Host "Using $srcFolder as `$srcFolder"
}
else {
    Write-Host "[$srcChoice] is not valid. Please choose 1 or 2."
    exit
}

Write-Host "`$accountId is: [$accountId]"
Write-Host "`$srcFolder is: [$srcFolder]"

##########




