
const textToSpeech = require('@google-cloud/text-to-speech');
const fs = require('fs');
const util = require('util');

const client = new textToSpeech.TextToSpeechClient();

const text = 'Text to synthesize, eg. hello';
const outputFile = 'c:/temp/nodee.mp3';

const request = {
    input: { text: text },
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

