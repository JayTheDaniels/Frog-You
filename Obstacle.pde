class Obstacle extends GameObject {
  //the parent class for the cars and logs. Oddly enough, the distinction is made in lane. This class is mostly just about drawing & moving them
  float speed;  //all you need is speed
  Obstacle(float x, float y, float w, float h, float s) {
    super(x, y, w, h);  //inherets the GameObject constructor
    speed = s;
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

  void show() {
    fill(200);
    rect(x, y, w, h);
    //setup if statements -> read in object type and size, give random image based on value
  }
}
