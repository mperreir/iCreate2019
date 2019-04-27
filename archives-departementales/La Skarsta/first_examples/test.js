const osc = require("osc");

const server = require("http").createServer();
const io = require("socket.io")(server);

var mplayer = require('mplayer-wrapper');
var player = mplayer();

var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});

var niveau = '-1';
var client;
var isConnect = false;

var isPlaying = false;

player.play('./rainforest.mp3');
player.exec('loop 999999');


player.on('time_pos', (val) => {
    console.log(val)
    if(val > 40){
      player.play('./bus.mp3');
      player.exec('loop 999999');
    }
})
setInterval(() => {
    player.getProps(['time_pos'])
}, 2 * 1000)

udpPort.on("message", function (oscMsg) {
    let nfc = oscMsg['args'][0]['value'];

    console.log(nfc);
    switch(nfc){
        case "$)ï¿½Wï¿½" :
            niveau = '0';
            player.play('./niveau0.mp3');
            player.exec('loop 999999');
            break;
        case "ï¿½Pbï¿½Wï¿½" :
            niveau = '1';
            player.play('./niveau1.mp3');
            player.exec('loop 999999');
            break;
        case "@ï¿½IZï¿½" :
            niveau = '2';
            player.play('./niveau2.mp3');
            player.exec('loop 999999');
            break;
        case "(ï¿½Wï¿½" :
            niveau = '3';
            player.play('./niveau3.mp3');
            player.exec('loop 999999');
            break;
        case "<\"ï¿½ï¿½Yï¿½":
            niveau = '4';
            player.play('./niveau4.mp3');
            player.exec('loop 999999');
            break;
        default :
            niveau = '-1';
            break;
    }
    console.log("Niveau : ",niveau);
    if(isConnect){
      client.emit("message",niveau);
    }
});
udpPort.open();

io.on("connection", socket => {
    client = socket;
    isConnect = true;
});

if(isConnect){
    client.on("disconnected", function () {
        isConnect = false;
    });
}

server.listen(9995);
