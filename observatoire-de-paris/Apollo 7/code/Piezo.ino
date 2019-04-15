void setup() {
  Serial.begin(9600); // ouvrir la connexion série
  
}

void loop() {
  int value0 = analogRead(0); // lire la valeur sur la pin A0 et la stocker dans une variable entière
  int value1 = analogRead(1);
  int value2 = analogRead(2);
  int value3 = analogRead(3);
  
  Serial.print(value0); // imprimmer le contenu de la variable dans le moniteur série
  Serial.print(",");
  Serial.print(value1);
  Serial.print(",");
  Serial.print(value2);
  Serial.print(",");
  Serial.print(value3);
  Serial.println(",");
  delay(250);
} 
