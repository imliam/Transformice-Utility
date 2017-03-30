const fs = require('fs');
const jsdom = require('jsdom');
const request = require('sync-request');

var outputPath = 'src/staff.lua';

fs.closeSync(fs.openSync(outputPath, 'w'));
var outputFile = fs.createWriteStream(outputPath, { flags: 'a' });

var staffLists = {
    "admins": "/staff-ajax?role=128",
    "mods": "/staff-ajax?role=1",
    "sentinels": "/staff-ajax?role=4",
    "mapcrew": "/staff-ajax?role=16",
    "funcorp": "/staff-ajax?role=2048"
}

console.log('\x1b[32m%s\x1b[0m', 'Checking staff lists...');
outputFile.write('-- This is an automatically generated list of all staff members, scraped from atelier801.com/staff\n\n');
outputFile.write('staff = {}\n');

for (var key in staffLists) {
    console.log('Processing list "' + key + '"...');
    outputFile.write('staff["' + key + '"] = {}\n');
    
    var response = request('GET', 'http://atelier801.com' + staffLists[key]);
    var responseBody = '<div id="staffGroupName">' + key + '</div>\n';
    responseBody += response.getBody().toString();

    jsdom.env(responseBody, function(err, window) {
        var staffGroupName = window.document.getElementById('staffGroupName').textContent;
        var names = window.document.getElementsByClassName('element-bouton-profil');
        for (var i = 0; i < names.length; i++) {
            var name = names[i].textContent.trim();
            if (name.length) {
                outputFile.write('staff["' + staffGroupName + '"]["' + name + '"] = true\n');
            }
        }
    });
}

console.log('\x1b[32m%s\x1b[0m', 'Finished processing staff list!');