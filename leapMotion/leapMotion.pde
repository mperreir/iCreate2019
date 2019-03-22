import de.voidplus.leapmotion.*;

import fisica.*;

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

int etatFenetre=3;
boolean etat_leap = true;
FenetreQuestion fenetreQuestion = new FenetreQuestion();

void settings() {
  fullScreen();
  
}


void setup() {

  Fisica.init(this);
  frameRate(30);
  Fisica.init(this);
  bg = loadImage("img/arbre.jpg");
  textureArbre = loadImage("img/texture-1.png");
  textureArbre.resize(width,height);
  
  bg.resize(width,height);
  background(bg);
  world = new FWorld();
  arbre = new Arbre(world);
  
  shapeArbre = loadGraphicsFromJson("data/test.json");
  textureArbre.mask(shapeArbre);
  
  leap = new LeapMotion(this).allowGestures("swipe");  // Leap detects only swipe gestures

  fenetreQuestion.terrainShape = loadShape("terrain.svg");

  fenetreQuestion.setEtat(etatFenetre);


    
background(bg);
  //shape(shapeArbre,0,0);
  image(textureArbre, 0, 0);
  arbre.step();
  world.step();
  world.draw();
  
    runSketch(new String[] { 
    "fenetreQuestion"
    }
    , fenetreQuestion);
  
}

void mousePressed() {
  //arbre.feuillage(mouseX,mouseY,mouseX+100, mouseY+100);
  arbre.setTimeFrame(50);
  arbre.destroyZone(200,200,mouseX,mouseY);
}

PShape loadShapeFromJson(String file){
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


PGraphics loadGraphicsFromJson(String file){
  JSONArray values = loadJSONArray(file);
  PGraphics s = createGraphics(width,height);
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
        println("<- Droite ");
        etatFenetre= fenetreQuestion.setEtat(etatFenetre+1);
      } else if (direction.x < -50) { //gauche 
        println("Gauche ->");

        etatFenetre=fenetreQuestion.setEtat(etatFenetre-1);
      }
      break;
    }
  }
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

  switch(state){
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
