# snippet to illustrate problems with ArrayList and pipelines

function bar() {

    $collectionA = [System.Collections.ArrayList] @()
    $collectionA.Add("row 1")
    $collectionA.Add("row 2")
    $collectionA.Add("row 3")
    $collectionA.Add("row 4")

    $collectionB = [System.Collections.ArrayList] @()

    <#
    $currIndex = 0
     $collectionA | % {
        $curr = $_
        $currIndex++
        if (($currIndex % 2) -eq 0) {
            $collectionB.Add($curr)
        }
    }
    #>

    $collectionB
}

[System.Collections.ArrayList] $foo = bar
# With the code as-is, you might expect bar() to return an empty collection (collectionB).
# No: it returns placeholders for collectionA, and anything it has for collectionB
$foo






