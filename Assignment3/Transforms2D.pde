// construct viewport matrix using width and height of canvas
PMatrix2D getViewPort() {
  PMatrix2D Vp, translation;
  PVector origin = new PVector(-1, 1);
  PVector u = new PVector(2.0f/width, 0);
  PVector v = new PVector(0, -2.0f/height);

  Vp = invertBasis(u, v);
  translation = translateMatrix(-origin.x, -origin.y);
  Vp.apply(translation);

  return Vp;
}

// construct projection matrix using 2D boundaries
PMatrix2D getOrtho(float left, float right, float bottom, float top) {
  PMatrix2D Pr, translation;
  PVector origin = new PVector((left+right)/2, (top+bottom)/2);
  PVector u = new PVector((right-left)/2, 0);
  PVector v = new PVector(0, (top-bottom)/2);
  
  Pr = invertBasis(u, v);
  translation = translateMatrix(-origin.x, -origin.y);
  Pr.apply(translation);

  return Pr;
}

// construct camera matrix using camera position, up vector, and zoom setting
PMatrix2D getCamera(PVector center, PVector up, PVector perp, float zoom) {
  PMatrix2D V, translation;
  
  V = invertBasis(perp, up);
  translation = translateMatrix(-center.x, -center.y);
  V.apply(translation);
  V.preApply(scaleMatrix(zoom));

  return V;
}

/*
Functions that manipulate the matrix stack
 */

void myPush() {
  matrixStack.push(M.get());
}

void myPop() {
  // Pop elements from the stack
  if(!matrixStack.isEmpty()) {
    M = matrixStack.pop();
  }else {
    M = new PMatrix2D(); // if i pop too much keep returning identity matrix
  }
}

/*
Functions that update the model matrix
 */

void myScale(float sx, float sy) {
  M.apply(scaleMatrix(sx, sy));
}

void myTranslate(float tx, float ty) {
  M.apply(translateMatrix(tx, ty));
}

void myRotate(float theta) {
  M.apply(rotateMatrix(theta));
}

/*
Receives a point in object space and applies the complete transformation
 pipeline, Vp.Pr.V.M.point, to put the point in viewport coordinates.
 Then calls vertex to plot this point on the raster
 */
void myVertex(float x, float y) {
  // apply transformations here
  PVector point = new PVector(x, y);

  PMatrix2D transMatrix = new PMatrix2D();
  
  transMatrix.apply(Vp);
  transMatrix.apply(Pr);
  transMatrix.apply(V);
  transMatrix.apply(M);
  
  point = transMatrix.mult(point, null);
  // this is the only place in your program where you are allowed
  // to use the vertex command
  vertex(point.x, point.y);
}

// overload for convenience
void myVertex(PVector vertex) {
  myVertex(vertex.x, vertex.y);
}

/**
 * Helper Methods
 */

PMatrix2D invertBasis(PVector u, PVector v){
  float determinant = 1/(u.x*v.y - v.x*u.y);
  
  PMatrix2D invertedBasis = new PMatrix2D(
     v.y * determinant, -v.x * determinant, 0,
    -u.y * determinant,  u.x * determinant, 0
  );

  return invertedBasis;
}

PMatrix2D rotateMatrix(float theta){
  return new PMatrix2D(
    cos(theta), -sin(theta), 0,
    sin(theta), cos(theta), 0
  );
}
PMatrix2D translateMatrix(float tx, float ty){
  return new PMatrix2D(
    1, 0, tx,
    0, 1, ty
  );
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
