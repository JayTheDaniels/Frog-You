class Car extends Rectangle {
  float speed;
  Car(float x, float y, float w, float h, float s) {
    super(x, y, w, h); //inherits the Rectangle's constructor
    speed = s;
  }

  void update() {
    x = x + speed; //keeps car moving towards the edge of the screen

    if (speed > 0 && x > width+grid) {
      x = -w; //reset car to start
    } else if (speed < 0 && x < -w-grid)
    {
      x = width + grid;
    }
    
  }

  void show() {
    fill(200);
    rect(x, y, w, h);
  }
}
