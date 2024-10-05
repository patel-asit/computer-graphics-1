/*
COMP 3490 Assignment 1 Template
 */

final color BLACK = color(0);

// for the test mode with one triangle
Triangle[] singleTriangle;
Triangle[] rotatedSingleTriangle;

// for drawing and rotating the 3D shape
Triangle[] surfaceTessellation;
Triangle[] rotatedSurfaceTessellation;

// to make the image rotate - don't change these values
float theta = 0.0;  // rotation angle
float dtheta = 0.01; // rotation speed

PGraphics buffer;

void setup() {
  // RGB values range over 0..1 rather than 0..255
  colorMode(RGB, 1.0f);

  buffer = createGraphics(600, 600);

  singleTriangle = new Triangle[]{}; // change this line
  rotatedSingleTriangle = copyTriangleList(singleTriangle);

  surfaceTessellation = new Triangle[]{}; // change this line
  rotatedSurfaceTessellation = copyTriangleList(surfaceTessellation);

  printSettings();
}

void settings() {
  size(600, 600); // hard-coded canvas size, same as the buffer
}

/*
You should read this function carefully and understand how it works,
 but you should not need to edit it
 */
void draw() {
  buffer.beginDraw();
  buffer.colorMode(RGB, 1.0f);
  buffer.background(BLACK);

  /*
  CAUTION: none of your functions should call loadPixels() or updatePixels().
   This is already done in the template. Extra calls will probably break things.
   */
  buffer.loadPixels();

  if (doRotate) {
    theta += dtheta;
    if (theta > TWO_PI) {
      theta -= TWO_PI;
    }
  }

  //do not change these blocks: rotation is already set up for you
  if (displayMode == DisplayMode.TEST_LINES) {
    testBresenham();
  } else if (displayMode == DisplayMode.SINGLE_TRIANGLE) {
    rotateTriangles(singleTriangle, rotatedSingleTriangle, theta);
    drawTriangles(rotatedSingleTriangle);
  } else if (displayMode == DisplayMode.SURFACE) {
    rotateTriangles(surfaceTessellation, rotatedSurfaceTessellation, theta);
    drawTriangles(rotatedSurfaceTessellation);
  }

  buffer.updatePixels();
  buffer.endDraw();
  image(buffer, 0, 0); // draw our raster image on the screen
}

/*
 Receives an array of triangles and draws them on the raster by
 calling draw2DTriangle()
 */
void drawTriangles(Triangle[] triangles) {
}

/*
Use the projected vertices to draw the 2D triangle on the raster.
 Several tasks need to be implemented:
 - cull degenerate or back-facing triangles
 - draw triangle edges using bresenhamLine()
 - draw normal vectors if needed
 - fill the interior using fillTriangle()
 */
void draw2DTriangle(Triangle t) {
}

/*
 Draw the normal vectors at each vertex and triangle center
 */
final int NORMAL_LENGTH = 20;
final float[] FACE_NORMAL_COLOR = {0f, 1f, 1f}; // cyan
final float[] VERTEX_NORMAL_COLOR = {1f, 0.6f, 0.1f}; // orange

void drawNormals(Triangle t) {
}

/*
Fill the 2D triangle on the raster, using a scanline algorithm.
 Modify the raster using setColor() and setPixel() ONLY.
 */
void fillTriangle(Triangle t) {
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
