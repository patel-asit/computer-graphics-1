class Bullet extends Particle {
    float speed;
    float direction;
    float x, y;
    Bullet(float originX, float originY, float direction) {
        this.speed = 10;
        this.direction = direction;
        this.x = originX;
        this.y = originY;
    }

    void move() {
        // x += speed;
        y += speed;
    }

    void draw() {
        drawRectangle();
        move();
        checkPrune();
    }

    void checkPrune(){
        //include collisions here later
        if(x < LEFT || x > RIGHT || y < BOTTOM || y > TOP){
            prune = true;
        }
    }

    void drawRectangle() {
        fill(color(0, 255, 0));
        stroke(color(0, 0, 0));
        beginShape(TRIANGLE);
            vertex(x, y, GROUND);
            vertex(x+40, y, GROUND);
            vertex(x+40, y+40, GROUND);
        endShape();
  }

}