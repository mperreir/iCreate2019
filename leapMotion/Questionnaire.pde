import processing.serial.*;
class Questionnaire{
  int maxScore=20;
  int score;
  Questionnaire(int score){
    this.score=score;
  }
  
  ;
  void stockScore(){// méthode qui ajoute le score au fichier texte
    String Score = String.valueOf(score);
    String []  stScore = append(Texte,Score);
    saveStrings("Score.txt" , stScore);
  }
  void getClassement(){// méthode qui trie tous les score et affiche la position de l'utilisateur dans le classement
    int [] scoreTrie= int(Texte);
    int valeurtemporaire, i, j;
 
     for (i=0; i<scoreTrie.length; i++)
     {
        for(j=i; j<scoreTrie.length; j++)
        {
            if(scoreTrie[j]<scoreTrie[i])  
            {
                valeurtemporaire = scoreTrie[i];
                scoreTrie[i] = scoreTrie[j];
                scoreTrie[j] = valeurtemporaire;
            }
        }
     }
       for (int z=0; z<scoreTrie.length;z++){
         Texte[z]= str(scoreTrie[z]);
       }
       int cla=0;
       int classement=1;
       while(score>scoreTrie[cla]){
         classement+=1;
         cla+=1;
       }
       println("Vous êtes " +classement+"e dans le classement");
  }

  void question1(boolean reponse){
    if (reponse ) score+=1;
  }
  void ajouterPoints( int point){//méthode qui incrémente directement le score
    score+=point;
  }
}
