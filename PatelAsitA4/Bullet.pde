class Bullet extends Particle {
    float speed;
    float x, y;
    PVector direction;
    float z = GROUND-0.005;
    Bullet(float originX, float originY, PVector direction) {
        this.speed = 10;
        this.direction = direction;
        this.x = originX;
        this.y = originY;
    }

    void move() {
        x += speed * direction.x;
        y += speed * direction.y;
        // direction.rotate(PI / 180); // Rotate by 1 degree each frame
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

    int i = 0;
    void drawRectangle() {
        fill(color(0, 255, 0));
        stroke(color(0, 0, 0));
        pushMatrix();
        beginShape(TRIANGLE);
            //bring the axis from origin to current point
            translate(x, y, z);
            //perform rotation about the axis
            rotate(radians(i++));
            //reset the axis to draw
            translate(-x, -y, -z);

            vertex(x, y, z);
            vertex(x-40, y-40, z);
            vertex(x+40, y-40,z);
        endShape();
        popMatrix();
  }

}