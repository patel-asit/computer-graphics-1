// useful constants
final int NUM_DIMENSIONS = 3;

// when you store (r,g,b) values in an array,
// USE THESE NAMED CONSTANTS to access the entries
final int R = 0;
final int G = 1;
final int B = 2;
final int NUM_COLOR_CHANNELS = 3;

// when you store (ambient,diffuse,specular) values in an array,
// USE THESE NAMED CONSTANTS to access the entries
final int A = 0;
final int D = 1;
final int S = 2;
final int NUM_LIGHT_COMPONENTS = 3;

// colors for drawing and filling triangles
final float[] OUTLINE_COLOR = {1.0f, 0.3f, .1f};
final float[] FLAT_FILL_COLOR = {1f, 1f, 1f};
final float[][] PHONG_COLORS = {{0.15f, 0.65f, 1f}, {0.15f, 0.65f, 1f}, {1f, 1f, 1f}} ; // A, D, S colors

// for projection and lighting
PVector EYE = new PVector(0, 0, 0); // location

// Phong lighting parameters
PVector LIGHT = new PVector(300, 300, 350); // location

//raster coordinates
final int RASTER_Z = 16;
final int RASTER_LEFT = -10;
final int RASTER_RIGHT = 10;
final int RASTER_BOTTOM = -10;
final int RASTER_TOP= 10;
final int RASTER_WIDTH = 800;
final int RASTER_HEIGHT= 800;

final float[] MATERIAL = {0.4, 0.5, 0.5}; // A, D, S
final float PHONG_SHININESS = 100; // exponent

/*
 A shortcut, because exponents are costly: only include the specular term
 if (R dot V) > SPECULAR_FLOOR
 */
final float SPECULAR_CUTOFF = 0.01;
final float SPECULAR_FLOOR = (float)Math.pow(SPECULAR_CUTOFF, 1/PHONG_SHININESS);

// to change the current color
// assorted overloads provided for convenience
color stateColor;
void setColor(float[] col) {
  stateColor = color(col[R], col[G], col[B]);
}

void setColor(float red, float green, float blue) {
  stateColor = color(red, green, blue);
}

void setColor(color c) {
  stateColor = c;
}

// draw a pixel at the given location
void setPixel(float x, float y) {
  int index = indexFromXYCoord(x, y);
  if (0 <= index && index < pixels.length) {
    pixels[index] = stateColor;
  } else {
    println("ERROR:  this pixel is not within the raster.");
  }
}

void setPixel(PVector p) {
  setPixel(p.x, p.y);
}

// helper functions for pixel calculations
int indexFromXYCoord(float x, float y) {
  int col = colNumFromXCoord(x);
  int row = rowNumFromYCoord(y);
  return indexFromColRow(col, row);
}

int indexFromColRow(int col, int row) {
  return row*width + col;
}

int colNumFromXCoord(float x) {
  return (int)round(x + width/2);
}

int rowNumFromYCoord(float y) {
  return (int)round(height/2 - y);
}
