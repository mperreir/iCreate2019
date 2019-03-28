
PGraphics g;  // The PShape object

ArrayList<Point> points; 
float sizeBrush;
PImage textureArbre;

void setup() {
  sizeBrush = 31;
  fullScreen();
  points = new ArrayList<Point>();
  // Creating a custom PShape as a square, by
  // specifying a series of vertices.
  g = createGraphics(width, height);
  g.beginDraw();
  g.endDraw();
  textureArbre = loadImage("../leapMotion/img/texturearbre.jpg");
  textureArbre.resize(width, height);
}

void draw() {
  background(204);
  image(g, 0, 0);

  if (mousePressed) {
    points.add(new Point(mouseX, mouseY, sizeBrush));
    g = createTronc(g);
  }
}

void mousePressed() {
}

void keyPressed() {
  //s = loadShapeFromJson("data/new.json");
  //saveShapeToJson("../leapMotion/data/tronc.json");
  println(keyCode);
  //up to grow sizebrush 
  if (keyCode == 38) {
    sizeBrush += 10;
  }
  //down to go down sizebrush 
  if (keyCode == 40) {
    if (sizeBrush < 0) {
      sizeBrush = 1;
    } else {
      sizeBrush -= 10;
    }
  }
  //return to erase previous dot
  if (keyCode == 8) {
    if (points.size()>0) {
      points.remove(points.size()-1);
      g = createTronc(g);
    }
  }

  //space load tree textures on shape 
  if (keyCode == 32) {
    PGraphics copy = createGraphics(width, height);
    copy.beginDraw();
    textureArbre.mask(g);
    copy.image(textureArbre, 0, 0);
    copy.endDraw();
    g = copy;
    println("toto");
  }

  //r to register in file
  if (keyCode == 82) {
    selectOutput("Save tronc to file :", "saveTronc");
  }

  //r to register in file
  if (keyCode == 84) {
    selectInput("Load tronc from file :", "loadTronc");
  }
}

void saveTronc(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    saveTroncToJson(selection.getAbsolutePath());
  }
}

void loadTronc(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    loadTroncFromJSON(selection.getAbsolutePath());
  }
}

PGraphics createTronc(PGraphics p) {
  PGraphics s = createGraphics(width, height);
  s.beginDraw();
  //s.image(p, 0, 0);
  //s.fill(0);
  //s.circle(points.get(points.size()-1).x, points.get(points.size()-1).y, 30);
  for (int i = 0; i < points.size(); i++) {
    s.fill(0, 0, 255);
    s.noStroke();
    s.circle(points.get(i).x, points.get(i).y, points.get(i).size);
  }
  s.endDraw();
  return s;
}

JSONArray values;

void saveTroncToJson(String file) {

  values = new JSONArray();

  for (int i = 0; i < points.size(); i++) {

    JSONObject point = new JSONObject();

    point.setFloat("x", points.get(i).x);
    point.setFloat("y", points.get(i).y);
    point.setFloat("size", points.get(i).size);

    values.setJSONObject(i, point);
  }

  saveJSONArray(values, file);
}

void loadTroncFromJSON(String file) {
  JSONArray values = loadJSONArray(file);
  points = new ArrayList<Point>();

  for (int i = 0; i < values.size(); i++) {

    JSONObject pointJson = values.getJSONObject(i); 
    Point point = new Point(pointJson.getFloat("x"), pointJson.getFloat("y"), pointJson.getFloat("size"));
    points.add(point);
  }

  g = createTronc(g);

}



class Point {
  float x;
  float y;
  float size;

  Point(float x, float y) {
    this.x =x;
    this.y =y;
  }

  Point(float x, float y, float size) {
    this.x =x;
    this.y =y;
    this.size = size;
  }
}
