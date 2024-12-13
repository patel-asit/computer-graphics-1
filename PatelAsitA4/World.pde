
class World{
    float PLAYER_ORIGIN_X = (LEFT+RIGHT)/2;
    float PLAYER_ORIGIN_Y = BOTTOM;

    Player player;
    ArrayList<Bullet> bullets;
    ArrayList<Particle> toRemove;
    ArrayList<Enemy> enemies;
    ArrayList<Particle> particles;

    World(){
        player = new Player(PLAYER_ORIGIN_X, PLAYER_ORIGIN_Y);
        bullets = new ArrayList<Bullet>();
        enemies = new ArrayList<Enemy>();
        toRemove = new ArrayList<Particle>();
        particles = new ArrayList<Particle>();
        particles.add(player);
        addEnemy();
        // addEnemy();
        // addEnemy();
        // addEnemy();
    }

    void drawWorld(){
        drawBackground();
        particles.addAll(bullets);
        particles.addAll(enemies);
        // player.draw();
        // drawBullets();
        // drawEnemies();

        //draw particles
        for(Particle particle : particles){
            if(particle.prune){
                toRemove.add(particle);
                continue;
            }
            particle.draw();
        }


        // //merge bullets and enemies list into particles list
        // particles.addAll(bullets);
        // particles.addAll(enemies);

        // // //check collisions between every particle
        // // for(Particle particle : particles){
        // //     print(particle);
        // //     for(Particle other : particles){
        // //         if(particle != other){
        // //             particle.collided(other);
        // //         }
        // //     }
        // // }

        // //check collisions between every particle and bullet
        // for(Particle particle : particles){
        //     for(Particle bullet : bullets){
        //         bullet.collided(particle); //<>//
        //     }
        // }
    }

    void drawBullets(){
        for(Particle bullet : bullets){
            if(bullet.prune){
                toRemove.add(bullet);
                continue;
            }
            bullet.draw();
        }
        bullets.removeAll(toRemove);
        toRemove.clear();
    }

    void drawEnemies(){
        for(Enemy enemy : enemies){
            if(enemy.prune){
                toRemove.add(enemy);
                continue;
            }
            enemy.draw();
        }
        enemies.removeAll(toRemove);
        toRemove.clear();
    }

    void drawBackground(){
        // draw the ground
        background(100);
        fill(200);
        beginShape();
            vertex(LEFT, BOTTOM, GROUND-0.01);
            vertex(RIGHT, BOTTOM, GROUND-0.01);
            vertex(RIGHT, TOP, GROUND-0.01);
            vertex(LEFT, TOP, GROUND-0.01);
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
    void addEnemy(){
        float randomX = random(LEFT, RIGHT);
        float randomY = random(0, TOP);
        enemies.add(new Enemy(randomX, randomY));
        // particles.add(new Enemy(randomX, randomY));
    }
}
