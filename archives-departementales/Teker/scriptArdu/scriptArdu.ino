void setup() {
  Serial.begin(9600);
}

void loop() {
  int Dalle1 = analogRead(A0);
  int Dalle2 = analogRead(A1);
  int Dalle3 = analogRead(A2);
  int Dalle4 = analogRead(A3);
  int AddMaison = analogRead(A4);
  int AddImmeuble = analogRead(A5);

  bool b = false;

  String json = "{";
  json = json + "\"A0\":"+Dalle1;
  json = json + ",";
  json = json + "\"A1\":"+Dalle2;
  json = json + ",";
  json = json + "\"A2\":"+Dalle3;
  json = json + ",";
  json = json + "\"A3\":"+Dalle4;
  json = json + ",";
  json = json + "\"A4\":"+AddMaison;
  json = json + ",";
  json = json + "\"A5\":"+AddImmeuble;
  json = json + "}";
  
  Serial.println(json);
}
