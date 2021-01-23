# This is only for use in Amazon Polly, so this saves to a text file,
# but does not render to speech.
# You have to paste the clipboard content into the Amazon Polly console, e.g.
# https://eu-west-2.console.aws.amazon.com/polly/home/SynthesizeSpeech
Set-StrictMode -Version latest

. ./Configuration.ps1

# Music theory on the guitar - fretboard familiarisation

Set-Globals

function Build-PollyString($pauseInSeconds = 3) {
    $breakTime = "<break time=`"$pauseInSeconds`s`"/>"
    $set = "a", "b", "c", "d", "e", "f", "g"
    $content = "Practice for guitar fretboard memorization. Naturals only. "
    $content += "$pauseInSeconds seconds pause between notes."
    $Global:pollyStringSequence | ForEach-Object {
        $guitarString = $_
        $perStringInstructions = " Now on string $guitarString. Remember, string $guitarString. Find the right fret for the following notes on string $guitarString. "
        $content += $perStringInstructions
        # $stringContent = $null
        
        1..10 | ForEach-Object { # pick a random fret
            $set | Get-Random | ForEach-Object {
                $content += "<p><break time=`"$pauseInSeconds`s`"/>$_</p>"
            }
        }
    }


    $content = "<speak>" + $content + "</speak>"
    $content | clip
    $content
}

# Entry point
Build-PollyString

