import processing.serial.*;
import processing.sound.*;
import processing.video.*;
Serial myPort;
App myApp = new App();
int x = 0;
int moveRate = 30;
int rangePlanet = 25;
boolean on = false;
boolean off = true;
SoundFile currentSound;
SoundFile intro;
SoundFile tuto;
SoundFile tutoDiscover;
SoundFile newPlanet1;
SoundFile newPlanet2;
SoundFile newPlanet3;
SoundFile keplerDesc;
SoundFile cancriDesc;
SoundFile trappistDesc;
Movie inRangeMovie;
Movie kepler, cancri, trappist;
int xKepler = 0, xCancri = 680, xTrappist = 1300;
int movieSize = 400;
int xScreen = width/2, yScreen = height/2, zoom = 0;
boolean isZoomEnabled = false;
boolean zooming;
boolean zoomOn = false;
boolean zoomIn = false;
int seuilZoom = 500;
int tx, ty;
int myZoom;
boolean moveAllowed = true;

void setup() {
  fullScreen(P3D);
  tx = 0;
  ty = 0;
  myZoom = 0;
  //Important : se câler sur la valeur en haud du prog Arduino (9600)
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  //Chargement des différents sons utilisés
  intro = new SoundFile(this, "intro.wav");
  tuto = new SoundFile(this,"tuto.wav");
  tutoDiscover = new SoundFile(this,"tuto planete proche.wav");
  newPlanet1 = new SoundFile(this,"planete proche 1.wav");
  newPlanet2 = new SoundFile(this,"planete proche 2.wav");
  newPlanet3 = new SoundFile(this,"planete proche 3.wav");
  keplerDesc = new SoundFile(this,"kepler.wav");
  cancriDesc = new SoundFile(this,"cancri.wav");
  trappistDesc = new SoundFile(this,"trappist.wav");
  currentSound = intro;
  inRangeMovie = null;
  //Chargement des motions (les planètes)
  kepler = new Movie(this,"kepler.mp4");
  cancri = new Movie(this,"cancri.mp4");
  trappist = new Movie(this,"trappist.mp4");
  kepler.loop();
  cancri.loop();
  trappist.loop();
  zooming = false;
  frameRate(1000);
}
  
void draw() {
  translate(tx,ty,myZoom);
  iZoom();
  if(on && !off){
    background(0);
    image(kepler,xKepler,(height-movieSize)/2,movieSize,movieSize);
    image(cancri,xCancri,(height-movieSize)/2,movieSize,movieSize);
    image(trappist,xTrappist,(height-movieSize)/2,movieSize,movieSize);
  }
  if(!on && off){
    background(0);
  }
}

void iZoom(){
   if (zoomOn && zoomIn){
    if (myZoom < seuilZoom){
      myZoom+=2; 
    }
  }
  if (zoomOn && !zoomIn){
    if (myZoom > 0){
      myZoom--;
    }
    else{
      zoomOn = false;
    }
  }
}
   
void serialEvent (Serial myPort) {
   String inBuffer = myPort.readStringUntil('\n');
   String list[] = split(inBuffer,',');
   for (String elem : list){
     println(elem);
   }
   if(!currentSound.isPlaying() && !zooming){
     //On ne prend en compte que les données complètes
     if(list.length >= 4) {
       myApp.listen(list);
     } 
   }
}

void movieEvent(Movie m) {
  m.read();
}

/*
0 Capteur On/Off
1 Droite
2 Gauche
3 Zoom
*/
class App {
    float coordX;
    State state;
    ArrayList<Integer> coordPlanets;
    // Indique la planète la plus proche (s'il y en a une dans la range du focus)
    String close;
    boolean discoveredPlanet;

    App(){
        coordX = width/2;
        state = new Off(this);
        close = null;
        discoveredPlanet = false;
    }

    void turn(){
        state.turn();
    }
    void zoom(){
        state.zoom();
    }
    void moveRight(){
        state.moveRight();
    }
    void moveLeft(){
        state.moveLeft();
    }
    
    void listen(String list[]){
        //Les valeurs entières indiquées dans les conditions qui suivent sont les paramètres de seuillage pour chaque capteur piezo
        if(int(list[0]) > 30) {
          //Allume ou éteind le système
          this.turn();
        }
        // Capteur manivelle gauche
        else if(int(list[1]) > 20) {
          //Déplacement du focus vers la gauche du système
          this.moveLeft();
        }
        // Capteur manivelle droite
        else if(int(list[2]) > 20) {
          //Déplacement du focus vers la droite du système
          this.moveRight();
        }
        // Capteur zoom
        else if(int(list[3]) > 10) {
          //Zoom sur la planète ciblée par le focus
          this.zoom();
        }
    }
}

