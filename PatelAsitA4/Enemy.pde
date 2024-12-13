    float RECT_SIZE = 100;

class Enemy extends Particle {
    float speed = 300; //frames per second
    float FRAME_RATE = 60;

    float dist, numSteps, stepCount;
    float destX, destY;
    float originX, originY;
    
    Enemy(float originX, float originY) {
        currX = originX;
        currY = originY;
        this.originX = originX;
        this.originY = originY;
        randomizeDest();
    }

    void move() {
        //one time movement including lerps
        //for 0th iteration
        //numsteps will give the interpolation t=0 and t=1 i think
        //then do t prime?
        float t;
        if(stepCount <= numSteps){
            t = 0.5 * (1 - cos(PI * (stepCount/numSteps)));
            currX = lerp(originX, destX, t);
            currY = lerp(originY, destY, t);
            stepCount++;
        }else{
            shootBullet();
            randomizeDest();
        }
    }

    void draw() {
        drawRectangle();
        move();
        checkPrune();
    }

    void shootBullet(){
        //add bullet to world
        world.addEnemyBullet(currX, currY);
        // bullets.add(new Bullet(currX, currY, new PVector(0, 1)));
    }
    
    void randomizeDest(){
        destX = random(LEFT+RECT_SIZE, RIGHT-RECT_SIZE);
        destY = random(0, TOP-RECT_SIZE);
        dist = dist(currX, currY, destX, destY);
        numSteps = dist / speed * FRAME_RATE;
        originX = currX;
        originY = currY;
        stepCount = 0;
    }

    void checkPrune(){
        //include collisions here later
        if(currX < LEFT || currX > RIGHT || currY < BOTTOM || currY > TOP){
            prune = true;
        }
    }

  void drawRectangle() {
    fill(color(0, 0, 255));
    stroke(color(0, 0, 0));
    beginShape();
      vertex(currX, currY, GROUND);
      vertex(currX+RECT_SIZE, currY, GROUND);
      vertex(currX+RECT_SIZE, currY+RECT_SIZE, GROUND);
      vertex(currX, currY+RECT_SIZE, GROUND); 
    endShape();
  }

    void setBoundingBox(){
        radius = RECT_SIZE/2;
    }
}