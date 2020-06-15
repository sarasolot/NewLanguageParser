"use strict";

function error_syntax (line, text, token, expected) {
    let map = {
                error: 'syntax',
                line: line,
                text: text,
                token: token,
                expected: expected
    };
    return map;
}
function error_lexical (a, b) {
    let err = {
                error: 'lexical',
                line: a,
                text: b
    };
    return err;
}
var error = "";
var parser = require ('./grammar.js').parser;
var fs = require ('fs');
try {
    var file = process.argv[2];
    var fileOut= process.argv[3];
    var data = fs.readFileSync(file).toString();
    fs.writeFileSync(fileOut, JSON.stringify(parser.parse (data), null, 2));
}
catch (e) {
    error = e.message;
    let parts = error.split(/\r?\n/);
    let text = parts[0];
    if(error.indexOf("Parse") > -1) {
        fs.writeFileSync(fileOut, JSON.stringify(error_syntax(e.hash.line + 1, e.hash.text, e.hash.token, e.hash.expected), null, 2));
    }
    if (error.indexOf("Lexical") >-1) {
        fs.writeFileSync(fileOut, JSON.stringify(error_lexical(e.hash.line + 1, text), null, 2));
    }
    //console.log(e);
}
