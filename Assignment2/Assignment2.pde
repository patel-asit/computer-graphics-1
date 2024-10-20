/*
  COMP 3490 Assignment 2
  Author: ASIT PATEL (7866182)
 */

final color BLACK = color(0);
final color WHITE = color(255);
final color RED = color(255, 0, 0);
final color GREEN = color(0, 255, 0);
final color BLUE = color(0, 0, 255);
final color YELLOW = color(255, 255, 0);
final color CYAN = color(0, 255, 255);
final color MAGENTA = color(255, 0, 255);

int numPixels;

void setup() {
  // RGB values range over 0..1 rather than 0..255
  colorMode(RGB, 1.0f);
  size(800, 800);
  numPixels = width * height;
  printSettings();
  noLoop();
}

/*
You should read this function carefully and understand how it works,
 but you should not need to edit it
 */
void draw() {
  colorMode(RGB, 1.0f);
  background(BLACK);
  loadPixels();
  if (shadingMode == shadingMode.FLAT) {
    drawShapes();
  } else if (shadingMode == shadingMode.PHONG_LIGHTING) {


  } else if (shadingMode == shadingMode.REFLECTIONS_SHADOWS) {


  }
  updatePixels();
}

void drawShapes(){
  Sphere sphere1 = new Sphere(new PVector(5, 5, RASTER_Z+15), 5, GREEN);
  Sphere sphere2 = new Sphere(new PVector(2, 2, RASTER_Z+30), 10, CYAN);
  Sphere sphere3 = new Sphere(new PVector(-2, -2, RASTER_Z+40), 15, RED);
  Plane plane = new Plane(new PVector(10, 15, RASTER_Z+7), new PVector(0, 1, 0), MAGENTA);
  
  IntersectionPoint ip, ip2;
  PVector Dij;

  //traverse the raster to draw the pixels
  for(int i=0; i<RASTER_WIDTH; i++){
    for(int j=0; j<RASTER_HEIGHT; j++){
      //make Pij in the loop and get Dij so Rij(t) = E + tDij for some t>0
      Dij = getPij(i,j).normalize();

      ip = closestShape(new IntersectionPoint[]{sphere1.checkIntersection(Dij), sphere2.checkIntersection(Dij), sphere3.checkIntersection(Dij), plane.checkIntersection(Dij)});

      if(ip!=null){
        setColor(ip.getCol());
        //System.out.print("Solutions at i=" + i + " j=" + j + "\t");
        setPixel(i,j);
      }
    }
  }
}

// This returns null if there are no shapes with intersection points for this pixel ray
IntersectionPoint closestShape(IntersectionPoint[] shapes){
  //return the closest shape
  IntersectionPoint closest = null;

  for(IntersectionPoint shape : shapes){
    if(shape != null){
      if(closest == null){
        closest = shape;
      } else {
        if (shape.getIntersection().z < closest.getIntersection().z) {
          closest = shape;
        }
      }
    }
  }

  return closest;
}
/*
Add helper functions for coordinate conversions
 */
 PVector getPij(int col, int row){
    float x = RASTER_LEFT + (RASTER_RIGHT - RASTER_LEFT) * (col + 0.5) / RASTER_WIDTH;
    float y = RASTER_BOTTOM + (RASTER_TOP - RASTER_BOTTOM) * (row + 0.5) / RASTER_HEIGHT;
    float z = RASTER_Z;
    return new PVector(x, y, z);
 }