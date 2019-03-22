void setup() {
  Serial.begin(9600);
}

void loop() {
  int valueBook = analogRead(A0);
  int valueFlute = analogRead(A1);
  int valueSand = analogRead(A2);
  String json;
  json = "{";
  json = json + "\"book\":" + valueBook;
  json = json + ",\"flute\":" + valueFlute;
  json = json + ",\"sand\":" + valueSand;
  json = json + "}";

  Serial.println(json);
}
