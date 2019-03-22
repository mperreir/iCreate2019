class Question {
  String enonce;
  String reponse1;
  String reponse2;
  int point1;
  int point2;

  Question(String enonce, String reponseA, int pointA, String  reponseB, int pointB) {
    this.enonce=enonce;
    this.reponse1=reponseA;
    this.point1=pointA;
    this.reponse2=reponseB;
    this.point2=pointB;
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
