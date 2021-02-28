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

function Break-ForSeconds($numberOfSeconds = 1) {
    "<break time=`"$numberOfSeconds`s`"/>"
}
function Build-PollyString($pauseInSeconds = 5, $stringIterations = 6, $noteIterations = 15) {
    $breakTime = "<break time=`"$pauseInSeconds`s`"/>"
    $set = "a", "b", "c", "d", "e", "f", "g"
    $content = "Practice for guitar fretboard memorization. $pauseInSeconds seconds pause between notes. Natural notes only. "
    
    1..$stringIterations | ForEach-Object {
        $currentSet = $_
        $perStringInstructions = "Set $currentSet of $stringIterations $(Break-ForSeconds) Choose a string $(Break-ForSeconds) `
                  $(Break-ForSeconds) Ready. $(Break-ForSeconds '2')  "

        $content += $perStringInstructions
        $priorNote = $null
        $priorPriorNote = $null

        1..$noteIterations | ForEach-Object { # pick a random note
            $duplicateTries = 0
            do {
                $set | Get-Random | ForEach-Object {
                    $currentNote = $_
                    if (($priorNote -ne $currentNote) -and $priorPriorNote -ne $currentNote) {
                        # ok - not a duplicate of previous or the one before that
                        $content += Get-ContentWithPause $currentNote $pauseInSeconds;
                        $priorPriorNote = $priorNote
                        $priorNote = $currentNote
                        $duplicateTries = 999
                    }
                    else {
                        $duplicateTries++
                    }
                }
            } while ($duplicateTries -lt $Global:maxDuplicateTries) }
    }

    $content += Break-ForSeconds 2
    $content += "The End"

    $content = "<speak>" + $content + "</speak>"
    $content | clip
    $fileNameRoot = Join-Path "SpeechFilesInSsmlFormat/NonIpa" "$pauseInSeconds`SecPause.$stringIterations`Strings.$noteIterations`Notes.xml"
    $fileNameRoot
    $content > $fileNameRoot
}

# Entry point
# Next example is 10 seconds between notes, 3 string sets, 20 notes per string set...
Build-PollyString 10 3 20
Build-PollyString 3 3 20
Build-PollyString 1 3 20



