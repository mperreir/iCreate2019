const osc = require("osc");

const server = require("http").createServer();
const io = require("socket.io")(server);



var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});

var niveau = '-1';
var client;
var connect = false;

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
        default :
            niveau = '-1';
            break;
    }
    console.log("Niveau : ",niveau);
    if(connect){
      client.emit("message",niveau);
    }
});
udpPort.open();

io.on("connection", socket => {
    client = socket;
    connect = true;
});

server.listen(9995);
