float Z_NEAR = 1.5;
float GROUND = -1.5;
float Z_FAR = 1500;
float LEFT = -1000;
float RIGHT = 1000;
float BOTTOM = -1000;
float TOP = 1000;

void setup() {
  size(600, 600, P3D); // change the dimensions if desired
  textureMode(NORMAL); // use normalized 0..1 texture coords
  textureWrap(REPEAT); // change if desired
  frustum(LEFT, RIGHT, TOP, BOTTOM, Z_NEAR, Z_FAR);
  // resetMatrix(); // replace this with your chosen camera settings
  camera(0, -1, 1, 0, 0, -Z_FAR, 0, 1, 1);
}

void draw() {
  drawWorld();
}
