import websockets.*;
import java.net.*;

WebsocketServer ws;
int now;
float x, y;
String address;

void setup() {
  size(200,200);
  
  //Initiates the websocket server, and listens for incoming connections on ws://localhost:8025/john
  ws = new WebsocketServer(this, 8025, "/musee");
  now = millis();
  x = 0;
  y = 0;
  
  try {
    address = InetAddress.getLocalHost().toString();
  } catch (UnknownHostException e) {
    
  }
}

void draw() {
  background(0);
  
  textSize(14);
  text(address.toString(), 10,20);
  
  ellipse(x,y, 10,10);
  
  //Send message to all clients very 5 seconds
  if (millis() > now+5000) {
    ws.sendMessage("Server message");
    now = millis();
  }
}

//This is an event like onMouseClicked. If you chose to use it, it will be executed whenever a client sends a message
void webSocketServerEvent(String msg) {
  println(msg);
  x = random(width);
  y = random(height);
}
