/***********************************************************************************************************************************
 *
 * Sushi maker
 * by Hector Ramirez. 
 * 
 * Click on the sushi of the same color as the order shows.
 * Complete the sushi order before the client(circle) goes red.
 * 
 **********************************************************************************************************************************/
 
class Sushi {
  PVector pos;
  PVector size;
  PVector col;
  float charge;
  float changeRate;
  
  Sushi(PVector iSize) {
    pos = new PVector(0.0, 0.0);
    size = iSize;
    col = new PVector(0.0, 0.0);
    charge = 0.0;
    changeRate = 0.0;
  }
  
   Sushi(PVector iPos, PVector iSize, PVector iCol) {
    pos = iPos;
    size = iSize;
    col = iCol;
    charge = 0.0;
    changeRate = 0.0;
  }
  
  Sushi(PVector iPos, PVector iSize, PVector iCol, float iCharge, float iChangeRate) {
    pos = iPos;
    size = iSize;
    col = iCol;
    charge = iCharge;
    changeRate = iChangeRate;
  }
  
  void tickSushi(float iCharge) {
    charge = iCharge;
  }
  
  void resetSushi(PVector iPos, PVector iCol, float iCharge, float iChangeRate) {
    pos = iPos;
    col = iCol;
    charge = iCharge;
    changeRate = iChangeRate;
  }
}
 
boolean gameEnded = false;
PVector sushiSize = new PVector(20, 20);
PVector customerSize = new PVector(60, 60);
PVector customerPos;
float customerCharge = 0.0;
float customerChangeRate = 0.0;
PVector barPos;
int score = -1;
int health = 10;
ArrayList<PVector> colors = new ArrayList<PVector>();
ArrayList<PVector> orderPos = new ArrayList<PVector>();
ArrayList<Sushi> sushiBar = new ArrayList<Sushi>();
ArrayList<Sushi> sushiOrder = new ArrayList<Sushi>();
float maxCharge = 100.0;
float minChangeRate = 0.5;
float maxChangeRate = 1.0;
int maxSushiBar = 20;
int maxSushiOrder = 4;
int maxColor = 4;

void setup() {
  size(640, 360);
  background(0);
  barPos = new PVector(0, (height/3)*2);
  customerPos = new PVector((width/3)*2+(customerSize.x/2), (height/3)*2+(customerSize.y));
  colors.add(new PVector(255.0, 0.0, 0.0));
  colors.add(new PVector(0.0, 255.0, 0.0));
  colors.add(new PVector(0.0, 0.0, 255.0));
  colors.add(new PVector(0.0, 255.0, 255.0));
  colors.add(new PVector(255.0, 255.0, 0.0));
  colors.add(new PVector(255.0, 0.0, 255.0));
  orderPos.add(new PVector((width/2)-(sushiSize.x/2), barPos.y+(sushiSize.x)));
  orderPos.add(new PVector((width/2)-(sushiSize.x/2), barPos.y+(sushiSize.x*2)));
  orderPos.add(new PVector((width/2)+(sushiSize.x/2), barPos.y+(sushiSize.x)));
  orderPos.add(new PVector((width/2)+(sushiSize.x/2), barPos.y+(sushiSize.x*2)));
  for (int i = 0; i<maxSushiBar; i++) {
    sushiBar.add(new Sushi(
      new PVector(random(sushiSize.x/2, width-(sushiSize.x/2)), random(0, barPos.y-(sushiSize.y/2))),
      sushiSize,
      colors.get((int)random(0, colors.size()-1)),
      maxCharge,
      random(minChangeRate, maxChangeRate)
    ));
  }
}

void draw() {
  background(0);
  fill(255,255,255);
  text("Score:"+score, 10, 30); 
  text("Health:"+health, 10, 60); 
  rect(barPos.x, barPos.y, width, 5);
  
  if(gameEnded) {
  } else {
    for(int i = 0; i<sushiBar.size(); i++) {
      Sushi tmp = sushiBar.get(i);
      fill(tmp.col.x, tmp.col.y, tmp.col.z);
      ellipse(tmp.pos.x, tmp.pos.y, tmp.size.x, tmp.size.y);
      if(tmp.charge > 0) {
        tmp.tickSushi(tmp.charge-tmp.changeRate);
      } else {
        tmp.resetSushi(
          new PVector(random(sushiSize.x/2, width-(sushiSize.x/2)), random(0, barPos.y-(sushiSize.y/2))),
          colors.get((int)random(0, colors.size()-1)),
          maxCharge,
          random(minChangeRate, maxChangeRate)
        );
      }
    }
    fill(255,255,255);
    
    if(customerCharge <= 0) {
      health--;
      customerCharge = 100.0;
      customerChangeRate = random(minChangeRate/3, maxChangeRate/3);
    } else if(sushiOrder.size() <= 0) {
      score++;
      customerCharge = 100.0;
      customerChangeRate = random(minChangeRate/3, maxChangeRate/3);
      for(int i = 0; i<maxSushiOrder; i++) {
        sushiOrder.add(new Sushi(
          orderPos.get(i),
          sushiSize,
          colors.get((int)random(0, colors.size()-1))
        ));
      }
    } else {
      for(int i = 0; i<sushiOrder.size(); i++) {
        fill(255,255,255);
        ellipse(customerPos.x, customerPos.y, customerSize.x, customerSize.y);
        fill(255.0, 0.0, 0.0);
        ellipse(customerPos.x, customerPos.y, customerSize.x*((maxCharge-customerCharge)/maxCharge), customerSize.y*((maxCharge-customerCharge)/maxCharge));
        Sushi tmp = sushiOrder.get(i);
        fill(tmp.col.x, tmp.col.y, tmp.col.z);
        ellipse(tmp.pos.x, tmp.pos.y, tmp.size.x, tmp.size.y);
      }
      customerCharge -= customerChangeRate;
    }
    fill(255,255,255);
    
    if (!(health > 0)) {
      gameEnded = true;
    }
    
  }
}

void mousePressed() {
  if(mouseButton == LEFT && !gameEnded) {
    for (int i=0; i<sushiBar.size(); i++) {
      Sushi tmp = sushiBar.get(i);
      if(checkClick(tmp.pos, tmp.size, new PVector(mouseX, mouseY))) {
        completeOrder(tmp.col);
        tmp.charge = 0.0;
      }
    }
  }
}

void completeOrder(PVector col) {
  for (int i=0; i<sushiOrder.size(); i++) {
      Sushi tmp = sushiOrder.get(i);
      if(areSameColor(tmp.col, col)) {
        sushiOrder.remove(i);
        break;
      }
    }
}

boolean areSameColor(PVector col1, PVector col2) {
  if(col1.x == col2.x) {
    if(col1.y == col2.y) {
      if(col1.z == col2.z) {
        return true;
      }
    }
  }
  return false;
}

boolean checkClick(PVector oPos, PVector oSize, PVector cPos) {
  if (cPos.x > oPos.x-(oSize.x/2) && cPos.x < oPos.x+(oSize.x/2)) {
    if (cPos.y > oPos.y-(oSize.y/2) && cPos.y < oPos.y+(oSize.y/2)) {
      return true;
    }
  }
  return false;
}