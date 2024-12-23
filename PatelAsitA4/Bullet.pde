class Bullet extends Particle {
    PVector direction;
    float speed;
    float rotationAngle = 0;
    
    float RECT_SIZE = 100;
    float z = GROUND-0.005;

    boolean playerBullet = false;
    
    Bullet(float originX, float originY, PVector direction, boolean playerBullet) {
        this.speed = 10;
        this.direction = direction;
        this.playerBullet = playerBullet;
        currX = originX;
        currY = originY;
        radius = sqrt(sq(RECT_SIZE/2) + sq(RECT_SIZE/2));
    }

    void draw() {
        drawBullet();
        move();
        checkBounds();
    }
    
    void drawBullet() {
        if(playerBullet){
            fill(color(0, 255, 0));
        }else{
            fill(color(128, 0, 0));
        }
        stroke(color(0, 0, 0));

        pushMatrix();
        beginShape();
            if(doTextures && playerBullet){
                texture(playerBulletTexture);
                noStroke();
            }

            //bring the axis from origin to current point
            translate(currX, currY, z);
            //perform rotation about the axis
            rotate(radians(rotationAngle++));
            //reset the axis to draw
            translate(-currX, -currY, -z);

            vertex(currX, currY, z, 0, 1);
            vertex(currX+RECT_SIZE, currY, z, 1, 1);
            vertex(currX+RECT_SIZE, currY+RECT_SIZE, z, 1, 0);
            vertex(currX, currY+RECT_SIZE, z, 0, 0); 
        endShape(CLOSE);
        popMatrix();
    }

    void move() {
        currX += speed * direction.x;
        currY += speed * direction.y;
        // direction.rotate(PI / 180); // Rotate by 1 degree each frame
        updateCenter();
    }

    void checkBounds(){
        //include collisions here later
        if(currX < LEFT || currX > RIGHT || currY < BOTTOM || currY > TOP){
            prune = true;
        }
    }

    void collided(Particle other){
        if(isTouching(other)){
            //apply if the bounds are touching
            if(other instanceof Bullet){
                prune = (playerBullet ^ ((Bullet)other).playerBullet);
            }else{
                //meaning its enemy or player
                if(playerBullet){
                    prune = other instanceof Enemy;
                }else{
                    prune = other instanceof Player;
                }
            }
        }
    }

    void updateCenter(){
        center = new PVector(currX+RECT_SIZE/2, currY+RECT_SIZE/2);
    }
}