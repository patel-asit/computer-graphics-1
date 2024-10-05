/*
Use Bresenham's line algorithm to draw a line on the raster between
 the two given points. Modify the raster using setPixel() ONLY.
 */
void bresenhamLine(int fromX, int fromY, int toX, int toY) {
  //System.out.println("fromX: " + fromX + " fromY: " + fromY + " toX: " + toX + " toY: " + toY);
  
  float deltaX = toX - fromX;
  float deltaY = toY - fromY;
  
  // considering x as the fast direction by default
  boolean fastX = true;
  
  float deltaFast = deltaX;
  float deltaSlow = deltaY;
  
  int fastFrom = fromX;
  int fastTo = toX; 
  int slowFrom = fromY;
  int slowTo = toY;
  
  // counter and offsets helpful for drawing pixels when rise or run are + OR -
  int j=0;
  int fastStep = 1;
  int slowStep = 1; 
  
  float slope, error;
     
  // SWITCHES FAST OR SLOW DIRECTION
  //if x > y or if x = y then x is fast direction; otherwise y is fast direction
  if(abs(deltaX) < abs(deltaY)){ //need abs value here
    fastFrom = fromY;
    fastTo = toY; 
    slowFrom = fromX;
    slowTo = toX;
    
    deltaFast = deltaY;
    deltaSlow = deltaX;
    
    fastX = false;
  }
  
  // SWITCHES rise OR run TO BE + OR - DIRECTION 
  if(deltaFast < 0) fastStep = -1;
  if(deltaSlow < 0) slowStep = -1;

  slope = abs(deltaSlow/deltaFast);
  error = slope;
  
  //draw initial pixel
  setPixel(fastFrom, slowFrom);

  for(int i=fastFrom; i != fastTo; i += fastStep){
    if(error >= 0.5){
     j += slowStep; //offset to draw pixels in slow direction
     error = error-1;
    }
    
    // Since fastFrom and slowFrom can be x or y values & setPixel expects params as (x,y) coordinates in order.
    // If fastX is true, treat i as x and slowFrom as y; otherwise, flip the coordinates.
    if(fastX)
      setPixel(i, slowFrom+j);
    else
      setPixel(slowFrom+j, i);

    error = error + slope;
  }
}

/*
Don't change anything below here
 */

final int LENGTH_X = 125;
final int LENGTH_Y = 125;
final int LENGTH_DIAGONAL = 52;

void testBresenham() {
  final color WHITE = color(1f, 1f, 1f);
  final color RED = color(1f, 0f, 0f);

  final int CENTER_OFFSET_X = 125;
  final int CENTER_OFFSET_Y = 125;

  buffer.updatePixels(); // display everything drawn so far

  buffer.stroke(RED);
  ComparisonLines comp = new ComparisonLines();
  comp.drawAllQuadrants(CENTER_OFFSET_X, CENTER_OFFSET_Y);

  buffer.loadPixels(); // switch back to editing the raster
  setColor(WHITE);

  // use the implementation of Bresenham's algorithm
  BresenhamLines bres = new BresenhamLines();
  bres.drawAllQuadrants(CENTER_OFFSET_X, CENTER_OFFSET_Y);
}

abstract class TestPattern {
  void drawAllQuadrants(int centerOffsetX, int centerOffsetY) {
    for (int signX=-1; signX<=1; signX+=2) {
      int centerX = signX*centerOffsetX;
      for (int signY=-1; signY<=1; signY+=2) {
        int centerY = signY*centerOffsetY;
        drawPattern(centerX, centerY);
      }
    }
  }

  void drawPattern(int centerX, int centerY) {
    drawAxes(centerX, centerY);
    drawDiagonals(centerX, centerY);
  }

  void drawAxes(int startX, int startY) {
    for (int sign=-1; sign<=1; sign+=2) {
      int endXHorizontal = startX + sign*LENGTH_X;
      int endYVertical = startY + sign*LENGTH_Y;
      drawLine(startX, startY, endXHorizontal, startY);
      drawLine(startX, startY, startX, endYVertical);
    }
  }

  void drawDiagonals(int startX, int startY) {
    for (int signX=-1; signX<=1; signX+=2) {
      int endXHorizontal = startX + signX*LENGTH_X;
      int endXDiagonal = startX + signX*LENGTH_DIAGONAL;
      for (int signY=-1; signY<=1; signY+=2) {
        int endYVertical = startY + signY*LENGTH_Y;
        int endYDiagonal = startY + signY*LENGTH_DIAGONAL;
        drawLine(startX, startY, endXDiagonal, endYVertical);
        drawLine(startX, startY, endXHorizontal, endYDiagonal);
      }
    }
  }

  abstract void drawLine(int startX, int startY, int endX, int endY);
}

class ComparisonLines extends TestPattern {
  void drawLine(int startX, int startY, int endX, int endY) {
    final int SMALL_SHIFT = 3;

    // shift left/right or up/down
    int xDir = -Integer.signum(endY - startY);
    int yDir = Integer.signum(endX - startX);

    int pStartX = rasterToProcessingX(startX + xDir*SMALL_SHIFT);
    int pStartY = rasterToProcessingY(startY + yDir*SMALL_SHIFT);

    int pEndX = rasterToProcessingX(endX + xDir*SMALL_SHIFT);
    int pEndY = rasterToProcessingY(endY + yDir*SMALL_SHIFT);

    buffer.line(pStartX, pStartY, pEndX, pEndY);
  }

  int rasterToProcessingX(int rx) {
    return width/2 + rx;
  }

  int rasterToProcessingY(int ry) {
    return height/2 - ry;
  }
}

class BresenhamLines extends TestPattern {
  void drawLine(int startX, int startY, int endX, int endY) {
    bresenhamLine(startX, startY, endX, endY);
  }
}
