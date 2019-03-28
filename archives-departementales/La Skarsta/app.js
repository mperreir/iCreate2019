var express = require('express');
const path = require('path');
var osc = require("osc");
const child_process = require("child_process");
var sleep = require('sleep');

var app = express();

var server = require('http').Server(app);
var io = require('socket.io')(server);

var mplayer = require('mplayer-wrapper');
var player = mplayer();

var client;					// Un seul socket client est accepté
var niveau;					// Niveau actuel
var oldLevel;				// Niveau précédent
var isConnected = false;	// Indique si un socket s'est déjà connecté ou non
var song;		// Indique si un morceau est en cours

var fade = [90,80,60,30,10,5,3,2,2,1,1,1,0,0,0];
function fadeout(){
  fade.forEach( (i) => {
    player.setVolume(i);
    j=0;
    console.log(i);
    while (j<50000000){
      j++;
    }
  });
}

//static files link
app.use(express.static(__dirname + '/public'));

// Page principale
app.get('/', function(req, res){
    res.sendFile(path.join(__dirname+'/render.html'));
});

// Quand un client se connecte, on l'enregistre
io.sockets.on('connection', function (socket) {
	client = socket;
  console.log("adihfejaokoa");
	oldLevel = '';
	isConnected = true;
});

// Le serveur web écoute sur le port 8080
server.listen(8080);

// On va écouter sur le port 9912 une connexion UDP (osc)
var udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 9912,
        metadata: true
});


// A la réception d'un message via osc
udpPort.on("message", function (oscMsg) {

	// récupération du message
    let nfc = oscMsg['args'][0]['value'];

	// Application d'un traitement différent selon le niveau détecté
	switch(nfc){
        case "$)ï¿½Wï¿½" :
            niveau = '0';
            fadeout();
            player.play('./sons/niveau0.mp3');
            player.exec('loop 999999');
            break;
        case "ï¿½Pbï¿½Wï¿½" :
            niveau = '1';
            fadeout();
            player.play('./sons/niveau1.mp3');
            player.exec('loop 999999');
            break;
        case "@ï¿½IZï¿½" :
            niveau = '2';
            fadeout();
            player.play('./sons/niveau2.mp3');
            player.exec('loop 999999');
            break;
        case "(ï¿½Wï¿½" :
            niveau = '3';
            fadeout();
            player.play('./sons/niveau3.mp3');
            player.exec('loop 999999');
            break;
        case "<\"ï¿½ï¿½Yï¿½":
            niveau = '4';
            fadeout();
            player.play('./sons/niveau4.mp3');
            player.exec('loop 999999');
            break;
        default :
            niveau = '0';
            fadeout();
			      player.play('./sons/niveau0.mp3');
            player.exec('loop 999999');
            break;
    }

  console.log("Niveau : ",niveau);
	// Envoie d'un message si un client est connecté et qu'on ne lui a pas déjà envoyé ce niveau
	if(isConnected && oldLevel !== niveau){
		client.emit('message', niveau);
		oldLevel = niveau;
	}

});

// On écoute sur le port en attente de messages UDP
udpPort.open();
