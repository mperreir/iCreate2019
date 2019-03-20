import websockets.*;

WebsocketClient wsc;
int now;
int state = 0;
String ipAddress = "";
boolean keyboard = false;

void setup() {
  size(200,200);
  
  now = millis();
}

void draw() {
  background(255);
  
  if (state == 0) {
    textSize(14);
    fill(0);
    text ("Adresse IP : \n" + ipAddress, 10, 20);
  }
  
  //Every 5 seconds I send a message to the server through the sendMessage method
  if (state == 1 && millis() > now+5000) {
    wsc.sendMessage("Client message");
    now = millis();
  }
}

//This is an event like onMouseClicked. If you chose to use it, it will be executed whenever the server sends a message 
void webSocketEvent(String msg) {
  println(msg);
}

void keyPressed() {
  if (keyCode == 66) { // ENTER
    state++;
    closeKeyboard();
    wsc = new WebsocketClient(this, "ws://"+ipAddress+":8025/musee");
  } else if (keyCode == 67 && ipAddress.length() > 0) { // BACKSPACE
    ipAddress = ipAddress.substring(0, ipAddress.length()-1);
  } else if (keyCode == 56) { // DOT
    ipAddress = ipAddress + '.';
  } else if (keyCode >= 7 && keyCode <= 16) { // NUMBER
    ipAddress = ipAddress + (keyCode - 7);
  }
}

void mousePressed() {
  if (!keyboard) {
    openKeyboard();
    keyboard = true;
  } else {
    closeKeyboard();
    keyboard = false;
  }
}
