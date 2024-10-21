class Circle {
    // PVector center;
    // PVector normal; //DO I NEED THIS?? I DONT HAVE NORMAL VECTORS FOR SPHERES BUT HAVE FOR POINTS
    // float radius;
    // color col; // SHOULD THIS BE  A float[] ??

    // Circle(PVector center, float radius, color col) {
    //     this.center = center;
    //     this.radius = radius;
    //     this.col = col;
    //     this.normal = PVector.sub(center, EYE).normalize();
    // }

    // IntersectionPoint checkIntersection(PVector normalized_ray) {
    //     //gotta check if normalized_ray will have NaN values or not
    //     //if it does, then return some predefined null value
    //     if(normalized_ray == null || Float.isNaN(normalized_ray.x) || Float.isNaN(normalized_ray.y) || Float.isNaN(normalized_ray.z)){
    //         System.out.println("Normalized ray has NaN values");
    //         return null;
    //     }

    //     PVector F = PVector.sub(EYE, center);
    //     PVector Rt1=null, Rt2=null, intersection=null;
    //     float t1, t2;
    //     float a = 1;
    //     float b = 2 * PVector.dot(normalized_ray, F);
    //     float c = PVector.dot(F,F) - sq(radius);
    //     float discriminant = sqrt(sq(b) - 4*a*c); //DO NOT CALCULATE ANYTHING IF THIS IS < 0

    //     if (discriminant < 0){
    //         System.out.println("Discriminant is less than 0");
    //         return null;
    //     }

    //     t1 = (-b - discriminant)/(2*a);
    //     t2 = (-b + discriminant)/(2*a);
    //     if(!Float.isNaN(t1) && t1 >= 0){
    //         Rt1 = PVector.add(EYE, PVector.mult(normalized_ray, t1));
    //         intersection = Rt1;
    //     }

    //     if(!Float.isNaN(t2) && t2 >= 0){
    //         Rt2 = PVector.add(EYE, PVector.mult(normalized_ray, t2));
    //         intersection = Rt2;
    //     }

    //     // if t1 and t2 are both present, then overwrite the variable with the closer intersection point
    //     if(!Float.isNaN(t1) && !Float.isNaN(t2)){
    //         if(t1 < t2){
    //             intersection = Rt1;
    //         } else {
    //             intersection = Rt2;
    //         }
    //     }
    //     // if(intersection != null){
    //     //     System.out.println("t1: " + t1 + " t2: " + t2 + " intersection: " + intersection);  
    //     // }
    //     // for now return with flat color, afterwards calculate phong too
    //     if(intersection == null){
    //         return null;
    //     } else {
    //         color phong = new PhongLighting(normal, intersection, col).calculate();
    //         return new IntersectionPoint(intersection, phong);
    //     }
    // }

    // //make getters for radius and center
    // float getRadius() {
    //     return radius;
    // }

    // PVector getCenter() {
    //     return center;
    // }
}