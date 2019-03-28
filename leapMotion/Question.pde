class Question {
  String enonce;
  String reponse1;
  String reponse2;
  int point1;
  int point2;
  int nextQ1;
  int nextQ2;

  Question(String enonce, String reponseA, int pointA, int nextQA, String  reponseB, int pointB, int nextQB) {
    this.enonce=enonce;
    this.reponse1=reponseA;
    this.point1=pointA;
    this.nextQ1 =  nextQA;
    this.reponse2=reponseB;
    this.point2=pointB;
    this.nextQ2= nextQB;
  }
  int repondre(boolean answer) {//methode qui incrémente le score selon la réponse à la question
    if (answer==true)
    {
      return point1;
    }
    else {
       return point2;
     }
  }
}
