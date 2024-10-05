/*
Define any mathematical operations that you need here.
 E.g., the 2D cross product as discussed in Unit 1.
 */

// 2D cross product
public float crossProduct2D(PVector a, PVector b) {
  return a.x*b.y - a.y*b.x;
}

//public PVector 3DcrossProduct(PVector edges[]){
//    PVector normal = new PVector();
//    normal.x = edges[0].y*edges[1].z - edges[0].z*edges[1].y;
//    normal.y = edges[0].z*edges[1].x - edges[0].x*edges[1].z;
//    normal.z = edges[0].x*edges[1].y - edges[0].y*edges[1].x;
//    return normal;
//}
