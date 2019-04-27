class Feuille extends FBox {

  PImage img;  
  float x;
  float y;
  FBox boxFeuille;


  Feuille(float w, float h, float x, float y, PImage img, float angle) {
    super(w, h);
    this.setPosition(x, y);
    //this.setRotation(random(-PI/2,PI/2));
    this.setRotation(angle);
    this.setDensity(0.2);
    this.setStatic(true);
    this.img = img;
    this.attachImage(img);
    this.setAngularVelocity(1);
  }
}


class Point {
  float x;
  float y;

  Point(float x, float y) {
    this.x =x;
    this.y =y;
  }
}

class Branch {
  ArrayList<Point> points; 

  Branch() {
    points = new ArrayList<Point>();
  }

  void growBranch(Point p) {
    points.add(p);
  }

  PGraphics drawBranch(int nColor) {
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    for (int i = 1; i < points.size(); i++) {
      g.strokeWeight(points.size()-i);
      g.stroke(nColor);
      g.line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
      g.strokeWeight(points.size()-i);
      g.stroke(nColor);
      g.line(points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
    }
    g.endDraw();
    return g;
  }

  PGraphics drawBranchCurve(int nColor) {
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    for (int i = 3; i < points.size(); i++) {
      g.strokeWeight(1.5 * (points.size()-i));
      g.stroke(nColor);
      g.curve(points.get(i-3).x, points.get(i-3).y, points.get(i-2).x, points.get(i-2).y, points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y);
      if (i >= points.size()-1) {
        g.curve(points.get(i-2).x, points.get(i-2).y, points.get(i-1).x, points.get(i-1).y, points.get(i).x, points.get(i).y, points.get(i).x, points.get(i).y);
      }
    }
    g.endDraw();
    return g;
  }
  
  void branchRandom(PGraphics g, float x, float y,float size, int ncolor){
    float step = 30;
    float x1 = random(x-step,x+step);
    float y1 = random(y-step,y+step);
    float x2 = random(x1-step,x1+step);
    float y2 = random(y1-step,y1+step);
    float x3 = random(x2-step,x2+step);
    float y3 = random(y2-step,y2+step);
    g.stroke(ncolor);
    g.strokeWeight(size);
    g.curve(x,y,x,y,x1,y1,x2,y2);
    g.stroke(ncolor);
    g.strokeWeight(size);
    g.curve(x,y,x1,y1,x2,y2,x3,y3);
  }

  JSONArray toJSONArray() {

    JSONArray values = new JSONArray();

    for (int i = 0; i < points.size(); i++) {

      JSONObject point = new JSONObject();

      point.setFloat("x", points.get(i).x);
      point.setFloat("y", points.get(i).y);

      values.setJSONObject(i, point);
    }

    return values;
  }
}
