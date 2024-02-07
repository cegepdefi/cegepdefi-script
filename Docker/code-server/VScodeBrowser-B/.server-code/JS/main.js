
// ==== primera forma ====
const http = require('https');
const req = http.request('https://www.google.com', (res) => {
    res.on('data', (chunk) => {
        console.log(`Data chunk: ${chunk}`);
    });
    res.on('end', () => {
        console.log('No more data');
    });
});
// sin el .end() no se completa el request.. se queda frizado esperando algo..
req.end();

// === Segunda forma.. Se recomienda usar mientras sea pocible :
// ya no se necesita guardar en una variable ni el req.end();
const { get } = require('https');
get('https://www.google.com', (res) => {
    res.on('data', (chunk) => {
        console.log(`Data chunk: ${chunk}`);
    });
    res.on('end', () => {
        console.log('No more data');
    });
});

// Reescribir para memorizar
