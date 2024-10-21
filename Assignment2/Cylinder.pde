class Cylinder extends Shape{
    PVector center;
    PVector normal; //DO I NEED THIS?? I DONT HAVE NORMAL VECTORS FOR SPHERES BUT HAVE FOR POINTS
    float radius;
    color col; // SHOULD THIS BE  A float[] ??
    int length;
    float yMin, yMax;
    Cylinder(PVector center, float radius, color col, int length){
        super(col);
        this.center = center;
        this.radius = radius;
        this.length = length;

        this.yMin = center.y - length/2;
        this.yMax = center.y + length/2;
        // this.normal = PVector.sub(center, EYE).normalize();
    }

    IntersectionPoint checkIntersection(PVector normalized_ray, PVector origin) {
        //gotta check if normalized_ray will have NaN values or not
        //if it does, then return some predefined null value
        if(normalized_ray == null || Float.isNaN(normalized_ray.x) || Float.isNaN(normalized_ray.y) || Float.isNaN(normalized_ray.z)){
            System.out.println("Normalized ray has NaN values");
            return null;
        }
        
        

        PVector Rt1=null, Rt2=null, intersection=null;
        float t1, t2;

        PVector F = PVector.sub(origin, center);

        float a = sq(normalized_ray.x) + sq(normalized_ray.z);
        float b = 2 * (normalized_ray.x * F.x + normalized_ray.z * F.z);
        float c = sq(F.x) + sq(F.z) - sq(radius);
        float discriminant = sqrt(sq(b) - 4*a*c); //DO NOT CALCULATE ANYTHING IF THIS IS < 0

        if (discriminant < 0){
            System.out.println("Discriminant is less than 0");
            return null;
        }

        t1 = (-b - discriminant)/(2*a);
        t2 = (-b + discriminant)/(2*a);


        // System.out.println("t1: " + t1 + " t2: " + t2);
        if(!Float.isNaN(t1) && t1 >= 0){
            Rt1 = PVector.add(origin, PVector.mult(normalized_ray, t1));
            intersection = Rt1;
        }

        if(!Float.isNaN(t2) && t2 >= 0){
            Rt2 = PVector.add(origin, PVector.mult(normalized_ray, t2));
            intersection = Rt2;
            // System.out.println("I am here");
            // System.out.println("Intersection: " + intersection);
        }

        // if t1 and t2 are both present, then overwrite the variable with the closer intersection point
        if(!Float.isNaN(t1) && !Float.isNaN(t2) && t1>=0 && t2>=0){
            // System.out.println("t1: " + t1 + " t2: " + t2);
            if(t1 < t2){
                intersection = Rt1;
            } else {
                intersection = Rt2;
            }

            //bound the yMin and yMax
            if(intersection.y < yMin || intersection.y > yMax){
                intersection = null;
            }
        }

        if(intersection == null){
            // System.out.println("I should not be here.");
            return null;
        } else {
            normal = PVector.sub(intersection, center).normalize();
            color phong = new PhongLighting(normal, intersection, this.getColor()).calculate(checkShadow());
            color ambientOnly = new PhongLighting(normal, intersection, this.getColor()).calculate(true);
            return new IntersectionPoint(intersection, phong, ambientOnly);
        }
    }

    boolean checkShadow(){
        return false;
    }
}