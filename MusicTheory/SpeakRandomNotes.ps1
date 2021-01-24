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
    $content += "$pauseInSeconds seconds pause between notes. "
    $content += "Using $stringIterations  string iterations. "
    $content += "Using $noteIterations  note iterations. "
    
    
    1..$stringIterations | ForEach-Object {
        "ON A NEW STRING"
        $first = $true
        $guitarString = $_
        $perStringInstructions = "Choose a string.<break time=`"5s`" />. Ready. "

        $content += $perStringInstructions
        $previousNote = $null
        1..$noteIterations | ForEach-Object { # pick a random note
            "here 1"
            $duplicateTries = 0
            do {
           
                $set | Get-Random | ForEach-Object {
                    $currentNote = $_
                    if ($previousNote -ne $currentNote) {
                        "here 2 - $previousNote - $currentNote"
                        # ok - not a duplicate of previous
                        $content += Get-ContentWithPause $currentNote $pauseInSeconds;
                        $previousNote = $currentNote
                        $duplicateTries = 999
                    }
                    else {
                        "did get a duplicate"
                        $duplicateTries++
                    }
                   
                }
            
            } while ($duplicateTries -lt $Global:maxDuplicateTries) }
    }

    $content = "<speak>" + $content + "</speak>"
    $content | clip
    $content
}

# Entry point
Build-PollyString 3 2 15

