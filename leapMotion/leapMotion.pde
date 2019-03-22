import de.voidplus.leapmotion.*;


LeapMotion leap;

int etatFenetre=3;
boolean etat_leap = true;
FenetreQuestion applet = new FenetreQuestion();

void settings() {
  size(800, 500);
  // fullScreen(3);
}


void setup() {

  background(255);
  leap = new LeapMotion(this).allowGestures("swipe");  // Leap detects only swipe gestures

  applet.terrainShape = loadShape("terrain.svg");
  applet.setEtat(etatFenetre);

  runSketch(new String[] { 
    "applet"
    }
    , applet);
}

void draw() {
  background(255);
  // ...
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
        etatFenetre= applet.setEtat(etatFenetre+1);
      } else if (direction.x < -50) { //gauche 
        println("Gauche ->");

        etatFenetre=applet.setEtat(etatFenetre-1);
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
