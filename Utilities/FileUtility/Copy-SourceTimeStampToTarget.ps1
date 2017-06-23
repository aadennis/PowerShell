$currDir = "G:\VideosCollection\Videos"
#https://blogs.technet.microsoft.com/heyscriptingguy/2012/06/01/use-powershell-to-modify-file-access-time-stamps/

function Copy-SourceTimeStampToTarget ($sourceAvi, $targetMp4) {
    $srcTime = Get-Item  $sourceAvi
    $targetTime = Get-Item $targetMp4
    $targetTime.LastWriteTime = $srcTime.LastWriteTime
    $targetTime.CreationTime = $srcTime.CreationTime
}

cd $currDir
$aviList = gci -Filter *.avi
$aviList | % {
    $currentAvi = $_
    $baseName = $currentAvi.BaseName
    $source = "$currDir/$baseName.avi"
    $target = "$currDir/$baseName.mp4"
    $source
    $target
    Copy-SourceTimeStampToTarget -sourceAvi $source -targetMp4 $target
    #$currentAvi

}

