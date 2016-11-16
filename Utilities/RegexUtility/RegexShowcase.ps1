﻿#https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex(v=vs.110).aspx

# multiline mode modifier
#https://msdn.microsoft.com/en-us/library/yd1hzczs(v=vs.110).aspx#Multiline

$Global:testId = 0
Set-StrictMode -Version latest

Add-Type -AssemblyName "System.Text.RegularExpressions"

function Test-RegexMatch($pattern, $inputToMatch, $message, $expectedResult) {
    $Global:testId++

    $regexPattern = $null
    $regexPattern = New-Object regex($pattern)
   
    $actualTextResult = $regexPattern.Match($inputToMatch)

    $actualBooleanResult = $($regexPattern.IsMatch($inputToMatch)).ToString().ToUpper()

    Write-Host "Test [$Global:testId] pattern:[$pattern]input:[$inputToMatch][expected result:$expectedResult ($pattern) $message][actual result:$actualBooleanResult]"
    if ($actualBooleanResult -ne $expectedResult) {
        throw "*** Last test failed. exiting... ***"
    }
    if ($actualBooleanResult -eq "TRUE") {
        Write-Host "[$actualTextResult][$($actualTextResult.Index)][$($actualTextResult.Length)]"
    }

    write-host "*******************************************" -ForegroundColor Yellow 


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

$pattern = "cricket\sbat"
$input = "cricket bat"
$expectedResult = "TRUE"
$message = "$input contains 1 and only 1 space"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricket  bat"
$expectedResult = "FALSE"
$message = "$input contains 2 spaces"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketbat"
$expectedResult = "FALSE"
$message = "$input contains 0 spaces"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "cricket\s*and\s*somebats"

$input = "cricket     and      somebats"
$expectedResult = "TRUE"
$message = "$input contains multiple spaces - OK"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "a cricket"
$expectedResult = "FALSE"
$message = "{$input} plain does not match {$pattern}"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricket\nbat"
$expectedResult = "FALSE"
$message = "{$input} plain does not match {$pattern}"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "(cricket)*"

$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket occurs 0 or more times"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketcricket"
$expectedResult = "TRUE"
$message = "cricket occurs 0 or more times"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "batbat"
$expectedResult = "TRUE"
$message = "cricket occurs 0 or more times - but in real terms clearly nonsense"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "(cricket){1,2}"
$input = "batbat"
$expectedResult = "FALSE"
$message = "cricket must occur 1 or 2 times in the input, and does not"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket must occur 1 or 2 times in the input, and does (1)"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketcricket"
$expectedResult = "TRUE"
$message = "cricket must occur 1 or 2 times in the input, and does (2)"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "(cricket){3}"
$input = "cricket"
$expectedResult = "FALSE"
$message = "cricket must occur 3 and only 3 times in the input, and does not"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketcricketcricket"
$expectedResult = "TRUE"
$message = "cricket must occur 3 and only 3 times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "(cricket)?"
$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket must occur 0 to many times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "batbat"
$expectedResult = "TRUE"
$message = "cricket must occur 0 to many times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketcricketcricketcricketcricket"
$expectedResult = "TRUE"
$message = "cricket must occur 0 to many times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "batbat"
$expectedResult = "TRUE"
$message = "cricket must occur 0 or 1 times in the input, and does (0) - sic"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "(cricket)+"
$input = "cricket"
$expectedResult = "TRUE"
$message = "cricket must occur 1 or many times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "batbat"
$expectedResult = "FALSE"
$message = "cricket must occur 1 or many times in the input, and does not"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "cricketcricketcricketcricketcricket"
$expectedResult = "TRUE"
$message = "cricket must occur 1 or many times in the input, and does"
Test-RegexMatch $pattern $input $message $expectedResult


#Match zero or one occurrence of either the positive sign or the negative sign.
$pattern = "[\+-]?"

$input = "+"
$expectedResult = "TRUE"
$message = "match found at position zero"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "++"
$expectedResult = "TRUE"
$message = "match found at position zero"
Test-RegexMatch $pattern $input $message $expectedResult


$input = "-"
$expectedResult = "TRUE"
$message = "match found at position zero"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "x--"
$expectedResult = "TRUE"
$message = "no match found, so matches on zero matches"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-x-"
$expectedResult = "TRUE"
$message = "no match found, so matches on zero matches"
Test-RegexMatch $pattern $input $message $expectedResult

#Match zero or one occurrence of the dollar sign.

$pattern = "`\`$`?"

$input = ""
$expectedResult = "TRUE"
$message = "no match found, so matches on zero matches"
Test-RegexMatch $pattern $input $message $expectedResult


$input = "`$29"
$expectedResult = "TRUE"
$message = "dollar found - match"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "`$`$29"
$expectedResult = "TRUE"
$message = "dollar found at position 0 - match"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "^[\+-]+`\`$"

$input = "`$29"
$expectedResult = "FALSE"
$message = "+ symbol should have been before `$ - no match"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29"
$expectedResult = "TRUE"
$message = "- symbol was before `$ - match"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "^[\+-]+`\`$\d{2}?"

$input = "`$29"
$expectedResult = "FALSE"
$message = "+ symbol should have been before `$ - no match"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29"
$expectedResult = "TRUE"
$message = "- symbol was before `$ - match"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$"
$expectedResult = "FALSE"
$message = "input contained no digits - no match"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$483"
$expectedResult = "TRUE"
$message = "pattern asked for match on 2 decimal zero or one times. OK"
Test-RegexMatch $pattern $input $message $expectedResult

$pattern = "^[\+-]+`\`$\d*\.?"


$input = "-`$29."
$expectedResult = "TRUE"
$message = "a found at least one dot after the digits"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29.."
$expectedResult = "TRUE"
$message = "b found at least one dot after the digits"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29.44"
$expectedResult = "TRUE"
$message = "c found at least one dot after the digits and don't care after that"
Test-RegexMatch $pattern $input $message $expectedResult
#---

$pattern = "^[\+-]+`\`$\d*\.?\d{2}?"



$input = "-`$29."
$expectedResult = "TRUE"
$message = "digits after the dot are optional - found none - OK"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29.."
$expectedResult = "TRUE"
$message = "digits after the dot are optional - found none - OK"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29.44"
$expectedResult = "TRUE"
$message = "digits after the dot are optional - found some - OK"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$29.444"
$expectedResult = "TRUE"
$message = "digits after the dot are optional - found the max 2 and ignored the rest - OK"
Test-RegexMatch $pattern $input $message $expectedResult

$input = "-`$483"
$expectedResult = "TRUE"
$message = "Both the dot and the digits after the dot are optional. OK"
Test-RegexMatch $pattern $input $message $expectedResult

return




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

