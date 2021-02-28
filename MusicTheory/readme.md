There 2 high-level actions:
1. Generate the (text) files in SSML format  
1.1 The file extension of these will always be.ssml, to make their purpose clear  
2. Generate the audio/speech files in mp3 format

Right now, it is the file `speakRandomNotes.ps1` that does both. 
This is poor Separation of Concerns, so that will change.



