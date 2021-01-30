Practising guitar fretboard memorization, using audio files.
=======
***Before reading this, please play one of the files in this folder, to give you some context. For example, [this file][5] - right click, "save link as", then play it.***  

This is a collection of audio files, which prompt you to find notes on a string of a guitar, with a pause to give you time to find the note.  
A file looks like this, as an example: `10SecPause.3Strings.20Notes.JoannaVoice.mp3`.   
*(Please see the FAQ at the bottom for an explanation of the name and content of the files.)*  

#### So it's just a set of audio files. How does that help me improve my memory of the fretboard?
There is no set way, but let me tell you how I use them. We'll take say the "Joanna" set of 3, which has 10, 3 and 1 second pauses.
When starting out, I will play the 10 second set, say on the E/6 string. 10 seconds gives me enough time to work out from the open string the spoken note. Let's say the first note that `Joanna` speaks is `C`. So I find and play `C` on the guitar, hopefully within the 10 seconds. If I don't manage to find it in 10 seconds, then I am immediately under pressure, because `Joanna` will not hear me saying "Er, hang on, haven't found it yet", and will continue on to the next note on her list. So this is not a test with concrete feedback from an app. You are testing yourself, you are putting pressure on yourself. Coming back to `Joanna` relentlessly churning out notes at 10 second intervals, you can either skip that note you can't get, or rewind the file to the start. Of course, if you can't find the note in time, that tells you that you are not ready to move to the 3 second files, far less the 1 second files. 
#### You've only discussed one string. Why does the file contain "3 string iterations"?
Well, you could stop after that first iteration. But if you want to continue... let's say you successfully played the 20, random, uttered notes for that E/6 string within 10 seconds. You could either consolidate by using the `E/6` string for the second and indeed third iteration, to be truly confident that you can move to the "faster" notes. Or you might try the `A/5` string. Not quite so good on that? So you could repeat `A/5` for iteration 3 as well. I'm just emphasising that you can use it in a way that suits you - there is no fixed approach.
#### And the 3 second and 1 second files?
This is the same principle as the 10 second file. Only now `Joanna` gives you a shorter gap to play the notes. Then if you cannot yet succeed with the 3 second file, which still gives you a little time to work things out, without instant recall, you are probably not ready to graduate to the 1 second file.  
By the time you get to the 1 second file, you are REALLY getting to a point where you know your keyboard. 
#### Will this work for me then?
I make no claims, but I use it myself.
It is just one more tool, to go with the large number of techniques out there which aim to help with this.

FAQ
===
#### What is this complicated file name all about?
The name of the file tells you more about its content.  
As an example, the name of this file...  
`10SecPause.3Strings.20Notes.JoannaVoice.mp3`  
means  
> 10 seconds pause between each note, 3 strings, 20 notes, using the "Joanna" voice.

#### What exactly do you mean by "note"?  
It is the speaker *uttering* a note. A note is a letter between A and G. In the file name, "Notes" is actually shorthand for "Note utterance". So in the example above, she will utter 20 notes.
#### Is there repetition of notes?
Yes, but not immediately 1 after the other. For example, you will never hear a sequence of `C` `C`. However, right now you may hear e.g. `C` `E` `C`, so I shall ensure in a future version that there is always a gap of 2 different note between two of the same note. For example, you will get sometimes get `C` `E` `A` `C`, worst-case.
#### And what exactly do you mean by "string"?  
It is a set of "note utterances", with a pause (10 seconds, etc) between each "note utterance". It is up to you to decide what string you will actually use. She doesn't know or care.
#### Why does each file have 3 "strings"?  
That is just a convenient number to make a practise session last between 3 and 10 minutes. The exact duration is the number of Strings, multiplied by the number of Notes, multiplied by the pause length... plus any speech introduction, which is not much. If you want more, you can obviously put a given file into a loop until you get bored.
#### Why "JoannaVoice", "EmmaVoice", etc?
I use the [Amazon Polly console][1] to generate audio from the [SSML][2] files. `Joanna` for example, is one of the English USA voices. `Emma` is 1 of the English UK voices. I have found that some of the UK recorded [phonemes][3] are not perfect, hence hopping between the 2 regions. Even using [IPA][4] for a more precise rendering has not helped.
#### Why does she say "Naturals only"?
The notes only cover A to G right now, not the chromatic scale. That is, it does not cover the sharps and flats. 

[1]: https://eu-west-2.console.aws.amazon.com/polly/home?region=eu-west-2
[2]: https://developer.amazon.com/en-US/docs/alexa/custom-skills/speech-synthesis-markup-language-ssml-reference.html
[3]: https://en.wikipedia.org/wiki/Phoneme
[4]: https://en.wikipedia.org/wiki/International_Phonetic_Alphabet
[5]: https://github.com/aadennis/PowerShell/raw/master/MusicTheory/SpeechFilesInMp3Format/10SecPause.3Strings.20Notes.JoannaVoice.mp3

###### https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet  
###### https://github.github.com/gfm/
###### https://www.markdownguide.org/basic-syntax/

