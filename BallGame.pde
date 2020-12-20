class Ball {
  float x;
  float y;
  float vX;
  float vY;
  int radius;
  
  int s;
  int f;
  
  boolean allowGravity;
  
  Ball(int r, float x, float y) {
    radius = r;
    this.x = x;
    this.y = y;
  }
  
  void setV(float vx, float vy) {
    vX = vx;
    vY = vy;
  }
  
  void setFillandStroke(float fill, float stroke) {
    f = (int)fill;
    s = (int)stroke;
  }
  
  void update() {
    strokeWeight(3);
    stroke(s);
    fill(f);
    ellipse(x, y, radius, radius);
  }
}

float gravity = -0.2;

Ball[] balls = new Ball[35];
int nBalls = 0;

int startX;
int startY;

void setup() {
  size(1000, 600);
  ellipseMode(RADIUS);
}

void draw() {
  background(#FFFFFF);
  
  fill(#553300);
  textSize(24);
  text("# Balls: " + nBalls + "        " + ((boom) ? "BOOM activated." : "") + "        Gravity: " + ((g == 0) ? "Normal" : (g == 1) ? "Low" : "High"), 30, 30);
  
  if (mousePressed) {
    stroke(#777777);
    strokeWeight(2);
    line(startX, startY, mouseX, mouseY);
  }
  for (int i = 0; i < nBalls; ++i) {
    balls[i].update();
    // gravity acceleration
    if (balls[i].allowGravity) balls[i].vY -= gravity; 
    
    // movement
    balls[i].x += balls[i].vX;
    balls[i].y += balls[i].vY;
    
    // wall collision detection
    // bottom
    if (balls[i].y > height - balls[i].radius) {
      balls[i].vY *= -0.8;
      balls[i].y = height - balls[i].radius;
    }
    // left
    if (balls[i].x - balls[i].radius < 0) {
      balls[i].vX *= -0.8;
      balls[i].x = 0 + balls[i].radius;
    }
    // right
    if (balls[i].x > width - balls[i].radius) {
      balls[i].vX *= -0.8;
      balls[i].x = width - balls[i].radius;
    }
  }
}

void mousePressed() {
  if (nBalls == balls.length) nBalls = 0;
  
  balls[nBalls] = new Ball(10, mouseX, mouseY);
  
  int s = mouseX;
  int f = mouseY;
  
  balls[nBalls]
    .setFillandStroke(map(s, 0, width,  #0FF000, #FF0000),
                      map(f, 0, height, #000FF0, #00FF00)); 
  startX = mouseX;
  startY = mouseY;
  
  balls[nBalls].allowGravity = false;
}

void mouseDragged() {
  ellipse(mouseX, mouseY, 3, 3);
}

void mouseReleased() {
  balls[nBalls].setV(0.1*(mouseX - startX), 0.1*(mouseY - startY));
  balls[nBalls].allowGravity = true;
  
  ++nBalls;
}

int impulse = 7;
boolean boom = false;
int g = 0;
void keyReleased() {
  if (keyCode == UP) {
    for (int i = 0; i < nBalls; ++i) {
      balls[i].vY -= impulse + random(-3,3);
      balls[i].vX += random(-1,1);
    }
  }
  if (keyCode == DOWN) {
    for (int i = 0; i < nBalls; ++i) {
      balls[i].vY += impulse + random(-3,3);
      balls[i].vX += random(-1,1);
    }
  }
  if (keyCode == LEFT) {
    for (int i = 0; i < nBalls; ++i) {
      balls[i].vX -= impulse + random(-3,3);
      balls[i].vY += random(-1,1);
    }
  }
  if (keyCode == RIGHT) {
    for (int i = 0; i < nBalls; ++i) {
      balls[i].vX += impulse + random(-3,3);
      balls[i].vY += random(-1,1);
    }
  }
  if (key == 'b') {
    if (!boom)
      for (int i = 0; i < nBalls; ++i) {
        balls[i].vX += random(-10,10);
        balls[i].vY += random(0,20);
      }
    boom = true;
  }
  if (key == 'g') {
    ++g;
    if (g == 3) g = 0;
    
    if (g == 0)
      gravity = -0.2;
    else if (g == 1)
      gravity = -0.01;
    else if (g == 2)
      gravity = -0.75;
  }
}

void keyPressed() {
  if (key == 'r') {
    boom = false;
    
    fill(#00FF00);
    textSize(60);
    text("BOOM RESET!", 30, 250);
    
    for (int i = 0; i < nBalls; ++i) {
      balls[i] = null;
    } 
    nBalls = 0;
  }
}
