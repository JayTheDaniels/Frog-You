class Lane extends GameObject {


  Obstacle[] obstacles;
  int col;
  int type; //tells game if obstacles in lane are cars or logs
  float laneNumb;

  //this constructor is for safe lanes. Not much happens here 
  Lane(int index, color c) {
    super(0, index*grid, width, grid); 
    obstacles = new Obstacle[0];
    col = c;
    laneNumb = index;
  }

  //this slightly more chaotic constructor is for danger lanes
  Lane(float index, int t, int n, int size, float spacing, float speed) {
    super(0, index*grid, width, grid);
    obstacles = new Obstacle[n];
    type = t;  //the obstacle type is read in and then used in the check function below
    float offset = random(0, 200);  //adds a bit of variety, which is the spice of life
    for (int i = 0; i< n; i++) {
      obstacles[i] = new Obstacle(offset + spacing * i, index*grid, grid*size, grid, speed);
    }
    col = color(0);  //in case you feel like colouring danger lanes too
    laneNumb = index;
  }

  void check(Frog frog) {  //checks 
    if (laneNumb == 1)  //checks if frog is in winning lane
    {
      level++;
      println("levelup! Now on level: "+level);
      newLevel();
    }
    if (type == car) {
      for (int i = 0; i<obstacles.length; i++) {  //checks logs for collision
        if (frog.intersects(obstacles[i])) {
          score = 0;
          resetGame();
        }
      }
    } else if (type == log) {
      boolean onLog = false;
      for (int i = 0; i<obstacles.length; i++) { //check cars for collision
        if (frog.intersects(obstacles[i])) {
          onLog = true;
          frog.attach(obstacles[i]);
        }
      }
      if (!onLog) {
        score = 0;
        resetGame();
      }
    } else {
      frog.attach(null); //keep frog from continuing to move on its own when not on car, you sneaky toad
    }
  }

  void showLanes() {  //draws the lanes AND has each of the obstacles drawn: THE SPACE SAVER
    fill(col);
    rect(x, y, w, h);
    for (int i = 0; i<obstacles.length; i++) {
      obstacles[i].show();
      obstacles[i].update();
    }
  }
}
