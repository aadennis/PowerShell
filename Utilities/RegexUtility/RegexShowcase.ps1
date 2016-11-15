#https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex(v=vs.110).aspx

# multiline mode modifier
#https://msdn.microsoft.com/en-us/library/yd1hzczs(v=vs.110).aspx#Multiline
Set-StrictMode -Version latest

Add-Type -AssemblyName "System.Text.RegularExpressions"

function Test-RegexMatch($pattern, $inputToMatch, $message, $expectedResult) {
    $regexPattern = $null
    $regexPattern = New-Object regex($pattern)
    $actualResult = $($regexPattern.IsMatch($inputToMatch)).ToString().ToUpper()

    Write-Host "pattern:[$pattern]input:[$inputToMatch][expected result:$expectedResult ($pattern) $message][actual result:$actualResult]"
    if ($actualResult -ne $expectedResult) {
        throw "*** Last test failed. exiting... ***"
    }
}

$pattern = "cricket"

$input = "cricket"
$expectedResult = "TRUE"
$message = "straight match"
Test-RegexMatch $pattern $input $message $expectedResult


$input = "ricket"
$expectedResult = "FALSE"
$message = "[$pattern] not wholly found in [$input]"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "a cricket"
$expectedResult = "TRUE"
$message = "[$pattern] wholly found in [$input]"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "Cricket"
$expectedResult = "FALSE"
$message = "matches are case sensitive as this .Net, not PowerShell"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "^cricket"

$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket is found at the start of the string"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "a cricket"
$expectedResult = "FALSE"
$message = "[a cricket] is not found at the start of the string"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricket\nbat"
$expectedResult = "TRUE"
$message = "cricket is found at the start of the string (note the backslash escape, not backtick)"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "cricket$"

$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket is found at the end of the string"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "a cricket"
$expectedResult = "TRUE"
$message = "cricket is found at the end of the string"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricket\nbat"
$expectedResult = "FALSE"
$message = "cricket is not found at the end of the string"
Test-RegexMatch $pattern $input $message $expectedResult

return





$candidateMatch = $regexPattern.IsMatch("cricket\nbat")
$candidateMatch #true

$regexPattern = $null
"-----"
# $
$regexPattern = New-Object regex("cricket$")

$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch #true

$candidateMatch = $regexPattern.IsMatch("a cricket")
$candidateMatch #false

$candidateMatch = $regexPattern.IsMatch("cricket\nbat")
$candidateMatch #true
"-----"
#  \s*
$regexPattern = New-Object regex("cricket\s*and\s*somebats")

$candidateMatch = $regexPattern.IsMatch("cricket     and      somebats")
$candidateMatch

$candidateMatch = $regexPattern.IsMatch("a cricket")
$candidateMatch

$candidateMatch = $regexPattern.IsMatch("cricket\nbat")
$candidateMatch 

"-----"
#  [\+-]?
$regexPattern = New-Object regex("[\+-].?")

$candidateMatch = $regexPattern.IsMatch("+")
$candidateMatch

$regexPattern = New-Object regex("[\+-].*")

$candidateMatch = $regexPattern.IsMatch("x")
$candidateMatch



$regexPattern = [regex] '(?m)^cricket$'
$regexPattern

$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch

# note that the input string still escapes using backtick not backslash...
$candidateMatch = $regexPattern.IsMatch("cricket`r`ncricket")
$candidateMatch

"-----"
# For all the records in the input, true if at least 1 line starts with cri, ends with cket, and has 0 or many spaces
$regexPattern = [regex] '(?m)^cri(\s*)cket$'
$regexPattern

# true because there are 0 or many spaaces beween cri and cket...
$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch

#true because rule above obeyed on both lines...
$candidateMatch = $regexPattern.IsMatch("cric     ket`r`ncricket")
$candidateMatch

#true because on line 1, [cricc] has all the characters required by [cric]
$candidateMatch = $regexPattern.IsMatch("cricc     ket`r`ncricket")
$candidateMatch

#true because on line 1, [crick] has all the characters required by [cric]
$candidateMatch = $regexPattern.IsMatch("crick     ket`r`ncricket")
$candidateMatch

#false because neither line 1 nor line 1 match the pattern
$candidateMatch = $regexPattern.IsMatch("crikk     ket`r`ncrikket")
$candidateMatch

#false because [cket] cannot be found...
$candidateMatch = $regexPattern.IsMatch("cric     ket")
$candidateMatch

