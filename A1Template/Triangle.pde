class Triangle {
  static final int NUM_VERTICES = 3;

  //consider adding these instance variables. also might need updating in updateAll() method
  // edge vectors, center point, normal vector at center, projected vertices, projected edge vectors...


  // positions of three triangle vertices in 3D space
  PVector[] vertices = new PVector[NUM_VERTICES];
  
  // normal vectors at vertices
  PVector[] vertexNormals = new PVector[NUM_VERTICES];

  //constructor with only 1 param
  Triangle(PVector[] vertices) {
    for (int j=0; j<NUM_VERTICES; j++) {
      this.vertices[j] = vertices[j].copy();
      
      //get cross product vector and that is normal vector
      //this.vertexNormals = 3DcrossProduct(getEdges(vertices));

      //CAREFUL ABOUT CREATING AND RETURNING PVECTOR OBJECTS
      // WE MIGHT HAVE TO DEEP COPY SOMETIMES
      // OR ELSE YOU WILL BE RETURNING POINTERS ONLY

      //to get normals, make 2 vectors from vertices and cross product them, and that n value is used to get [n,n,n] vertexNormals
      //this.vertexNormals[j] = normals[j].copy();
      //this.vertexNormals[j].normalize();
    }
    updateAll();
  }

  Triangle(PVector[] vertices, PVector[] normals) {
    for (int j=0; j<NUM_VERTICES; j++) {
      this.vertices[j] = vertices[j].copy();
      this.vertexNormals[j] = normals[j].copy();
      this.vertexNormals[j].normalize();
    }
    updateAll();
  }
  
  
  // if triangle vertices or vertex normals change, update remaining data
  void updateAll() {
    
    // if we add more instance variables in this class,
    // then this method is used to update their values like how setVectros() is used to update the class's variables
    
    /*
        If you add more instance variables to the
        Triangle class—and you should definitely do so—put the code that calculates their values into updateAll()
        so that all of your variables are updated as the triangle rotates.
    */
  }

  void setVectors(PVector[] newVertices, PVector[] newNormals) {
    for (int j=0; j<Triangle.NUM_VERTICES; j++) {
      vertices[j] = newVertices[j].copy();
      vertexNormals[j] = newNormals[j].copy();
    }
    updateAll();
  }
}

/*
Implementation of the rotation effect. 
Don't change anything below here.
*/

void rotateTriangles(Triangle[] original, Triangle[] rotated, float theta) {
  if (original == null || rotated == null) return;
  for (int i=0; i<original.length; i++) {
    PVector[] rotatedVertices = new PVector[Triangle.NUM_VERTICES];
    PVector[] rotatedNormals = new PVector[Triangle.NUM_VERTICES];
    for (int j=0; j<Triangle.NUM_VERTICES; j++) {
      rotatedVertices[j] = rotateVertex(original[i].vertices[j], theta);
      rotatedNormals[j] = rotateVertex(original[i].vertexNormals[j], theta);
    }
    rotated[i].setVectors(rotatedVertices, rotatedNormals);
  }
}

/*
Parameter v is a 3D vector. Return a copy of v after
 rotating by angle theta about the x, y and z axes in succession.
 This math will be covered later in the course.
 */
PVector rotateVertex(PVector v, float theta) {
  PVector r = v.copy();
  for (int axis=X; axis<=Z; axis++) {
    eulerRotate(r, theta, axis);
  }
  return r;
}

/*
Rotate 3D vector in place about the given axis
 */
void eulerRotate(PVector v, float theta, int rotateIndex) {
  float[] vectorArray = v.array();
  int ind1 = (rotateIndex+1) % NUM_DIMENSIONS;
  int ind2 = (rotateIndex+2) % NUM_DIMENSIONS;

  float tmp1, tmp2;

  tmp1 = vectorArray[ind1]*cos(theta) - vectorArray[ind2]*sin(theta);
  tmp2 = vectorArray[ind1]*sin(theta) + vectorArray[ind2]*cos(theta);
  vectorArray[ind1] = tmp1;
  vectorArray[ind2] = tmp2;
  v.set(vectorArray);
}

Triangle[] copyTriangleList(Triangle[] originalList) {
  if (originalList == null) return null;
  Triangle[] copyList = new Triangle[originalList.length];
  for (int i=0; i<originalList.length; i++) {
    copyList[i] = new Triangle(originalList[i].vertices, originalList[i].vertexNormals);
  }
  return copyList;
}
