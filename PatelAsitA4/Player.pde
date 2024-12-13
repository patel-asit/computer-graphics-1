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
  float playerX, playerY;
  final float RECT_WIDTH = 200;
  final float RECT_HEIGHT = 200;

  float speed = 10;

  Player(float originX, float originY) {
    super();
    playerX = originX;
    playerY = originY;

    //for drifting back to center
    originX = originX;
    originY = originY;
  }

  void draw() {
    drawRectangle();
    move();
  }

  void drawRectangle() {
    fill(color(255, 0, 0));
    stroke(color(0, 0, 0));
    beginShape();
      vertex(playerX, playerY, GROUND);
      vertex(playerX+RECT_WIDTH, playerY, GROUND);
      vertex(playerX+RECT_WIDTH, playerY+RECT_HEIGHT, GROUND);
      vertex(playerX, playerY+RECT_HEIGHT, GROUND); 
    endShape();
  }

  void move(){
    if (moveLeft) {
      playerX = constrain(playerX-speed, LEFT, RIGHT);
    }
    if (moveRight) {
      playerX = constrain(playerX+speed, LEFT, RIGHT-RECT_WIDTH);
    }
    if (moveUp) {
      playerY = constrain(playerY+speed, BOTTOM, TOP-RECT_HEIGHT);
    }
    if (moveDown) {
      playerY = constrain(playerY-speed, BOTTOM, TOP);
    }
  }

  void driftBack(){

  }

  float getX(){
    return playerX+RECT_WIDTH/2;
  } 
  float getY(){
    return playerY+RECT_HEIGHT;
  }
}