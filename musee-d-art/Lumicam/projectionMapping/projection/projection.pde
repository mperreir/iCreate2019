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
color c;

void setup() {
  fullScreen();
  background(0);
  //On utilise la webcam fourni par l'école ici Microsoft LifeCam
  video = new Capture(this, 640, 480,"Microsoft LifeCam HD-5000");
  
  visitor = loadImage("visitor.tif");
  // Initialize Movie object.
  discours = new Movie(this, "discours.mp4");  
  nom = new Movie(this, "nom.mp4");
  ville = new Movie(this, "ville.mp4");
  dispute = new Movie(this, "dispute.mp4");
  // Ouverture de la webcam pour le color tracking
  video.start();
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
  //On regarde si la couleur a bien été détecter
  if(colorDetect) {
    //On affiche la vidéo des 2 comédiens
    image(discours, 0, 0,discours.width,discours.height);
    // On affiche la tête du visiteur ou une vidéo du visiteur en fonction de l'avancement de la vidéo
    if(discours.time() >= 35.5 && discours.time() <=36 && nom.time()<nom.duration()) {
      playNom();
    } else if(discours.time() >= 70 && discours.time() <=70.5  && ville.time()<ville.duration()) {
      playVille();
    } else if(discours.time() >= 97.5 && discours.time() <=98  && dispute.time()<dispute.duration()) {
      playDispute();
    } else {
      image(visitor,650,780,130,130);
    }
    //On arrête la vidéo lorsque celle ci est finie, et on remet la détection de la couleur lorsque la vidéo des comédiens est finie
    if(nomPlayed && nom.time()>=nom.duration()) {
      nom.stop();
      discours.play();
      discours.jump(38.3);
      nomPlayed=false;
    } else if(villePlayed && ville.time()>=ville.duration()) {
      ville.stop();
      discours.play();
      discours.jump(72);
      villePlayed=false;
    } else if(disputePlayed && dispute.time()>=dispute.duration()) {
      dispute.stop();
      discours.play();
      discours.jump(102);
      disputePlayed=false;
    }
    else if(discours.time()>=discours.duration()){
     colorDetect=false; 
     background(0);
    }
  }
  else {
    colorTracking();
  }
}

//Fonction qui découpe et affiche la tête du visiteur de la vidéo "Nom"
void playNom(){
  //On lance la vidéo en mettant le discours des 2 comédiens en pause
  if(!nomPlayed){
    discours.pause();
    nom.play();
    nomPlayed=true;
    opencvNom = new OpenCV(this, nom.width, nom.height);
    opencvNom.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  //Découpage de la tête du visiteur
  while (nom.height == 0 )  delay(1); 
  opencvNom.loadImage(nom);
  faces = opencvNom.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
        image(nom, 650,780,130,130,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

//Fonction qui découpe et affiche la tête du visiteur de la vidéo "Ville"
void playVille(){
  //On lance la vidéo en mettant le discours des 2 comédiens en pause
  if(!villePlayed){
    discours.pause();
    ville.play();
    villePlayed=true;
    opencvVille = new OpenCV(this, ville.width, ville.height);
    opencvVille.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  //Découpage de la tête du visiteur
  while (ville.height == 0 )  delay(1); 
  opencvVille.loadImage(ville);
  faces = opencvVille.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
        image(ville, 650,780,130,130,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

//Fonction qui découpe et affiche la tête du visiteur de la vidéo "Dispute"
void playDispute(){
  //On lance la vidéo en mettant le discours des 2 comédiens en pause
  if(!disputePlayed){
    discours.pause();
    delay(10);
    dispute.play();
    disputePlayed=true;
    opencvDispute = new OpenCV(this, dispute.width, dispute.height);
    opencvDispute.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  //Découpage de la tête du visiteur
  while (dispute.height == 0 )  delay(1); 
  opencvDispute.loadImage(dispute);
  faces = opencvDispute.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
        image(dispute, 650,780,130,130,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

//Fonction qui détecte la couleur voulu
void colorTracking() {
  //On affiche l'image renvoyée par la webcam
 video.loadPixels();
  image(video, 0, 0,100,100);

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      color currentColor = video.pixels[loc];
      
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      
      //On regarde si on a une couleur spécifique à la webcam
     if(r1>=80 && r1<=90 && b1>=55 && b1<=65 && g1>=125 && g1<=1350) {
        //delay(5000);
        video.stop();
        
        // On lance la vidéo des comédiens
        discours.play();
        colorDetect=true;
     }
    }
  }
}
