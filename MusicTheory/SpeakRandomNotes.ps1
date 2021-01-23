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
        return "<p><break time=`"$pauseInSeconds`s`"/>$currentFret</p>"
    }
    "<p>$currentFret</p>"
}

function Build-PollyString($pauseInSeconds = 5) {
    $breakTime = "<break time=`"$pauseInSeconds`s`"/>"
    $set = "a", "b", "c", "d", "e", "f", "g"
    $content = "Practice for guitar fretboard memorization. Naturals only. "
    $content += "$pauseInSeconds seconds pause between notes."
    $Global:pollyStringSequence | ForEach-Object {
        $first = $true
        $guitarString = $_
        $perStringInstructions = " Now on string $guitarString. Remember, string $guitarString. Find the right fret for the following notes on string $guitarString. "
        $content += $perStringInstructions
        
        1..10 | ForEach-Object { # pick a random fret
            $set | Get-Random | ForEach-Object {
                $currentFret = $_
                if (!$first) { # most times
                    $content += Get-ContentWithPause $currentFret $pauseInSeconds;
                } else {
                    $content += Get-ContentWithPause $currentFret ;
                    $first = $false
                }
                
            }
        }
    }


    $content = "<speak>" + $content + "</speak>"
    $content | clip
    $content
}

# Entry point
Build-PollyString

