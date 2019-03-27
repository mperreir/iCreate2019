import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;


//Initialize variables
PImage visitor;
OpenCV opencvNom;
OpenCV opencvVille;
OpenCV opencvDispute;
Rectangle[] faces;
Movie discours; 
Movie nom;
Movie ville;
Movie dispute;
Capture video;

boolean nomPlayed = false;
boolean villePlayed = false;
boolean disputePlayed = false;
boolean colorDetect = false;
color trackColor; 
color c;
float rc ;      
float gc ;      
float bc ;  

void setup() {
  size(1440, 1080);
  

  // Start off tracking for red
  trackColor = color(255, 0, 0);
  visitor = loadImage("visitor.tif");
  // Initialize Movie object.
  discours = new Movie(this, "discours.mp4");  
  nom = new Movie(this, "nom.mp4");
  ville = new Movie(this, "ville.mp4");
  dispute = new Movie(this, "dispute.mp4");
  //discours.play();
  nom.loop();
  nom.play();
}



// Read new frames from the movie.
void movieEvent(Movie movie) {  
  movie.read();
}

void draw() {
    image(discours, 0, 0,1440,1080);
    image(nom,650,650,150,150);

}
