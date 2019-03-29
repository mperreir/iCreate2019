import de.voidplus.leapmotion.*;

import fisica.*;


FWorld world;

PImage img;  
PImage bg;
PImage textureArbre;

float len=90;
float theta=PI/6;
float r;

PGraphics shapeArbre;

Arbre arbre;

float lampX = -10;
float lampY = 10;
int lampW = 820;
int lampH = 1380;

PImage carte;
PImage carte1999;
PImage carte2016;
PImage lampadaire;

LeapMotion leap;

boolean etat_leap = true;
FenetreQuestion fenetreQuestion = new FenetreQuestion();

//Questionnaire
Questionnaire q;
String [] texte;
int [] scoreTrie;


void settings() {
  fullScreen(2);
}


void setup() {

  texte = loadStrings("Score.txt");
  frameRate(30);
  Fisica.init(this);

  world = new FWorld();
  arbre = new Arbre(world);

  leap = new LeapMotion(this).allowGestures("swipe");  // Leap detects only swipe gestures

  lampadaire = loadImage("lampadaire.png");
  lampadaire.resize(lampW, lampH);
  carte = loadImage("carte.png");
  carte1999 = loadImage("carte1999.png");
  carte2016 = loadImage("carte2016.png");
  carte1999.resize(width/2, height/4);
  carte2016.resize(width/2, height/4);
  carte.resize(width/2, height/4);


  fenetreQuestion.terrainShape = loadShape("terrain.svg");
  fenetreQuestion.logoLA = loadImage("logola.png");
  q= new Questionnaire();
  fenetreQuestion.setEtat(1);
  runSketch(new String[] { 
    "fenetreQuestion"
    }
    , fenetreQuestion);
}
int etatTranstionCarte = 300;
void draw() {
  background(0);
  //shape(shapeArbre,0,0);
  //image(textureArbre, 0, 0);
  arbre.step();
  world.step();
  arbre.draw();
  world.draw();

  if (fenetreQuestion.etat == 4) {
    image(lampadaire, lampX, lampY);
    if (etatTranstionCarte> 0) {
      image(carte1999, 0, 0);
      etatTranstionCarte--;
    }
    if (etatTranstionCarte >200) {

      image(carte, 0, 0);
    } else if (etatTranstionCarte >100) {
      image(carte1999, 0, 0);
    } else {
      image(carte2016, 0, 0);
    }
  }



  fenetreQuestion.hands = leap.getHands();
}

void mousePressed() {
  //arbre.feuillage(mouseX,mouseY,mouseX+100, mouseY+100);
  arbre.setTimeFrame(50);
  arbre.destroyLeaf(10);
}

void keyPressed() {
  println(keyCode);
  //arbre.reset();
  //traitementLampadaire();
  if (keyCode == 37) {
    println("Gauche");
    arbre.setTimeFrame(50);
    if (fenetreQuestion.etat == 2) {
      fenetreQuestion.etatQuestion_choix = 1;
      arbre.destroyLeaf((q.repondre(2)*100)/140);
      fenetreQuestion.setEtat(3);
    }
  }

  if (keyCode == 39) {
    println("Droite ");
    arbre.setTimeFrame(50);
    //arbre.destroyLeaf(20);
    if (fenetreQuestion.etat == 2) {
      fenetreQuestion.etatQuestion_choix = 2;
      arbre.destroyLeaf((q.repondre(1)*100)/140);
      fenetreQuestion.setEtat(3);
    }
  }

  if (keyCode == 38) {
    println("Haut");
    if (fenetreQuestion.etat == 1) {
      lancerQuestionnaire();
    }
  }
  //down to go down sizebrush 
  if (keyCode == 40) {
    println("Bas");
    if (fenetreQuestion.etat==4) {          
      q.stockScore();
      arbre.reset();
      etatTranstionCarte = 300;
      fenetreQuestion.setEtat(1);
    }
  }
}

void traitementLampadaire() {
  if (keyCode == 38) {
    lampY += 10;
  }
  //down to go down sizebrush 
  if (keyCode == 40) {
    lampY -= 10;
  }
  if (keyCode == 37) {
    lampX -= 10;
  }

  if (keyCode == 39) {
    lampX += 10;
  }

  //size
  if (key == 'd') {
    lampW += 10;
  }

  if (key == 'q') {
    lampW -= 10;
  }

  if (key == 'z') {
    lampH -= 10;
  }

  if (key == 's') {
    lampH += 10;
  }
  println(keyCode);
  lampadaire.resize(lampW, lampH);
  println(lampX, lampY, lampW, lampH);
}

