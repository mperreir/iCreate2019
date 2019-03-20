const osc = require("osc");

var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});

udpPort.open();


udpPort.on("message", function (oscMsg) {
    let nfc = oscMsg['args'][0]['value'];
    console.log(nfc);
    let niveau;
    switch(nfc){
        case "$)ï¿½Wï¿½" :
            niveau = 0;
            break;
        case "ï¿½Pbï¿½Wï¿½" :
            niveau = 1;
            break;
        case "@ï¿½IZï¿½" :
            niveau = 2;
            break;
        case "(ï¿½Wï¿½" :
            niveau = 3;
            break;
        case "<\"ï¿½ï¿½Yï¿½":
            niveau = 4;
            break;
    }
    console.log("Niveau : ",niveau);

});
