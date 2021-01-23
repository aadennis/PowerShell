# This is only for use in Amazon Polly, so this saves to a text file,
# but does not render to speech.
Set-StrictMode -Version latest

. ./Configuration.ps1

# Music theory on the guitar - fretboard familiarisation

Set-Globals

function Build-PollyString($pauseInSeconds=3, $guitarString=1) {
    $breakTime = "<break time=`"$pauseInSeconds`s`"/>"
    $set = "a","b","c","d","e","f","g"
    $content = "On string $guitarString, find the right fret for the following notes."
    1..10 | % {
        $set | Get-Random | ForEach-Object {
            $content += "<p><break time=`"$pauseInSeconds`s`"/>$_</p>"
        }
    }  
    $content = "<speak>"+$content+"</speak>"
    $content | clip
    $content
}

# Entry point
Build-PollyString

