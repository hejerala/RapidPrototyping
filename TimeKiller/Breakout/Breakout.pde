/***********************************************************************************************************************************
 *
 * Breakout
 * by Hector Ramirez. 
 * 
 * Destroy all the bricks.
 * Move the mouse to control the paddle.
 * 
 **********************************************************************************************************************************/
 
int screenW = 400;
int screenH = 600;
int brickSpacing= 5;
int brickCols= 10;
int brickRows= 10;
int topSpace= 20;
int bottomSpace= 50;
int textSize = 32;
boolean gameEnded = false;
boolean didWin = false;
PVector ballSize = new PVector(15, 15);
PVector ballPos = new PVector(screenW/2, screenH/2);
PVector ballSpeed = new PVector(4, 4);
PVector ballCol = new PVector(255, 0, 0);
PVector brickSize = new PVector((screenW-(brickCols-2)*brickSpacing)/brickCols, 10);
PVector paddleSize = new PVector(60, 20);
PVector paddlePos = new PVector(screenW/2, screenH-bottomSpace);
PVector paddleCol = new PVector(255, 0, 255);
int score = 0;
int health = 3;
ArrayList<PVector> colors = new ArrayList<PVector>();
ArrayList<Block> brickWall = new ArrayList<Block>();
Ball gBall = new Ball(ballPos, ballSize, ballCol, ballSpeed);
Block paddle = new Block(paddlePos, paddleSize, paddleCol, 0);
 
class Ball {
  PVector pos;
  PVector size;
  PVector col;
  PVector speed;
   
  Ball(PVector iPos, PVector iSize, PVector iCol, PVector iSpeed) {
    pos = iPos;
    size = iSize;
    col = iCol;
    speed = iSpeed;
  }
  
  void drawShape() {
    noStroke();
    fill(col.x, col.y, col.z);
    ellipse(pos.x, pos.y, size.x, size.y);
  }
  
  void tick() {
    pos.x += speed.x;
    pos.y += speed.y;
  }
  
  void resetBall() {
    pos = new PVector(screenW/2, screenH/2);
    speed = new PVector(4, 4);
  }
   
  boolean checkEdges() {
    boolean died = false;
    if(pos.x > width-(size.x/2)) {
      speed.x = -abs(speed.x);
    } else if(pos.x < size.x/2) {
      speed.x = abs(speed.x);
    } else if(pos.y > height-(size.y/2)) {
      speed.y = -abs(speed.y);
      died = true;
    } else if(pos.y < size.y/2) {
      speed.y = abs(speed.y);
    }
    return died;
  }
}
 
class Block {
  PVector pos;
  PVector size;
  PVector col;
  int hits;
   
  Block(PVector iPos, PVector iSize, PVector iCol, int iHits) {
    pos = iPos;
    size = iSize;
    col = iCol;
    hits = iHits;
  }
  
  void drawShape() {
    noStroke();
    fill(col.x, col.y, col.z);
    rect(pos.x, pos.y, size.x, size.y);
  }
  
  boolean checkCollisions(Ball b) {
    //Bottom collision
    if((b.pos.x+(b.size.x/2) > pos.x && b.pos.x-(b.size.x/2) < pos.x+size.x)
    && (b.pos.y-(b.size.y/2) < pos.y+size.y && b.pos.y-(b.size.x/2) > pos.y)) {
      b.speed.y = abs(b.speed.y);
      hits--;
      return true;
    }
    //Top collision
    if((b.pos.x+(b.size.x/2) > pos.x && b.pos.x-(b.size.x/2) < pos.x+size.x)
    && (b.pos.y+(b.size.y/2) < pos.y+size.y && b.pos.y+(b.size.y/2) > pos.y)) {
      b.speed.y = -abs(b.speed.y);
      hits--;
      return true;
    }
    //Left collision
    if((b.pos.x+(b.size.x/2) > pos.x && b.pos.x+(b.size.x/2) < pos.x+size.x)
    && (b.pos.y-(b.size.y/2) < pos.y+size.y && b.pos.y+(b.size.y/2) > pos.y)) {
      b.speed.x = -abs(b.speed.x);
      hits--;
      return true;
    }
    //Right collision
    if((b.pos.x-(b.size.x/2) > pos.x && b.pos.x-(b.size.x/2) < pos.x+size.x)
    && (b.pos.y-(b.size.y/2) < pos.y+size.y && b.pos.y+(b.size.y/2) > pos.y)) {
      b.speed.x = abs(b.speed.x);
      hits--;
      return true;
    }
    
    return false;
  }
}

void setup() {
  size(400, 600);
  background(0);
  
  colors.add(new PVector(255.0, 0.0, 0.0));
  colors.add(new PVector(0.0, 255.0, 0.0));
  colors.add(new PVector(0.0, 0.0, 255.0));
  colors.add(new PVector(0.0, 255.0, 255.0));
  colors.add(new PVector(255.0, 255.0, 0.0));
  colors.add(new PVector(255.0, 0.0, 255.0));
  
  for(int i = 0; i<brickRows; i++) {
    for(int j = 0; j<brickCols; j++) {
      brickWall.add(new Block(
        new PVector((brickSize.x+brickSpacing)*j, topSpace+(brickSize.y+brickSpacing)*i),
        brickSize,
        colors.get((int)random(0, colors.size()-1)),
        1
      ));
    }
  }
  
}

void draw() {
  background(0);
  textSize(textSize);
  fill(255,255,255);
  text("Score:"+score, 0, height-2); 
  text("Health:"+health, (int)(width-textWidth("Health:"+health)), height-2); 
  
  if(gameEnded) {
    if(didWin) {
      text("You Won!", (int)(width-textWidth("You Won!"))/2, height/2);
    } else {
      text("You Lost!", (int)(width-textWidth("You Lost!"))/2, height/2);
    }
  } else {
    
    for(int i = 0; i<brickWall.size(); i++) {
      Block tmp = brickWall.get(i);
      tmp.drawShape();
      if(tmp.checkCollisions(gBall)) {
        brickWall.remove(i);
        score++;
      }
    }
    
    gBall.drawShape();
    gBall.tick();
    if(gBall.checkEdges()) {
      health--;
      gBall.resetBall();
    }
    
    paddle.drawShape();
    if(mouseX+paddle.size.x < width) {
      paddle.pos.x = mouseX;
    }
    paddle.checkCollisions(gBall);
    
    if (!(health > 0)) {
      gameEnded = true;
      didWin = false;
    }
    if (!(brickWall.size() > 0)) {
      gameEnded = true;
      didWin = true;
    }
    
  }
}