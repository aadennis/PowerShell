Add-Type -AssemblyName "System.Text.RegularExpressions"
$regexPattern = New-Object regex("cricket")
#$regex | gm

#https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex(v=vs.110).aspx

$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch #true

$candidateMatch = $regexPattern.IsMatch("ricket")
$candidateMatch #false


$candidateMatch = $regexPattern.IsMatch("a cricket")
$candidateMatch #true

$candidateMatch = $regexPattern.IsMatch("Cricket")
$candidateMatch #false

$regexPattern = $null
"-----"
# ^
$regexPattern = New-Object regex("^cricket")

$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch #true

$candidateMatch = $regexPattern.IsMatch("a cricket")
$candidateMatch #false

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

#https://msdn.microsoft.com/en-us/library/system.text.regularexpressions.regex(v=vs.110).aspx

# multiline mode modifier
#https://msdn.microsoft.com/en-us/library/yd1hzczs(v=vs.110).aspx#Multiline

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