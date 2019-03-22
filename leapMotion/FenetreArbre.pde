
import fisica.*;

FWorld world;

PImage img;  
PImage bg;

float len=90;
float theta=PI/6;
float r;

Arbre arbre;

void settings() {
  fullScreen();
  
}

void setup() {
  frameRate(30);
  Fisica.init(this);
  bg = loadImage("img/arbre.jpg");
  bg.resize(width,height);
  background(bg);
  world = new FWorld();
  arbre = new Arbre(world);
}

void draw() {
  background(bg);
  arbre.step();
  world.step();
  world.draw();
  
}

void mousePressed() {
  //arbre.feuillage(mouseX,mouseY,mouseX+100, mouseY+100);
  arbre.setTimeFrame(50);
  arbre.destroyZone(200,200,mouseX,mouseY);
}
