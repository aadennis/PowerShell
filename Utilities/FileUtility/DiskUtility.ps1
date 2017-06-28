# Try to copy all named files starting with the biggest to e.g. a DVD
# Once less than $minAllowedSpace, exit, in the hope that a bit of contingency on the DVD
# makes it easier to read and write files... which are a pain on a DVD writer.
#Remove-Item -Path E:\Set1 -Recurse -Force

# Edit below here
$srcDir = "G:\VideosCollection\TheRest\MP4Temp"
$targetDir = "E:\MissedFromLargeFiles"
$minAllowedSpace = 50mB
# Edit above here

$set = Get-ChildItem -Path $srcDir -Filter *.mp4 | Sort-Object -Property Length -Descending
$counter = 1
$set | ForEach-Object {
    $disk = Get-WmiObject Win32_LogicalDisk -ComputerName localhost -Filter "DeviceID='E:'" | Select-Object Size,FreeSpace
    $diskFreeSpace = $disk.FreeSpace
    if ($diskFreeSpace -lt $minAllowedSpace) {
        $diskFreeSpaceAsMb = [decimal]::round($diskFreeSpace/1MB)
        "diskFreeSpace is now [$diskFreeSpaceAsMb]Mb. Exiting..."
        exit
    }
    $file = $_
    $baseName = $file.BaseName
    $source = "$srcDir/$baseName.mp4"
    $target = "$targetDir/$baseName.mp4"
    "Processing [$counter][$source]"
    Copy-Item -Path $source -Destination $target -ErrorAction Continue
    Start-Sleep 2
    $counter++
}

