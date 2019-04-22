import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Movie actualVideo = null;
boolean firstVideoStarted = false;
boolean transition = false;
boolean transition1 = false;
boolean transition2 = false;
boolean transitionning = false;
float firstDuration = 0.0;

float pourcent = 0.0;

String oldpays = "";
String pays = "";

String file = "";

JSONObject jsonExp, jsonC;
JSONObject items;

final int COMPTEUR =1;
final float TEMPSTRANSI = 10000;
float timeTransi = 0;
float f1, f2, f3 = 0.;
String v1 = "0";

String oldFilm = "";
String Film = "";
String VideoAlancer = "";

Boolean premierPassage = false;
Boolean premierPassageTransi = false;

int compteurMoy = 1;
float moyenneAzy, someAzy=0;
float deltaAzy = 0;
float rotationAngle = 0;
int largeurTransition = 6;

int center = 300;
void setup() {

  size(1200, 800);
  frameRate(60);

  jsonExp = loadJSONObject("expeditions_pays.json");
  jsonC = loadJSONObject("Liaison_Carte.json");
  println(jsonC);

  oscP5 = new OscP5(this, 12000);//listening to port 12000
  myRemoteLocation = new NetAddress("192.168.137.231", 12000);// remote location is the adress ip from the phone + port where phone is listening
}


void draw() {

  DrawCompass((moyenneAzy), 400);
  drawArrow(300, 250, 300, 350, 10, 0, true);
  //println("PASSAGE = "+premierPassage+" PASSAGETRANSI = "+premierPassageTransi);
  if (premierPassage) {
    checkVideo(moyenneAzy);
    file = VideoAlancer + "_" + Film + ".mp4";
    println(file);
    println("pc : "+pourcent);
    afficheVideo(pourcent, file);
  }
  
}

void movieEvent(Movie m) {
  m.read();
}

