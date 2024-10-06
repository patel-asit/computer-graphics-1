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

  // surfaceTessellation = new Triangle[]{}; // change this line
  surfaceTessellation = createTessellation(20,30,300);
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
  try {
    setColor(OUTLINE_COLOR);
    //we dont draw anything if doOutline is false
    if (!doOutline) return;

    // holds 2D projected vertices
    PVector twoDVertices[] = new PVector[3];

    // now i have projected triangle points for 2D raster
    for (int i = 0; i < 3; i++) {
      try {
        twoDVertices[i] = projectVertex(t.vertices[i]);
      } catch (NullPointerException e) {
        System.err.println("NullPointerException caught while projecting vertex " + i + ": " + e.getMessage());
        e.printStackTrace();
        return;
      }
      //print vertices with with saying vertex number i and its x and y values
      // System.out.println("Vertex " + i + " x: " + twoDVertices[i].x + " y: " + twoDVertices[i].y);
    }

    //     PENDING TODO!!!
    // DOUBLE CHECK WHEN DOES projectVertex() returns NULL VALUES
    // ACCOUNT FOR THOSE IN doCulling() METHOD
    if(doCulling(twoDVertices)) return;

    // draw breseham lines for the edges of the triangle
    for (int i = 0; i < 3; i++) {
      // print out the line coordinates with Edge number i and its x and y values
      // System.out.println("Edge " + i + " x: " + int(twoDVertices[i].x) + " y: " + int(twoDVertices[i].y) + " x2: " + int(twoDVertices[(i + 1) % 3].x) + " y2: " + int(twoDVertices[(i + 1) % 3].y));
      bresenhamLine(int(twoDVertices[i].x), int(twoDVertices[i].y), int(twoDVertices[(i + 1) % 3].x), int(twoDVertices[(i + 1) % 3].y));
    }

    if(doNormals) drawNormals(t);
  } catch (NullPointerException e) {
    System.err.println("NullPointerException caught: " + e.getMessage());
    e.printStackTrace();
  }
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

    //return early of x or y values in v or n has gotten null vertices from projectVertex
    if(v == null || n == null) return;

    bresenhamLine(int(v.x), int(v.y), int(v.x + n.x * NORMAL_LENGTH), int(v.y + n.y * NORMAL_LENGTH));
    //print out the vertex normal coordinates with vertex number i and its x and y values
    //System.out.println("Vertex Normal " + i + " x: " + int(v.x) + " y: " + int(v.y) + " x2: " + int(v.x + n.x * NORMAL_LENGTH) + " y2: " + int(v.y + n.y * NORMAL_LENGTH));
  }

  // draw the normal vector at the center of the triangle
  PVector center = projectVertex(t.getCenter());
  PVector normal = projectVertex(t.getNormal());

  //return early of x or y values in v or n has gotten null vertices from projectVertex
  if(center == null || normal == null) return;

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
  //if any of the projected vertices are null, return true
  if(vertices[0] == null || vertices[1] == null || vertices[2] == null) return true;

  // get the edge vectors
  PVector[] edges = getEdges(vertices);

  // get the normal vector
  PVector normal = edges[0].copy().cross(edges[1]).normalize();

  //degenerate test: if the cross product of edges is zero (or <1 in pixel units as an approximation)
  if (normal.mag() <= 0.1) return true;

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

// CREATE TESSELATION MATRIX
Triangle[] createTessellation(int nPhi, int nTheta, int radius){
  if(nPhi < 2 || nTheta < 3) return null;
  
  //renaming the variables for easier understanding
  int rings = nPhi; // horizontal rings parallel to the equator
  int lines = nTheta; //vertical lines from top point to bottom point

  PVector[][] vertices = new PVector[rings][lines];
  PVector[][] normals = new PVector[rings][lines];
  // Triangle[] tessellation = new Triangle[(rings-1)*lines*2];
  Triangle[] tessellation = new Triangle[(rings-1)*lines*2];

  // # of hsteps = # of vertical lines from top point to bottom point
  float hSteps = TWO_PI / nTheta;
  // # of vsteps = # of rings
  float vSteps = PI / nPhi;

  // get the x, y, z coordinates for the sphere
  for(int r=1; r<=rings; r++){
    for(int l=1; l<=lines; l++){

      // get the x, y, z coordinates for the sphere but do float calculations
      float x = (float)radius * sin(vSteps * (float)r) * cos(hSteps * (float)l);
      float y = (float)radius * cos(vSteps * (float)r);
      float z = (float)radius * sin(vSteps * (float)r) * sin(hSteps * (float)l);

      vertices[r-1][l-1] = new PVector(x, y, z);
      normals[r-1][l-1] = new PVector(x, y, z).normalize();

      //print vertices and normal vectors
      System.out.println("Vertex " + r + " " + l + " x: " + x + " y: " + y + " z: " + z);
    }
  }

  // create triangles for the sphere

  int counter = 0;
  PVector ver1, ver2, ver3, nor1, nor2, nor3;
  for(int i=0; i<rings-1; i++){
    for(int j=0; j<lines; j++){
      //print iteration values i j and counter value for the current iteration
      // System.out.println("i: " + i + " j: " + j + " counter: " + counter);

      ver1 = vertices[i][j];
      ver2 = vertices[i+1][j];
      ver3 = vertices[i][(j+1)%lines];
      nor1 = normals[i][j];
      nor2 = normals[i+1][j];
      nor3 = normals[i][(j+1)%lines];
      
      if (counter >= (rings-1)*lines*2){
        System.out.println("Counter exceeds lines * rings: " + counter);
      } else {
        tessellation[counter] = new Triangle(new PVector[]{ver1.copy(), ver2.copy(), ver3.copy()}, new PVector[]{nor1.copy(), nor2.copy(), nor3.copy()});
        counter++;
      }

      ver1 = vertices[i][j];
      ver2 = vertices[i+1][((j-1)+lines)%lines]; //java is so f dumb omfg!!! -1 mod 30 returns -1 for some reason! Spent a day figuring this out!!!!
      ver3 = vertices[i+1][j];
      nor1 = normals[i][j];
      nor2 = normals[i+1][((j-1)+lines)%lines]; //java is so f dumb omfg!!! -1 mod 30 returns -1 for some reason! Spent a day figuring this out!!!!
      nor3 = normals[i+1][j];
      
      // System.out.println("im here2");

      if (counter >= (rings-1)*lines*2){ 
        println("Counter exceeds lines * rings: " + counter);
      } else {
        tessellation[counter] = new Triangle(new PVector[]{ver1.copy(), ver2.copy(), ver3.copy()}, new PVector[]{nor1.copy(), nor2.copy(), nor3.copy()});
        // System.out.println("im here3");
        counter++;
      }
    }
  }
  
  // draw poles for the sphere
  //when creating triangles, i need the triangles array to have 2*lines more, because that is extra triangles touching poles.
  // get coordinates for north pole and south pole and get normals
  // PVector northPole = new PVector(0, radius, 0);
  // PVector northNormal = new PVector(0, 0, 1);
  // PVector southNormal = new PVector(0, 0, -1);

  // for(int i=0; i<lines; i++){
  //   ver1 = northPole;
  //   ver2 = vertices[1][(i+1)%lines];
  //   ver3 = vertices[1][i];
  //   nor1 = northNormal;
  //   nor2 = normals[1][(i+1)%lines];
  //   nor3 = normals[1][i];
  //   tessellation[counter++] = new Triangle(new PVector[]{ver1, ver2, ver3}, new PVector[]{nor1, nor2, nor3});
  // }
  return tessellation;

}