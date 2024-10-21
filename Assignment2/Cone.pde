class Cone extends Shape{
    PVector center;
    PVector normal;
    color col;
    float slope, length, yMin, yMax;
    
    Cone(PVector center, float slope, color col, int length){
        super(col);
        this.center = center;
        this.slope = slope;
        this.length = length;

        this.yMin = center.y - length/2;
        this.yMax = center.y + length/2;
    }

    IntersectionPoint checkIntersection(PVector normalized_ray, PVector origin) {
        // return early if normalized_ray has NaN values 
        if(normalized_ray == null || Float.isNaN(normalized_ray.x) || Float.isNaN(normalized_ray.y) || Float.isNaN(normalized_ray.z)){
            System.out.println("Normalized ray has NaN values");
            return null;
        }
        
        PVector Rt1=null, Rt2=null, intersection=null;
        float t1, t2;

        PVector F = PVector.sub(origin, center);
        float a = sq(normalized_ray.x) + sq(normalized_ray.z) - sq(slope*normalized_ray.y);
        float b = 2 * (normalized_ray.x * F.x + normalized_ray.z * F.z - slope*normalized_ray.y*F.y);
        float c = sq(F.x) + sq(F.z) - sq(slope*F.y);
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
        }

        // if t1 and t2 are both present, then overwrite the variable with the closer intersection point
        if(!Float.isNaN(t1) && !Float.isNaN(t2) && t1>=0 && t2>=0){
            if(t1 < t2){
                intersection = Rt1;
            } else {
                intersection = Rt2;
            }

            //only draw half of the cone and then bound the intersection to the cone
            if(intersection.y > center.y || intersection.y < yMin){
                intersection = null;
            }
        }

        if(intersection == null){
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