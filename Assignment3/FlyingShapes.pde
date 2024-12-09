// for accessing components of homogeneous 4-vectors
final int X = 0;
final int Y = 1;
final int Z = 2;
final int W = 3;
final int NUM_COORDS = 4;
final int NUM_VERTICES = 8; // reset as desired
final int NUM_SHAPES = 1; // reset as desired

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
}

void drawShapes() {
}
