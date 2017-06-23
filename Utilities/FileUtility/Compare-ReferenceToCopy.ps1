# Compare a reference folder and children, with a copy of that reference
$refPath = "G:\VideosCollection\TheRest\MP4"
$copyPath = "e:\set3"

$refSet = Get-ChildItem -Recurse -path $refPath
$copySet = Get-ChildItem -Recurse -path $copyPath

Compare-Object -ReferenceObject $refSet -DifferenceObject $copySet

