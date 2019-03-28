void setup() {
  Serial.begin(9600);
}

void loop() {
  int brazil_value = analogRead(0);
  int russia_value = analogRead(1);
  int japan_value = analogRead(2);
  int usa_value = analogRead(3);
  
  String json;
  json = "{\"brazil\":";
  json += brazil_value;
  json += ", \"russia\":";
  json += russia_value;
  json += ", \"japan\":";
  json += japan_value;
  json += ", \"usa\":";
  json += usa_value;
  json += "}";

  Serial.println(json);
}
