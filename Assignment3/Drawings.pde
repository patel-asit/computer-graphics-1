
void drawDiamond(float r, float g, float b){
  myPush();
    diamondTop(r,g,b);
    diamondBottom(r,g,b);
    drawRandomSparkles();
  myPop();
}

void drawRandomSparkles(){
  for(int i = 0; i < 3; i++){
    myPush();
      myTranslate(random(-1, 1), random(0, 1));
      myScale(random(0.1, 0.3), random(0.1, 0.3));
      sparkle();
    myPop();
  }
}

void sparkle(){
  fill(1,1,0);              //golden color
  stroke(1,1,0);            //golden color
  strokeWeight(5);
  beginShape(LINES);
    myVertex(-1, 0);
    myVertex(1, 0);         //horizontal line
    myVertex(0, -1);
    myVertex(0, 1);         //vertical line
    myVertex(-0.67, -0.67);
    myVertex(0.67, 0.67);   //right diagonal line
    myVertex(-0.67, 0.67);
    myVertex(0.67, -0.67);  //left diagonal line
  endShape();
}

void diamondTop(float r, float g, float b){
  stroke(1, 1, 1);  //white color borders
  strokeWeight(2);
  fill(r,g,b);
  beginShape(TRIANGLE_STRIP);
    myVertex(-1, 0);
    myVertex(-0.67, 0.67);
    myVertex(-0.33, 0);
    myVertex(0, 0.67);
    myVertex(0.33, 0);
    myVertex(0.67, 0.67);
    myVertex(1, 0);
  endShape();
}

void diamondBottom(float r, float g, float b){
  stroke(1, 1, 1);  //white color borders
  strokeWeight(2);
  fill(r,g,b);
  beginShape(TRIANGLE_STRIP);
    myVertex(-1, 0);
    myVertex(0, -1);
    myVertex(-0.33, 0);
    myVertex(0, -1);
    myVertex(1, 0);
    myVertex(0.33, 0);
  endShape();
}
