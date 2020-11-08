class Obstacle extends GameObject {
  float speed;
  PImage carLeft;
  PImage carRight;
  PImage boatLeft;
  PImage boatRight;
  int imageNumber;
  int laneType;
  Obstacle(float x, float y, float w, float h, float s) {
    super(x, y, w, h);  //inherets the GameObject constructor
    speed = s;
    //creating separate left/right images proved easier than flipping. Optimize someday
    carLeft = loadImage("car_left.png");
    carRight = loadImage("car_right.png");
    boatLeft = loadImage("boat_left.png");
    boatRight = loadImage("boat_right.png");
  }

  void update() {
    x = x + speed; //keeps obstacle moving towards the right edge of the screen
    if (speed > 0 && x > width+grid) {
      x = -w; //reset to start
    } else if (speed < 0 && x < -w-grid) //keeps obstacle moving towards the left edge of the screen
    {
      x = width + grid;
    }
  }

  void show(int type) {
    laneType = type;
    if (laneType == car) {
      if (speed > 0) {
        image(carRight, x, y, w, h);
      } else if (speed < 0) {
        image(carLeft, x, y, w, h);
      }
    } else if (laneType == boat) {
      if (speed > 0) {
        image(boatRight, x, y, w, h);
      } else if (speed < 0) {
        image(boatLeft, x, y, w, h);
      }
    }
  }
}
