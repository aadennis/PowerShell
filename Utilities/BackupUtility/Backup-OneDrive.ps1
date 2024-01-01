$accountId = $null  
# Displaying the options to the user
Write-Host "accountName:"

$accountName = Read-Host "Enter 1 for DWHotmail; Enter 2 for DWOutlook"

if ($accountName -eq "1") {
    $accountId = "DWHotmail"
    Write-Host "Using `$accountId as accountId"
}
elseif ($accountName -eq "2") {
    $accountId = "DWOutlook"
    Write-Host "Using `$accountId as accountId"
}
else {
    Write-Host "Wrong value entered. Please choose 1 or 2."
    exit
}

Write-Host "`$accountId is: [$accountId]"

##########


