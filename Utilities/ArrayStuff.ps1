Clear-Host
$x = [System.Collections.ArrayList]@()
$x.Add("Row number 1")
$x.Add("Row number 2")
$x.Add("Row number 3")
$x.Add("Row number 4")
$x.Add("Row number 5")
$x.Add("Row number 6")
"Count of x:"
$x.Count

$y = [array] $x
[array]::Reverse([array]$y)
"x cast to y as array and reversed:"
$y

"x reverse using cast to array silently fails:"
[array]::Reverse([array]$x)
$x