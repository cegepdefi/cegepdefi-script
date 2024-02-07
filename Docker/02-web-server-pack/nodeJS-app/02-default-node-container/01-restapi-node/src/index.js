const app = require('./app');

//  http://localhost:3000/

// Retorna en formato JSON para poderlo ver en sitio web ?
async function main() {
    await app.listen(3000);
    console.log('My REST API running on port 3000!')
}

main();

// Call-bac
// app.listen(3000, () => {
//     console.log('My REST API running on port 3000!')
// })

// app.get('/', (req, res) => res.send('Hellow world!'));