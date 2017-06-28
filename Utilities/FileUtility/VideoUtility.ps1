# Given a set of AVI files, compare their duration a set of mp3 files of the same root name.
# Expectation is that they have identical durations.

$currDir = "G:\VideosCollection\TheRest"

function Get-FileNameFromFullPath ($file) {
    Split-Path -Path $file -Leaf
}

function Remove-FileNameFromFullPath ($file) {
    [System.IO.Path]::GetDirectoryName($file)
}

function Get-VideoDuration2 ($fullPath2) {
    $LengthColumn = 27 #magic value
    $objShell2 = New-Object -ComObject Shell.Application 
    $pathMinusLeaf = Remove-FileNameFromFullPath $fullPath2
    $leafWithoutPath = Get-FileNameFromFullPath $fullPath2
    $objFolder2 = $objShell2.Namespace($pathMinusLeaf)
    $objFile2 = $objFolder2.ParseName($leafWithoutPath)
    $length2 = $objFolder2.GetDetailsOf($objFile2, $LengthColumn)
    $length2
}

#Entry point...

$aviList = Get-ChildItem -Filter *.avi

$aviList | ForEach-Object {
    $currentAvi = $_
    $baseName = $currentAvi.BaseName
    $source = "$currDir/$baseName.avi"
    $target = "$currDir/$baseName.mp4"

    $aviDuration =  Get-VideoDuration2 -fullPath $source
    $mp4Duration =  Get-VideoDuration2 -fullPath $target

    "Current file root:[$baseName]"
    "[$aviDuration],[$mp4Duration]"
    if ($mp4Duration -ne $aviDuration) {
        "Expected [$aviDuration], got [$mp4Duration]"
    }

}

