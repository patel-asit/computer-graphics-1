class Sphere extends Shape{
    PVector center;
    PVector normal; //DO I NEED THIS?? I DONT HAVE NORMAL VECTORS FOR SPHERES BUT HAVE FOR POINTS
    float radius;
    color col; // SHOULD THIS BE  A float[] ??

    Sphere(PVector center, float radius, color col) {
        super(col);
        this.center = center;
        this.radius = radius;
        this.normal = PVector.sub(center, EYE).normalize();
    }

    IntersectionPoint checkIntersection(PVector normalized_ray, PVector origin) {
        // return early if normalized_ray has NaN values 
        if(normalized_ray == null || Float.isNaN(normalized_ray.x) || Float.isNaN(normalized_ray.y) || Float.isNaN(normalized_ray.z)){
            System.out.println("Normalized ray has NaN values");
            return null;
        }

        PVector F = PVector.sub(origin, center);
        PVector Rt1=null, Rt2=null, intersection=null;
        float t1, t2;
        float a = 1;
        float b = 2 * PVector.dot(normalized_ray, F);
        float c = PVector.dot(F,F) - sq(radius);
        float discriminant = sqrt(sq(b) - 4*a*c); //DO NOT CALCULATE ANYTHING IF THIS IS < 0

        if (discriminant < 0){
            System.out.println("Discriminant is less than 0");
            return null;
        }

        t1 = (-b - discriminant)/(2*a);
        t2 = (-b + discriminant)/(2*a);
        if(!Float.isNaN(t1) && t1 >= 0){
            Rt1 = PVector.add(origin, PVector.mult(normalized_ray, t1));
            intersection = Rt1;
        }

        if(!Float.isNaN(t2) && t2 >= 0){
            Rt2 = PVector.add(origin, PVector.mult(normalized_ray, t2));
            intersection = Rt2;
        }

        // if t1 and t2 are both present, then overwrite the variable with the closer intersection point
        if(!Float.isNaN(t1) && !Float.isNaN(t2)){
            if(t1 < t2){
                intersection = Rt1;
            } else {
                intersection = Rt2;
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