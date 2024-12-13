float PLAYER_ORIGIN_X = 0;
float PLAYER_ORIGIN_Y = 0;

Player player = new Player(PLAYER_ORIGIN_X, PLAYER_ORIGIN_Y);
ArrayList<Particle> bullets = new ArrayList<Particle>();

ArrayList<Particle> toRemove = new ArrayList<Particle>();

void drawWorld(){
    drawBackground();
    
    player.draw();

    for(Particle bullet : bullets){
        if(bullet.prune){
            toRemove.add(bullet);
            continue;
        }
        bullet.draw();
    }
    bullets.removeAll(toRemove);
}

void drawBackground(){
    // draw the ground
    background(0);
    fill(200);
    beginShape();
        vertex(LEFT, BOTTOM, GROUND-0.01);
        vertex(RIGHT, BOTTOM, GROUND-0.01);
        vertex(RIGHT, TOP, GROUND-0.01);
        vertex(LEFT, TOP, GROUND-0.01);
    endShape(CLOSE);
}

void addBullet(){
    bullets.add(new Bullet(player.getX(), player.getY(), 0));
}