
$root = "d:/Github"

$root += "/PowerShell/MusicTheory/"
$textToAudioRoot = $root + "GoogleTTSSandbox"
$ssmlLocation = $root + "/SpeechFilesInSsmlFormat/NonIpa"
$configFile = Join-Path $textToAudioRoot "config.json"
$outTextFile = "c:/temp/TempPreSpeech.sp"

Write-Host "SSML Location is: [$ssmlLocation]."
$inFile = Read-Host "Enter the name of the SSML file to convert (Do not include the extension)"
$inFileSsml = $inFile + ".ssml"
$outSpeechFile = Join-Path $textToAudioRoot "$inFile.mp3"
$inTextFile = Join-Path $ssmlLocation $inFileSsml

$configData = get-content -path $configFile -raw | convertfrom-json
$textToConvertToSpeech = get-content -path $inTextFile
$jsonRequestTemplateFile =  "$textToAudioRoot/requestTemplate.json"
$jsonRequestTemplate = get-content -path $jsonRequestTemplateFile -raw
$jsonRequestToParse = "$textToAudioRoot/request.json"
$tokenToReplace = "1TOKEN1"

$env:GOOGLE_APPLICATION_CREDENTIALS=$configData.googleAppCredentials

# remove-item $outTextFile > dev/null
remove-item $outSpeechFile -Force

# replace the token in the template with the required text...
$newContent = $jsonRequestTemplate -replace $tokenToReplace, $textToConvertToSpeech
$newContent | set-content -path $jsonRequestToParse

read-host "Now check $jsonrequesttoparse"

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




