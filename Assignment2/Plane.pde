class Plane {
    PVector P0;
    PVector normal; 
    color col;

    Plane(PVector P0, PVector normal, color col) {
        this.P0 = P0;
        this.normal = normal;
        this.col = col;
    }

    IntersectionPoint checkIntersection(PVector normalized_ray) {
        //gotta check if normalized_ray will have NaN values or not
        //if it does, then return some predefined null value
        if(normalized_ray == null || Float.isNaN(normalized_ray.x) || Float.isNaN(normalized_ray.y) || Float.isNaN(normalized_ray.z)){
            System.out.println("Normalized ray has NaN values");
            return null;
        }

        PVector F = PVector.sub(EYE, P0);
        PVector intersection = null;

        float a = PVector.dot(normal, normalized_ray);
        float b = PVector.dot(normal, F);

        if(a == 0){
            return null; // normal is parallel to the plane
        }

        float t = -b/a;

        if(!Float.isNaN(t) && t >= 0){
            intersection = PVector.add(EYE, PVector.mult(normalized_ray, t));
        }

        // for now return with flat color, afterwards calculate phong too
        if(intersection == null){
            return null;
        } else {
            return new IntersectionPoint(intersection, col);
        }
    }
}