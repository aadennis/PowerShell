# Given a directory ($dir), rename all files that contain the string $old,
# to replace that with a $new string.
# For example: e:\epscan\001\epson001.jpg -> e:\epscan\001\discover01_001.jpg,
# based on the example below
#------------------------------------
$dir = "E:\EPSCAN\001"
$old = "epson"
$new = "discover01_"
#$fileName = "epson001.jpg"
#$newName = $fileName -replace $old, $new

$fileSet = Get-ChildItem $dir
$fileSet
$fileSet | ForEach-Object {
    $currentFile = $_
    $currentFile
    $newName = $currentFile -replace $old, $new
    $newName
    Move-Item "$dir\$currentFile" "$dir\$newName"
}

$dir



