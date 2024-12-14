class Enemy extends Particle {
    float RECT_SIZE = 250;
    float speed = 300; //pixels per second
    float FRAME_RATE = 60;

    float dist, numSteps, stepCount;
    float destX, destY;
    float originX, originY;
    float Z;

    Enemy(float originX, float originY) {
        // for avoiding enemy overlapping
        Z = GROUND + random(0.05, 0.10);

        this.originX = originX;
        this.originY = originY;
        currX = originX;
        currY = originY;

        if(hardMode){
            speed = 500;
        }
        
        radius = sqrt(sq(RECT_SIZE/2) + sq(RECT_SIZE/2));
        randomizeDest();
    }

    void draw() {
        drawRectangle();
        move();
    }

    void move() {
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
        updateCenter();
    }

    void shootBullet(){
        world.addEnemyBullet(currX, currY);
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

    void drawRectangle() {
        fill(color(0, 0, 255));
        noStroke();
        beginShape();
            if(doTextures){
                texture(enemyTexture);
            }
            vertex(currX, currY, Z,0,1);
            vertex(currX+RECT_SIZE, currY, Z, 1,1);
            vertex(currX+RECT_SIZE, currY+RECT_SIZE, Z, 1,0);
            vertex(currX, currY+RECT_SIZE, Z, 0,0); 
        endShape();
    }

    void updateCenter(){
        center = new PVector(currX+RECT_SIZE/2, currY+RECT_SIZE/2);
    }

    void collided(Particle other){
        if(isTouching(other)){
            if(other instanceof Bullet){
                prune = ((Bullet)other).playerBullet;
            }else if(other instanceof Player){
                prune = true;
            }
        }
    }
}