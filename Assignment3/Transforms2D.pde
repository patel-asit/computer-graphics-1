// construct viewport matrix using width and height of canvas
PMatrix2D getViewPort() {
  PMatrix2D invertedB, translation;
  PVector origin = new PVector(-1, 1);
  PVector u = new PVector(2.0f/width, 0);
  PVector v = new PVector(0, -2.0f/height);

  invertedB = invertBasis(u, v);
  translation = new PMatrix2D(
    1, 0, -origin.x,
    0, 1, -origin.y;
  );

  return invertedB.apply(translation);
}

// construct projection matrix using 2D boundaries
PMatrix2D getOrtho(float left, float right, float bottom, float top) {
  PMatrix2D invertedB, translation;
  PVector origin = new PVector((left+right)/2, (top+bottom)/2);
  PVector u = new PVector((right-left)/2, 0);
  PVector v = new PVector(0, (top-bottom)/2);
  
  invertedB = invertBasis(u, v);
  translation = new PMatrix2D(
    1, 0, -origin.x,
    0, 1, -origin.y;
  );

  return invertedB.apply(translation);
}

// construct camera matrix using camera position, up vector, and zoom setting
PMatrix2D getCamera(PVector center, PVector up, PVector perp, float zoom) {
  
  PMatrix2D invertedB, translation;
  
  invertedB = invertBasis(up, perp);
  translation = new PMatrix2D(
    1, 0, -center.x,
    0, 1, -center.y;
  );

  return scaleMatrix(zoom).apply(invertedB.apply(translation));
}

/*
Functions that manipulate the matrix stack
 */

void myPush() {
}

void myPop() {
}

/*
Functions that update the model matrix
 */

void myScale(float sx, float sy) {
}

void myTranslate(float tx, float ty) {
  
}

void myRotate(float theta) {
}

/*
Receives a point in object space and applies the complete transformation
 pipeline, Vp.Pr.V.M.point, to put the point in viewport coordinates.
 Then calls vertex to plot this point on the raster
 */
void myVertex(float x, float y) {
  // apply transformations here

  // this is the only place in your program where you are allowed
  // to use the vertex command
  vertex(x, y);
}

// overload for convenience
void myVertex(PVector vertex) {
  myVertex(vertex.x, vertex.y);
}

PMatrix2D invertBasis(PVector u, PVector v){
  float determinant = 1/(u.x*v.y - v.x*u.y);
  
  PMatrix2D invertedBasis = new PMatrix2D(
     v.y * determinant, -v.x * determinant, 0,
    -u.y * determinant,  u.x * determinant, 0
  ) 

  return invertedBasis;
}

PMatrix2D scaleMatrix(float sx, float sy){
  return new PMatrix2D(
    sx, 0, 0,
    0, sy, 0
  );
} 

PMatrix2D scaleMatrix(float zoom){
  return scaleMatrix(zoom, zoom);
}