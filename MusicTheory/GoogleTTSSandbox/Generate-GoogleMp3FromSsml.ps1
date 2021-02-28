
$root = "F:\Den\Github\aadennis\PowerShell\MusicTheory\GoogleTTSSandbox"
$outTextFile = "c:\temp\chap.txt"
$outSpeechFile = "c:\temp\chap.mp3"
$configFile = Join-Path $root "config.json"
$inTextFile = Join-Path $root "TextToConvertToSpeech.txt"

$configData = get-content -path $configFile -raw | convertfrom-json
$textToConvertToSpeech = get-content -path $inTextFile
$jsonRequestTemplateFile = "F:\Den\Github\aadennis\PowerShell\MusicTheory\GoogleTTSSandbox\requestTemplate.json"
$jsonRequestTemplate = get-content -path $jsonRequestTemplateFile -raw
$jsonRequestToParse = "F:\Den\Github\aadennis\PowerShell\MusicTheory\GoogleTTSSandbox\request.json"
$tokenToReplace = "1TOKEN1"

$env:GOOGLE_APPLICATION_CREDENTIALS=$configData.googleAppCredentials

remove-item $outTextFile
remove-item $outSpeechFile

# replace the token in the template with the required text...
$newContent = $jsonRequestTemplate -replace $tokenToReplace, $textToConvertToSpeech
$newContent | set-content -path $jsonRequestToParse

$cred = gcloud auth application-default print-access-token
$headers = @{ "Authorization" = "Bearer $cred" }
$audioAsJson = Invoke-WebRequest `
    -Method POST `
    -Headers $headers `
    -ContentType: "application/json; charset=utf-8" `
    -InFile $jsonRequestToParse `
    -Uri "https://texttospeech.googleapis.com/v1/text:synthesize" | Select-Object -ExpandProperty content 
($audioAsJson | convertfrom-json).audioContent | out-file $outTextFile
certutil -decode $outTextFile $outSpeechFile




