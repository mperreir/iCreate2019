import processing.serial.*;

class Questionnaire {
  int score =0;
  ArrayList<Question> questions ;
  int idQuestionActuel=0;
  int nextQ=0;

  Questionnaire() {
    questions = new ArrayList<Question>();
    questions.add(new Question("En zone rurale ou agglomération ?", "En agglomération", 30,1, "En zone rurale", 10,1));
    questions.add(new Question("Vous préferrez vivre :", "En colocation", 20,2, "Seul", 10,2));
    questions.add(new Question("Comment vous déplacez-vous?", "En voiture", 5,3, "En transport en commun", 10,3));
    questions.add(new Question("Préférez vous un appartement ou une maison ?", "Un appartement", 30,4 ,"Une maison", 10,6));
    questions.add(new Question("Une maison isolée ou mitoyenne ?", "Isolée", 10,5, "Mitoyenne", 20,5));
    questions.add(new Question("Avec ou sans jardin ?", "Sans", 30, -1,"Avec", 0,-1));
    questions.add(new Question("Dans quelle zone ?", "Centre-ville", 10,7, "Banlieue", 5,7));
    questions.add(new Question("Dans quel type d'immeuble", "Immeuble\n de 5 étages", 5,-1, "Immeuble\n de 20 étages", 20,-1));
  }

  void stockScore() {// méthode qui ajoute le score au fichier texte
    String Score = String.valueOf(score);
    String []  stScore = append(texte, Score);
    saveStrings("Score.txt", stScore);
  }
  int getClassement() {// méthode qui trie tous les score et affiche la position de l'utilisateur dans le classement
   
    scoreTrie= int(texte);
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
      texte[z]= str(scoreTrie[z]);
    }
    int cla=0;
    int classement=1;
    if(scoreTrie.length==0){
      return 1;
    }
    while (score>scoreTrie[cla]) {
      classement+=1;
      cla+=1;
    }
    println("Vous êtes " +classement+"e dans le classement");
    return classement;
  }
  
  int getNbParticipant(){
    int [] scoreTrie= int(texte);
    return scoreTrie.length;
  }

  void question1(boolean reponse) {
    if (reponse ) score+=1;
  }
  void ajouterPoints( int point) {//méthode qui incrémente directement le score
    score+=point;
  }
  int repondre(int numero) {
    if (numero == 1) {
      println(this.getQuestion().point1);
      score+= this.getQuestion().point1;
      nextQ = this.getQuestion().nextQ1;
      return this.getQuestion().point1;
    } else if (numero ==2) {
      println(this.getQuestion().point2);
      score+= this.getQuestion().point2;
      nextQ = this.getQuestion().nextQ2;
      return this.getQuestion().point2;
    }    
    
    return 0;
  }
  Question getQuestion() {
    if (idQuestionActuel >= questions.size() || idQuestionActuel == -1) {
      return null;
    }
    return questions.get(idQuestionActuel);
  }
  boolean isLastQuestion() {
    return idQuestionActuel==questions.size() || idQuestionActuel == -1;
  }
}
