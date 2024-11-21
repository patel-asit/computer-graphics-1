// don't change these keys
final char KEY_ROTATE_CW = ']';
final char KEY_ROTATE_CCW = '[';
final char KEY_ZOOM_IN = '='; // plus sign without the shift
final char KEY_ZOOM_OUT = '-';
final char KEY_ORTHO_MODE = 'o';
final char KEY_DISPLAY_MODE = 'd';

enum OrthoMode {
  IDENTITY, // straight to viewport with no transformations (Pr, V and M are all the identity)
  CENTER600, // bottom left is (-300,-300), top right is (300,300), center is (0,0)
  TOPRIGHT600, // bottom left is (0,0), top right is (600,600)
  FLIPX, // same as CENTER600 but reflected through y axis (x -> -x)
  ASPECT // uneven aspect ratio: x is from -300 to 300, y is from -100 to 100
}
OrthoMode orthoMode = OrthoMode.IDENTITY;

enum DisplayMode {
  PATTERN, 
  SCENE,
  SHAPES
}
DisplayMode testMode = DisplayMode.PATTERN;

void keyPressed() {
  // change orthoMode with 'o' key
  switch(key) {
    case KEY_ORTHO_MODE:
      orthoMode = OrthoMode.values()[(orthoMode.ordinal() + 1) % OrthoMode.values().length];
      resetCameraAngles();
      resetOrtho();
      break;
    case KEY_DISPLAY_MODE:
      testMode = DisplayMode.values()[(testMode.ordinal() + 1) % DisplayMode.values().length];
      break;
    case KEY_ZOOM_IN:
      globalZoom *= ZOOM_IN_FACTOR;
      break;
    case KEY_ZOOM_OUT:
      globalZoom *= ZOOM_OUT_FACTOR;
      break;
    case KEY_ROTATE_CCW:
      globalRotation -= ROTATION_ANGLE;
      globalRotation = (globalRotation % TWO_PI + TWO_PI) % TWO_PI;      println(globalRotation);
      cameraUp.rotate(globalRotation);
      cameraPerp.rotate(globalRotation);
      break;
    case KEY_ROTATE_CW:
      globalRotation += ROTATION_ANGLE;
      globalRotation %= TWO_PI;
      cameraUp.rotate(globalRotation);
      cameraPerp.rotate(globalRotation);
      break;
  }
  printSettings();
}


void printSettings() {
  String settings = "";
  settings += "OrthoMode: " + orthoMode + "\n";
  settings += "DisplayMode: " + testMode + "\n";
  println(settings);
}

// don't change anything below here

final int NUM_LINES = 11;
final int THIN_LINE = 1;
void drawTest(float scale) {
  float left, right, top, bottom;
  left = bottom = -scale/2;
  right = top = scale/2;

  strokeWeight(THIN_LINE);
  beginShape(LINES);
  for (int i=0; i<NUM_LINES; i++) {
    float x = left + i*scale/(NUM_LINES-1);
    float y = bottom + i*scale/(NUM_LINES-1);

    setHorizontalColor(i);
    myVertex(left, y);
    myVertex(right, y);

    setVerticalColor(i);
    myVertex(x, bottom);
    myVertex(x, top);
  }
  endShape(LINES);
}

void setHorizontalColor(int i) {
  int r, g, b;
  r = (i >= NUM_LINES/2) ? 0 : 1;
  g = (i >= NUM_LINES/2) ? 1 : 0;
  b = (i >= NUM_LINES/2) ? 1 : 0;
  stroke(r, g, b);
}

void setVerticalColor(int i) {
  int r, g, b;
  r = (i >= NUM_LINES/2) ? 1 : 0;
  g = (i >= NUM_LINES/2) ? 1 : 0;
  b = (i >= NUM_LINES/2) ? 0 : 1;
  stroke(r, g, b);
}
