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
  final float RECT_WIDTH = 200;
  final float RECT_HEIGHT = 250;

  //0.005 is a magic number because the players drift moveSpeed felt right when running 
  float driftSpeed = 0.005;
  float moveSpeed = 10;

  Player(float originX, float originY) {
    //for drifting back to center
    this.originX = originX;
    this.originY = originY;

    currX = originX;
    currY = originY;

    radius = sqrt(sq(RECT_WIDTH/2) + sq(RECT_HEIGHT/2));
  }

  void draw() {
    drawRectangle();
    move();
  }

  void drawRectangle() {
    fill(color(255, 0, 0));
    noStroke();
    beginShape();
      if(doTextures){
        texture(playerTexture);
      }
      vertex(currX, currY, GROUND, 0,1);
      vertex(currX+RECT_WIDTH, currY, GROUND, 1,1);
      vertex(currX+RECT_WIDTH, currY+RECT_HEIGHT, GROUND, 1,0);
      vertex(currX, currY+RECT_HEIGHT, GROUND, 0,0); 
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

    updateCenter();
  }

  void driftBack(){
    //drift the player back to origin using the simplest lerp step
    currX = lerp(currX, originX, driftSpeed);
    currY = lerp(currY, originY, driftSpeed);
  }

  void collided(Particle other){
    if(isTouching(other)){
      if(other instanceof Bullet){
          prune = !((Bullet)other).playerBullet;
      }else if(other instanceof Enemy){
          prune = true;
      }
    }
  }

  void updateCenter(){
    center = new PVector(currX+RECT_WIDTH/2, currY+RECT_HEIGHT/2);
  }

  float getX() { return currX + RECT_WIDTH / 2; }
  float getY() { return currY + RECT_HEIGHT; }
}