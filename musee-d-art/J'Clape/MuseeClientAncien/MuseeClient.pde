import websockets.*;

WebsocketClient wsc;
int state = 0;
String ipAddress = "";
boolean keyboard = false;

// Initialisation
void setup() {
  fullScreen();
  
  wsc = new WebsocketClient(this, "ws://192.168.8.107:8025/musee");
}

// Fonction appelée régulièrement
void draw() {
  background(255);
  
  textSize(14);
  fill(0);
  /*
  if (state == 0) {
    // Synchronisation client/serveur
    text("Adresse IP : \n" + ipAddress, 10, 20);
  } else if (state == 1) {
    text("Connexion OK", 10, 20);
    // wsc.sendMessage("Client message");
  }
  */
}

// Le client reçoit un message du serveur 
void webSocketEvent(String msg) {
  println(msg);
}

// Une touche est appuyée
void keyPressed() {
  if (keyCode == 66) { // ENTER
    state++;
    closeKeyboard();
    // wsc = new WebsocketClient(this, "ws://"+ipAddress+":8025/musee");
  } else if (keyCode == 67 && ipAddress.length() > 0) { // BACKSPACE
    ipAddress = ipAddress.substring(0, ipAddress.length()-1);
  } else if (keyCode == 56) { // DOT
    ipAddress = ipAddress + '.';
  } else if (keyCode >= 7 && keyCode <= 16) { // NUMBER
    ipAddress = ipAddress + (keyCode - 7);
  }
}

// Clic sur l'application
void mousePressed() {
  wsc.sendMessage("Client message");
  if (!keyboard) {
    openKeyboard();
    keyboard = true;
  } else {
    closeKeyboard();
    keyboard = false;
  }
}
