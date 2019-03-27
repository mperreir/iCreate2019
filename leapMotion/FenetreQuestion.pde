

class FenetreQuestion extends PApplet {
  color[] palette = new color[]{  0xff009E4F, 0xff009f00, 0xff006332, 0xff000f00, 0x00000000};
  color currentStroke = palette[0];
  int bottom0;
  int bottom1;
  int left = 0;
  int right;
  int top0 = 0;
  int top1;
  int x, y;
  Question question;
  float loopStep;
  float animStep;

  int etat = 0;
  ArrayList<Hand> hands; 
  public int setEtat(int e) {
    println("FenetreQuestion : "+etat);
    etat_leap = false;
    etat = e;
    return etat;
  }



  void settings() {
    fullScreen(1);
    //size(900,600);
  }
  PShape terrainShape;

  LeapMotion leapF;
  void setup() {

    background(255);
    right = width;
    bottom0 = height ;
    top1 = bottom0 + 1;
    bottom1 = height;

    leapF = new LeapMotion(this);
  }

  void draw() {


    animStep = abs(sin(frameCount * 0.02));
    for (int i = left; i <= right; i += 1) {

      loopStep = map(i, left, right, 0.0, 0.2);
      currentStroke = lerpColor(palette, (loopStep + animStep) * 0.5, HSB);
      stroke(currentStroke);
      line(i, top0, i, bottom0);
    }


    for (Hand hand : leapF.getHands()) {

      PVector position = hand.getSpherePosition();
      float radius = hand.getSphereRadius();
      pushMatrix();
      ellipseMode(PConstants.CENTER);
      fill(255, 2, 2, 20);
      ellipse(position.x, position.y, radius, radius);
      popMatrix();
      //hand.draw(20);
    }
    switch(etat) {
    case 1: 
      etatInstruction();
      break;
    case 2:
      etatQuestion();
      break;
    case 3:
      etatTransitionQuestion();
      break;
    case 4:
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
      //etat = 2;
      etat_leap = true;
    }
  }

  int etatQuestion_choix = 0;
  int etatQuestion_tempT1 = 0;
  int etatQuestion_tempTA = 0;
  int etatQuestion_tempIncA = 15;
  int etatQuestion_tempTB = 0;
  int etatQuestion_tempIncB = 15;
  int etatQuestion_sizeA = 50;
  int etatQuestion_sizeB = 50;

  void etatQuestion() {
    question = q.getQuestion();
    etatQuestion_tempIncA = 15;
    etatQuestion_tempIncB = 15;
    etatQuestion_sizeA = 50;
    etatQuestion_sizeB = 50;
    choixQuestion();

    etat_leap = true;
  }

  void choixQuestion() {
    etatQuestion_tempT1 = transitionText(question.enonce, 70, width/2, height/3, etatQuestion_tempT1, 15, CENTER, TOP);
    etatQuestion_tempTA = transitionText(question.reponse1+"\n<<", etatQuestion_sizeA, width/5, (height/3)*2, etatQuestion_tempTA, etatQuestion_tempIncA, CENTER, TOP);
    etatQuestion_tempTB = transitionText(question.reponse2+"\n>>", etatQuestion_sizeB, (width/5)*4, (height/3)*2, etatQuestion_tempTB, etatQuestion_tempIncB, CENTER, TOP);
    if (etatQuestion_tempT1 > 255) {
      etatQuestion_tempT1=0;
    }
  }

  void etatTransitionQuestion() {

    choixQuestion();
    if (etatQuestion_choix == 1) {
      etatQuestion_sizeA = etatQuestion_sizeA+4;
      etatQuestion_tempIncB = -1;
    } else if (etatQuestion_choix == 2) {
      etatQuestion_sizeB = etatQuestion_sizeB+4;
      etatQuestion_tempIncA = -1;
    }
    if (etatQuestion_sizeA> 75 || etatQuestion_sizeB> 75) {

      q.idQuestionActuel++;
      if (q.isLastQuestion()) {
        this.setEtat(4);
      } else {

        this.setEtat(2);
      }
    }

    etat_leap = true;
  }

  int etatStats_tempA = 0;
  int etatStats_nbHabitantparAn = 0;
  int etatStats_nbHabitant = 0;
  float etatStats_nbHabitant_inc = 1 ;

  int etatStats_i = 150;
  boolean etatStats_etat = true;
 
  void etatStats() {
     int col2= (width/2)+10;
    //Classement
    etatStats_tempA= transitionText(str(q.getClassement()), 100, 250, height-250, etatStats_tempA, 15, CENTER, TOP);
    transitionText("ème", 50, 250+120, height-250, etatStats_tempA, 15, CENTER, TOP);
    transitionText("sur "+q.getNbParticipant(), 50, 200+200, height-200, etatStats_tempA, 15, LEFT, TOP);



    transitionText( nfc(etatStats_nbHabitantparAn), 80, col2, 100, etatStats_tempA, 15, LEFT, TOP);
    transitionText("hab/an", 30, col2+20, 100+85, etatStats_tempA, 15, LEFT, TOP);
    transitionText("(Évolution annuelle moyenne entre 2011 et 2016) ", 20, col2, 100+120, etatStats_tempA, 15, LEFT, TOP);

    
    transitionText( nfc(etatStats_nbHabitant), 80, col2, (height/2)-160, etatStats_tempA, 15, LEFT, TOP);
    transitionText("habitant en 2016", 30, col2+20, (height/2)-80, etatStats_tempA, 15, LEFT, TOP);


    shape(terrainShape,col2+50, height-450, etatStats_i, etatStats_i);
    transitionText("+1,8 stade par an", 50, col2+300, height-300, etatStats_tempA, 15, LEFT, BOTTOM);
    
   
    transitionText("Source : observatoire.loire-atlantique.fr", 20, width-5, height-30, etatStats_tempA, 15, RIGHT, BOTTOM);
    
    if (etatStats_nbHabitantparAn != 16865) {
      etatStats_nbHabitant_inc = etatStats_nbHabitant_inc+2.2;
      etatStats_nbHabitantparAn = int( etatStats_nbHabitantparAn + (etatStats_nbHabitant_inc*etatStats_nbHabitant_inc));
      if (etatStats_nbHabitantparAn>= 16865) {
        etatStats_nbHabitantparAn = 16865;
      }    
    }
    if(etatStats_nbHabitant != 1380852){
      etatStats_nbHabitant = int( etatStats_nbHabitant + (etatStats_nbHabitant_inc*etatStats_nbHabitant_inc*etatStats_nbHabitant_inc));
      if (etatStats_nbHabitant>= 1380852) {
        etatStats_nbHabitant = 1380852;
      }
    }

    if (etatStats_i >200) {
      etatStats_etat = false;
    } else if (etatStats_i < 150) {
      etatStats_etat = true;
    } 

    if (etatStats_etat) {
      etatStats_i = etatStats_i +5;
    } else {
      etatStats_i = etatStats_i -5;
    }    
    etat_leap = true;
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
}
