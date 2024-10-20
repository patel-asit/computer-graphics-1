class IntersectionPoint {
    PVector intersection;
    color col;

    IntersectionPoint(PVector intersection, color col) {
        this.intersection = intersection;
        this.col = col;
    }

    // getters
    PVector getIntersection() {
        return intersection;
    }

    color getCol() {
        return col;
    }
}