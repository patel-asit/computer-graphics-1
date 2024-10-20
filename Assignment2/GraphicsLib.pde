//raster coordinates
final int RASTER_Z = 16;
final int RASTER_LEFT = -10;
final int RASTER_RIGHT = 10;
final int RASTER_BOTTOM = -10;
final int RASTER_TOP= 10;
final int RASTER_WIDTH = 800;
final int RASTER_HEIGHT= 800;

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

// colors for drawing and filling
final float[][] PHONG_COLORS = {{0.15f, 0.65f, 1f}, {0.15f, 0.65f, 1f}, {1f, 1f, 1f}} ; // A, D, S colors

// for projection and lighting
PVector EYE = new PVector(0, 0, 0); // at the origin

// Phong lighting parameters
PVector LIGHT = new PVector(-10, -10, -50); // above and behind the EYE

final float[] MATERIAL = {0.4, 0.5, 0.4}; // A, D, S
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
void setPixel(int i, int j) {
  int index = getIndex(i, j);
  if (0 <= index && index < numPixels) {
    pixels[index] = stateColor;
  } else {
    println("ERROR:  this pixel is not within the raster.");
  }
}

int getIndex(int col, int row) {
  return row*width + col;
}
