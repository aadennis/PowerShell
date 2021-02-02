Node: Using Google Cloud Text-To-Speech libraries
===

### Description
Yet another text-to-speech console app, this time based on the Google TTS engine.   
Dependencies: nodejs. I have not yet confirmed if you must be logged into your Google developer account to use the TTS engine.

### Parameters

Parameter 0: This is always the argument 'node'.   
Parameter 1: The called script. Mandatory.  
Parameter 2: The FQPN of the text to convert to speech. Do not use quotes at the start and end. The last character should be followed by a CR/LF, else I find the speech is truncated. (TODO - fix that programmatically). Mandatory.  
Parameter 3: The FQPN of the mp3 file to be created or overwritten. Mandatory.  
Parameter 4: The language code to use. For example, 'en-US'. Default: 'en-GB'. Mandatory if subsequent parameters are specified, else optional.  
Parameter 5: The input SSML gender to use. For example, 'MALE'. Default: 'FEMALE'. Optional.  

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
