// player character
final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';

// turn textures or collisions on/off - useful for testing and debugging
final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';

boolean doTextures = false;
boolean doCollision = false;

void keyPressed() {
    if (key == KEY_LEFT) {
        moveLeft = true;
    }
    if (key == KEY_RIGHT) {
        moveRight = true;
    }
    if (key == KEY_UP) {
        moveUp = true;
    }
    if (key == KEY_DOWN) {
        moveDown = true;
    }
    if(key == KEY_SHOOT){
        world.addBullet();
    }
}

void keyReleased() {
    if (key == KEY_LEFT) {
        moveLeft = false;
    }
    if (key == KEY_RIGHT) {
        moveRight = false;
    }
    if (key == KEY_UP) {
        moveUp = false;
    }
    if (key == KEY_DOWN) {
        moveDown = false;
    }
}
