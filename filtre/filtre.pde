import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
OpenCV opencv;
Rectangle[] faces;
Capture video;

void setup() {
  size(640, 480);
  background(0);
  
  video = new Capture(this, width, height);
  video.start();

  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}

void draw() {
  if (video.available()) {
    video.read();
    
    opencv.loadImage(video);
    video.loadPixels();
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    faces = opencv.detect();
    for (int i = 0; i < faces.length; i++) {
      image(video, 200,200,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
    }
  }
}

void mousePressed() {
    recording = !recording;
    begin = millis();
    time = duration;
}
