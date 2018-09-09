class Game {
  final int[] controls = new int[128];
  boolean[] keyDown = new boolean[4];
  Guy guy;
  Ball[] balls = new Ball[BALLS * 2];
  int firstBall;
  float ballSpeed;
  Random r;
  int state = PLAYING;

  Game(int[][] controls, int seed) {
    guy = new Guy(WIDTH / 2, HEIGHT / 2);
    r = new Random(seed);
    ballSpeed = 4f;

    for (int i = 0; i < controls.length; i++) {
      for (int keyCode : controls[i]) {
        this.controls[keyCode] = i + 1;
      }
    }

    for (int i = 0; i < balls.length; i++) {
      balls[i] = new Ball();

      if (i < BALLS) {
        float y = HEIGHT / 2 - 5;
        if (r.nextFloat() > 0.5) {
          y += 25;
        }

        float x = (-60 * (i + 1)) * ballSpeed;
        if (r.nextFloat() > 0.5) {
          x = WIDTH - x;
        }

        balls[i].init(x, y, ballSpeed, (int)(x / abs(x)) * -1);
      } else {
        balls[i].alive = false;
      }
    }
  }

  void draw() {
    fill(255);
    rect(0, 0, WIDTH, HEIGHT);
    fill(0, 0, 255);
    if (state == GAME_OVER) {
      drawGameOver();
      return;
    }
    
    if (guy.draw()) {
      state = GAME_OVER;
    }

    for (Ball b : balls) {
      b.draw();

      if (b.alive && abs(b.x - WIDTH / 2) < 15) {
        boolean died = guy.collide(b); 
        int horDir = died ? b.direction : -b.direction;
        b.destroy(horDir, b.y > HEIGHT / 2 ? 1 : -1);
        createBall((++firstBall + BALLS) % balls.length);
        firstBall %= balls.length;
        ballSpeed += 0.1f;
        guy.animationSpeed = died ? 1f : guy.animationSpeed + 0.01f;
      }
    }
  }


  void drawGameOver() {
    text(guy.points, guy.x, guy.y - HEIGHT / 3);
    text("You make kung fu look ugly!", WIDTH / 2, HEIGHT / 2);
  }

  void createBall(int ballIndex) {
    float y = HEIGHT / 2 - 5;
    if (r.nextFloat() > 0.5) {
      y += 25;
    }

    float x = -60 * ballSpeed;
    if (r.nextFloat() > 0.5) {
      x = WIDTH - x;
    }

    balls[ballIndex].init(x, y, ballSpeed, (int)(x / abs(x)) * -1);
  }
  
  boolean keyPressed(int keyCode) {
    if (keyCode >= controls.length) {
      return false;
    }
    
    int control = controls[keyCode];
    if (control == 0) {
      return false;
    }
    
    if(keyDown[control - 1]) {
      return true;
    }
    
    keyDown[control - 1] = true;
    switch(controls[keyCode]) {
      case L:
        guy.left();
        break;
      case R:
        guy.right();
        break;
      case P:
        guy.punch();
        break;
      case K:
        guy.kick();
        break;
    }
    
    return true;
  }
  
  boolean keyReleased(int keyCode) {
    if (keyCode >= controls.length) {
      return false;
    }
    
    int control = controls[keyCode];
    if (control == 0) {
      return false;
    }
    
    keyDown[control - 1] = false;
    return true;
  }
}
