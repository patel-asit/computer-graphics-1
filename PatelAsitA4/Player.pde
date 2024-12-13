/***************
 Global variables for keyboard movement
 **************/
  boolean moveLeft = false;
  boolean moveRight = false;
  boolean moveUp = false;
  boolean moveDown = false;
  boolean playerShoot = false;

class Player extends Particle {
  float originX, originY;
  float currX, currY;
  final float RECT_WIDTH = 200;
  final float RECT_HEIGHT = 200;

  float moveSpeed = 10;
  
  //0.005 is a magic number because the players drift moveSpeed felt right when running 
  float driftSpeed = 0.005;

  Player(float originX, float originY) {
    super();
    currX = originX;
    currY = originY;

    //for drifting back to center
    this.originX = originX;
    this.originY = originY;
  }

  void draw() {
    drawRectangle();
    move();
  }

  void drawRectangle() {
    fill(color(255, 0, 0));
    stroke(color(0, 0, 0));
    beginShape();
      vertex(currX, currY, GROUND);
      vertex(currX+RECT_WIDTH, currY, GROUND);
      vertex(currX+RECT_WIDTH, currY+RECT_HEIGHT, GROUND);
      vertex(currX, currY+RECT_HEIGHT, GROUND); 
    endShape();
  }

  void move(){
    if (moveLeft) {
      currX = constrain(currX-moveSpeed, LEFT, RIGHT);
    }
    if (moveRight) {
      currX = constrain(currX+moveSpeed, LEFT, RIGHT-RECT_WIDTH);
    }
    if (moveUp) {
      currY = constrain(currY+moveSpeed, BOTTOM, TOP-RECT_HEIGHT);
    }
    if (moveDown) {
      currY = constrain(currY-moveSpeed, BOTTOM, TOP);
    }
    if(!moveLeft && !moveRight && !moveUp && !moveDown){
      driftBack();
    }
  }

  void driftBack(){
    //drift the player back to origin using the simplest lerp step
    currX = lerp(currX, originX, driftSpeed);
    currY = lerp(currY, originY, driftSpeed);
  }

  float getX(){
    return currX+RECT_WIDTH/2;
  } 
  float getY(){
    return currY+RECT_HEIGHT;
  }

  void setBoundingBox(){
    radius = RECT_WIDTH/2;
  }
}