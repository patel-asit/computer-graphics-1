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
final float ROTATION_ANGLE = PI/32;

float orthoLeft;
float orthoRight;
float orthoTop;
float orthoBottom;


void setup() {
  size(600, 600);  // don't change, and don't use the P3D renderer
  colorMode(RGB, 1.0f);

  generateStarVertices();   // for Part 4-FlyingShapes of the assignment

  // put additional setup here
  resetCameraAngles();
  resetOrtho();
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
    break;
  case TOPRIGHT600:
    setOrtho(0, 600, 0, 600);
    break;
  case FLIPX:
    setOrtho(300, -300, -300, 300);
    break;
  case ASPECT:
    setOrtho(-300, 300, -100, 100);
    break;
  }
  V = getCamera(cameraCenter, cameraUp, cameraPerp, globalZoom);
  Pr = getOrtho(orthoLeft, orthoRight, orthoBottom, orthoTop);
    

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
    M.reset();
    V.reset();
    Pr.reset(); 
    Vp = getViewPort();
    // moveShapes();
    // drawShapes();
    break;
  }
}

// feel free to add a new file for drawing your scene
void drawScene() {
  //draws 5 diamonds
  myPush();
    myTranslate(-200, 0);
    myRotate(PI/4);
    myScale(50,50);
    drawDiamond(0, 1, 1); //cyan diamond  
  myPop();

  myPush();
    myTranslate(250, 100);
    myRotate(PI/16);
    myScale(80,80);
    drawDiamond(0.31, 0.78, 0.47); //dark emerald green diamond
  myPop();

  myPush();
    myTranslate(-100, -200);
    myRotate(PI/8);
    myScale(80,40);
    drawDiamond(1, 0.5, 0); //orange diamond
  myPop();

  myPush();
    myTranslate(0, 200);
    myRotate(PI/2);
    myScale(120,120);
    drawDiamond(0.5, 0.2, 0.8); // purple diamond
  myPop();

  myPush();
    myTranslate(200, -100);
    myRotate(-PI/3);
    myScale(70,100);
    drawDiamond(1, 0, 1); //magenta diamond
  myPop();
}

void mouseDragged() {
  float xMove = mouseX - pmouseX;
  float yMove = mouseY - pmouseY;

  float denominatorX = globalZoom*2*width/abs(orthoRight-orthoLeft);
  float denominatorY = globalZoom*2*height/abs(orthoTop-orthoBottom);

  // click-and-drag panning
  if(mousePressed){
      if(orthoMode == OrthoMode.FLIPX)
        xMove *= -1;
      cameraCenter = new PVector(cameraCenter.x - xMove*cameraPerp.x/denominatorX, cameraCenter.y + yMove*cameraUp.y/denominatorY);
  }
}

void resetCameraAngles(){
  cameraUp = new PVector(0,1);      // reset rotation angles
  cameraPerp = new PVector(1,0);
  cameraCenter = new PVector(0,0);  // reset panning position
  globalZoom = 1;                   // reset zoom
}

void resetOrtho(){
  setOrtho(-300, 300, -300, 300);
}

void setOrtho(float left, float right, float bottom, float top){
  orthoLeft = left;
  orthoRight = right;
  orthoBottom = bottom;
  orthoTop = top;
}
