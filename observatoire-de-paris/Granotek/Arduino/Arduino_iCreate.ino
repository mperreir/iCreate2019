// inclure la bibliothèque fast-led
#include <FastLED.h>
#define NUM_LEDS 5 // définir le nombre de leds

// Les informations diverses et dans l'ordre : 1, la serie de lampe où on est, 2, la lampe au sein de cette série, 3, 0 si on doit clignoter 1 sinon
int informations[3] = {0, 0, 1};
CRGBArray<NUM_LEDS> leds1;
CRGBArray<NUM_LEDS> leds2;
CRGBArray<NUM_LEDS> leds3;
CRGBArray<NUM_LEDS> leds4; // définir un tableau de données chaque entrée du tableau représentera une led.
CRGBArray<NUM_LEDS> leds[4] = {leds1, leds2, leds3, leds4};
int  inc = 0; // un variable que l'on va utiliser pour créer une animation.

void setup() {
  // on initialise notre strip de led sur la pin 9
  FastLED.addLeds<NEOPIXEL, 9>(leds1, NUM_LEDS);
  FastLED.addLeds<NEOPIXEL, 10>(leds2, NUM_LEDS);
  FastLED.addLeds<NEOPIXEL, 11>(leds3, NUM_LEDS);
  FastLED.addLeds<NEOPIXEL, 12>(leds4, NUM_LEDS);
  Serial.begin(115200);
  /*leds1.setBrightness(32);*/
  /*while(!Serial){}
  Serial.println("GO");*/
}

void loop() {
  inc+= 1;
    //Cas où on a un groupe de led allumé
    if (informations[1] == 0) {
      Serial.println(1);
      int int_entree = 0;
      while (!Serial.available()) {}
      int_entree = Serial.read();
      //Serial.println(int_entree);
      //int autre = Serial.read();
      //Serial.println(autre);
      if (int_entree == 100) {
        CRGBArray<NUM_LEDS> leds1b = leds1;
        CRGBArray<NUM_LEDS> leds2b = leds2;
        CRGBArray<NUM_LEDS> leds3b = leds3;
        CRGBArray<NUM_LEDS> leds4b = leds4;
        leds1 = CRGB(0, 0, 50);
        leds2 = CRGB(50, 50, 50);
        leds3 = CRGB(50, 50, 50);
        leds4 = CRGB(50, 0, 0);
        FastLED.show();
        delay(2000);
        leds1 = leds1b;
        leds2 = leds2b;
        leds3 = leds3b;
        leds4 = leds4b;
      }
      if ((int_entree == 110 or int_entree == 78) and informations[0] == 0 and inc != 1) {
        informations[0] = 3;
      }
      else if ((int_entree == 110 or int_entree == 78) and inc != 1) {
        informations[0] -= 1;
      }
      else if (informations[0] == 3) {
        informations[1] = 4;
      }
      else if (informations[0] == 4) {
        informations[0] = 0;
        for (int i = 0; i < 4; i ++) {
           leds[i] = CRGB(0, 0, 0);
        }
      }
      if ((int_entree == 110 or int_entree == 78) and inc != 1) {
        leds[informations[0]] = CRGB(0, 0, 0);
      }
      informations[2] = 1;
    }
    
    CRGBArray<NUM_LEDS> led_actuel = leds[informations[0]];
  
    if (informations[2] == 0) {
      delay(750);
      led_actuel = CRGB(0, 0, 0);
      informations[2] = 1;
    }
    else {
      delay(250);
//C T ICI
      if (led_actuel == leds1) {
        for (int j = 0; j < (informations[1] + 1); j++) {
          led_actuel[j] = CRGB(50, 0, 0);
        }
      }
      else if (led_actuel == leds2) {
        for (int j = 0; j < (informations[1] + 1); j++) {
          led_actuel[j] = CRGB(0, 50, 0);
        }
      }
      else if (led_actuel == leds3) {
        for (int j = 0; j < (informations[1] + 1); j++) {
          led_actuel[j] = CRGB(0, 0, 50);
        }
      }
      else if (led_actuel == leds4) {
        for (int j = 0; j < (informations[1] + 1); j++) {
          led_actuel[j] = CRGB(50, 50, 50);
        }
      }

      
      informations[1] += 1;
      if (informations[1] == 5) {
        informations[1] = 0;
        informations[0] += 1;
      }
      informations[2] = 0;
    }
    
    FastLED.show();
}
