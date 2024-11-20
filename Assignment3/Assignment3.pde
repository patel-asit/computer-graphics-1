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
float globalZoom, globalRotation;
final float ZOOM_IN_FACTOR = 1.2;
final float ZOOM_OUT_FACTOR = 0.8;
final float ROTATION_ANGLE = PI/16;

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
  globalRotation = 0;

  setOrtho(0, width, 0, height);
}

void draw() {
  background(BLACK);
  mouseDragged();
  // System.out.println(getViewPort());
  switch (orthoMode) {
  case IDENTITY: // no zoom, panning or rotation effects on this mode because Pr, V and M are all the identity
    M.reset();
    V.reset();
    Pr.reset(); 
    Vp = getViewPort();
    break;
  case CENTER600:
    setOrtho(-300, 300, -300, 300);
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(orthoLeft, orthoRight, orthoBottom, orthoTop);
    break;
  case TOPRIGHT600:
    setOrtho(0, 600, 0, 600);
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(orthoLeft, orthoRight, orthoBottom, orthoTop);
    break;
  case FLIPX:
    setOrtho(300, -300, -300, 300);
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(orthoLeft, orthoRight, orthoBottom, orthoTop);
    break;
  case ASPECT:
    setOrtho(-300, 300, -100, 100);
    V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
    Pr = getOrtho(orthoLeft, orthoRight, orthoBottom, orthoTop);
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

  float denominatorX = globalZoom*2*width/abs(orthoRight-orthoLeft);
  float denominatorY = globalZoom*2*height/abs(orthoTop-orthoBottom);
  PVector mouseMove = new PVector(xMove/denominatorX, yMove/denominatorY);
  mouseMove.rotate(-globalRotation);
  // implement click-and-drag panning here
  if(mousePressed){
      if(orthoMode == OrthoMode.FLIPX)
        mouseMove.x *= -1;
      cameraCenter = new PVector(cameraCenter.x - mouseMove.x, cameraCenter.y + mouseMove.y);
      // cameraCenter = new PVector(cameraCenter.x - xMove/denominatorX, cameraCenter.y + yMove/denominatorY);
  }
}

void resetCameraAngles(){
  cameraUp = new PVector(0,1);
  cameraPerp = new PVector(1,0);
  cameraCenter = new PVector(0,0);
  globalZoom = 1;
  globalRotation = 0;
}

void setOrtho(float left, float right, float bottom, float top){
  orthoLeft = left;
  orthoRight = right;
  orthoBottom = bottom;
  orthoTop = top;
}
