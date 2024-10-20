class IntersectionPoint {
    PVector intersection;
    color col;

    IntersectionPoint(PVector intersection, float[] col) {
        this.intersection = intersection;
        this.col = col;
    }

    // getters
    PVector getIntersection() {
        return intersection;
    }

    float[] getCol() {
        return col;
    }
}