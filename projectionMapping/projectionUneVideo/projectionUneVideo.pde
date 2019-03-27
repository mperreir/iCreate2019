import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;


//Initialize variables
OpenCV opencvNom;
OpenCV opencvVille;
OpenCV opencvDispute;
Rectangle[] faces;
Movie discours; 
Movie nom;
Movie ville;
Movie dispute;

boolean nomPlayed = false;
boolean villePlayed = false;
boolean disputePlayed = false;

int visitorWidth =600;
int visitorHeight = 450;

void setup() {
  size(1440, 1080);
  
  // Initialize Movie object.
  discours = new Movie(this, "discours.mp4");  
  nom = new Movie(this, "nom.mp4");
  ville = new Movie(this, "ville.mp4");
  dispute = new Movie(this, "dispute.mp4");
  discours.play();
  opencvNom = new OpenCV(this, visitorWidth, visitorHeight);
  opencvNom.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  opencvVille = new OpenCV(this, visitorWidth, visitorHeight);
  opencvVille.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  opencvDispute = new OpenCV(this, visitorWidth, visitorHeight);
  opencvDispute.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

// Read new frames from the movie.
void movieEvent(Movie movie) {  
  movie.read();
}

void draw() {
    print(discours.time()+"\n");
    image(discours, 0, 0,1440,1080);
    if(discours.time() >= 35) {
      playNom();
    } else if(discours.time() >= 69.5) {
      playVille();
    } else if(discours.time() >= 96.5) {
      playDispute();
    } else if(nom.time()>=nom.duration()) {
      print(nom.time()+"\n");
      discours.play();
    } else if(ville.time()>=ville.duration()) {
      discours.play();
    } else if(dispute.time()>=dispute.duration()) {
      discours.play();
    }
      
  
}

void playNom(){
  if(!nomPlayed){
    discours.pause();
    nom.play();
    nomPlayed=true;
  }
  while (nom.height == 0 )  delay(10); 
  opencvNom.loadImage(nom);
  faces = opencvNom.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(nom, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

void playVille(){
  if(!villePlayed){
    discours.pause();
    ville.play();
    villePlayed=true;
  }
  while (ville.height == 0 )  delay(10); 
  opencvVille.loadImage(ville);
  faces = opencvVille.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(ville, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

void playDispute(){
  if(!disputePlayed){
    discours.pause();
    dispute.play();
    disputePlayed=true;
  }
  while (dispute.height == 0 )  delay(10); 
  opencvDispute.loadImage(dispute);
  faces = opencvDispute.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(dispute, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}
