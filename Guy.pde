class Guy {
  static final int STANCE = 0, PUNCH = 1, KICK = 2, TURN = 3,
                   DEATH_HI_FRONT = 4, DEATH_LO_FRONT = 4,
                   DEATH_HI_BEHIND = 4, DEATH_LO_BEHIND = 4;
  
  float x, y;
  int frame;
  int animation;
  int nextAnimation;
  int direction;
  float counter;
  float animationSpeed = 1f;
  int points;
  
  Guy(float x, float y) {
    this.x = x;
    this.y = y;
    direction = 1;
    points = 0;
    nextAnimation = 0;
    setAnimation(STANCE);
  }
  
  boolean draw() {
    counter += animationSpeed;
    PImage image = guySprites.getImage(frame, animation, counter);
    if (image == null) {
      frame++;
      counter = 0;
      image = guySprites.getImage(frame, animation, counter);
      
      if (image == null) {
        if (animation >= DEATH_HI_FRONT) {
          setAnimation(STANCE);
          return true;
        }
        
        setAnimation(nextAnimation);
        image = guySprites.getImage(frame, animation, counter);
      }
    }
    
    pushMatrix(); // Save the transformation matrix
    translate(x, y); // Move to the guy's position
    scale(direction, 1); // Ensure we draw the graphics the right way around by flipping the horizontal scale
    image(image, 0, 0);
    scale(direction, 1); // Ensure we draw the text the right way around by flipping if previously flipped
    text(points, 0, -HEIGHT / 3);
    popMatrix(); // Restore the transformation matrix
    
    return false;
  }

  void setAnimation(int animation) {
    if (animation == TURN) {
      direction = -direction;
    }
    
    nextAnimation = STANCE;
    this.animation = animation;
    frame = 0;
  }
  
  void punch() {
    if (animation != 0) {
      nextAnimation = PUNCH;
      return;
    }
    
    setAnimation(PUNCH);
  }
  
  void kick() {
    if (animation != 0) {
      nextAnimation = KICK;
      return;
    }
    
    setAnimation(KICK);
  }
  
  void turn() {
    if (animation != 0) {
      nextAnimation = TURN;
      return;
    }
    
    setAnimation(TURN);
  }
  
  void right() {
    if (direction < 0) {
      turn();
    }
  }
  
  void left() {
    if (direction > 0) {
      turn();
    }
  }
  
  boolean collide(Ball b) {
    if (animation >= DEATH_HI_FRONT) {
      return true;
    }
    
    if (b.direction == direction) {
      if (b.y > y) {
        setAnimation(DEATH_LO_BEHIND);
      } else {
        setAnimation(DEATH_HI_BEHIND);
      }
      
      return true;
      
    } else if (b.y > y && animation != KICK) {
      setAnimation(DEATH_LO_FRONT);
      return true;
      
    } else if (b.y < y && animation != PUNCH) {
      setAnimation(DEATH_HI_FRONT);
      return true;
    }

    points++;    
    return false;
  }
}

