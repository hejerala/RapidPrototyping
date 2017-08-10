/**
 *
 * Clam feeding competition
 * by Hector Ramirez. 
 * 
 * The display shows a couple boats over sea level and two clams at the bottom.
 * Each player must click on their respective targets as fast as possible to feed the clam.
 * The first player to fill the feeding bar wins.
 * 
 */

boolean gameEnded = false;
boolean p1Won = false;
PVector star = new PVector(10, 30, 5);
PVector targetSize = new PVector(20, 20);
int maxTargetClicks = 10;
PVector clamSize = new PVector(20, 20);
PVector p1Pos, p2Pos, t1Pos, t2Pos;
PVector foodSize = new PVector(10, 10);
float fallSpeed = 10.0;
PVector boatSize = new PVector(20, 20);
PVector boat1Pos, boat2Pos;
ArrayList<PVector> foodPellets = new ArrayList<PVector>();
int p1FoodEaten = 0;
int p2FoodEaten = 0;
int foodToEat = 20;
int seaHeight = 100;
int barWidth = 10;

void setup() {
  size(640, 360);
  background(0);
  randomizeTarget1Pos();
  randomizeTarget2Pos();
  boat1Pos = new PVector((boatSize.x/2)+(width/4), height-seaHeight);
  boat2Pos = new PVector((boatSize.x/2)+(3*(width/4)), height-seaHeight);
  p1Pos = new PVector((boatSize.x/2)+(width/4), height-(clamSize.y/2));
  p2Pos = new PVector((boatSize.x/2)+(3*(width/4)), height-(clamSize.y/2));
}

void draw() {
  background(0);
  
  drawScene();
  
  if(gameEnded) {
    if(p1Won) {
      fill(255,0,0);
      star(width/4, star.x+(star.y), star.x, star.y, (int)star.z); 
    } else {
      fill(0,0,255);
      star((width/4)*3, star.x+(star.y), star.x, star.y, (int)star.z); 
    }
  } else {
    fill(255,0,0);
    ellipse(t1Pos.x, t1Pos.y, targetSize.x, targetSize.y);
    fill(0,0,255);
    ellipse(t2Pos.x, t2Pos.y, targetSize.x, targetSize.y);
    
    fill(255,255,255);
    for (int i = 0; i < foodPellets.size(); i++) {
      PVector tmp = foodPellets.get(i);
        if(tmp.y < height-(clamSize.y/2)) {
          rect(tmp.x, tmp.y, foodSize.x, foodSize.y); 
          foodPellets.set(i, new PVector(tmp.x, tmp.y+fallSpeed));
        } else {
          if (tmp.x == boat1Pos.x) {
            p1FoodEaten++;
          } else {
            p2FoodEaten++;
          }
          foodPellets.remove(i);
        }
    }
    
    if(p1FoodEaten >= foodToEat) {
      p1Won = true;
      gameEnded = true;
    }
    if(p2FoodEaten >= foodToEat) {
      gameEnded = true;
    }
  }
   
}

void drawScene() {
  fill(255,255,255);
  
  rect(0, height-seaHeight, width, 5);
  
  pushMatrix();
  translate(boat1Pos.x, boat1Pos.y-(boatSize.y/2));
  rotate(-30);
  arc(0, 0, boatSize.x, boatSize.y, -HALF_PI, HALF_PI); 
  popMatrix(); 
  
  pushMatrix();
  translate(boat2Pos.x, boat2Pos.y-(boatSize.y/2));
  rotate(-30);
  arc(0, 0, boatSize.x, boatSize.y, -HALF_PI, HALF_PI); 
  popMatrix();
  
  fill(255,0,0);
  rect(width/2-barWidth, height-((height/foodToEat)*p1FoodEaten), barWidth, ((height/foodToEat)*p1FoodEaten));
  pushMatrix();
  translate(p1Pos.x, p1Pos.y);
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  popMatrix();
  
  fill(0,0,255);
  rect(width/2, height-((height/foodToEat)*p2FoodEaten), barWidth, ((height/foodToEat)*p2FoodEaten));
  pushMatrix();
  translate(p2Pos.x, p2Pos.y);
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  rotate(45);
  arc(0, 0, clamSize.x, clamSize.y, -HALF_PI, HALF_PI); 
  popMatrix();
  
  fill(255,255,255);
}

void mousePressed() {
  if(mouseButton == LEFT && !gameEnded) {
    if(checkClick(t1Pos, targetSize, new PVector(mouseX, mouseY))) {
      if (t1Pos.z > 0) {
        foodPellets.add(new PVector(boat1Pos.x, boat1Pos.y));
        t1Pos.z --;
      } else {
        randomizeTarget1Pos();
      }
    }
    if(checkClick(t2Pos, targetSize, new PVector(mouseX, mouseY))) {
      if (t2Pos.z > 0) {
        foodPellets.add(new PVector(boat2Pos.x, boat2Pos.y));
        t2Pos.z --;
      } else {
        randomizeTarget2Pos();
      }
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
  t1Pos = new PVector(random(targetSize.x/2, (width/2)-(targetSize.x/2)), random(targetSize.y/2, height-(targetSize.y/2)-seaHeight-boatSize.y), random(1, maxTargetClicks));
}

void randomizeTarget2Pos() {
  t2Pos = new PVector(random((width/2)+(targetSize.x/2), width-(targetSize.x/2)), random((height/2)+(targetSize.y/2), height-(targetSize.y/2)-seaHeight-boatSize.y), random(1, maxTargetClicks));
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