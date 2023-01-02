const fs = require('fs');
const combine = require('./combine');
const luamin = require('luamin');

combine(

    // List of files and directories in order to be concatenated
    [
        'src/before.lua',
        'src/config.lua',
        'src/translations',
        'src/changelog.lua',
        'src/maps',
        'src/lib',
        'src/events',
        'src/segments',
        'src/segments/map-modes',
        'src/after.lua'
    ],

    // Output file
    'utility.lua',

    // Optional parameters to alter behaviour
    {
        'delimeterBefore': '--[[ ',
        'delimeterAfter': ' ]]--'
    }
);


// Optionally minify the final output script using luamin
if (process.argv[2] == 'minify') {
    console.log('\x1b[32m%s\x1b[0m', 'Minifying script...\n');

    var fileContents = fs.readFileSync('utility.lua', 'utf8', function(err, data) {
        if (err) {
            console.log('\x1b[31m%s\x1b[0m', err);
            process.exit(1)
        }
        var originalFile = fs.createWriteStream('utility.lua', { flags: 'w' });
        outputFile.write(luamin.minify(data));
        originalFile.end();
    });

    console.log('\x1b[32m%s\x1b[0m', 'Finished minifying!\n');
}