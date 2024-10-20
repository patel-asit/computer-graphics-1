class Sphere {
    PVector center;
    PVector normal; //DO I NEED THIS?? I DONT HAVE NORMAL VECTORS FOR SPHERES BUT HAVE FOR POINTS
    float radius;
    color col; // SHOULD THIS BE  A float[] ??

    Sphere(PVector center, float radius, color col) {
        this.center = center;
        this.radius = radius;
        this.col = col;
    }

    IntersectionPoint checkIntersection(PVector normalized_ray) {
        //gotta check if normalized_ray will have NaN values or not
        //if it does, then return some predefined null value
        if(normalized_ray.x == null || normalized_ray.y == null || normalized_ray.z == null){
            System.out.println("Normalized ray has NaN values");
            return null;
        }

        PVector F = PVector.sub(EYE, center);
        PVector Rt1, Rt2, intersection;
        float t1, t2;
        float a = 1;
        float b = 2 * PVector.dot(Dij, F);
        float c = PVector.dot(F,F) - sq(radius);
        float discriminant = sqrt(sq(b) - 4*a*c); //DO NOT CALCULATE ANYTHING IF THIS IS < 0

        if (discriminant < 0){
            System.out.println("Discriminant is less than 0");
            return null;
        }

        t1 = (-b - discriminant)/(2*a);
        t2 = (-b + discriminant)/(2*a);

        if(t1 != null or !Float.isNaN(t1)){
            Rt1 = PVector.add(EYE, PVector.mult(Dij, t1));
            intersection = Rt1;
        }

        if(t2 != null && !Float.isNaN(t2)){
            Rt2 = PVector.add(EYE, PVector.mult(Dij, t2));
            intersection = Rt2;
        }

        // if t1 and t2 are present, find the closer intersection point
        if(t1 != null && t2 != null && !Float.isNaN(t1) && !Float.isNaN(t2)){
            if(t1 < t2){
                intersection = Rt1;
            } else {
                intersection = Rt2;
            }
        }

        // for now return with flat color too, afterwards calculate phong too
        // return the array of PVector
        return new IntersectionPoint(intersection, col);
    }

    //make getters for radius and center
    float getRadius() {
        return radius;
    }

    PVector getCenter() {
        return center;
    }
}