import processing.serial.*;
class Questionnaire {
  int maxScore=20;
  int score;
  /*tableauQuestion= new Question[];
   tableauScore[0] = new Question ( "Préférez vous un appartement ou une maison ?", "un appartement", 1, "une maison", 2);
   tableauScore[1] = new Question ( "Préférez vous un appartement ou une maison ?", "un appartement", 1, "une maison", 2);*/
  ArrayList<Question> questions ;
  


  Questionnaire(int score) {
    this.score=score;
    questions = new ArrayList<Question>();
    questions.add(new Question("Préférez vous un appartement ou une maison ?", "Un appartement", 1, "Une maison", 2));
    questions.add(new Question("Une maison individuelle ou en mitoyenne ?", "Mitoyenne", 1, "Individuelle", 2));
    questions.add(new Question("Avec ou sans jardin ?", "Sans", 1, "Avec", 2));
    questions.add(new Question("En zone rurale ou agglomération ?", "En agglomération", 1, "En zone rurale", 2));
    questions.add(new Question("Comment vous déplacez vous?", "En voiture", 1, "En transport en commun", 2));
    questions.add(new Question("En bord de litoral?", "Oui", 1, "Non", 2));
    questions.add(new Question("Vous préferrez vivre :", "En collococation", 1, "Seul", 2));
    questions.add(new Question("Dans quelle zone ?", "En centre-ville", 1, "En couronne périurbaine", 2));
    questions.add(new Question("Dans quel type d'immeuble", "EN building", 1, "En immeuble Haussmanien", 2));
  }

  void stockScore() {// méthode qui ajoute le score au fichier texte
    String Score = String.valueOf(score);
    String []  stScore = append(Texte, Score);
    saveStrings("Score.txt", stScore);
  }
  void getClassement() {// méthode qui trie tous les score et affiche la position de l'utilisateur dans le classement
    int [] scoreTrie= int(Texte);
    int valeurtemporaire, i, j;

    for (i=0; i<scoreTrie.length; i++)
    {
      for (j=i; j<scoreTrie.length; j++)
      {
        if (scoreTrie[j]<scoreTrie[i])  
        {
          valeurtemporaire = scoreTrie[i];
          scoreTrie[i] = scoreTrie[j];
          scoreTrie[j] = valeurtemporaire;
        }
      }
    }
    for (int z=0; z<scoreTrie.length; z++) {
      Texte[z]= str(scoreTrie[z]);
    }
    int cla=0;
    int classement=1;
    while (score>scoreTrie[cla]) {
      classement+=1;
      cla+=1;
    }
    println("Vous êtes " +classement+"e dans le classement");
  }

  void question1(boolean reponse) {
    if (reponse ) score+=1;
  }
  void ajouterPoints( int point) {//méthode qui incrémente directement le score
    score+=point;
  }
}
