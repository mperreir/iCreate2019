class Arbre {

  ArrayList<Feuille> feuilles; 
  FWorld aWorld;

  int timeFrame;
  int initTimeFrame;
  float initBrancheX;
  float initBrancheY;

  PImage[] images = new PImage[9];
  //zone à définir

  Arbre(FWorld fworld) {

    feuilles = new ArrayList<Feuille>();
    this.aWorld = fworld;
    //tableau des images (améliore les perf de les charger et redimensionner qu'une fois)
    for (int i=0; i < 9; i++) {
      images[i] = loadImage("img/feuilles/feuille-"+i+".png");
      images[i].resize(30, 0);
    }
    feuillage(width/3, height/5, 2*width/3, (height/5) + height/3);

  }

  void feuillage(float x, float y, float nx, float ny) {
    float maille = 30;

    for (float j = y; j < ny; j += maille) {
      for (float i = x; i < nx; i += maille) {
        float angle = ((i-x)/(nx-x)) * PI - PI/2;
        Feuille f = new Feuille(10, 10, i + random(-10,10), j + random(-10,10), images[int(random(0, 8))], angle);
        aWorld.add(f);
        feuilles.add(f);
        
      }
    }

    println(feuilles.size());
  }

  void gravity() {
    for (int i = 0; i < 100; i++) {
      this.feuilles.get(i).setStatic(false);
    }
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

  void step() {
    if (timeFrame > 0) {
      timeFrame --;
      this.wind();
    }
  }

  void setTimeFrame(int nbFrame) {
    initTimeFrame = nbFrame;
    timeFrame = initTimeFrame;
  }
}
