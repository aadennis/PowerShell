
const textToSpeech = require('@google-cloud/text-to-speech');
const fs = require('fs');
const util = require('util');

const client = new textToSpeech.TextToSpeechClient();

const outputFile = 'c:/temp/nodee.mp3';
const inputFile = 'c:/temp/inner.txt'; // text file - no quotes at start and end, a CR should be the final character.
const readFile = util.promisify(fs.readFileSync);
const textToSpeak = fs.readFileSync(inputFile);

const request = {
    input: { text: textToSpeak },
    voice: { languageCode: 'en-GB', ssmlGender: 'FEMALE' },
    audioConfig: { audioEncoding: 'MP3' },
};

async function run() {
    const [response] = await client.synthesizeSpeech(request);
    const writeFile = util.promisify(fs.writeFile);
    await writeFile(outputFile, response.audioContent, 'binary');
    console.log(`Audio content written to file: ${outputFile}`);
}

run();

