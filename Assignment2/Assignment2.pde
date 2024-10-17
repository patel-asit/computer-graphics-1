/*
  COMP 3490 Assignment 2
  Author: ASIT PATEL (7866182)
 */

final color BLACK = color(0);
int numPixels;

void setup() {
  // RGB values range over 0..1 rather than 0..255
  colorMode(RGB, 1.0f);
  size(800, 800);
  numPixels = width * height;
  printSettings();
}

/*
You should read this function carefully and understand how it works,
 but you should not need to edit it
 */
void draw() {
  colorMode(RGB, 1.0f);
  background(BLACK);

  /*
  CAUTION: none of your functions should call loadPixels() or updatePixels().
   This is already done in the template. Extra calls will probably break things.
   */
  //clearCanvasToBlack();

  if (shadingMode == shadingMode.FLAT) {


  } else if (shadingMode == shadingMode.PHONG_LIGHTING) {
    

  } else if (shadingMode == shadingMode.REFLECTIONS_SHADOWS) {


  }
}

/*
Given a point p, unit normal vector n, eye location, light location, and various
 material properties, calculate the Phong lighting at that point (see course
 notes and the assignment instructions for more details).
 Return an array of length 3 containing the calculated RGB values.
 */
float[] phong(PVector p, PVector n, PVector eye, PVector light,
  float[] material, float[][] fillColor, float shininess) {
  return null;
}

/*
Add helper functions for coordinate conversions
 */
 int getPixel(int row, int col){
    return  row * width + col;
 }

 void clearCanvasToBlack() {
  loadPixels();
  for (int i=0; i<numPixels; i++) {
    pixels[i] = BLACK;
  }
  updatePixels();
}