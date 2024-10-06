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
      new PVector(200, -200, 20),
      new PVector(0, 200, 20),
      new PVector(-200, -200, 20)
    }, new PVector[]{
        new PVector(0, 0, 1),
        new PVector(0, 0, 1),
        new PVector(0, 0, 1)
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
    draw2DTriangle(t);  }
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
  setColor(OUTLINE_COLOR);
  
  // holds 2D projected vertices
  PVector twoDVertices[] = new PVector[3];

  // now i have projected triangle points for 2D raster
  for (int i = 0; i < 3; i++) {
    twoDVertices[i] = projectVertex(t.vertices[i]);
    //print vertices with with saying vertex number i and its x and y values
    // System.out.println("Vertex " + i + " x: " + twoDVertices[i].x + " y: " + twoDVertices[i].y);
  }

  //     PENDING TODO!!!
  // DOUBLE CHECK WHEN DOES projectVertex() returns NULL VALUES
  // ACCOUNT FOR THOSE IN doCulling() METHOD


  if(doCulling(twoDVertices))  return;

  // draw breseham lines for the edges of the triangle
  for (int i = 0; i < 3; i++) {
    // print out the line coordinates with Edge number i and its x and y values
    // System.out.println("Edge " + i + " x: " + int(twoDVertices[i].x) + " y: " + int(twoDVertices[i].y) + " x2: " + int(twoDVertices[(i + 1) % 3].x) + " y2: " + int(twoDVertices[(i + 1) % 3].y));
    bresenhamLine(int(twoDVertices[i].x), int(twoDVertices[i].y), int(twoDVertices[(i + 1) % 3].x), int(twoDVertices[(i + 1) % 3].y));
  }

  if(doNormals) drawNormals(t);
}

/*
 Draw the normal vectors at each vertex and triangle center
 */
final int NORMAL_LENGTH = 20;
final float[] FACE_NORMAL_COLOR = {0f, 1f, 1f}; // cyan
final float[] VERTEX_NORMAL_COLOR = {1f, 0.6f, 0.1f}; // orange
void drawNormals(Triangle t) {
  
  // draw the normal vectors at the vertices
  PVector v, n;

  setColor(VERTEX_NORMAL_COLOR);
  for (int i = 0; i < 3; i++) {
    v = projectVertex(t.vertices[i]);
    n = projectVertex(t.vertexNormals[i]);
    bresenhamLine(int(v.x), int(v.y), int(v.x + n.x * NORMAL_LENGTH), int(v.y + n.y * NORMAL_LENGTH));
    //print out the vertex normal coordinates with vertex number i and its x and y values
    //System.out.println("Vertex Normal " + i + " x: " + int(v.x) + " y: " + int(v.y) + " x2: " + int(v.x + n.x * NORMAL_LENGTH) + " y2: " + int(v.y + n.y * NORMAL_LENGTH));
  }

  // draw the normal vector at the center of the triangle
  PVector center = projectVertex(t.getCenter());
  PVector normal = projectVertex(t.getNormal());
  setColor(FACE_NORMAL_COLOR);
  bresenhamLine(int(center.x), int(center.y), int(center.x + normal.x * NORMAL_LENGTH), int(center.y + normal.y * NORMAL_LENGTH));
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


/*
  helper functions for 2D triangle drawing
*/

boolean doCulling(PVector[] vertices){
  // get the edge vectors
  PVector[] edges = getEdges(vertices);

  // get the normal vector
  PVector normal = edges[0].copy().cross(edges[1]).normalize();

  //degenerate test: if the cross product of edges is zero
  if (normal.mag() == 0) return true;

  //backface test: if the dot product of the normal and the eye vector is negative
  if (normal.dot(EYE) < 0) return true;

  return false;
}

PVector[] getEdges(PVector[] vertices) {
  PVector[] edges = new PVector[3];
  for (int i = 0; i < 3; i++) {
    edges[i] = vertices[(i + 1) % 3].copy().sub(vertices[i]);
  }
  return edges;
}


// //helper functions for 2D triangle drawing
// boolean doCulling(PVector[] vertices){
//   // get the edge vectors
//   PVector[] edges = getEdges(vertices);

//   // get the normal vector
//   PVector normal = edges[0].copy().cross(edges[1]).normalize();

//   // get the center of the triangle
//   PVector center = new PVector(0, 0, 0);
//   for (PVector v : vertices) {
//     center.add(v);
//   }
//   center.div(3);

//   // get the vector from the center to the eye
//   PVector eye = new PVector(EYE.x, EYE.y, EYE.z);
//   eye.sub(center);

//   // if the dot product of the normal and the eye vector is negative, the triangle is back-facing
//   if (normal.dot(eye) < 0) {
//     return true;
//   }
//   return false;
// }