'use strict'

var http = require('http');
var fs = require('fs');

// Object associating client choosen IDs with their given IDs at the connexion
var clients = {};

// List of videos to use
var videos = {
    '0' : 'start.mp4',
    '1' : 'baku.mp4',
    '2' : 'kyoto.mp4',
    '3' : 'moscou.mp4',
    '4' : 'seattle.mp4',
    '11' : 'montreal.mp4',
    '12' : 'sydney.mp4',
    '13' : 'newdelhi.mp4',
    '14' : 'shanghai.mp4',
    '20' : 'veille.mp4'
};

// Names of the video
var videoNames = {
    '0' : 'start',
    '1' : 'baku',
    '2' : 'kyoto',
    '3' : 'moscou',
    '4' : 'seattle',
    '11' : 'montreal',
    '12' : 'sydney',
    '13' : 'newdelhi',
    '14' : 'shanghai',
    '20' : 'veille'
};

// Setting express and socket.io
var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

// Using static files
app.use(express.static(__dirname + '/node_modules'));
app.use(express.static(__dirname + '/videos'));
app.use(express.static(__dirname + '/images'));
app.use(express.static(__dirname + '/sounds'));
app.use(express.static(__dirname + '/style'));
app.use(express.static(__dirname + '/js'));
app.use(express.static(__dirname + '/fonts'));

// Routing
app.get('/', function(req, res, next) {
    res.sendFile(__dirname + '/index_leap_motion.html');
});
app.get('/phone', function(req, res, next) {
    res.sendFile(__dirname + '/phone.html')
});

io.sockets.on('connection', function (socket, id) {

    // When receiving an ID, we store it in the clients Object
    socket.on('identifiant', function(id) {
        console.log(socket.id);
        clients[id] = socket.id;
        console.log('id of new client : ', clients[id]);
        console.log(clients);
    });

    // Getting video source and name
    socket.on('getVideo', function(id) {
        console.log(id + ' choosed : ' + videos[id]);
        var theId = parseInt(id);
        if (theId > 10) {
            theId = theId - 10;
        }
        theId = theId + "";
        //io.sockets.to(clients[0]).emit('setVideoName', id, videoNames[id]);
        io.sockets.to(clients[theId]).emit('setVideoSource', videos[id]);
    });

    // Request to play a video for a choosed time
    socket.on('playVideo', function(id, time) {
        console.log('request to play video of : ' + id);
        io.sockets.to(clients[id]).emit('playVideo', time);
    });

    // Request to fullScreen a video and play it
    socket.on('fullScreenAndPlay', function() {
        console.log('request full screen and play video of : 0');
        io.sockets.to(clients[0]).emit('fullScreenAndPlay');
    });

    // Sending the message to the correct client
    socket.on('messageFrom', function (id, message) {
        console.log(id + ' says ' + message);
        io.sockets.to(socket.id).emit('messageFrom', id, message);
    });

    // Receiving a message to send to someone
    socket.on('messageTo', function (id, message) {
        console.log(socket.id + ' wants to send a message to ' + id);
        // We send the message to the correct client
        io.sockets.to(clients[id]).emit('messageFrom', id, message);
    });
});

console.log('Starting server...');
server.listen(8080);
