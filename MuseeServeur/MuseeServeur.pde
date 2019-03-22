import websockets.*;
import java.net.*;
import processing.serial.*;

WebsocketServer ws;
String address;
Serial myPort;
float valueFromBook, valueFromFlute, valueFromSand = 0;

// Initialisation
void setup() {
  size(200,200);
  
  printArray(Serial.list());
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  
  // Création du serveur Websocket qui écoute sur ws://0.0.0.0:8025/musee
  ws = new WebsocketServer(this, 8025, "/musee");
  
  try {
    InetAddress inetAddress = InetAddress.getLocalHost();
    address = inetAddress.getHostAddress();
  } catch (UnknownHostException e) {
    
  }
}

void draw() {
  background(0);
  
  textSize(14);
  text(address.toString(), 10,20);
  
  // ws.sendMessage("Server message");
}

void serialEvent (Serial myPort) {
  try {
    while (myPort.available() > 0) {
      String inBuffer = myPort.readStringUntil('\n');
      if (inBuffer != null) {
        if (inBuffer.substring(0, 1).equals("{")) {
          JSONObject json = parseJSONObject(inBuffer);
          if (json == null) {
            //println("JSONObject could not be parsed");
          } else {
            valueFromBook = json.getInt("book");
            valueFromFlute = json.getInt("flute");
            valueFromSand = json.getInt("sand");
            //println(valueFromBook + " - " + valueFromFlute + " - " + valueFromSand);
          }
        }
      }
    }
  } 
  catch (Exception e) {
  }
}

void webSocketServerEvent(String msg) {
  println(msg);
}
