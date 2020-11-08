/*
 Frog You by Jay
 Creation & Computation DIGF 6037
 OCAD University
 November 6, 2020
 
 Based on Coding Challenge #72: Frogger by The Coding Train
 https://www.youtube.com/watch?v=giXV6xErw0Y&list=PLRqwX-V7Uu6aRpfixWba8ZF6tJnZy5Mfw&index=11
 
 Also based on example code by Kate Hartman & Nick Puckett
 
 Images are courtesy of Kenney Game Assets Pack 1, available at itch.io, used under public domain license
 https://kenney.itch.io/kenney-game-assets-1
 */

import processing.serial.*;  //import processing serial library
Serial myPort;    //serial port

int totalPins =4;
int pinValues[] = new int[totalPins];
int pinValuesPrev[] = new int[totalPins];

//generates game objects
Frog frog;
Lane[] lanes;

//quick type distinction between lanes
int safe = 0;
int car = 1; 
int boat = 2;

//for score system
int score = 0;
int level = 0;

float grid = 50; //size of snapping grid. Increasing size reduces lanes


void setup() {
  printArray(Serial.list()); //list the available serial ports
  String portName = Serial.list()[0]; // <--- change the 0 to whatever port you're using
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); //for separating the incoming data, since it comes in new lines

  size(800, 600);
  resetGame(); //resetGame also works for initializing the frog
  int totalLanes = int(height/grid); //changing the height now adds more lines
  lanes = new Lane[totalLanes];
  newLevel();
}

void draw() {
  background(0);
  //draw lanes
  for (int i = 0; i <lanes.length; i++) {  //carries the game. Draws lane spaces and obstacles for the lane
    lanes[i].showLanes();
  }
  //check frog position/collision
  int laneIndex = int(frog.y/grid);  //document frog's position for checking collision and conformity.
  lanes[laneIndex].check(frog);  //Lane check for determining collision and level advancement
  frogHardwareMove(); //only needed if using hardware
  frog.update();
  frog.show();
  drawInterface();
}

void keyPressed() {
  //leaving in the keypress for testing and sharing
  if (keyCode == UP) {
    frog.move(0, -1);
    score++;
  } else if (keyCode == DOWN) {
    frog.move(0, 1);
  } else if (keyCode == RIGHT) {
    frog.move(1, 0);
  } else if (keyCode == LEFT) {
    frog.move(-1, 0);
  } else if (key == BACKSPACE) {
    newLevel();
  }
}

void frogHardwareMove() {
  //how the game was intended to be played!!
  if ((pinValues[2]==1)&&(pinValuesPrev[2]==0)) {  //up
    frog.move(0, -1);
    score++;
  } else if ((pinValues[0]==1)&&(pinValuesPrev[0]==0)) {  //down
    frog.move(0, 1);
  } else if ((pinValues[1]==1)&&(pinValuesPrev[1]==0)) {  //right
    frog.move(-1, 0);
  } else if ((pinValues[3]==1)&&(pinValuesPrev[3]==0)) {  //left
    frog.move(1, 0);
  }
  for (int i = 0; i<pinValues.length; i++)
  {
    pinValuesPrev[i] = pinValues[i];  //stores the code so can't hold input to move
  }
}
void resetGame() {
  int rand = int(random(0, 9)); //generate a random number between 1 & 9
  frog = new Frog(width/2-grid/2, height-grid*2, grid, grid, rand);  //generate new frog on reset. Also works on load
  frog.attach(null);  //reset frog attach just in case
}


void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    // println(myString);
    myString = trim(myString);

    //store the message as a string array
    String tempData[] = split(myString, ',');

    for (int i=0; i<totalPins; i++)
    {
      pinValues[i]=int(tempData[i]);
    }
  }
  printArray(pinValues);
}

void drawInterface() {
  //draw text
  fill(#E9FF00);
  textSize(grid/2); //scale text based on size of game
  text("Frog you", width/2, height-grid/2+10);  //draws text on the safe zones. Offset by 10 helps center
  text("Car dodge", 0, height-grid-10);
  text("Boat ride", 0, height-grid*6-10);
  text("Game win", 0, height-grid*10-10);
  text((level+1)+" Level", 10, height-grid*11-10);
  text(score+ " Score", width-grid*2-10, height-grid*11-10);
}

void newLevel() {
  //Level 1 is hardcoded for design purposes. Every subsequent level generates its values randomly
  if (level == 0) {
    lanes[0] = new Lane(0, color(0), 0); //safe lanes have their own constructor since they don't need much
    lanes[1] = new Lane(1, color(#04C121), 0);  //win lane
    lanes[2] = new Lane(2, color(#50FFF2), boat, 2, 2, 200, 2.5);  //few small average speed log
    lanes[3] = new Lane(3, color(#50FFF2), boat, 3, 2, 400, -3);  //many small fast log
    lanes[4] = new Lane(4, color(#50FFF2), boat, 3, 3, 300, 2);  //many big slow log
    lanes[5] = new Lane(5, color(#04C121), 0);
    lanes[6] = new Lane(6, color(0), car, 3, 3, 250, -2.25);  //car going left -> drop difficulty but still harder that beginning; more trucks, slightly faster, less spaced out
    lanes[7] = new Lane(7, color(0), car, 4, 2, 400, -3);  //cars going left -> more space, much faster
    lanes[8] = new Lane(8, color(0), car, 3, 2, 300, 2.5);  //car going right -> slightly faster, less space
    lanes[9] = new Lane(9, color(0), car, 2, 3, 350, 2); //cars going right -> ease in, few trucks, average speed
    lanes[10] = new Lane(10, color(#04C121), 0);  //start lane
    lanes[11] = new Lane(11, color(0), 0);
  }
  if (level>0) {
    //randomly generate new level
    resetGame();
    //safe lanes are guaranteed at the same point, but the other lands will be completely random!
    lanes[0] = new Lane(0, color(0), 0); //safe lanes have their own constructor since they don't need much
    lanes[1] = new Lane(1, color(#04C121), 0);  //win lane
    for (int i = 2; i < 5; i++) {
      int randNumb = int(random(2, 4));
      int randSize = int(random(2, 3));  //larger cars need to be spaced manually, so only generate either size 2 or 3
      float randSpace = random(1, 4)*100; //spacing is a float
      float randSpeed = random(2, 4); //fast vs slow, multiplied with direction for variety
      int randDir = int(random(-2, 2));  //can only output 1 or -1, multiply with speed for direction
      println(randDir);
      if (randDir==0) {
        randDir = -1;
      }

      lanes[i] = new Lane(i, color(#50FFF2), boat, randNumb, randSize, randSpace, randSpeed*randDir);  //random lanes for infinite replayability!
    }
    lanes[5] = new Lane(5, color(#04C121), 0);  //guaranteed safe lane
    for (int i = 6; i < 10; i++) {
      int randNumb = int(random(2, 4));
      int randSize = int(random(2, 3));
      float randSpace = random(1, 4)*100; //spacing is a float
      float randSpeed = random(2, 4); //fast vs slow, multiplied with direction for variety
      int randDir = int(random(-2, 2));
      if (randDir==0) {
        randDir = 1;
      }
      lanes[i] = new Lane(i, color(0), car, randNumb, randSize, randSpace, randSpeed*randDir);  //random lanes for infinite replayability!
    }
    lanes[10] = new Lane(10, color(#04C121), 0);  //start lane
    lanes[11] = new Lane(11, color(0), 0);
  }
}
