/* Phone client */

// Creation of the socket
var socket = io.connect('http://localhost:8080');

// We ask for the id of the client
var id = prompt('Identifiant :');
// We send it to the server
socket.emit('identifiant', id);

var video = document.getElementById("video");
socket.emit('getVideo', id);
// variable containing the source of the video
var source = '';

// Setting the video source
socket.on('setVideoSource', function(videoSource) {
    source  = videoSource;
    video.src = videoSource;
});

// Play the video for the specified time
socket.on('playVideo', function(playTime) {
    // We hide the control panel of the video
    video.controls = false;
    playTime = parseInt(playTime);
    var startTime = video.currentTime;
    var endTime = startTime + playTime;
    playVideo(video, startTime, endTime);
});

// Function that plays a video for a choosed time
function playVideo(video, startTime, playTime) {
    // Function that checks the current time of the video to pause it or not
    function checkTime() {
        if (video.currentTime >= playTime) {
            video.pause();
            // We check if the video has reach the end to reload it
        } else if (video.currentTime == video.duration) {
            video.src = source;
        } else {
            // call checkTime every tenth of a second
            setTimeout(checkTime, 100);
        }
    }
    // We check if the video has reach the end
    if (video.currentTime != video.duration) {
        video.currentTime = startTime;
        video.play();
        checkTime();
        // if so, we set it back to 0 to start the video over
    } else {
        video.currentTime = 0;
    }
}

// We add the message to the list when receiving one
socket.on('messageFrom', function(id, message) {
    console.log('message received');
    var li = document.createElement('li');
    li.innerHTML = '<li>Server said : ' + message + '</li>';
    document.getElementById("messageList").appendChild(li);
});
