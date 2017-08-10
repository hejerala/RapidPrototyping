/**
 *
 * Crab Race
 * by Hector Ramirez. 
 * 
 * The display shows Starfish & Sea Urchins rotating.
 * Creates a Starfish on left click and a Sea Urchin on right click.
 * 
 */

boolean gameEnded = false;
boolean p1Won = false;
PVector star = new PVector(10, 30, 5);
PVector targetSize = new PVector(20, 20);
PVector t1Pos;
PVector t2Pos;
float crabSpeed = 20.0;
PVector crabSize = new PVector(20, 20);
PVector p1Pos;
PVector p2Pos;
float dT = 1000;//miliseconds

void setup() {
  size(640, 360);
  background(0);
  randomizeTarget1Pos();
  randomizeTarget2Pos();
  p1Pos = new PVector(0, (height/2)-crabSize.y);
  p2Pos = new PVector(0, height-crabSize.y);
}

void draw() {
  background(0);
  
  if(gameEnded) {
    if(p1Won) {
      star(width/2, star.x+(star.y), star.x, star.y, (int)star.z); 
    } else {
      star(width/2, (height/2)+(star.y), star.x, star.y, (int)star.z); 
    }
  } else {
    rect(p1Pos.x, p1Pos.y, crabSize.x, crabSize.y);
    rect(p2Pos.x, p2Pos.y, crabSize.x, crabSize.y);
    
    ellipse(t1Pos.x, t1Pos.y, targetSize.x, targetSize.y);
    ellipse(t2Pos.x, t2Pos.y, targetSize.x, targetSize.y);
    
    if(p1Pos.x >= width-(crabSize.x)) {
      p1Won = true;
      gameEnded = true;
    }
    if(p2Pos.x >= width-(crabSize.x)) {
      gameEnded = true;
    }
  }
}

void mousePressed() {
  if(mouseButton == LEFT && !gameEnded) {
    if(checkClick(t1Pos, targetSize, new PVector(mouseX, mouseY))) {
      randomizeTarget1Pos();
      p1Pos.x += crabSpeed;
    }
    if(checkClick(t2Pos, targetSize, new PVector(mouseX, mouseY))) {
      randomizeTarget2Pos();
      p2Pos.x += crabSpeed;
    }
  }
}

boolean checkClick(PVector oPos, PVector oSize, PVector cPos) {
  if (cPos.x > oPos.x-(oSize.x/2) && cPos.x < oPos.x+(oSize.x/2)) {
    if (cPos.y > oPos.y-(oSize.y/2) && cPos.y < oPos.y+(oSize.y/2)) {
      return true;
    }
  }
  return false;
}

void randomizeTarget1Pos() {
  t1Pos = new PVector(random(targetSize.x/2, width-(targetSize.x/2)), random(targetSize.y/2, (height/2)-(crabSize.y/2)));
}

void randomizeTarget2Pos() {
  t2Pos = new PVector(random(targetSize.x/2, width-(targetSize.x/2)), random((height/2)+(targetSize.y/2), height-(crabSize.y/2)));
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}