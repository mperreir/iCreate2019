// Master client

//var socket = io.connect('http://localhost:8080');
//var socket = io.connect('http://192.168.43.202:8080');
var socket = io.connect('http://172.20.10.6:8080');
//var socket = io.connect('http://192.168.1.27:8080');

// We send it to the server
socket.emit('identifiant', 0);

// Loading background music and playing it
var waterfall = new Audio('waterfall.mp3');
waterfall.volume = 0.1;
waterfall.play();

// We display an alert box when we receive a message
socket.on('messageFrom', function(id, message) {
    alert(id + ' says : ' + message);
});

// Playing video when fullScreen is activated
socket.on('fullScreenAndPlay', function() {
    var video = document.getElementById("video");
    video.play();
});

// Changing button value when the video is affected
socket.on('setVideoName', function(id, videoName) {
    console.log(id + ' gets : ' + videoName);
    var button = document.getElementById('city' + id);
    button.value = videoName;
});

// Event when clicking the play video button
$('#playVideo').click(function () {
    var clientId = document.getElementById("videoOf").value;
    var time = document.getElementById("time").value;
    socket.emit('playVideo', clientId, time);
});

// Event when clicking the full screen button
$('#fullScreen').click(function () {
    var video = document.getElementById("video");
    video.requestFullscreen();
    socket.emit('fullScreenAndPlay');
});

// Event whe  clicking on the video buttons
$('.masterButton2').click(function () {
    var id = this.id.substr(this.id.length - 1);
    socket.emit('playVideo', id, 4);
    waterfall.pause();
    // We stop the background music while the video is playing
    setTimeout(function(){
        waterfall.play();
    }, 5500);
});

// We send the info for a message to someone when clicking the send button
$('#sendMessage').click(function () {
    var idToSend = document.getElementById("to").value;
    var messageToSend = document.getElementById("message").value;
    socket.emit('messageTo', idToSend, messageToSend);
});
