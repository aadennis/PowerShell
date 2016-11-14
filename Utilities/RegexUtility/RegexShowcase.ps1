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

# cannot get this working - New-Object : Exception calling ".ctor" with "1" argument(s): "parsing "m)^cricket" - Too many )'s.

$subPattern = "m`)"
$regexPattern = New-Object regex($subPattern + "^cricket")
$regexPattern

$candidateMatch = $regexPattern.IsMatch("cricket")
$candidateMatch

$candidateMatch = $regexPattern.IsMatch("football`r`ncricket")
$candidateMatch