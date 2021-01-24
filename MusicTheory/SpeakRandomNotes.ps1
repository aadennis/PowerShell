# This is only for use in Amazon Polly, so this saves to a text file,
# but does not render to speech.
# You have to paste the clipboard content into the Amazon Polly console, e.g.
# https://eu-west-2.console.aws.amazon.com/polly/home/SynthesizeSpeech
Set-StrictMode -Version latest

. ./Configuration.ps1

# Music theory on the guitar - fretboard familiarisation

Set-Globals

function Get-ContentWithPause($currentFret, $pauseInSeconds) {
    if ($pauseInSeconds) {
        return "<p>$currentFret<break time=`"$pauseInSeconds`s`"/></p>"
    }
    "<p>$currentFret</p>"
}

function Build-PollyString($pauseInSeconds = 5, $stringIterations = 6, $noteIterations = 15) {
    $breakTime = "<break time=`"$pauseInSeconds`s`"/>"
    $set = "a", "b", "c", "d", "e", "f", "g"
    # $content = "Practice for guitar fretboard memorization. Naturals only. "
    $content += "Practice for guitar keyboard memory, with a $pauseInSeconds seconds pause between notes.<break time=`"2s`"/>"
    $content += "We'll do $stringIterations string sets. <break time=`"1s`"/>"
    $content += "And for each string set, we'll practice $noteIterations random notes. <break time=`"2s`"/>"
    
    
    1..$stringIterations | ForEach-Object {
        $perStringInstructions = "Choose a string.<break time=`"3s`" />. Ready. "

        $content += $perStringInstructions
        $previousNote = $null
        1..$noteIterations | ForEach-Object { # pick a random note
            $duplicateTries = 0
            do {
           
                $set | Get-Random | ForEach-Object {
                    $currentNote = $_
                    if ($previousNote -ne $currentNote) {
                        # ok - not a duplicate of previous
                        $content += Get-ContentWithPause $currentNote $pauseInSeconds;
                        $previousNote = $currentNote
                        $duplicateTries = 999
                    }
                    else {
                        $duplicateTries++
                    }
                }
            } while ($duplicateTries -lt $Global:maxDuplicateTries) }
    }

    $content = "<speak>" + $content + "</speak>"
    $content | clip
    $uidPart = ([timespan] (Get-Date).ToLongTimeString()).TotalSeconds
    $fileNameRoot = Join-Path SpeechFilesInSsmlFormat "$uidPart.$pauseInSeconds`SecPause.$stringIterations`Strings.$noteIterations`Notes.xml"
    $fileNameRoot
    $content > $fileNameRoot
}

# Entry point
# Next example is 10 seconds between notes, 2 string sets, 20 notes per string set...
Build-PollyString 10 3 20
Build-PollyString 3 3 20
Build-PollyString 1 3 20



