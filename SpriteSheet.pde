class SpriteSheet {
  PImage[] images = new PImage[10];
  int[][] animations = new int[10][];
  int imageCount;
  int animationCount;
  
  void addImage(PImage img) {
    if (imageCount == images.length) {
      PImage[] newImages = new PImage[images.length * 2];
      for (int i = 0; i < imageCount; i++) {
        newImages[i] = images[i];
      }
      images = newImages;
    }
    images[imageCount++] = img;
  }
  
  void addAnimation(int[] animation) {
    if (animationCount == animations.length) {
      int[][] newAnimations = new int[animations.length * 2][];
      for (int i = 0; i < animationCount; i++) {
        newAnimations[i] = animations[i];
      }
      animations = newAnimations;
    }
    animations[animationCount++] = animation;
  }
  
  PImage getImage(int frame, int animation, float time) {
    if (animation >= animationCount
        || frame >= animations[animation].length / 2
        || time > animations[animation][frame * 2 + 1]) {
      return null;
    }
    
    return images[animations[animation][frame * 2]];
  }
  
}
