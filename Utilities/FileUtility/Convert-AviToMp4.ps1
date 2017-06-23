# Given a folder with a set of avi files, convert each of those files to mp4 format,in the same folder.
# If the target mp4 name already exists, then skip.
# Following the conversion the file creation and amendment times get copied from the source/avi to the target/mp4.
# And finally, the target name (minus extension) is copied to the clipboard so that you can check the details in Explorer/search.
# The rootnames rename the same, only the extension changes.
# https://blogs.technet.microsoft.com/heyscriptingguy/2012/06/01/use-powershell-to-modify-file-access-time-stamps/

$currDir = "G:\VideosCollection\2005JulyToDecember"
$handBrakeDir= "C:\temp\HandBrakeCLI-1.0.7-win-x86_64"
$logFile = "$currDir/Conversion.$(Get-Random).log"

function AviToMp3 ($sourceAvi, $targetMp4) {
    $cmd = "$handBrakeDir\HandBrakeCLI.exe"
    $presetSwitch = "-Z"
    $presetValue = "Fast 1080p30"
    #$presetValue = "HQ 1080p30 Surround"
    $verboseSwitch = "--verbose=1"
    $sourceAvi
    & $cmd $presetSwitch $presetValue -i $sourceAvi -o $targetMp4 $verboseSwitch
}

function Copy-SourceTimeStampToTarget ($sourceAvi, $targetMp4) {
    $srcTime = Get-Item  $sourceAvi
    $targetTime = Get-Item $targetMp4
    $targetTime.LastWriteTime = $srcTime.LastWriteTime
    $targetTime.CreationTime = $srcTime.CreationTime
}

function Count-FileType ($folder, $extension) {
    $set = (gci $folder -Filter "*.$extension") | Measure-Object
    $setCount = $set.Count
    "In folder [$folder], there are [$setCount] files of type [$extension]"
    start-sleep 2
}

function Get-FileNameFromFullPath ($file) {
    Split-Path -Path $file -Leaf
}

function Remove-FileNameFromFullPath ($file) {
    [System.IO.Path]::GetDirectoryName($file)
}

function Get-VideoDuration ($fullPath) {
    $LengthColumn = 27
    $objShell = New-Object -ComObject Shell.Application 
    $objFolder = $objShell.Namespace($(Remove-FileNameFromFullPath $fullPath))
    $objFile = $objFolder.ParseName($(Get-FileNameFromFullPath $fullPath))
    $objFolder.GetDetailsOf($objFile, $LengthColumn)
}

function Convert-File ($source, $target) {
    $source
    $target
    start-sleep 2
    $startTime = Get-Date
    AviToMp3 -sourceAvi $source -targetMp4 $target
    $endTime = Get-Date
    $secondsToConvert = [int] ($endTime - $startTime).TotalSeconds
    Get-Date | Out-File -Append $logFile
    "Completed conversion of [$source] in [$secondsToConvert] seconds" | Out-File -Append $logFile 
    $sourceSizeInMb = [int] ((Get-Item -Path $source).Length/1MB)  
    $targetSizeInMb = [int] ((Get-Item -Path $target).Length/1MB)  
    "sourceSizeInMb: [$sourceSizeInMb]" | Out-File -Append $logFile 
    "targetSizeInMb: [$targetSizeInMb]" | Out-File -Append $logFile 

    $conversionRate = $sourceSizeInMb/$secondsToConvert
    "Conversion rate was [$conversionRate]MB per second" | Out-File -Append $logFile 
    $compressionRatio = $sourceSizeInMb/$targetSizeInMb
    "Compression ratio was $compressionRatio ([$sourceSizeInMb]/[$targetSizeInMb])" | Out-File -Append $logFile 
    $aviDuration =  Get-VideoDuration -fullPath $source
    $mp4Duration =  Get-VideoDuration -fullPath $target
    "Avi duration: [$aviDuration]" | Out-File -Append $logFile 
    "MP4 duration: [$mp4Duration] (these should match)" | Out-File -Append $logFile 


    Get-Date | Out-File -Append $logFile

    $baseName | clip.exe 
    start-sleep 5
}

# Entry point...

cd $currDir
Count-FileType -folder $currDir -extension "avi" | Out-File -Append $logFile 
Count-FileType -folder $currDir -extension "mp4" | Out-File -Append $logFile 

$aviList = gci -Filter *.avi
#$aviList = gci -Filter "2007-12-25 16.13.12 Emma medley quite a few ages.avi"

$aviList | % {
    $currentAvi = $_
    $baseName = $currentAvi.BaseName
    $source = "$currDir/$baseName.avi"
    $target = "$currDir/Mp4/$baseName.mp4"

    if (!( Test-Path $target)) {
        Convert-File $source $target
    }
    Copy-SourceTimeStampToTarget -sourceAvi $source -targetMp4 $target
}

#cmd.exe '$handBrakeDir\HandBrakeCLI.exe -Z "Fast 1080p30" -i "G:\VideosCollection\Videos\2002-03-03 15.12.42 emma4.avi" -o "C:\MpegUtil\first2.mp4" --verbose=1'
