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
