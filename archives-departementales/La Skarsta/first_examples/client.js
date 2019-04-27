//client.js
var io = require('socket.io-client');
var socket = io.connect('http://192.168.8.116:9995');

// Add a connect listener
socket.on('connect', function (socket) {
    console.log('Connected!');
});

socket.on('user connected',function(socket){
	console.log("A user is connected");
});

socket.on('message',function(data){
	console.log("Message " + data);
});

socket.on('disconnect', function () {
  console.log('Socket is disconnected.');
});
