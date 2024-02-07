//  npm init -y
// node src/index.js
// npm i morgan

const express = require('express');
const morgan = require('morgan');
const app = express();

// nos permite ver MSN cortos en consola.
app.use(morgan('dev'));

app.use(require('./routes/index'));

module.exports = app;