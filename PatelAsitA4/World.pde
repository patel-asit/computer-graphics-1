boolean hardMode = false;

class World{
    float PLAYER_ORIGIN_X = (LEFT+RIGHT)/2;
    float PLAYER_ORIGIN_Y = BOTTOM;

    boolean playerDead;
    int level;
    Player player;
    ArrayList<Bullet> bullets;
    ArrayList<Enemy> enemies;
    ArrayList<Particle> toRemove;
    ArrayList<Particle> particles;

    World(){
        level = 1;
        playerDead = false;
        player = new Player(PLAYER_ORIGIN_X, PLAYER_ORIGIN_Y);
        bullets = new ArrayList<Bullet>();
        enemies = new ArrayList<Enemy>();
        toRemove = new ArrayList<Particle>();
        particles = new ArrayList<Particle>();
        addEnemy(level);
    }

    void drawWorld(){
        drawBackground();
        if(!player.prune){
            drawParticles();

            if(doCollision)
                checkCollisions();
        }
    }

    void drawParticles(){
        particles.clear();
        particles.add(player);
        particles.addAll(bullets);
        particles.addAll(enemies);

        for(Particle particle : particles){
            if(particle.prune){
                toRemove.add(particle);
                continue;
            }
            particle.draw();
        }

        //remove all the pruned particles
        enemies.removeAll(toRemove);
        bullets.removeAll(toRemove);

        if(enemies.size() == 0){
            addEnemy(level++);
        }
    }

    void checkCollisions(){
        //check collisions between every particle
        for(Particle particle : particles){
            for(Particle other : particles){
                if(particle != other){
                    particle.collided(other);
                }
            }
        }
    }

    void drawBackground(){
        // draw the ground
        background(100);
        fill(200);
        beginShape();
            if(doTextures){
                texture(backgroundTexture);
            }
            vertex(LEFT, BOTTOM, GROUND-0.01, 0, 1);
            vertex(RIGHT, BOTTOM, GROUND-0.01, 1, 1);
            vertex(RIGHT, TOP, GROUND-0.01, 1, 0);
            vertex(LEFT, TOP, GROUND-0.01, 0, 0);
        endShape(CLOSE);
    }

    void addPlayerBullet(){
        addBullet(player.getX(), player.getY(), new PVector(0, 1), true);
    }

    void addEnemyBullet(float x, float y){
        PVector direction = new PVector(player.getX() - x, player.getY() - y);
        direction.normalize();
        addBullet(x, y, direction, false);
    }

    //adds the bullet in world
    void addBullet(float x, float y, PVector direction, boolean playerBullet){
        bullets.add(new Bullet(x, y, direction, playerBullet));
        // particles.add(new Bullet(x, y, direction, playerBullet));
    }
    
    //randomly adds enemy on top half of screen
    void addEnemy(int level){
        if(level >= 6){
            hardMode = true;
        }

        for(int i = 0; i < level; i++){
            float randomX = random(LEFT, RIGHT);
            float randomY = random(0, TOP);
            enemies.add(new Enemy(randomX, randomY));
            // particles.add(new Enemy(randomX, randomY));
        }
    }
}