PShape loadShapeFromJson(String file) {
  JSONArray values = loadJSONArray(file);
  PShape s = createShape();
  s.beginShape();

  s.texture(textureArbre);
  //s.fill(100);
  s.noStroke();
  for (int i = 0; i < values.size(); i++) {

    JSONObject point = values.getJSONObject(i); 

    float x = point.getFloat("x");
    float y = point.getFloat("y");
    //points.add(new Point(x,y));
    s.vertex(x, y);
  }
  s.endShape(CLOSE);


  return s;
}


PGraphics loadGraphicsFromJson(String file) {
  JSONArray values = loadJSONArray(file);
  PGraphics s = createGraphics(width, height);
  s.beginDraw();

  s.noStroke();
  s.beginShape();
  s.texture(textureArbre);
  for (int i = 0; i < values.size(); i++) {

    JSONObject point = values.getJSONObject(i); 

    float x = point.getFloat("x");
    float y = point.getFloat("y");
    //points.add(new Point(x,y));
    s.vertex(x, y);
  }
  s.endShape();

  s.endDraw();

  return s;
}

// ======================================================
// 1. Swipe Gesture
void leapOnSwipeGesture(SwipeGesture g, int state) {

  if (etat_leap) {
    int     id               = g.getId();
    Finger  finger           = g.getFinger();
    PVector position         = g.getPosition();
    PVector positionStart    = g.getStartPosition();
    PVector direction        = g.getDirection();
    float   speed            = g.getSpeed();
    long    duration         = g.getDuration();
    float   durationSeconds  = g.getDurationInSeconds();

    switch(state) {
    case 1: // Start
      break;
    case 2: // Update

      break;
    case 3: // Stop
      println("SwipeGesture: " + direction);
      if (direction.x > 60) { //droite 
        println("Droite ");
        arbre.setTimeFrame(50);
        //arbre.destroyLeaf(20);
        if (fenetreQuestion.etat == 2) {
          fenetreQuestion.etatQuestion_choix = 2;
          arbre.destroyLeaf((q.repondre(1)*100)/140);
          fenetreQuestion.setEtat(3);
        }
      } else if (direction.x < -50) { //gauche 
        println("Gauche");
        arbre.setTimeFrame(50);
        if (fenetreQuestion.etat == 2) {
          fenetreQuestion.etatQuestion_choix = 1;
          arbre.destroyLeaf((q.repondre(2)*100)/140);
          fenetreQuestion.setEtat(3);
        }
      }
      if (direction.y > 80) { //gauche 
        println("Haut");
        if (fenetreQuestion.etat == 1) {
          lancerQuestionnaire();
        }
      } else if (direction.y < -80) { //gauche 
        println("Bas");
        if (fenetreQuestion.etat==4) {          
          q.stockScore();
          arbre.reset();
          etatTranstionCarte = 300;
          fenetreQuestion.setEtat(1);
        }
      }
      break;
    }
  }
}


void lancerQuestionnaire() {
  fenetreQuestion.setEtat(2);
  q = new Questionnaire();
}

// ======================================================
// 2. Circle Gesture

void leapOnCircleGesture(CircleGesture g, int state) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector positionCenter   = g.getCenter();
  float   radius           = g.getRadius();
  float   progress         = g.getProgress();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  int     direction        = g.getDirection();

  switch(state) {
  case 1: // Start
    break;
  case 2: // Update
    break;
  case 3: // Stop
    println("CircleGesture: " + id);
    break;
  }

  switch(direction) {
  case 0: // Anticlockwise/Left gesture
    break;
  case 1: // Clockwise/Right gesture
    break;
  }
}


// ======================================================
// 3. Screen Tap Gesture

void leapOnScreenTapGesture(ScreenTapGesture g) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  println("ScreenTapGesture: " + id);
}


// ======================================================
// 4. Key Tap Gesture

void leapOnKeyTapGesture(KeyTapGesture g) {
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  println("KeyTapGesture: " + id);
}
