import java.util.Stack;  // for your matrix stack
Stack<PMatrix2D> matrixStack = new Stack<PMatrix2D>();

PMatrix2D M = new PMatrix2D();
PMatrix2D V = new PMatrix2D();
PMatrix2D Pr = new PMatrix2D();
PMatrix2D Vp = new PMatrix2D();

final float BIG_TEST_PATTERN = 1000;
final float MED_TEST_PATTERN = 100;
final float SMALL_TEST_PATTERN = 1;
final color BLACK = color(0); 

PVector cameraCenter;
PVector cameraUp;
PVector cameraPerp;
float globalZoom;
final float ZOOM_IN_FACTOR = 1.2;
final float ZOOM_OUT_FACTOR = 0.8;


float orthoLeft;
float orthoRight;
float orthoTop;
float orthoBottom;


void setup() {
  size(600, 600);  // don't change, and don't use the P3D renderer
  colorMode(RGB, 1.0f);

  // put additional setup here
  cameraCenter = new PVector(0,0);
  cameraUp = new PVector(0,1);
  cameraPerp = new PVector(1,0);
  globalZoom = 1;

  orthoLeft = 0;
  orthoRight = width;
  orthoTop = 0;
  orthoBottom = height;
}

void draw() {
  background(BLACK);

  // System.out.println(getViewPort());
  switch (orthoMode) {
  case IDENTITY:
    M.reset();
    V.reset();
    Pr.reset(); 
    resetCameraAngles();
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Vp = getViewPort();
    break;
  case CENTER600:
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(-300, 300, -300, 300);
    break;
  case TOPRIGHT600:
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(0, 600, 0, 600);
    break;
  case FLIPX:
    Pr.reset();
    cameraPerp = new PVector(-1,0);
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    break;
  case ASPECT:
    resetCameraAngles();
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(-300, 300, -100, 100);
    break;
  }

  switch (testMode) {
  case PATTERN:
    drawTest(BIG_TEST_PATTERN);
    drawTest(MED_TEST_PATTERN);
    drawTest(SMALL_TEST_PATTERN);
    break;

  case SCENE:
    drawScene();
    break;
    
  case SHAPES:
    moveShapes();
    drawShapes();
    break;
  }
}

// feel free to add a new file for drawing your scene
void drawScene() {
}

void mouseDragged() {
  /*
   how much the mouse has moved between this frame and the previous one,
   measured in viewport coordinates - you will have to do further
   calculations with these numbers
   */
  float xMove = mouseX - pmouseX;
  float yMove = mouseY - pmouseY;

  // implement click-and-drag panning here
}

void resetCameraAngles(){
  cameraUp = new PVector(0,1);
  cameraPerp = new PVector(1,0);
}
