# This generates SSML content.
# It does not include the subsequent rendering to voice. Rendering is Done
# a Amazon Polly, or a Google TTS script, also available in this repo.
# For Polly,. you have to paste the clipboard content into the Amazon Polly console, e.g.
# https://eu-west-2.console.aws.amazon.com/polly/home/SynthesizeSpeech
Set-StrictMode -Version latest

. ./Configuration.ps1
Set-Globals

function Get-ContentWithPause($currentFret, $pauseInSeconds) {
    if ($pauseInSeconds) {
        return "<p>$currentFret<break time=`'$pauseInSeconds`s`'/></p>"
    }
    "<p>$currentFret</p>"
}

function Break-ForSeconds($numberOfSeconds = 1) {
    "<break time=`'$numberOfSeconds`s`'/>"
}
function Build-PollyString($pauseInSeconds = 5, $stringIterations = 6, $noteIterations = 15) {
    write-host "Number of string iterations: $stringIterations "
  
    $breakTime = "<break time=`'$pauseInSeconds`s`'/>"
    $set = "a", "beep", "c", "dees", "e", "f", "g"
    $content = "Fretboard memorization. $pauseInSeconds seconds pause. Natural notes. "
    
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
    $fileNameRoot = Join-Path "SpeechFilesInSsmlFormat/NonIpa" "$pauseInSeconds`SecPause.$stringIterations`Strings.$noteIterations`Notes.ssml"
    $fileNameRoot
    $content > $fileNameRoot
}

# Entry point
# Next example is 10 seconds between notes, 3 string sets, 20 notes per string set...
#Build-PollyString 10 3 20
#Build-PollyString 3 7 20 # 6 strings ok (when generating mp3 in Google) , 8 not ok, 7 OK - suggests a limit imposed by Google
#Build-PollyString 3 10 20
Build-PollyString 1 1 20



