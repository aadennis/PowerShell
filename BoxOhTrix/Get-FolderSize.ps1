# Given a root folder, list the sizes in MB, sorted by descending size,
# of each of the child folders, but not *their" children

$rootDir = "C:\"
$fso = New-Object -ComObject Scripting.FileSystemObject
$fx = [ordered] @{}

$folderSet = gci -Path $currDir -Directory
$folderSet | % { 
    $childDir = $_.FullName

    $msg = "[$childDir] {0:N2}" -f (($fso.GetFolder($childDir).Size) / 1MB) + " MB"
    $size = $fso.GetFolder($childDir).Size
    try {
        $fx.Add([long] $size, $msg)
    } catch {
        "stuff went bad"
    }
}

$fso = $null

"root folder: [$rootDir]"
$foldersBySizeDescending = $fx.GetEnumerator() | Sort-Object Key -Descending
$foldersBySizeDescending
"Folders originally counted: [$($foldersBySizeDescending.Count)]"
"Folders in the dictionary: [$($folderSet.Count)]"


if ($foldersBySizeDescending.Count -lt $folderSet.Count) {
    "Fewer items in the hashtable than in the original folder set. Likely size duplicate" 
} 

