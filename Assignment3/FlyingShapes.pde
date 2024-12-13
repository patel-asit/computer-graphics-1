// for accessing components of homogeneous 4-vectors
final int X = 0;
final int Y = 1;
final int Z = 2;
final int W = 3;
final int NUM_COORDS = 4;
final int NUM_SHAPES = 100; // reset as desired
final int NUM_VERTICES = 8*NUM_SHAPES; // 8 because our single shape of star needs 8 vertices

final float X_MIN = -300;
final float X_MAX = 300;
final float Y_MIN = -300;
final float Y_MAX = 300;
final float Z_MIN = 0;
final float Z_MAX = -500;
PVector[] vertices = new PVector[NUM_VERTICES];
// construct projection matrix for view frustum
PMatrix3D getViewFrustum(float left, float right, float bottom, float top, float near, float far) {
  return new PMatrix3D(
    2*near/(right-left), 0, (right+left)/(right-left), 0,
    0, 2*near/(top-bottom), (top+bottom)/(top-bottom), 0,
    0, 0, -(far+near)/(far-near), -2*far*near/(far-near),
    0, 0, -1, 0
  );
}

void moveShapes() {
  for(int i = 0; i < NUM_VERTICES; i++){
  if(vertices[i].z < Z_MIN)
    vertices[i].z = Z_MAX;
  else
    vertices[i].z += 1;
  }
}

// Choose reasonable boundaries for your view frustum. Setting (left, right) and (bottom, top) to
// (−300,300) is probably a good choice. You can set far to 500, but remember that near should not be 0.
PMatrix3D frustumView = getViewFrustum(-300, 300, -300, 300, 1, 1000);
float[] vertex = new float[NUM_COORDS];
float[] projectedVertex = new float[NUM_COORDS];
void drawShapes() {
  for(int i = 0; i < NUM_VERTICES; i++){
    vertex[X] = vertices[i].x;
    vertex[Y] = vertices[i].y;
    vertex[Z] = vertices[i].z;
    vertex[W] = 1;
    frustumView.mult(vertex, projectedVertex);
    projectedVertex[X] /= projectedVertex[W];
    projectedVertex[Y] /= projectedVertex[W];
    myVertex(projectedVertex[X], projectedVertex[Y]); //TODO: draw the star using coordinates from here
  }
}

//generate vertices 

void generateStarVertices(){
  for(int i = 0; i < NUM_SHAPES; i+=8){
    // generate a random point in 3D space which would become a center for my object
    float randX = random(X_MIN, X_MAX);
    float randY = random(Y_MIN, Y_MAX);
    float randZ = random(Z_MIN, Z_MAX);

    //generate my star's vertices
    //(these values are not random, an inspiration/template is at the bottom of the file)
    vertices[i] = new PVector(randX, randY-10, randZ);
    vertices[i+1] = new PVector(randX+3, randY-3, randZ);
    vertices[i+2] = new PVector(randX+10, randY, randZ);
    vertices[i+3] = new PVector(randX+3, randY+3, randZ);
    vertices[i+4] = new PVector(randX, randY+10, randZ);
    vertices[i+5] = new PVector(randX-3, randY+3, randZ);
    vertices[i+6] = new PVector(randX-10, randY, randZ);
    vertices[i+7] = new PVector(randX-3, randY-3, randZ);
  }
}

/*
* inspiration/template for star
* I would normally draw this type of star if using Model matrix
*/
// void star(float r, float g, float b){
//   fill(r,g,b);
//   beginShape();
//     myVertex(0, -1);
//     myVertex(0.3, -0.3);
//     myVertex(1, 0);
//     myVertex(0.3, 0.3);
//     myVertex(0, 1);
//     myVertex(-0.3, 0.3);
//     myVertex(-1, 0);
//     myVertex(-0.3, -0.3);
//   endShape();
// }
