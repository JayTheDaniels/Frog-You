class Frog extends GameObject {
  //inheritence! Am I learning object-oriented programming? Sure, why not

  Obstacle attached = null;
  PImage[] animals;
  int imageNumber;

  Frog(float x, float y, float w, float h, int i) {
    super(x, y, w, h);
    //run setup on images
    animals = new PImage[9];
    animals[0] = loadImage("snake.png");
    animals[1] = loadImage("elephant.png");
    animals[2] = loadImage("giraffe.png");
    animals[3] = loadImage("hippo.png");
    animals[4] = loadImage("monkey.png");
    animals[5] = loadImage("panda.png");
    animals[6] = loadImage("parrot.png");
    animals[7] = loadImage("penguin.png");
    animals[8] = loadImage("pig.png");
    imageNumber = i;
  }

  void show() {  //draw frog
    image(animals[imageNumber], x, y, w, h);
  }

  void attach(Obstacle log) {
    attached = log;
  }

  void update() {  //moves frog when attached to car
    if (attached != null) {
      frog.x += attached.speed;
    }

    frog.x = constrain(x, 0, width-w);  //keeps the frog from going off the grid... except for up and down. Frog earned his freedom
    frog.y = constrain(y, 0, height-h);
  }

  void move(float xdir, float ydir) {
    //only need to modify it's left and top values to move whole frog. Multiply by grid
    x += xdir * grid;
    y += ydir * grid;
    frog.attach(null);  //detach frog on move, because frog has learned to let go
  }
}
