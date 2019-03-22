  
PGraphics s;  // The PShape object

ArrayList<Point> points; 

void setup() {
  fullScreen();
  points = new ArrayList<Point>();
  // Creating a custom PShape as a square, by
  // specifying a series of vertices.
  s = createGraphics(width,height);
}

void draw() {
  background(204);
  if(points.size() > 2){
    image(s, 0, 0);
  }
}

void mousePressed() {
  points.add(new Point(mouseX,mouseY));
  createF();
}

void keyPressed() {
  //s = loadShapeFromJson("data/new.json");
  //saveShapeToJson("../leapMotion/data/tronc.json");
  
}

void createF(){
  s.beginDraw();
  println("new");
  //s.curveVertex(points.get(0).x, points.get(0).y);
  for(int i = 1; i < points.size();i++){
    strokeWeight(4);
    line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
  }
  s.endDraw();
}

JSONArray values;

void saveShapeToJson(String file) {

  values = new JSONArray();

  for (int i = 0; i < points.size(); i++) {

    JSONObject point = new JSONObject();

    point.setFloat("x", points.get(i).x);
    point.setFloat("y", points.get(i).y);

    values.setJSONObject(i, point);
  }
  
  saveJSONArray(values, file);
}



class Point{
  float x;
  float y;
  
  Point(float x, float y){
    this.x =x;
    this.y =y;
  }
}
