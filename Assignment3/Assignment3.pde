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
final float ROTATION_ANGLE = 0.01;

float orthoLeft;
float orthoRight;
float orthoTop;
float orthoBottom;


void setup() {
  size(600, 600);  // don't change, and don't use the P3D renderer
  colorMode(RGB, 1.0f);

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
    moveShapes();
    drawShapes();
    break;
  }
}

// feel free to add a new file for drawing your scene
void drawScene() {
  // drawRing();
  diamondTop();
  drawSparkle();
  // myPush();
  // stroke(color(1,1,1));
  // strokeWeight(4);
  // beginShape(LINES);
  //   myVertex(0, 0);
  //   myVertex(10,10);
  // endShape(LINES);
  // myPop();
}

void drawRing(){
  myPush();
  //navy blue stroke color
  stroke(0, 0, 0.5);  //navy blue color
  strokeWeight(2);
  fill(0,1,1);        //teal color
  beginShape(TRIANGLE_FAN);
    myVertex(57.5, 50);
    myVertex(57.5, 15);
    myVertex(92, 50);
    myVertex(57.5, 85);
    myVertex(22, 50);
    myVertex(57.5, 15);
  endShape();
  myPop();
}

// void drawDiamond(){
//   myPush();
//   stroke(color(1,1,1));
//   strokeWeight(4);
//   beginShape(LINES);
//     myVertex(0, 0);
//     myVertex(10,10);
//   endShape(LINES);
//   myPop();
// }

void drawBand(){

}

void drawSparkle(){
  //draw a shiny sparkly star in golden color
  myPush();
  fill(1,1,0);  //golden color
  stroke(1,1,0);  //golden color
  strokeWeight(1);
  //draw a 6 pointed star
  beginShape();
    myVertex(50, 50);
    myVertex(55, 55);
    myVertex(60, 50);
    myVertex(55, 45);
    myVertex(50, 50);
  endShape();
  myPop();
}

void drawDiamond(){
  //draw a complex diamong
  myPush();
  fill(1,1,1);  //white color
  stroke(1,1,1);  //white color
  strokeWeight(1);
  beginShape();
    myVertex(50, 50);
    myVertex(55, 55);
    myVertex(60, 50);
    myVertex(55, 45);
    myVertex(50, 50);
  endShape();
    myRotate(PI);
  myPop();  
}

void diamondTop(){
  myPush();
  //navy blue stroke color
  stroke(0, 0, 0.5);  //navy blue color
  strokeWeight(2);
  fill(0,1,1);        //teal color
  beginShape(TRIANGLE_STRIP);
    myVertex(30, 75);
    myVertex(40, 20);
    myVertex(50, 75);
    myVertex(60, 20);
    myVertex(70, 75);
    myVertex(80, 20);
    myVertex(90, 75);
  endShape();
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

  // implement click-and-drag panning here
  if(mousePressed){
      if(orthoMode == OrthoMode.FLIPX)
        xMove *= -1;
      cameraCenter = new PVector(cameraCenter.x - xMove*cameraPerp.x/denominatorX, cameraCenter.y + yMove*cameraUp.y/denominatorY);
      // System.out.println("Camera perp" + cameraPerp.x + ", " + cameraPerp.y);
  }
}

void resetCameraAngles(){
  cameraUp = new PVector(0,1);
  cameraPerp = new PVector(1,0);
  cameraCenter = new PVector(0,0);
  globalZoom = 1;
  globalRotation = 0;
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
