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
final int MIN_N_PHI = 2;
final int MIN_N_THETA = 3;

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
  })};
  rotatedSingleTriangle = copyTriangleList(singleTriangle); 

  /*
    Create the tessellation of the surface of a sphere.
    Parameters: 
      number of horizontal rings (has to be at least 2)
      number of vertical lines (has to be at least 3)
      radius of the sphere
  */
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
  setColor(OUTLINE_COLOR);

  // holds 2D projected vertices
  PVector twoDVertices[] = new PVector[NUM_DIMENSIONS];
  for (int i = 0; i < NUM_DIMENSIONS; i++) {
    twoDVertices[i] = projectVertex(t.vertices[i]);
  }

  if(doCulling(twoDVertices)) return;

  // draw breseham lines for the edges of the triangle
  if (doOutline){
    for (int i = 0; i < NUM_DIMENSIONS; i++) {
      bresenhamLine(int(twoDVertices[i].x), int(twoDVertices[i].y), int(twoDVertices[(i + 1) % NUM_DIMENSIONS].x), int(twoDVertices[(i + 1) % NUM_DIMENSIONS].y));
    }
  }

  if(doNormals) drawNormals(t);

  if(shadingMode != ShadingMode.NONE) fillTriangle(t);
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
  for (int i = 0; i < NUM_DIMENSIONS; i++) {
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
  //check mode and change the color accordingly
  // run the loop and call scan line fill function. Project the vertices maybe
  // if shading mode is not NONE, calculate the shading for each pixel
  if(shadingMode != ShadingMode.NONE){
    scanLineFill(t);
  }
}


void scanLineFill(Triangle t){

  //if shading mode is not NONE, calculate the shading for each pixel
  //set the pixel color

  //get projected vertices
  PVector v1 = projectVertex(t.vertices[0]);
  PVector v2 = projectVertex(t.vertices[1]);
  PVector v3 = projectVertex(t.vertices[2]);

  //get the bounding box of the triangle
  float minX = min(v1.x, v2.x, v3.x);
  float maxX = max(v1.x, v2.x, v3.x);
  float minY = min(v1.y, v2.y, v3.y);
  float maxY = max(v1.y, v2.y, v3.y);
  
  //loop from y min to y max
  for(int y = int(minY); y <= int(maxY); y++){
    //this loop represents the scan line. We check individual pixels on the scan line
    for(int x = int(minX); x <= int(maxX); x++){
      if(isInTriangle(new PVector[]{v1, v2, v3}, new PVector(x, y))){
        //if the pixel is in the triangle, set the pixel color
        setColor(FLAT_FILL_COLOR);
        setPixel(x, y);
      }
    }
  }
}

boolean isInTriangle(PVector[] triangleVertices, PVector point){
  boolean result = false;
  //subtract point from tx then ty and tz
  PVector px = triangleVertices[0].copy().sub(point);
  PVector py = triangleVertices[1].copy().sub(point);
  PVector pz = triangleVertices[2].copy().sub(point);

  //get triangle's edges. Gives e1, e2, e3 in order
  PVector[] edges = getTriangleEdges(triangleVertices);

  //perform the test
  PVector result1 = edges[0].cross(px);
  PVector result2 = edges[1].cross(py);
  PVector result3 = edges[2].cross(pz);

  //if all the results have same sign or 0, the point is inside the triangle
  if(result1.z >= 0 && result2.z >= 0 && result3.z >= 0){
    result = true;
  } else if(result1.z <= 0 && result2.z <= 0 && result3.z <= 0){
    result = true;
  }
  
  return result;
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
  for (PVector vertex : vertices) {
    if (vertex == null) return true;
  }

  // get the edge vectors. 
  PVector[] edges = getTriangleEdges(vertices);

  // get the normal vector
  PVector normal = edges[0].copy().cross(edges[1]).normalize();

  //degenerate test: if the cross product of edges is zero (or very small number of pixel units as an approximation)
  if (normal.mag() <= 0.1) return true;

  //backface test: if the dot product of the normal and the eye vector is negative
  if (normal.dot(EYE) < 0) return true;

  return false;
}

// get the edges of the triangle using the 2D projected vertices
PVector[] getTriangleEdges(PVector[] vertices) {
  int numVertices = vertices.length;
  PVector[] edges = new PVector[numVertices];
  for (int i = 0; i < numVertices; i++) {
    edges[i] = vertices[(i + 1) % numVertices].copy().sub(vertices[i]);
  }
  return edges;
}

// CREATE TESSELATION MATRIX
Triangle[] createTessellation(int nPhi, int nTheta, int radius){
  //Returns empty Tesselation if nPhi is less than 2 or nTheta is less than 3
  if(nPhi < MIN_N_PHI || nTheta < MIN_N_THETA){
    System.out.println("ERROR: No Tessellation can be drawn. nPhi has to be >=2 and nTheta has to be >=3");
    return new Triangle[]{};
  } 

  
  //renaming the variables for easier understanding
  int rings = nPhi; // horizontal rings parallel to the equator
  int lines = nTheta; //vertical lines from top point to bottom point

  PVector[][] vertices = new PVector[rings+1][lines+1];
  PVector[][] normals = new PVector[rings+1][lines+1];
  int tessellationSize = (rings-1)*(lines)*2 + lines*2;
  Triangle[] tessellation = new Triangle[tessellationSize];

  // # of hsteps = # of vertical lines from top point to bottom point
  float hSteps = TWO_PI / nTheta;
  // # of vsteps = # of rings
  float vSteps = PI / nPhi;

  // get the x, y, z coordinates for the sphere
  for(int r=0; r<=rings; r++){
    for(int l=0; l<=lines; l++){
      // get the x, y, z coordinates for the sphere but do float calculations
      float x = (float)radius * sin(vSteps * (float)r) * cos(hSteps * (float)l);
      float y = (float)radius * cos(vSteps * (float)r);
      float z = (float)radius * sin(vSteps * (float)r) * sin(hSteps * (float)l);

      vertices[r][l] = new PVector(x, y, z);
      normals[r][l] = new PVector(x, y, z).normalize();
    }
  }

  // create triangles for the sphere

  int counter = 0;
  PVector ver1, ver2, ver3, nor1, nor2, nor3;
  for(int i=0; i<rings; i++){
    for(int j=0; j<lines; j++){
      ver1 = vertices[i][j];
      ver2 = vertices[i+1][j];
      ver3 = vertices[i][(j+1)%lines];
      nor1 = normals[i][j];
      nor2 = normals[i+1][j];
      nor3 = normals[i][(j+1)%lines];
      tessellation[counter++] = new Triangle(new PVector[]{ver1.copy(), ver2.copy(), ver3.copy()}, new PVector[]{nor1.copy(), nor2.copy(), nor3.copy()});      

      ver1 = vertices[i][j];
      ver2 = vertices[i+1][((j-1)+lines)%lines]; //java is so f dumb omfg!!! -1 mod 30 returns -1 for some reason! Spent 15 hours figuring this out!!!!
      ver3 = vertices[i+1][j];
      nor1 = normals[i][j];
      nor2 = normals[i+1][((j-1)+lines)%lines]; //java is so f dumb omfg!!! -1 mod 30 returns -1 for some reason! Spent 15 hours figuring this out!!!!
      nor3 = normals[i+1][j];
      tessellation[counter++] = new Triangle(new PVector[]{ver1.copy(), ver2.copy(), ver3.copy()}, new PVector[]{nor1.copy(), nor2.copy(), nor3.copy()});
    }
  }

  return tessellation;
}