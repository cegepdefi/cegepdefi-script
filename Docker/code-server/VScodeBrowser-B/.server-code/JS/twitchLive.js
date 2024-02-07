const channelName = 'twitch';

const { get } = require('https');
get(`https://www.twitch.tv/${channelName}`, (res) => {
    res.on('data', (chunk) => {
        if(chunk["stream"] == null){
            console.log(`Esta en vivo !`);
        } else {
            console.log(`Offline !`);
        }
    });
    res.on('end', () => {
        console.log('No more data');
    });
});
