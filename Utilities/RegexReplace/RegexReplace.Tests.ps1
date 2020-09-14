$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "RegexMatch" {
    It "returns true if the pattern and the input are identical" {
        $pattern = $testInput = "cricket"

        $expectedResult = "TRUE"
        $message = "straight match"
        Test-RegexMatch $pattern $testInput $message $expectedResult
        
    }

    It "returns false if the pattern is not wholly found in the input" {
        $pattern = "cricket" 
        $testInput = "ricket"

        $expectedResult = "FALSE"
        $message = "[$pattern] not wholly found in [$testInput]"
        Test-RegexMatch $pattern $testInput $message $expectedResult
    }

    It "returns true if the pattern is wholly found in the input" {
        $pattern = "cricket"
        $testInput = "a cricket"

        $expectedResult = "TRUE"
        $message = "[$pattern] wholly found in [$testInput]"
        Test-RegexMatch $pattern $testInput $message $expectedResult
        
    }

    It "returns false if the pattern is identical to the input apart from case (.Net, not PowerShell)" {
        $pattern = "cricket"
        $testInput = "Cricket"

        $expectedResult = "FALSE"
        $message = "matches are case sensitive as this .Net, not PowerShell"
        Test-RegexMatch $pattern $testInput $message $expectedResult
    }

    It "returns true if [c]ricket is found at the start of the string" {
        $pattern = "^cricket"
        $testInput = "cricket" 

        $expectedResult = "TRUE"
        $message = "Expects and finds lc 'c' at start of string"
        Test-RegexMatch $pattern $testInput $message $expectedResult
    }

    It "returns false if [C]ricket is found at the start of the string" {
        $pattern = "^cricket"
        $testInput = "Cricket" 

        $expectedResult = "FALSE"
        $message = "Expects lc 'c' at start of string, but was 'C'"
        Test-RegexMatch $pattern $testInput $message $expectedResult
    }

    It "returns false because cricket is not found at the start of the string" {
        $pattern = "^cricket"
        $testInput = "a cricket" 

        $expectedResult = "FALSE"
        $message = "Expects 'cricket' at start of string, but was '[a ]cricket"
        Test-RegexMatch $pattern $testInput $message $expectedResult
    }

}
