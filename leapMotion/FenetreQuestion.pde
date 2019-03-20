/*
int Y_AXIS = 1;
 int X_AXIS = 2;
 color vert, vertfonce, c1, c2;
 
 */
color[] palette = new color[]{  0xff009E4F, 0xff009f00, 0xff006332};
color currentStroke = palette[0];
int bottom0;
int bottom1;
int left = 0;
int right;
int top0 = 0;
int top1;
int x, y;

float loopStep;
float animStep;

int etat = 3;

void settings() {
  fullScreen();
  //size(900,600);
}
PImage img;
void setup() {
   img = loadImage("grap.gif");
  background(255);
  right = width;
  bottom0 = height ;
  top1 = bottom0 + 1;
  bottom1 = height;
}

void draw() {
  animStep = abs(sin(frameCount * 0.016666667));
  for (int i = left; i <= right; i += 1) {

    loopStep = map(i, left, right, 0.0, 0.2);
    currentStroke = lerpColor(palette, (loopStep + animStep) * 0.5, HSB);
    stroke(currentStroke);
    line(i, top0, i, bottom0);
  }

  stroke(currentStroke);
  switch(etat) {
  case 1: 
    etatInstruction();
    break;

  case 2:
    etatQuestion();
    break;
  case 3:
    etatStats();
    break;
  }
}

boolean etatTransition = false;

int etatInstruction_tempT1 = 0;
int etatInstruction_tempT2 = 0;

// ETAT
void etatInstruction() {
  etatInstruction_tempT1 = transitionText("Bienvenue,\n vous allez vivre une expérience ....", 100, width/2, height/4, etatInstruction_tempT1, 10, CENTER, TOP);
  etatInstruction_tempT2 = transitionText("Levez la main\n ⇈⇈", 50, width/2, (height/4)*2+50, etatInstruction_tempT2, 10, CENTER, TOP);
  if (etatInstruction_tempT2> 255) {
    etatInstruction_tempT2 =0;
    etat = 2;
  }
}
String question = "Que souhaitez-vous  ?";
String choixA = "Une maison";
String choixB = "Un appartement";
int etatQuestion_choix = 0;
int etatQuestion_tempT1 = 0;
int etatQuestion_tempTA = 0;
int etatQuestion_tempIncA = 15;
int etatQuestion_tempTB = 0;
int etatQuestion_tempIncB = 15;
int etatQuestion_sizeA = 50;
int etatQuestion_sizeB = 50;
void etatQuestion() {
  etatQuestion_tempT1 = transitionText(question, 70, width/2, height/3, etatQuestion_tempT1, 15, CENTER, TOP);
  etatQuestion_tempTA = transitionText(choixA+"\n<<", etatQuestion_sizeA, width/5, (height/3)*2, etatQuestion_tempTA, etatQuestion_tempIncA, CENTER, TOP);
  etatQuestion_tempTB = transitionText(choixB+"\n>>", etatQuestion_sizeB, (width/5)*4, (height/3)*2, etatQuestion_tempTB, etatQuestion_tempIncB, CENTER, TOP);
  if (etatQuestion_tempT1 > 255) {
    etatQuestion_tempT1=0;
  }
  if(etatQuestion_choix == 1){
    etatQuestion_sizeA = etatQuestion_sizeA+2;
    etatQuestion_tempIncB = -1;
  }else if (etatQuestion_choix == 2){
    etatQuestion_sizeB = etatQuestion_sizeA+2;
    etatQuestion_tempIncA = -2;
  }
}


int etatStats_tempA = 0;

int classement= 0;
void etatStats() {
  etatStats_tempA= transitionText("55", 100, 250, height-250, etatStats_tempA, 15, CENTER, TOP);
  etatStats_tempA= transitionText("ème", 50, 250+120, height-250, etatStats_tempA, 15, CENTER, TOP);
  
  etatStats_tempA= transitionText("sur 36000", 50, 200+200, height-200, etatStats_tempA, 15, LEFT, TOP);
  image(img, 0, 0);
  
  
  
}

int transitionText(String text, int textSize, int widthT, int heightT, int tempT, int inc, int c, int t) {
  textSize(textSize);
  textAlign(c, t);
  fill(255, 255, 255, tempT);
  text(text, widthT, heightT);
  if (tempT < 255) {
    tempT =tempT+ inc;
  }
  return tempT;
}

// Utilities
color lerpColor(color[] arr, float step, int colorMode) {
  int sz = arr.length;
  if (sz == 1 || step <= 0.0) {
    return arr[0];
  } else if (step >= 1.0) {
    return arr[sz - 1];
  }
  float scl = step * (sz - 1);
  int i = int(scl);
  return lerpColor(arr[i], arr[i + 1], scl - i, colorMode);
}
