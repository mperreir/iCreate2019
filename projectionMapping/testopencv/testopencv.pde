import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

//Initialize variables
OpenCV opencv;
Rectangle[] faces;
Movie movie1; 
Movie movieVisitor;
boolean visitorPlayed=true;
void setup() {  
  size(1440, 1080);  

  // Initialize Movie object.
  movie1 = new Movie(this, "discours.mp4");  
  movieVisitor = new Movie(this, "movie.mp4");
  opencv = new OpenCV(this, 720, 1080);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  

  // Start playing movie.
  movie1.loop();

}

// Read new frames from the movie.
void movieEvent(Movie movie) {  
  movie.read();
}

// Step 5. Display movie.
void draw() {
  image(movie1, 0, 0,1440,1080);
  //Movie needs time to load into canvas, so we wait until we get a height
  if(movie1.time()>=20) {
      if(visitorPlayed) {
        visitorPlayed = false;
        movieVisitor.play();
      }
     while (movieVisitor.height == 0 )  delay(10); 
     opencv.loadImage(movieVisitor);
     faces = opencv.detect();
  
  
    if (faces != null) {
      for (int i = 0; i < faces.length; i++) {
          image(movieVisitor, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
        }
    }
  }
  
}
