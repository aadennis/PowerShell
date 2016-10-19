#https://github.com/pester/Pester/wiki/Invoke-Pester
# Execute this from the folder [Tests]

try {
. ..\DateFormatUtility\DateFormatUtility.ps1
. ..\LogUtility\LogUtility.ps1
. ..\FileUtility\FileUtility.ps1
} catch {
    "Error count[$($Error.Count)]"
    throw
}
# Execute all the tests
$result = Invoke-Pester -PassThru -Strict

# Did any tests fail? If so, in a more rigorous scenario, the throw would be replaced
# with some way to tell the build to fail
$totalCount = $result.TotalCount
$passedCount = $result.PassedCount
$failedCount = $result.FailedCount
$msg = "Total tests:[$totalCount]; Passed:[$passedCount]; Failed:[$failedCount]"
if ($failedCount -gt 0) {
    Write-Host $msg -f red -b White
    Throw
}
Write-Host $msg -f Green -b Blue
 





