const express = require('express')
const app = express()

app.get('/', (req, res) => res.send('Hellow world!'));

app.listen(3000, () => {
    console.log('My REST API running on port 3000!')
})