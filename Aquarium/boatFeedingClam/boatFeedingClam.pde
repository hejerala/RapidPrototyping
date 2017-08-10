/**
 *
 * Boat Feeding Clam
 * by Hector Ramirez. 
 * 
 * Click to drop food from the boat.
 * Feed the clam with the dropped food.
 * 
 */

boolean gameEnded = false;
PVector star = new PVector(10, 30, 5);
PVector boatSize = new PVector(20, 20);
PVector boatPos = new PVector(boatSize.x/2, 50);
float boatSpeed = 10.0;
float boatDir = 1.0;
PVector clamSize = new PVector(20, 20);
PVector clamPos;
PVector foodSize = new PVector(10, 10);
float fallSpeed = 10.0;
ArrayList<PVector> foodPellets = new ArrayList<PVector>();
int foodEaten = 0;
int foodToEat = 1;

void setup() {
  size(640, 360);
  background(0);
  clamPos = new PVector(width/2, height-(clamSize.y/2));
}

void draw() {
  background(0);
  
  if(foodEaten >= foodToEat) {
    gameEnded = true;
  }
  
  rect(0, 50, width, 5);
  
  pushMatrix();
  translate(boatPos.x, boatPos.y-(boatSize.y/2));
  rotate(-30);
  arc(0, 0, boatSize.x, boatSize.y, -HALF_PI, HALF_PI); 
  popMatrix(); 
  
  pushMatrix();
  translate(clamPos.x, clamPos.y);
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  popMatrix();
  
  if(gameEnded) {
    star(width/2, height/2, star.x, star.y, (int)star.z); 
  } else {
    for (int i = 0; i < foodPellets.size(); i++) {
      PVector tmp = foodPellets.get(i);
        if(tmp.y < height) {
          if(checkClick(clamPos, clamSize, new PVector(tmp.x+(foodSize.x/2),tmp.y+(foodSize.y/2)))) {
            foodEaten++;
          }
          rect(tmp.x, tmp.y, foodSize.x, foodSize.y); 
          foodPellets.set(i, new PVector(tmp.x, tmp.y+fallSpeed));
        } else {
          foodPellets.remove(i);
        }
    }
    
    if(boatPos.x <= boatSize.x/2) {
      boatDir = 1;
    }
    if(boatPos.x >= width-(boatSize.x/2)) {
      boatDir = -1;
    }
    
    boatPos.x += boatDir*boatSpeed;
  }
  
  
}

void mousePressed() {
  if(mouseButton == LEFT && !gameEnded) {
    foodPellets.add(new PVector(boatPos.x, boatPos.y));
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