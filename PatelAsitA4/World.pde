
class World{
    float PLAYER_ORIGIN_X = (LEFT+RIGHT)/2;
    float PLAYER_ORIGIN_Y = BOTTOM;

    Player player;
    ArrayList<Particle> bullets;
    ArrayList<Particle> toRemove;
    ArrayList<Enemy> enemies;

    World(){
        //add enemies every 2 seconds
        player = new Player(PLAYER_ORIGIN_X, PLAYER_ORIGIN_Y);
        bullets = new ArrayList<Particle>();
        enemies = new ArrayList<Enemy>();
        toRemove = new ArrayList<Particle>();
        addEnemy();
    }

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

        for(Enemy enemy : enemies){
            enemy.draw();
        }
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
        bullets.add(new Bullet(x, y, direction, false));
    }
    
    //randomly adds enemy on top half of screen
    void addEnemy(){
        float randomX = random(LEFT, RIGHT);
        float randomY = random(0, TOP);
        enemies.add(new Enemy(randomX, randomY));
    }
}