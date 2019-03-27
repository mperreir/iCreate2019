import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;


//Initialize variables

OpenCV opencv;
Rectangle[] faces;
Movie visitor;

boolean recording=false;

void setup() {
  size(640, 480);
  
  // Initialize Movie object.
  visitor = new Movie(this, "nom.mp4");
  visitor.play();
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}

// Read new frames from the movie.
void movieEvent(Movie movie) {  
  movie.read();
}

void draw() {
  if(recording){
    saveFrame("output/visitor.tif");
    exit();
  }
  while (visitor.height == 0 )  delay(10); 
  opencv.loadImage(visitor);
  faces = opencv.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(visitor,0 ,0,640,480,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
  
}

void keyPressed() {
 recording=true;
}
