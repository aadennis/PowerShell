$w = New-Object -TypeName PSCustomObject -Property @{numcol = [int] 13; stringCol = “the original”}
$w | Get-Member
$w
$x = New-Object -TypeName System.Management.Automation.PSCustomObject -Property @{numcol = [int] 22; stringCol = “something”}
$x | Get-Member
$x
$y = New-Object -TypeName PSObject -Property @{numcol = [int] 42; stringCol = “something additional”}
$y | Get-Member
$y.GetType().ToString()

$z = @()

$z += $w
$z += $x
$z += $y
$z[0]

$z.GetType().ToString()

$z[1] | Get-Member

$z | % { $_.stringCol }

$sum = 0
$concattedString = “”

$z | % { $sum += $_.numCol; $concattedString += “[$($_.stringCol)]” }

$sum
$concattedString