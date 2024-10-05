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

  singleTriangle = new Triangle[]{
    new Triangle(new PVector[]{
      new PVector(150, -150, 20),
      new PVector(0, 150, 20),
      new PVector(-150, -150, 20)
    }, new PVector[]{
        new PVector(0, 0, 0),
        new PVector(0, 0, 0),
        new PVector(0, 0, 0)
  })}; // change this line <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  rotatedSingleTriangle = copyTriangleList(singleTriangle); // <<<<<<< would i have to change this copylist since i added more instance variables to the Triangle class??

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
  for (Triangle t : triangles) {
    draw2DTriangle(t);
  }
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
  //triangle has 3 vertices and 3 normals

  //i think we focus only on vertices here, so loop through each vertex and project it

  // holds 2D projected vertices
  // Each of this PVector vertex is 2D projected from 3D
  PVector twoDVertices[] = new PVector[3];

  // now i have projected triangle points for 2D raster
  for (int i = 0; i < 3; i++) {
    twoDVertices[i] = projectVertex(t.vertices[i]);
    //System.out.println(twoDVertices[i]);
    
    //print vertices with with saying vertex number i and its x and y values
    System.out.println("Vertex " + i + " x: " + twoDVertices[i].x + " y: " + twoDVertices[i].y);
  }

  // now i need to get the edges of the triangle
  // we assume that the input vertices are in CCW order
  // need a method for edge vector 
  // returns: 3 edge vectors in CCW order, using 3 vertices
  //PVector[] edges = getEdges(twoDVertices);

  // maybe i shouldnt need edge vectors, i just make line using points.
  // use those edges to draw bresenhams line and give the 2D vertices as int values
  for (int i = 0; i < 3; i++) {
    // print out the line coordinates with Edge number i and its x and y values
    System.out.println("Edge " + i + " x: " + int(twoDVertices[i].x) + " y: " + int(twoDVertices[i].y) + " x2: " + int(twoDVertices[(i + 1) % 3].x) + " y2: " + int(twoDVertices[(i + 1) % 3].y));
  
    bresenhamLine(int(twoDVertices[i].x), int(twoDVertices[i].y), int(twoDVertices[(i + 1) % 3].x), int(twoDVertices[(i + 1) % 3].y));
  }
  
  // DOUBLE CHECK WHEN DOES projectVertex() returns NULL VALUES
  // ACCOUNT FOR THOSE

  // DO SOMETHING ABOUT degenerate triangles AND back-facing culling
}

//helper functions for 2D triangle drawing
PVector[] getEdges(PVector[] vertices) {
  PVector[] edges = new PVector[3];
  for (int i = 0; i < 3; i++) {
    edges[i] = vertices[(i + 1) % 3].copy().sub(vertices[i]);
  }
  return edges;
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
