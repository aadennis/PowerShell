"Declare and populate a hash table"
$simpleList = @{}
$simpleList.Add(101, "Orville")
$simpleList.Add(-2, "Zebedee")
$simpleList.Add(3, "Aardvark")

"By default, it is sorted by value (and not by sequence of insert, nor key):"

$simpleList

"Sort it explicitly by key:"

$simpleList.GetEnumerator() | Sort-Object Key

"Sort it explicitly by value:"

$simpleList.GetEnumerator() | Sort-Object Value

"Do it again, this time with the ordered keyword:"

$simpleList = [ordered] @{}
"Note that the impact of [ordered] is to preserve the order of the *insert*, not the sorted order:"
$simpleList.Add(101, "Orville")
$simpleList.Add(-2, "Zebedee")
$simpleList.Add(3, "Aardvark")


$simpleList

"Sort it explicitly by key:"

$simpleList.GetEnumerator() | Sort-Object Key

"Sort it explicitly by value:"

$simpleList.GetEnumerator() | Sort-Object Value

"Finally, use strings not integers for the key values"

$simpleList = [ordered] @{}
"Note that the impact of [ordered] is to preserve the order of the *insert*, not the sorted order:"
$simpleList.Add("OneOhone", "Orville")
$simpleList.Add("MinusTwo", "Zebedee")
$simpleList.Add("Three", "Aardvark")


$simpleList

"Sort it explicitly by key:"
$simpleList.GetEnumerator() | Sort-Object Key

"Sort it explicitly by value:"
$simpleList.GetEnumerator() | Sort-Object Value
