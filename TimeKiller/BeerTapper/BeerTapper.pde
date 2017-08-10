/***********************************************************************************************************************************
 *
 * Beer Tapper
 * by Hector Ramirez. 
 * 
 * Click on the customer(circle) before it goes red.
 * Wait for them to finish their beer.
 * 
 **********************************************************************************************************************************/
 
enum Type{
  Empty,
  Customer,
  Beer
};
 
class Seat {
  PVector pos;
  PVector size;
  Type type;
  float changeRate;
  float charge;
  
  Seat(PVector iPos) {
    pos = iPos;
    size = new PVector(0.0, 0.0);
    type = Type.Empty;
    changeRate = 0.0;
    charge = 0.0;
  }
  
  void setSeat(PVector iSize, Type iType, float iChangeRate, float iCharge) {
    size = iSize;
    type = iType;
    changeRate = iChangeRate;
    charge = iCharge;
  }
  
  void tickSeat(float iCharge) {
    charge = iCharge;
  }
  
  void emptySeat() {
    size = new PVector(0.0, 0.0);
    type = Type.Empty;
    changeRate = 0.0;
    charge = 0.0;
  }
}
 
boolean gameEnded = false;
PVector glassSize = new PVector(40, 60);
PVector customerSize = new PVector(60, 60);
PVector barPos;
int score = 0;
int health = 10;
ArrayList<Seat> seats = new ArrayList<Seat>();
float newCustomerChance = 5.0f;
int maxBeer = 6;
float beerSpacing = 90;
float minChangeRate = 0.1;
float maxChangeRate = 0.8;
float maxCharge = 100.0;

void setup() {
  size(640, 360);
  background(0);
  barPos = new PVector(0, (height/3)*2);
  for (int i=0; i<maxBeer; i++) {
    seats.add(new Seat(new PVector(beerSpacing*(i+1), barPos.y, 0)));
  }
}

void draw() {
  background(0);
  fill(255,255,255);
  text("Score:"+score, 10, 30); 
  text("Health:"+health, 10, 60); 
  rect(barPos.x, barPos.y, width, height/3);
  
  if(gameEnded) {
  } else {
    if (random(0, 100) <= newCustomerChance) {
      int seat = getEmptySeat();
      if(seat != -1) {
        Seat tmp = seats.get(seat);
        tmp.setSeat(customerSize, Type.Customer, random(minChangeRate, maxChangeRate), maxCharge);
      }
    }
    for (int i=0; i<seats.size(); i++) {
      Seat tmp = seats.get(i);
      
      if(tmp.type != Type.Empty) {
        if(tmp.charge > 0) {
          switch(tmp.type) {
            case Customer:
              ellipse(tmp.pos.x, tmp.pos.y-(tmp.size.y/2), tmp.size.x, tmp.size.y);
              fill(255.0, 0.0, 0.0);
              ellipse(tmp.pos.x, tmp.pos.y-(tmp.size.y/2), tmp.size.x*((maxCharge-tmp.charge)/maxCharge), tmp.size.y*((maxCharge-tmp.charge)/maxCharge));
              fill(255.0, 255.0, 255.0); 
            break;
            case Beer:
              fill(255.0, 255.0, 0.0);
              rect(tmp.pos.x, tmp.pos.y-tmp.size.y, tmp.size.x, tmp.size.y);
              fill(255.0, 255.0, 255.0);
              rect(tmp.pos.x, tmp.pos.y-tmp.size.y, tmp.size.x, tmp.size.y*((maxCharge-tmp.charge)/maxCharge));
            break;
            default:
            break;
          }
          tmp.tickSeat(tmp.charge-tmp.changeRate);
        } else {
          switch(tmp.type) {
            case Customer:
              health--;
            break;
            case Beer:
            score++;
            break;
            default:
            break;
          }
          tmp.emptySeat();
        }
      }
      
      
    }
    
    if (!(health > 0)) {
      gameEnded = true;
    }
    
  }
}

void mousePressed() {
  if(mouseButton == LEFT && !gameEnded) {
    for (int i=0; i<seats.size(); i++) {
      Seat tmp = seats.get(i);
      if(checkClick(tmp.pos, tmp.size, new PVector(mouseX, mouseY))) {
        tmp.setSeat(customerSize, Type.Beer, random(minChangeRate, maxChangeRate), maxCharge);
      }
    }
  }
}

int getEmptySeat() {
  for (int i=0; i<seats.size(); i++) {
    Seat tmp = seats.get(i);
    if(tmp.type == Type.Empty) {
      return i;
    }
  }
  return -1;
}

boolean checkClick(PVector oPos, PVector oSize, PVector cPos) {
  if (cPos.x > oPos.x-(oSize.x/2) && cPos.x < oPos.x+(oSize.x/2)) {
    if (cPos.y > oPos.y-(oSize.y/2) && cPos.y < oPos.y+(oSize.y/2)) {
      return true;
    }
  }
  return false;
}