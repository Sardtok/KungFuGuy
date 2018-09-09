import java.util.Random;

final int[][][] controls = {
  {{'A', LEFT},
   {'D', RIGHT},
   {'R', 'G', 'O', 'L'},
   {'F', 'T', 'K', 'P'}}, 
  {{LEFT},
   {RIGHT},
   {'O', 'L'},
   {'K', 'P'}},
  {{'A'},
   {'D'},
   {'R', 'G'},
   {'F', 'T'}}};
final int TITLE_SCREEN = 0, PLAYING = 1, GAME_OVER = 2;
final int L = 1, R = 2, K = 3, P = 4;
final float WIDTH = 960f, HEIGHT = 200f;
float offset;
float scale;
Game[] games;
final int BALLS = 3;

int buttonFrame = 0;
float buttonTime = 0;
int state = TITLE_SCREEN;
SpriteSheet guySprites;
SpriteSheet buttonSprites;

void setup() {
  fullScreen(P2D);
  textFont(loadFont("SevenMonkeyFuryBB-72.vlw"));
  textAlign(CENTER);
  textSize(36);
  imageMode(CENTER);
  ellipseMode(CENTER);
  fill(0, 0, 255);
  noStroke();
  noCursor();

  scale = width / WIDTH;

  guySprites = new SpriteSheet();
  guySprites.addImage(loadImage("Stance.png"));
  guySprites.addImage(loadImage("Punch1.png"));
  guySprites.addImage(loadImage("Punch2.png"));
  guySprites.addImage(loadImage("Kick1.png"));
  guySprites.addImage(loadImage("Kick2.png"));
  guySprites.addImage(loadImage("Kick3.png"));
  guySprites.addImage(loadImage("Turn1.png"));
  guySprites.addImage(loadImage("Turn2.png"));
  guySprites.addImage(loadImage("Turn3.png"));
  guySprites.addImage(loadImage("Turn4.png"));
  guySprites.addImage(loadImage("Punch3.png"));
  guySprites.addImage(loadImage("Punch4.png"));
  guySprites.addImage(loadImage("FallBack1.png"));
  guySprites.addImage(loadImage("FallBack2.png"));
  guySprites.addImage(loadImage("FallBack3.png"));
  guySprites.addImage(loadImage("FallBack4.png"));
  guySprites.addAnimation(new int[]{0, 1000});
  guySprites.addAnimation(new int[]{1, 2, 2, 8, 10, 2, 11, 8});
  guySprites.addAnimation(new int[]{3, 5, 4, 10, 5, 5});
  guySprites.addAnimation(new int[]{6, 5, 7, 5, 8, 5, 9, 5});
  guySprites.addAnimation(new int[]{12, 3, 13, 5, 14, 5, 15, 50});
  
  buttonSprites = new SpriteSheet();
  buttonSprites.addImage(loadImage("button-blue0.png"));
  buttonSprites.addImage(loadImage("button-blue1.png"));
  buttonSprites.addImage(loadImage("button-blue2.png"));
  buttonSprites.addImage(loadImage("button-blue3.png"));
  buttonSprites.addImage(loadImage("button-blue4.png"));
  buttonSprites.addImage(loadImage("button-red0.png"));
  buttonSprites.addImage(loadImage("button-red1.png"));
  buttonSprites.addImage(loadImage("button-red2.png"));
  buttonSprites.addImage(loadImage("button-red3.png"));
  buttonSprites.addImage(loadImage("button-red4.png"));
  buttonSprites.addImage(loadImage("button-green0.png"));
  buttonSprites.addImage(loadImage("button-green1.png"));
  buttonSprites.addImage(loadImage("button-green2.png"));
  buttonSprites.addImage(loadImage("button-green3.png"));
  buttonSprites.addImage(loadImage("button-green4.png"));
  buttonSprites.addImage(loadImage("button-yellow0.png"));
  buttonSprites.addImage(loadImage("button-yellow1.png"));
  buttonSprites.addImage(loadImage("button-yellow2.png"));
  buttonSprites.addImage(loadImage("button-yellow3.png"));
  buttonSprites.addImage(loadImage("button-yellow4.png"));
  buttonSprites.addAnimation(new int[]{0, 20, 1, 3, 2, 3, 3, 3, 4, 20, 3, 3, 2, 3, 1, 3});
  buttonSprites.addAnimation(new int[]{5, 20, 6, 3, 7, 3, 8, 3, 9, 20, 8, 3, 7, 3, 6, 3});
  buttonSprites.addAnimation(new int[]{10, 20, 11, 3, 12, 3, 13, 3, 14, 20, 13, 3, 12, 3, 11, 3});
  buttonSprites.addAnimation(new int[]{15, 20, 16, 3, 17, 3, 18, 3, 19, 20, 18, 3, 17, 3, 16, 3});

  surface.setTitle("Kung Fu Guy vs. the Blue Balls");
}

