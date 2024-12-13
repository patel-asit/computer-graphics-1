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

  float moveSpeed = 10;
  
  //0.005 is a magic number because the players drift moveSpeed felt right when running 
  float driftSpeed = 0.005;

  Player(float originX, float originY) {
    super();
    playerX = originX;
    playerY = originY;

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
      vertex(playerX, playerY, GROUND);
      vertex(playerX+RECT_WIDTH, playerY, GROUND);
      vertex(playerX+RECT_WIDTH, playerY+RECT_HEIGHT, GROUND);
      vertex(playerX, playerY+RECT_HEIGHT, GROUND); 
    endShape();
  }

  void move(){
    if (moveLeft) {
      playerX = constrain(playerX-moveSpeed, LEFT, RIGHT);
    }
    if (moveRight) {
      playerX = constrain(playerX+moveSpeed, LEFT, RIGHT-RECT_WIDTH);
    }
    if (moveUp) {
      playerY = constrain(playerY+moveSpeed, BOTTOM, TOP-RECT_HEIGHT);
    }
    if (moveDown) {
      playerY = constrain(playerY-moveSpeed, BOTTOM, TOP);
    }
    if(!moveLeft && !moveRight && !moveUp && !moveDown){
      driftBack();
    }
  }

  void driftBack(){
    //drift the player back to origin using the simplest lerp step
    playerX = lerp(playerX, originX, driftSpeed);
    playerY = lerp(playerY, originY, driftSpeed);
  }

  float getX(){
    return playerX+RECT_WIDTH/2;
  } 
  float getY(){
    return playerY+RECT_HEIGHT;
  }
}