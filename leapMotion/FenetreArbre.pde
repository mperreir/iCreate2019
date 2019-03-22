
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

void settings() {
  fullScreen();
  
}

void setup() {
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
}

void draw() {
  background(bg);
  //shape(shapeArbre,0,0);
  image(textureArbre, 0, 0);
  arbre.step();
  world.step();
  world.draw();
  
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
