class Ball {
  float x, y, speed;
  boolean alive;
  int direction;
  Particle[] particles = new Particle[30];
  
  Ball() {
    for (int i = 0; i < particles.length; i++) {
      particles[i] = new Particle();
    }
  }
  
  void init(float x, float y, float speed, int direction) {
    this.x = x;
    this.y = y;
    this.direction = direction;
    this.speed = speed * direction;
    alive = true;
  }
  
  void draw() {
    if (!alive) {
      for (Particle p : particles) {
        p.draw();
      }
      return;
    }
    
    fill(0, 0, 255, 32);
    x += speed;
    ellipse(x, y, 10 + speed, 10);
    ellipse(x, y, 10 - speed, 10);
    ellipse(x - speed, y, 10, 10);
    fill(0, 0, 255);
    ellipse(x, y, 10, 10);
  }
  
  void destroy(int horDir, int verDir) {
    alive = false;
    
    for (Particle p : particles) {
      p.init(x + random(-5, 5), y + random(-5, 5), horDir * random(0.1f, abs(speed) / 4f), verDir * random(0.1f, abs(speed) / 4f));
    }
  }
}
