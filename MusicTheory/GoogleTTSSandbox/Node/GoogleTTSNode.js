
const textToSpeech = require('@google-cloud/text-to-speech');
const fs = require('fs');
const util = require('util');

const client = new textToSpeech.TextToSpeechClient();
let inputFile, outputFile, inputlanguageCode = 'en-GB', inputSsmlGender = 'FEMALE';

// see HappyToons repo
const args = process.argv
args.forEach((val, index) => {
    console.log(`${index}: ${val}`);
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/switch
    switch (index) {
        case 2:
            // text file - no quotes at start and end, a CR should be the final character.
            inputFile = val;
            break;
        case 3:
            outputFile = val;
            break;
        case 4:
            inputlanguageCode = val;
            break;
        case 5:
            inputSsmlGender = val;
            break;
        default:
    }
});

const textToSpeak = fs.readFileSync(inputFile);

const request = {
    input: { text: textToSpeak },
    voice: { languageCode: inputlanguageCode, ssmlGender: inputSsmlGender },
    audioConfig: { audioEncoding: 'MP3' },
};

async function run() {
    const [response] = await client.synthesizeSpeech(request);
    const writeFile = util.promisify(fs.writeFile);
    await writeFile(outputFile, response.audioContent, 'binary');
    console.log(`Audio content written to file: ${outputFile}`);
}

run();

// Example call
// node .\GoogleTTSNode.js 'c:/temp/inner.txt' 'c:/temp/speech.mp3'