void mousePressed() {

  OscMessage myMessage = new OscMessage("JE SUIS L'ORDINATEUR");

  myMessage.add(123); /* add an int to the osc message */


  oscP5.send(myMessage, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/orientation"))
  {
    //println(" typetag: "+theOscMessage.typetag());
    f1 = theOscMessage.get(0).floatValue();
    f2 = theOscMessage.get(1).floatValue();
    f3 = theOscMessage.get(2).floatValue();
    //println(" values: "+f1+" "+f2+" "+f3);
    if (compteurMoy<=COMPTEUR) {
      someAzy+=f1;
      compteurMoy++;
    } else {
      moyenneAzy = someAzy/(compteurMoy-1);
      someAzy = 0;
      compteurMoy = 1;
      // println("Moyenne = "+moyenneAzy+" Valeur Actuelle"+f1);
      // DrawCompass((radians(moyenneAzy-deltaAzy)),150);
      rotationAngle = moyenneAzy - deltaAzy;
      deltaAzy = moyenneAzy;
    }
  }
  if (theOscMessage.addrPattern().equals("/nfc"))
  {

    v1 = theOscMessage.get(0).stringValue();
    char[] a = v1.toCharArray();
    int id = (int)a[0]+(int)a[1]+(int)a[2];
    println("ID = "+str(id));
    premierPassage = true;
    items = jsonC.getJSONObject(str(id));
    VideoAlancer = items.getString("Pays");
  }
}

void drawArrow(float x0, float y0, float x1, float y1, float beginHeadSize, float endHeadSize, boolean filled) {

  PVector d = new PVector(x1 - x0, y1 - y0);
  d.normalize();

  float coeff = 1.5;

  strokeCap(SQUARE);

  line(x0+d.x*beginHeadSize*coeff/(filled?1.0f:1.75f), 
    y0+d.y*beginHeadSize*coeff/(filled?1.0f:1.75f), 
    x1-d.x*endHeadSize*coeff/(filled?1.0f:1.75f), 
    y1-d.y*endHeadSize*coeff/(filled?1.0f:1.75f));

  float angle = atan2(d.y, d.x);

  if (filled) {
    // begin head
    pushMatrix();
    translate(x0, y0);
    rotate(angle+PI);
    triangle(-beginHeadSize*coeff, -beginHeadSize, 
      -beginHeadSize*coeff, beginHeadSize, 
      0, 0);
    popMatrix();
    // end head
    pushMatrix();
    translate(x1, y1);
    rotate(angle);
    triangle(-endHeadSize*coeff, -endHeadSize, 
      -endHeadSize*coeff, endHeadSize, 
      0, 0);
    popMatrix();
  } else {
    // begin head
    pushMatrix();
    translate(x0, y0);
    rotate(angle+PI);
    strokeCap(ROUND);
    line(-beginHeadSize*coeff, -beginHeadSize, 0, 0);
    line(-beginHeadSize*coeff, beginHeadSize, 0, 0);
    popMatrix();
    // end head
    pushMatrix();
    translate(x1, y1);
    rotate(angle);
    strokeCap(ROUND);
    line(-endHeadSize*coeff, -endHeadSize, 0, 0);
    line(-endHeadSize*coeff, endHeadSize, 0, 0);
    popMatrix();
  }
}

void DrawCompass(float rotate, int size) {
  pushMatrix();
  rectMode(CENTER);
  translate(center, center); 
  rotate(radians(rotate));
  /*============================Affichage de la boussolle=========================================*/
  fill(255, 255, 0);
  arc(0, 0, size, size, 0, HALF_PI, PIE);
  fill(255, 0, 255);
  arc(0, 0, size, size, HALF_PI, PI, PIE);
  fill(0, 255, 255);
  arc(0, 0, size, size, PI, 3*HALF_PI, PIE);
  fill(127, 127, 127);
  arc(0, 0, size, size, 3*HALF_PI, 2*PI, PIE);
  /*============================Affichage des bordures=========================================*/

  fill(255, 255, 255);
  arc(0, 0, size, size, 0-HALF_PI/largeurTransition, HALF_PI/largeurTransition, PIE);
  fill(255, 255, 255);
  arc(0, 0, size, size, HALF_PI-HALF_PI/largeurTransition, HALF_PI+HALF_PI/largeurTransition, PIE);
  fill(255, 255, 255);
  arc(0, 0, size, size, PI-HALF_PI/largeurTransition, PI+HALF_PI/largeurTransition, PIE);
  fill(255, 255, 255);
  arc(0, 0, size, size, -HALF_PI-HALF_PI/largeurTransition, -HALF_PI+HALF_PI/largeurTransition, PIE);

  fill(0, 0, 0);
  text("Spon", 50, 50);
  text("Serr", -50, 50);
  text("Exo", 50, -50);
  text("Medi", -50, -50);
  popMatrix();
}


void checkVideo(float angle)
{
  float value = radians(angle);
  println(value);
  //println(2*PI-HALF_PI/largeurTransition);
  String ValTransi= "";
  //Determiner valeurs Globale
  if (value > 0 && value < HALF_PI) {
    Film="E Médic";
  }
  if (value > HALF_PI && value < PI) {
    Film="E Serres";
  };
  if (value > PI && value < 3*HALF_PI) {
    Film="E Spon";
  }
  if (value > 3*HALF_PI && value < 2*PI) {
    Film="E Exotic";
  }
  
  transitionning = false;
  //println("========VALUE= "+value+"=================");
  //Determiner Valeurs Transitions
  if ((value > 2*PI-HALF_PI/largeurTransition && value < 2*PI) || value < 0+HALF_PI/largeurTransition) {
   // println("MEDIEXO");
    ValTransi="Transition entre MEDI et EXO";
    calculTransi(value, 2*PI-HALF_PI/largeurTransition, 2*PI, 0, 0+HALF_PI/largeurTransition);
  }else
  if (value > HALF_PI-HALF_PI/largeurTransition && value < HALF_PI+HALF_PI/largeurTransition) {
  //   println("SERREMEDI");
    ValTransi="Transition entre SERRE et MEDI";
    calculTransi(value, HALF_PI-HALF_PI/largeurTransition, HALF_PI, HALF_PI, HALF_PI+HALF_PI/largeurTransition);
  }else
  if (value > PI-HALF_PI/largeurTransition && value < PI+HALF_PI/largeurTransition) {
   //  println("SPONTSERRE");
    ValTransi="Transition entre SPONT et SERRE";
    calculTransi(value, PI-HALF_PI/largeurTransition, PI, PI, PI+HALF_PI/largeurTransition);
  }else
  if (value > 3*HALF_PI-HALF_PI/largeurTransition && value < 3*HALF_PI+HALF_PI/largeurTransition) {
   //  println("EXOSPONT");
    ValTransi="Transition entre EXO et SPONT";
    calculTransi(value, 3*HALF_PI-HALF_PI/largeurTransition, 3*HALF_PI, 3*HALF_PI, 3*HALF_PI+HALF_PI/largeurTransition);
  } else {
   // println("Pas de transitions donc Premier PassageTransi = false");
    premierPassageTransi = false;
  }
  
  if (!Film.equals(oldFilm)) {
    println("chgm film, old : " + oldFilm + " new : " + Film);
    firstVideoStarted = false;
    oldFilm = Film;
  }
  
  int Type = 0;
  //if (premierPassage)Type = jsonExp.getJSONObject(items.getString("Pays")).getInt(Film);
  pushMatrix();
  rectMode(CENTER);
  translate(center, center-200);
  fill(127, 127, 127);
  rect(0, 0, 300, 100);
  fill(255, 255, 255);
  text(Film, -100, 0);
  text(ValTransi, -100, 20);
  text(VideoAlancer + "   " + Type, -100, 40);
  popMatrix();
}

void calculTransi(float value, float bBD, float bHD, float bBG, float bHG)
{
  transitionning = true;
  Film = "transition";
  
  if (!premierPassageTransi)
  {
   // println("Passage Dans permierpassaga");
    premierPassageTransi = true; 
    timeTransi = millis();
  }

  println("premierPassage = " + premierPassageTransi +"    " + (millis()-timeTransi));
  if ((millis()-timeTransi)<TEMPSTRANSI)
  {
    println(value + " bBD : " + bBD+ " bmapDroite : " + bHD+ " bBG : " + bBG+ " bHG : " + bHG );
    float mapGauche = map(value, bBG, bHG, 0, 99);
    float mapDroite = map(value, bBD, bHD, 99, 0);

    if (mapGauche > 99  || mapGauche < 0) {
      mapGauche = 0;
    }
    if (mapDroite > 99  || mapDroite < 0) {
      mapDroite = 0;
    }
    
    if (mapDroite > mapGauche) transition2 = true;
    
    if (mapDroite < mapGauche) transition1 = true;
    
    println("t1 : "+transition1 + " t2 : "+transition2);
    
    if (transition1) pourcent = mapGauche;
    else if (transition2) pourcent = mapDroite;
    
    if ((mapDroite > mapGauche && transition1) || (mapDroite < mapGauche && transition2)) {
      transition = false;
      transition1 = false;
      transition2 = false;
    }
    
    println(mapGauche + "   " + mapDroite);

    //Dessin des rectangles de lancements des vidéos
    pushMatrix();
    rectMode(CORNER);
    translate(10, 10);
    /*BackRect*/
    fill(127, 127, 127);
    rect(-10, -10, 60, 110);
    /*RECT MAPGAUCHE*/
    fill(255, 0, 255);
    rect(0, 0, 20, mapGauche);
    /*RECT MAPGAUCHE*/
    fill(0, 255, 255);
    rect(20, 0, 20, mapDroite);
    popMatrix();
  } else
  {
    println("PassageDAnsELSE");
    premierPassage = false;
    //premierPassageTransi = false;
  }
}

void majVideo1(String fileN) {
  image(actualVideo, 600, 400, 640, 360);
}

void majVideo1Time(float time, String fileN) {
  actualVideo.jump(time);
  image(actualVideo, 600, 400, 640, 360);
}

void afficheVideo(float pourcent, String fileName) {
  if (!firstVideoStarted) {
    if (actualVideo != null) actualVideo.stop();
    actualVideo = null;
    println("Load video...");
    actualVideo = new Movie(this, fileName);
    actualVideo.playbin.setVolume(0);
    actualVideo.play();
    firstDuration = actualVideo.duration();
    firstVideoStarted = true;
    println("Video loaded.");
  }
  if (transitionning) {
    if (!transition) {
      if (actualVideo != null) actualVideo.stop();
      actualVideo = null;
      actualVideo = new Movie(this, fileName);
      actualVideo.playbin.setVolume(0);
      actualVideo.play();
      firstDuration = actualVideo.duration();
      firstVideoStarted = true;
      transition = true;
    }
    float time = map(pourcent, 0, 100, 0.0, firstDuration);
    time = constrain(time, 0, firstDuration);
    //println("time : "+time);
    majVideo1Time(time, fileName);
  } else {
    //println("Maj video ...");
    majVideo1(fileName);
  }
}
