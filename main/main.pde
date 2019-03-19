import de.voidplus.leapmotion.*;
import processing.sound.*;

LeapMotion leap;

void setup() {
  size(800, 500);
  background(255);
  // ...

  leap = new LeapMotion(this).allowGestures();
}

void draw(){
  for (Hand hand : leap.getHands ()) {

    int     handId             = hand.getId();
    PVector handPosition       = hand.getPosition();
    PVector handStabilized     = hand.getStabilizedPosition();
    PVector handDirection      = hand.getDirection();
    PVector handDynamics       = hand.getDynamics();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float   handGrab           = hand.getGrabStrength();
    float   handPinch          = hand.getPinchStrength();
    float   handTime           = hand.getTimeVisible();
    PVector spherePosition     = hand.getSpherePosition();
    float   sphereRadius       = hand.getSphereRadius();
    
    println(handIsLeft);
    println(handGrab);
  }
}
