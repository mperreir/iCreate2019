class Arbre {

  ArrayList<Feuille> feuilles; 
  ArrayList<Branch> branchesArbre;
  ArrayList<Point> pointsTronc;
  ArrayList<PGraphics> graphicBranches;
  PGraphics imageBranches;
  PGraphics imageTronc;
  PImage textureArbre;

  FWorld aWorld;

  int timeFrame;
  int initTimeFrame;
  float initBrancheX;
  float initBrancheY;
  float nbLeaf;



  PImage[] images = new PImage[9];
  //zone à définir

  Arbre(FWorld fworld) {
    imageBranches = createGraphics(width, height);
    feuilles = new ArrayList<Feuille>();
    branchesArbre = new ArrayList<Branch>();
    graphicBranches = new ArrayList<PGraphics>();

    textureArbre = loadImage("img/texturearbre.jpg");
    textureArbre.resize(width, height);
    
    loadTroncFromJSON("data/tronc.json");
    

    this.aWorld = fworld;
    //tableau des images (améliore les perf de les charger et redimensionner qu'une fois)
    for (int i=0; i < 9; i++) {
      images[i] = loadImage("../leapMotion/img/feuilles/feuille-"+i+".png");
      images[i].resize(0, 40);
    }
    //feuillage(width/3, height/5, 2*width/3, (height/5) + height/3);
    
    loadTroncFromJSON("data/tronc.json");
    loadBranchesFromJson("data/branches.json");
    drawBranchage();
    brancheFeuille();
    
  }
  
  void reset(){
    world.clear();
    brancheFeuille();
  }

  void drawBranchage() {
    
    imageBranches = createGraphics(width, height);
  
    imageBranches.beginDraw();
    for (int i = 0; i < graphicBranches.size(); i++) {
      imageBranches.image(graphicBranches.get(i), 0, 0);
    }
    imageBranches.endDraw();
  }

  void brancheFeuille() {
    for (int i = 0; i < branchesArbre.size(); i++) {
      Branch myBranch = branchesArbre.get(i);
      for (int j = 1; j < myBranch.points.size(); j++) {
        float x, y, angle;
        if (random(0, 1) <1) {
          if (random(0, 2) <1) {
            x = myBranch.points.get(j).x - 15;
            y = myBranch.points.get(j).y + 15;
            angle = random(PI/3, PI/2);
          } else {
            x = myBranch.points.get(j).x + 15;
            y = myBranch.points.get(j).y + 15;
            angle = random(PI/2, 2*PI / 3);
          }
          Feuille f = new Feuille(20, 20, x, y, images[int(random(0, 8))], angle);
          aWorld.add(f);
          feuilles.add(f);
        }
      }
    }
    nbLeaf = feuilles.size();
    println("NB FEUILLES:", feuilles.size());
  }

  void feuillage(float x, float y, float nx, float ny) {
    float maille = 30;

    for (float j = y; j < ny; j += maille) {
      for (float i = x; i < nx; i += maille) {
        float angle = ((i-x)/(nx-x)) * PI - PI/2;
        Feuille f = new Feuille(10, 10, i + random(-10, 10), j + random(-10, 10), images[int(random(0, 8))], angle);
        aWorld.add(f);
        feuilles.add(f);
      }
    }
    nbLeaf = feuilles.size();
  }

  void gravity() {
    for (int i = 0; i < feuilles.size(); i++) {
      this.feuilles.get(i).setStatic(false);
      this.feuilles.get(i).addTorque(random(0, 30));
      this.feuilles.get(i).addImpulse(random(-10, 10), random(0, 10));
    }
    feuilles = new ArrayList<Feuille>();
    //aWorld.clear();
  }

  void wind() {
    for (int i=0; i < feuilles.size(); i++) {
      float facteurMove = 0;
      if (timeFrame > initTimeFrame / 2) {
        facteurMove = 1 - float(timeFrame) / float(initTimeFrame);
      } else {
        facteurMove = float(timeFrame) / float(initTimeFrame);
      }

      feuilles.get(i).adjustRotation(random(-facteurMove, facteurMove)*PI/60);
      feuilles.get(i).adjustPosition(random(-facteurMove, facteurMove), random(-facteurMove, facteurMove));
    }
  }

  void destroyLeaf(float percentage) {
    float nbobject = (percentage / 100) *  nbLeaf;
    if (feuilles.size() > 0) {

      for (int i = 0; i < nbobject -1; i++) {
        int j = int(random(0, feuilles.size()-1));
        if (feuilles.size() > 0) {
          Feuille f = feuilles.get(j);
          f.setStatic(false);
          f.addTorque(random(0, 1));
          f.addImpulse(random(-10, 10), random(0, 10));
          feuilles.remove(j);
        }
      }
    }
  }

  void destroyZone(float w, float h, float x, float y) {
    for (int i=0; i < feuilles.size(); i++) {
      Feuille f = feuilles.get(i);
      float xF = f.getX();
      float yF = f.getY();
      if (xF > x && xF < x + w &&  yF > y && yF < y + h ) {
        f.setStatic(false);
        f.addTorque(random(0, 1));
        f.addImpulse(random(-10, 10), random(0, 10));
      }
    }
  }

  void setTimeFrame(int nbFrame) {
    initTimeFrame = nbFrame;
    timeFrame = initTimeFrame;
  }

  void loadBranchesFromJson(String file ) {
    JSONArray values = loadJSONArray(file);
    branchesArbre = new ArrayList<Branch>();
    graphicBranches = new ArrayList<PGraphics>();
    Branch currentBranch = new Branch();

    for (int i = 0; i < values.size(); i++) {

      JSONArray branchJSON = values.getJSONObject(i).getJSONArray("branch"); 
      currentBranch = new Branch();
      for (int j = 0; j < branchJSON.size(); j++) {
        float x = branchJSON.getJSONObject(j).getFloat("x");
        float y = branchJSON.getJSONObject(j).getFloat("y");
        currentBranch.growBranch(new Point(x, y));
      }
      branchesArbre.add(currentBranch);
      graphicBranches.add(currentBranch.drawBranchCurve(0));
      currentBranch = new Branch();
    }
    drawBranchage();
  }

  PGraphics createTronc(PGraphics p) {
    PGraphics s = createGraphics(width, height);
    s.beginDraw();
    //s.image(p, 0, 0);
    //s.fill(0);
    //s.circle(points.get(points.size()-1).x, points.get(points.size()-1).y, 30);
    for (int i = 0; i < pointsTronc.size(); i++) {
      s.fill(0, 0, 255);
      s.noStroke();
      s.circle(pointsTronc.get(i).x, pointsTronc.get(i).y, pointsTronc.get(i).size);
    }
    s.endDraw();
    return s;
  }

  void loadTroncFromJSON(String file) {
    JSONArray values = loadJSONArray(file);
    pointsTronc = new ArrayList<Point>();

    for (int i = 0; i < values.size(); i++) {

      JSONObject pointJson = values.getJSONObject(i); 
      Point point = new Point(pointJson.getFloat("x"), pointJson.getFloat("y"), pointJson.getFloat("size"));
      pointsTronc.add(point);
    }

    imageTronc = createTronc(g);
    PGraphics copy = createGraphics(width, height);
    copy.beginDraw();
    textureArbre.mask(imageTronc);
    copy.image(textureArbre, 0, 0);
    copy.endDraw();
    imageTronc = copy;
  }

  void step() {
    if (timeFrame > 0) {
      timeFrame --;
      this.wind();
    }
  }

  void draw() {
    image(imageBranches, 0, 0);
    image(imageTronc,0,0);
  }
}
