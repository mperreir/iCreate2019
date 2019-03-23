import processing.serial.*;

class Questionnaire {
  int score =0;
  ArrayList<Question> questions ;
  int idQuestionActuel=0;



  Questionnaire() {
    questions = new ArrayList<Question>();
    questions.add(new Question("Préférez vous un appartement ou une maison ?", "Un appartement", 10, "Une maison", 20));
    questions.add(new Question("Une maison isolée ou mitoyenne ?", "Isolée", 10, "Mitoyenne", 20));
    questions.add(new Question("Avec ou sans jardin ?", "Sans", 10, "Avec", 20));
    questions.add(new Question("En zone rurale ou agglomération ?", "En agglomération", 10, "En zone rurale", 20));
    questions.add(new Question("Comment vous déplacez-vous?", "En voiture", 10, "En transport en commun", 20));
    questions.add(new Question("En bord de littoral?", "Oui", 10, "Non", 20));
    questions.add(new Question("Vous préferrez vivre :", "En collococation", 10, "Seul", 20));
    questions.add(new Question("Dans quelle zone ?", "Centre-ville", 10, "Couronne périurbaine", 20));
    questions.add(new Question("Dans quel type d'immeuble", "Building", 10, "Immeuble Haussmanien", 20));
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
      score+= this.getQuestion().point1;
      return this.getQuestion().point1;
    } else if (numero ==2) {
      score+= this.getQuestion().point2;
      return this.getQuestion().point2;
    }    
    return 0;
  }
  Question getQuestion() {
    if (idQuestionActuel >= questions.size()) {
      return null;
    }
    return questions.get(idQuestionActuel);
  }
  boolean isLastQuestion() {
    return idQuestionActuel==questions.size();
  }
}
