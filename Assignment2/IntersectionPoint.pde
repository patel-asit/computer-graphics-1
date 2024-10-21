class IntersectionPoint {
    PVector intersection;
    color col;
    color ambientOnly;

    IntersectionPoint(PVector intersection, color col, color ambientOnly) {
        this.intersection = intersection;
        this.col = col;
        this.ambientOnly = ambientOnly;
    }

    // getters
    PVector getIntersection() {
        return intersection;
    }

    color getCol() {
        return col;
    }

    color getAmbient() {
        return ambientOnly;
    }
}