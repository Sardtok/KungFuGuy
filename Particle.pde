class Particle {
  int alpha = 0;
  float horSpeed;
  float verSpeed;
  float x;
  float y;
  float size;
  
  void init(float x, float y,
            float horSpeed, float verSpeed) {
    alpha = 255;
    this.x = x;
    this.y = y;
    this.horSpeed = horSpeed;
    this.verSpeed = verSpeed;
    this.size = -0.5f * abs(horSpeed * verSpeed) + 5f;
  }
  
  void draw() {
    if (alpha <= 0) {
      return;
    }
    
    alpha -= 16;
    x += horSpeed;
    y += verSpeed;
    fill(0, 0, 255, alpha);
    ellipse(x, y, size, size);
  }
}
