
import processing.serial.*; // import the Processing serial library
Serial myPort;              // The serial port

int totalPins =12;
int pinValues[] = new int[totalPins];
int pinValuesPrev[] = new int[totalPins];

Frog frog;
Car[] cars;
Log[] logs;

float grid = 50;

void setup() {
  //setup serialization
  printArray(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');

  size(750, 500);
  frog = new Frog(width/2-grid/2, height-grid, grid, grid);
  cars = new Car[10]; 

  int index = 0;
  //setup Row 1
  for (int i = 0; i < 2; i++) {
    float x = i * 500; //space out the cars
    cars[index] = new Car(x, height - grid *2, grid *2, grid, 2);
    index++;
  }
  //setup Row 2
  for (int i = 0; i < 3; i++) {
    float x = i * 300;
    cars[index] = new Car(x, height - grid *3, grid, grid, 2.5);
    index++;
  }

  //setup Row 3
  for (int i = 0; i < 3; i++) {
    float x = i * 300;
    cars[index] = new Car(x, height - grid *4, grid, grid, -3); //negative speed allows opposite direction
    index++;
  }

  //setup Row 4
  for (int i = 0; i < 2; i++) {
    float x = i * 500;
    cars[index] = new Car(x, height - grid *5, grid*2, grid, -1.5);
    index++;
  }

  //setup log rows

  logs = new Log[7];

  //setup Row 5
  index = 0;
  for (int i = 0; i < 3; i++) {
    float x = i * 300;
    logs[index] = new Log(x, height - grid *7, grid*4, grid, 1.75);
    index++;
  }

  //setup Row 6
  for (int i = 0; i < 2; i++) {
    float x = i * 400;
    logs[index] = new Log(x, height - grid *8, grid*3, grid, -2.25);
    index++;
  }

  //setup Row 7
  for (int i = 0; i < 2; i++) {
    float x = i * 500;
    logs[index] = new Log(x, height - grid *9, grid*2, grid, 3);
    index++;
  }
}

void draw() {
  background(0);
  fill(#04C121, 75);
  rect(0, height-grid, width, grid);
  rect(0, height-grid*6, width, grid);
  rect(0, height-grid*10, width, grid);
  fill(#E9FF00);
  textSize(32);
  text("Dodge cars", 0, height-10);
  text("Ride logs", 0, height-grid*5-10);
  text("Win game", 0, height-grid*9-10);


  for (int i = 0; i < cars.length; i++) {
    cars[i].show();
    cars[i].update();
    if (frog.intersects(cars[i])) {
      resetGame();
      println("GAME OVER");
    }
  }


  for (int i = 0; i < logs.length; i++) {
    logs[i].show();
    logs[i].update();
  }

  if (frog.y < height - grid*6 && frog.y > 0) { //check if frog is in log zone, reset if not on log
    boolean onLog = false;
    for (Log log : logs) { //recheck the logs for intersection
      if (frog.intersects(log)) {
        onLog = true;
        frog.attach(log);
      }
    }
    if (!onLog) {
      resetGame();
    }
  } else {
    frog.attach(null); //keeps the frog from continuing to move on its own when not on a log
  }

  frog.update();
  frog.show();
}

void keyPressed() {
  //leaving in the keypress for testing and for playing the game normally

  if (keyCode == UP) {
    frog.move(0, -1);
  } else if (keyCode == DOWN) {
    frog.move(0, 1);
  } else if (keyCode == RIGHT) {
    frog.move(1, 0);
  } else if (keyCode == LEFT) {
    frog.move(-1, 0);
  }
}

void resetGame() {
  frog = new Frog(width/2-grid/2, height-grid, grid, grid);
  frog.attach(null);
}


void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    // println(myString);
    myString = trim(myString);

    //store the message as a string array
    String tempData[] = split(myString, ',');

    //uncomment to see what the data looks like in the string array
    //printArray(tempData);

    ///read the first 12 items of the array into the pinValues array and convert
    for (int i=0; i<totalPins; i++)
    {
      pinValues[i]=int(tempData[i]);
    }

    //convert the last 2 items in the String array to floats
    //pitch = float(tempData[totalPins]);
    //roll = float(tempData[totalPins+1]);
  }
}
