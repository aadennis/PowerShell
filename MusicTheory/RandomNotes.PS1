using namespace System.Collections.Generic
$uniqueQuestionsDict = [List[string]]::new()

# In PowerShell, the "using" must be line 1, and a List object must not be declared in a function. Evidently.

Set-StrictMode -Version latest

. ./Configuration.ps1

# Music theory on the guitar - fretboard familiarisation

Set-Globals

function Start-SpeechEnvironment() {
    Add-Type -AssemblyName System.Speech
    $Global:speech = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    $Global:speech.SelectVoice("Microsoft Hazel Desktop")
}

function Format-Question($currentString, $currentNote) {
    $spokenNote = $currentNote
    if ($spokenNote -eq "A") {
        # simplest way to get correct pronunciation:
        $spokenNote = "Eh"
    }
    $utterance = "string, $currentString, note, `"$spokenNote`""
    Speak($utterance) 
    $display = "string, $currentString, note, `"$currentNote`""
    $display
}

function Speak($utterance) {
    $speech.Rate = -0
    $speech.Speak($utterance)
}

function Get-Options() {
    try {
        [int] $delayBetweenQuestionsChoice = 
            Read-Host "Enter the delay between questions (default is [$global:delayBetweenQuestions] seconds)" 
    }
    catch {
        $null
    }
    if ($delayBetweenQuestionsChoice -ne $Global:delayBetweenQuestions) {
        $Global:delayBetweenQuestions = $delayBetweenQuestionsChoice
    }

    try {
        Write-Host "String set: Enter [1] for all, [2] for 1,5,6, "
        [int] $stringChoice = Read-Host "[3] for 2,3,4, [4] for 5,6 (default)"
    }
    catch {
        $null
    }
    if ($stringChoice -eq 1) {
        $Global:stringSet = $Global:stringSet1
    }
    if ($stringChoice -eq 2) {
        $Global:stringSet = $Global:stringSet2
    }
    if ($stringChoice -eq 3) {
        $Global:stringSet = $Global:stringSet3
    }

    try {
    [int] $duplicatesChoice = Read-Host "Duplicates: 1 for OK to repeat a question (default), 2 for Do not repeat questions"
    }
    catch {
        $null
    }
    if ($duplicatesChoice -eq 2) {
        $Global:duplicatesOK = $false
    }


    write-host "Total number of questions: [$Global:questionCount]"
    write-host "Delay between questions: [$Global:delayBetweenQuestions] seconds"
    Write-Host "Strings used:" $Global:stringSet
    Write-Host "Notes used:" $Global:note
    Write-Host "Duplicates OK: $Global:duplicatesOK"
}

function Invoke-QuestionSet() {
    $score = 0
    $i = 0
    1.. $questionCount | ForEach-Object {
        $stringIndex = Get-Random -Minimum 0 -Maximum $($Global:stringSet.count)
        $currentString = $Global:stringSet[$stringIndex]

        $noteIndex = Get-Random -Minimum 0 -Maximum $($note.count)
        $currentNote = $note[$noteIndex]

        $dictEntry = "" + $currentNote + $currentString

        $found = $uniqueQuestionsDict.Where( { $_ -eq $dictEntry }) # and ForEach is also valid
        if (! $found) {
            $uniqueQuestionsDict.Add($dictEntry)   
        }
        
        if (!$found -or $Global:duplicatesOK) {
            Format-Question $currentString $currentNote
            [int] $ans = read-host "Enter the fret"
            $ans
            Start-Sleep $Global:delayBetweenQuestions
            $fretAnswer = $fretPerStringNote["$currentString$currentNote"]
            "Fret: $fretAnswer"   
            if ($ans -eq $fretAnswer)  {
                "Your answer was right"
                Speak("correct")
                $score++
            } else {
                "Your answer was wrong"
                Speak("wrong")
            }
        }
        $i++
        # right now, finding of duplicates continues the count, so the number of questions will be
        # reduced by each duplicate found.
    }
    speak("you scored $score out of $questionCount")
}

function Stop-SpeechEnvironment() {
    $speech.Dispose()
    $speech = $null
}

function Main() {
    Set-Globals
    Start-SpeechEnvironment
    Get-Options
    Invoke-QuestionSet
    Stop-SpeechEnvironment
}

# Entry point
main

# Footnote - trying other Speech and SSML options...
# $prompt = New-Object -TypeName System.Speech.Synthesis.PromptBuilder
# https://docs.microsoft.com/en-us/dotnet/api/system.speech.synthesis.speechsynthesizer.speakssml?view=netframework-4.8
# https://docs.microsoft.com/en-us/dotnet/api/system.speech.synthesis.speechsynthesizer.addlexicon?view=netframework-4.8
# https://docs.microsoft.com/en-us/azure/cognitive-services/speech-service/speech-synthesis-markup?tabs=csharp
# https://stackoverflow.com/questions/11529164/how-do-i-use-a-lexicon-with-speechsynthesizer
# https://csharp.hotexamples.com/examples/-/SpeechSynthesizer/SpeakSsml/php-speechsynthesizer-speakssml-method-examples.html
# prosody:
# https://www.codemag.com/article/1707091/Use-Your-Words-Getting-Familiar-with-Speech-Synthesis-Markup-Language

# $str = "<speak version='1.0' xml:lang='en-GB'>"
# $str += "<prosody rate=x-slow>"
# $str += $textToSpeak
# $str += "Now I say A and Ay"
# $str += " xmlns='http://www.w3.org/2001/10/synthesis'  
# $str += "<say-as type=\"date:mdy\"> 1/29/2009 </say-as>"; 
# $str += "</prosody>"
# $str += "</speak>";  
# $speech.Rate = -2
# $prompt.AppendText("A B C")
# $speech.Speak($str)
# $speech.SpeakSsml($str)




