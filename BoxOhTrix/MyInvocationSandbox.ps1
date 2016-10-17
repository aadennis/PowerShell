pwd
$location2 = "c:\book"
$cwd = pwd
Write-Host "I start the script in [$cwd]" -ForegroundColor Green
Write-Host "I now save my location using Push-Location"
Push-Location

Write-Host "I now record the point of invocation"
$startPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "And [$startPath] is it" -ForegroundColor Green

pwd

cd $location2
Write-Host "My location is now [$location2]"

$startPath2 = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "And [$startPath2] is it"
pwd
Pop-Location
pwd

