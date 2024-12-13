abstract class Particle{
    boolean prune;
    float currX, currY;
    float radius;
    PVector center;

    Particle(){
        prune = false;
        updateCenter();
    }

    abstract void draw();
    abstract void move();
    abstract void collided(Particle other);
    abstract void updateCenter();

    PVector getCenter(){
        return center;
    }

    float getRadius(){
        return radius;
    }

    boolean isTouching(Particle other){
        PVector otherCenter = other.getCenter();
        float distance = dist(center.x, center.y, otherCenter.x, otherCenter.y);
        return distance < radius + other.getRadius();
    }
}