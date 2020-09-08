
function Test-RegexReplace($inputToReplace, $oldToken, $newToken, $expectedResult) {
    $Global:testId++

    $actualResult = [Regex]::Replace($inputToReplace, $oldToken, $newToken)

    Write-Host "Test [$Global:testId] inputToReplace:[$inputToReplace] oldToken:[$oldToken] newToken:[$newToken]"
    if ($expectedResult -ne $actualResult) {
    
        Write-Host "[expected result:$expectedResult][actual result:$actualResult]"
        throw "*** Last test failed. exiting... ***"
    }
    Write-Host "[expected and actual result:$expectedResult]"
   

}


function Test-RegexMatch($pattern, $inputToMatch, $message, $expectedResult) {
    write-host "*******************************************" -ForegroundColor Yellow 
    $Global:testId++

    $regexPattern = $null
    $regexPattern = New-Object regex($pattern)
   
    $actualTextResult = $regexPattern.Match($inputToMatch)

    $actualBooleanResult = $($regexPattern.IsMatch($inputToMatch)).ToString().ToUpper()

    Write-Host "Test Id: [$Global:testId]; pattern:[$pattern]; input:[$inputToMatch]" 
    Write-Host "[expected result:$expectedResult ($pattern) $message]"
    Write-Host "[actual result:$actualBooleanResult]"
    if ($actualBooleanResult -ne $expectedResult) {
        throw "*** Last test failed. exiting... ***"
    }
    if ($actualBooleanResult -eq "TRUE") {
        Write-Host "[$actualTextResult][$($actualTextResult.Index)][$($actualTextResult.Length)]"
    }



}
