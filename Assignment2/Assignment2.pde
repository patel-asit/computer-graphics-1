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

// Define the shapes with their respective parameters

Shape sphere1, sphere2, plane, cylinder, cone;
Shape[] shapes;

int numPixels;

void setup() {
  // RGB values range over 0..1 rather than 0..255
  colorMode(RGB, 1.0f);
  size(800, 800);
  numPixels = width * height;
  printSettings();
  noLoop();

  // Sphere(center, radius, color)
sphere1 = new Sphere(new PVector(-5, 5, RASTER_Z + 15), 5, GREEN); // Sphere with center at (-5, 5, RASTER_Z+15), radius 5, color GREEN
sphere2 = new Sphere(new PVector(4, -2, RASTER_Z + 40), 15, RED);  // Sphere with center at (4, -2, RASTER_Z+40), radius 15, color RED
// Plane(point, normal, color)
plane = new Plane(new PVector(10, 15, RASTER_Z + 7), new PVector(0, 1, 0), MAGENTA); // Plane with point (10, 15, RASTER_Z+7), normal vector (0, 1, 0), color MAGENTA
// Cylinder(center, radius, color, height)
cylinder = new Cylinder(new PVector(5, 5, RASTER_Z + 2), 2, BLUE, 6); // Cylinder with base center at (5, 5, RASTER_Z+2), radius 2, color BLUE, height 6
// Cone(apex, radius, color, height)
cone = new Cone(new PVector(-5, 0, RASTER_Z + 5), 0.9, YELLOW, 10); // Cone with apex at (-5, 0, RASTER_Z+5), radius 0.9, color YELLOW, height 10
// Array of shapes
shapes = new Shape[] { sphere1, sphere2, plane, cylinder, cone };
}

/*
You should read this function carefully and understand how it works,
 but you should not need to edit it
 */
void draw() {
  colorMode(RGB, 1.0f);
  background(BLACK);
  loadPixels();
  drawShapes();
  updatePixels();
}

void drawShapes(){
  IntersectionPoint ip;
  PVector Dij;

  //traverse the raster to draw the pixels
  for(int i=0; i<RASTER_WIDTH; i++){
    for(int j=0; j<RASTER_HEIGHT; j++){
      //make Pij in the loop and get Dij so Rij(t) = E + tDij for some t>0
      Dij = getPij(i,j).normalize();

      ip = closestIntersection(shapes, Dij);
      if(ip!=null){

        if(drawShadow(ip.getIntersection(), shapes)){
          setColor(ip.getAmbient());
        }else{
          setColor(ip.getCol());
        }
        setPixel(i,j);
      }
    }
  }
}

// This returns null if there are no shapes with intersection points for this pixel ray
IntersectionPoint closestIntersection(Shape[] shapes, PVector normalized_ray){
  //return the closest shape
  IntersectionPoint closest = null, current = null;

  for(Shape shape : shapes){
    current = shape.checkIntersection(normalized_ray, EYE);
    if(current != null){
      if(closest == null){
        closest = current;
      } else {
        if (current.getIntersection().z < closest.getIntersection().z) {
          closest = current;
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

// The intersection point on the shape becomes the origin for a new ray
// The new ray will point towards the light source

boolean drawShadow(PVector origin, Shape[] shapes){
  boolean result = false;
  PVector ray = PVector.sub(LIGHT, origin).normalize();
  
  for(Shape shape : shapes){
    if(shape.checkIntersection(ray, origin) != null){
      result = true;
    }
  }
  // return result;
  return false;
}
 