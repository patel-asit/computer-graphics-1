abstract class Shape {
    color col;

    Shape(color fillColor) {
        this.col = fillColor;
    }

    abstract IntersectionPoint checkIntersection(PVector normalized_ray, PVector origin);

    color getColor() {
        return col;
    }
}