//Début du patron ETAT

abstract class State {
    String name;
    App app;
    void turn(){}
    void zoom(){}
    void moveRight(){}
    void moveLeft(){}
    void run(){}
}

class Off extends State{
    Off(App a){
        this.app = a;
        name = "Off";
    }
    // Allume le système
    void turn(){
      app.state = new Galaxy(app);
      on = true;
      off = false;
      currentSound = intro;
      intro.play();
      delay(9000);
      currentSound = tuto;
      tuto.play();
    }
}

abstract class On extends State{
    On(App a){
        this.app = a;
    }
}

class Galaxy extends On{
    Galaxy(App a){
        super(a);
        name = "Galaxy";
    }
    // Eteind le système
    void turn(){
      app.state = new Off(app);
      on = false;
      off = true;
      app.discoveredPlanet = false;
    }
    // Déplacement du focus vers la gauche du système
    void moveLeft(){
      xKepler += moveRate;
      xCancri += moveRate;
      xTrappist += moveRate;
      isSomePlanetClose();
    }
    // Déplacement du focus vers la gauche du système
    void moveRight(){
      xKepler -= moveRate;
      xCancri -= moveRate;
      xTrappist -= moveRate;
      isSomePlanetClose();
    }
    
    //Vérifie si une planète est dans la range du focus
    void isSomePlanetClose(){
      if(xKepler >= width/2-rangePlanet && xKepler <= width/2+rangePlanet){
         if(app.close != "kepler"){
           app.close = "kepler";
           planetDiscovered();
         }
      }
      else if(xCancri >= width/2-rangePlanet && xCancri <= width/2+rangePlanet){
        if(app.close != "cancri"){
          app.close = "cancri";
          planetDiscovered();
        }
      }
      else if(xTrappist >= width/2-rangePlanet && xTrappist <= width/2+rangePlanet){
        if(app.close != "trappist"){
          app.close = "trappist";
          planetDiscovered();
        }
      }
      else{
        app.close = null;
      }
    }
    //Lancement d'un son lorsqu'une planète est découverte
    void planetDiscovered(){
      if(!app.discoveredPlanet){
        currentSound = tutoDiscover;
        tutoDiscover.play();
        app.discoveredPlanet = true;
      }
      else{
        SoundFile[] newPlanets = {newPlanet1,newPlanet2,newPlanet3};
        int index = int(random(newPlanets.length));
        currentSound = newPlanets[index];
        newPlanets[index].play();
      }
    }
    
    // Zoome sur la planète qui se trouve dans la range du focus
    void zoom(){
      if(app.close != null && !zoomIn) {
        zooming = true;
        switch(app.close){
          case "kepler":
            app.state = new Planet(app,"kepler",xKepler);
            delay(21000);
            zoomIn = false;
            break;
          case "cancri":
            app.state = new Planet(app,"cancri",xCancri);
            delay(14000);
            zoomIn = false;
            break;
          case "trappist":
            println("In Trappist");
            app.state = new Planet(app,"trappist",xTrappist);
            delay(18000);
            zoomIn = false;
            break;
        }
        
      }
    }
}

class Planet extends On{
  
  int xPlanet;
  boolean rightTo;
  
    Planet(App a, String planet, int xPlanet){
        super(a);
        this.name = planet;
        this.xPlanet = xPlanet;
        this.rightTo = this.name == app.close;
        focus();
    }
    
    //Action permettant de zoomer sur une planète en particulier (celle dans la renge du focus) et de lancer le fichier audio qui la décrit
    void focus(){
      if(rightTo){
        centerPlanet();
        zoomScreen();
        describePlanet();        
        zoomOn = true;
        zoomIn = true;
        app.state = new Galaxy(app);
        zooming = false;
      }  
    }
    
    void centerPlanet(){
        int diff = width/2 - this.xPlanet;
        xKepler += diff - movieSize/2;
        xCancri += diff - movieSize/2;
        xTrappist += diff - movieSize/2;
    }
    
    void zoomScreen(){
      zoom += 50;
      isZoomEnabled = true;
    }
    
    void describePlanet(){
        if(this.name == "kepler"){
          currentSound = keplerDesc;
          keplerDesc.play();
        }
        else if(this.name == "cancri"){
          currentSound = cancriDesc;
          cancriDesc.play();
        }
        else if(this.name == "trappist"){
          currentSound = trappistDesc;
          trappistDesc.play(); 
        }
    }
    
}