void initGame(int players) {
  offset = (displayHeight - (players * HEIGHT * scale)) / ((players + 1) * scale);

  int seed = (int) random(MIN_INT, MAX_INT);
  games = new Game[players];
  for (int i = 0; i < players; i++) {
    games[i] = new Game(controls[i + players - 1], seed);
  }

  state = PLAYING;
}

void draw() {
  background(0);
  scale(scale, scale);

  boolean gameOver = true;
  switch (state) {
  case TITLE_SCREEN:
    drawTitle();
    break;
  case GAME_OVER:
    drawGameOver();
  case PLAYING:
    pushMatrix();
    translate(0, offset);
    for (Game g : games) {
      g.draw();
      gameOver = gameOver && g.state == GAME_OVER;
      translate(0, HEIGHT + offset);
    }  
    state = gameOver ? GAME_OVER : state;
    popMatrix();
  }
}

void drawTitle() {
  background(255);
  text("Kung Fu Guy vs. the Blue Balls - Beta 3", WIDTH / 2, height / (scale * 3));
  
  if (buttonSprites.getImage(buttonFrame, 0, buttonTime) == null) {
    buttonFrame++;
    buttonTime = 0;
    if (buttonSprites.getImage(buttonFrame, 0, buttonTime) == null) {
      buttonFrame = 0;
    } 
  }
  
  for (int i = 0; i < 4; i++) {
    PImage buttonImage = buttonSprites.getImage(buttonFrame, i, buttonTime);
    image(buttonImage, (int)(WIDTH / 6 + ((i % 2) * 64)), (int)(height / (scale * 7) * (4 + (i / 2))),64,64);
  }
  buttonTime++;
  
  textAlign(LEFT);
  text("1 Player game / High punch", WIDTH / 6 + 128, height / (scale * 7) * 4 + 12);
  text("2 Player game / Low kick", WIDTH / 6 + 128, height / (scale * 7) * 5 + 12);
  textAlign(CENTER);
}

void drawGameOver() {
  fill(255);
  text("Feedback to sigmunha@ifi.uio.no", WIDTH / 2, offset / 2);
  translate(0, (int)(offset + HEIGHT));
  
  if (buttonSprites.getImage(buttonFrame, 0, buttonTime) == null) {
    buttonFrame++;
    buttonTime = 0;
    if (buttonSprites.getImage(buttonFrame, 0, buttonTime) == null) {
      buttonFrame = 0;
    } 
  }
  
  for (int i = 0; i < 4; i++) {
    PImage buttonImage = buttonSprites.getImage(buttonFrame, i, buttonTime);
    image(buttonImage, (int)(WIDTH / 7 * (i / 2 * 2 + 2) + ((i % 2) * 64)), 32,64,64);
  }
  buttonTime++;
  
  textSize(36);
  textAlign(LEFT);
  text("Retry", WIDTH / 7 * 2 + 96, 44);
  text("Quit", WIDTH / 7 * 4 + 96, 44);
  textAlign(CENTER);
  
  translate(0, -offset - HEIGHT);
}

int getControlIndex(int keyCode) {
  for (int i = 0; i < controls[0].length; i++) {
    for (int j = 0; j < controls[0][i].length; j++) {
      if (controls[0][i][j] == keyCode) {
        return i;
      }
    }
  }
  
  return -1;
}

void keyPressed() {
  switch(state) {
  case TITLE_SCREEN:
    switch (getControlIndex(keyCode)) {
    case 2: initGame(2); break;
    case 3: initGame(1); break;
    }
    break;
  case GAME_OVER:
    switch (getControlIndex(keyCode)) {
    case 2:
      print(games[0].guy.points);
      for (int i = 1; i < games.length; i++) {
        print(" ");
        print(games[i].guy.points);
      }
      println();
      exit();
    case 3: state = TITLE_SCREEN; break;
    }
    
  case PLAYING:
    for (Game g : games) {
      if (g.keyPressed(keyCode)) {
        return;
      }
    }
  }
}

void keyReleased() {
  if (state != PLAYING) {
    return;
  }
  for (Game g : games) {
    if (g.keyReleased(keyCode)) {
      return;
    }
  }
}
