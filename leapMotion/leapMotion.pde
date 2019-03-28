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


LeapMotion leap;

boolean etat_leap = true;
FenetreQuestion fenetreQuestion = new FenetreQuestion();

//Questionnaire
Questionnaire q;
String [] texte;
int [] scoreTrie;


void settings() {
  fullScreen(3);
}


void setup() {
  
  texte = loadStrings("Score.txt");
  frameRate(30);
  Fisica.init(this);
  textureArbre = loadImage("img/texturearbre.jpg");
  textureArbre.resize(width, height);

  world = new FWorld();
  arbre = new Arbre(world);

  shapeArbre = loadGraphicsFromJson("data/tronc.json");
  textureArbre.mask(shapeArbre);

  leap = new LeapMotion(this).allowGestures("swipe");  // Leap detects only swipe gestures

  fenetreQuestion.terrainShape = loadShape("terrain.svg");
  fenetreQuestion.logoLA = loadImage("logola.png");
  q= new Questionnaire();
  fenetreQuestion.setEtat(1);
  runSketch(new String[] { 
    "fenetreQuestion"
    }
    , fenetreQuestion);
}

void draw() {
  background(255);
  //shape(shapeArbre,0,0);
  image(textureArbre, 0, 0);
  arbre.step();
  world.step();
  world.draw();
  
  fenetreQuestion.hands = leap.getHands();
}

void mousePressed() {
  //arbre.feuillage(mouseX,mouseY,mouseX+100, mouseY+100);
  arbre.setTimeFrame(50);
  arbre.destroyLeaf(10);
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
        //arbre.destroyLeaf(20);
        if (fenetreQuestion.etat == 2) {
          fenetreQuestion.etatQuestion_choix = 2;
          arbre.destroyLeaf(q.repondre(1));

          fenetreQuestion.setEtat(3);
        }
      } else if (direction.x < -50) { //gauche 
        println("Gauche");
        if (fenetreQuestion.etat == 2) {
          fenetreQuestion.etatQuestion_choix = 1;
          arbre.destroyLeaf(q.repondre(2));
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
        if(fenetreQuestion.etat==4){          
          q.stockScore();
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
