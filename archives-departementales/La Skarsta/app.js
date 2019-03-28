var express = require('express');
const path = require('path');
var osc = require("osc");
var app = express();

var server = require('http').Server(app);
var io = require('socket.io')(server);

var mplayer = require('mplayer-wrapper');
var player = mplayer();

var client;					// Un seul socket client est accepté
var niveau;					// Niveau actuel
var oldLevel;				// Niveau précédent
var isConnected = false;	// Indique si un socket s'est déjà connecté ou non
var soundToPlay;			// Indique le chemin vers le fichier de son à jouer

// Création d'un fondu sonore
var fade = [90,80,60,30,10,5,3,2,2,1,1,1,0,0,0];
function fadeout(){
  fade.forEach( (i) => {
    player.setVolume(i);
    j=0;
    while (j<50000000){
      j++;
    }
  });
}

// Lien vers les fichiers statiques
app.use(express.static(__dirname + '/public'));

// Page principale
app.get('/', function(req, res){
    res.sendFile(path.join(__dirname+'/render.html'));
});

// Quand un client se connecte, on l'enregistre
io.sockets.on('connection', function (socket) {
	client = socket;
	console.log("[LOG] Connexion d'un client");
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
			soundToPlay = './sons/niveau0.mp3';
            break;
        case "ï¿½Pbï¿½Wï¿½" :
            niveau = '1';
			soundToPlay = './sons/niveau1.mp3';
            break;
        case "@ï¿½IZï¿½" :
            niveau = '2';
			soundToPlay = './sons/niveau2.mp3';
            break;
        case "(ï¿½Wï¿½" :
            niveau = '3';
			soundToPlay = './sons/niveau3.mp3';
            break;
        case "<\"ï¿½ï¿½Yï¿½":
            niveau = '4';
			soundToPlay = './sons/niveau4.mp3';
            break;
        default :
			niveau = '0';
			soundToPlay = './sons/niveau0.mp3';
            break;
    }

	console.log("[LOG] Niveau : ",niveau);
	
	// Envoi d'un message si un client est connecté et qu'on ne lui a pas déjà envoyé ce niveau
	if(isConnected && oldLevel !== niveau){
		client.emit('message', niveau);
		oldLevel = niveau;
		// Lancement du fichier son
		fadeout();
		player.play(soundToPlay);
        player.exec('loop 999999');
	}

});

// On écoute sur le port en attente de messages UDP
udpPort.open();
