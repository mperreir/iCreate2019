const osc = require("osc");

const app = require("express")();
const http = require("http").Server(app);
const io = require("socket.io")(http);

var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});
var audio;


var niveau = '-1';
udpPort.on("message", function (oscMsg) {
    let nfc = oscMsg['args'][0]['value'];
    console.log(nfc);
    switch(nfc){
        case "$)ï¿½Wï¿½" :
            niveau = '0';

            break;
        case "ï¿½Pbï¿½Wï¿½" :
            niveau = '1';

            break;
        case "@ï¿½IZï¿½" :
            niveau = '2';

            break;
        case "(ï¿½Wï¿½" :
            niveau = '3';
            break;
        case "<\"ï¿½ï¿½Yï¿½":
            niveau = '4';
            break;
        music = true;
    }
    console.log("Niveau : ",niveau);

});
udpPort.open();

io.on("connection", socket => {
    io.emit("message",niveau);
});

http.listen(9995);
