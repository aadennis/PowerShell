Node: Using Google Cloud Text-To-Speech libraries
===

### Description
Yet another text-to-speech console app, this time based on the Google TTS engine.   
The app takes text passed from a file on the command line, and outputs speech to a file, in mp3 format.  
Dependencies: nodejs and the project.json in this project. I have not yet confirmed if you must be logged into your Google developer account to use the TTS engine.

#### Example for context
`node .\GoogleTTSNode.js 'c:/temp/inner.txt' 'c:/temp/example3.mp3' 'en-US' 'MALE'  ` 

### Parameters

| Parameter        | Description          | Default |Mandatory?  |
|:-------------:|:-------------|:-------------| :-----:|
| 0     | This is always the argument literal '**node**'. | n/a | Yes |
| 1     | The called script. | n/a | Yes |
| 2     | The FQPN of the text to convert to speech. Do not use quotes at the start and end. The last character should be followed by a CR/LF, else I find the speech is truncated (TODO - fix that programmatically.). |n/a | Yes |
| 3     | The FQPN of the mp3 file to be created or overwritten. |n/a | Yes |
| 4     | The language code to use. For example, 'en-US'. This and 'en-GB' are the only allowed values. |en-GB | Conditional |
| 5     | The input SSML gender to use. For example, 'MALE'. This and 'FEMALE' are the only allowed values.|FEMALE | No |

### Examples

#### Example 1
Read the file inner.txt.  
Save the output as speech to example1.mp3.
Use the default values for language code and gender.  
`node .\GoogleTTSNode.js 'c:/temp/inner.txt' 'c:/temp/example1.mp3'  ` 

#### Example 2
Pass a value for the language code. Use the default value for gender.  
`node .\GoogleTTSNode.js 'c:/temp/inner.txt' 'c:/temp/example2.mp3' 'en-US';  ` 

#### Example 3
Pass values for language code and gender.  
`node .\GoogleTTSNode.js 'c:/temp/inner.txt' 'c:/temp/example3.mp3' 'en-US' 'MALE'  ` 

#### Sample text for input files - thanks to Jane Austen and Gutenburg Press
>It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife.  
However little known the feelings or views of such a man may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered the rightful property of some one or other of their daughters.  
"My dear Mr. Bennet," said his lady to him one day, "have you heard that Netherfield Park is let at last?"  
Mr. Bennet replied that he had not.  

###### Abbreviations
<sup><sub>FQPN: fully qualified path name </sub></sup>

