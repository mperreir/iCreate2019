const osc = require("osc");

var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});

udpPort.on("message", function (oscMsg) {
    console.log(oscMsg['args'][0]['value']);

});

udpPort.open();
