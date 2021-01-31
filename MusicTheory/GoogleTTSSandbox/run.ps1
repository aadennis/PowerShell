$jsonRequestToParse = "F:\Den\Github\aadennis\PowerShell\MusicTheory\GoogleTTSSandbox\request.json"

$outTextFile = "c:\temp\chap.txt"
$outSpeechFile = "c:\temp\chap.mp3"
$configFile = "F:\Den\Github\aadennis\PowerShell\MusicTheory\GoogleTTSSandbox\config.json"

$configData = get-content -path $configFile -raw | convertfrom-json
$configData
$env:GOOGLE_APPLICATION_CREDENTIALS=$configData.googleAppCredentials

remove-item $outTextFile
remove-item $outSpeechFile


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
# $audioAsJson



