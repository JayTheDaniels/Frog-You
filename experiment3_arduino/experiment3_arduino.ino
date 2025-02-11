#include <Wire.h>
#include "Adafruit_MPR121.h"
#include "SparkFunLSM6DS3.h"


//////////////////////////capacitive input
#ifndef _BV
#define _BV(bit) (1 << (bit))
#endif

Adafruit_MPR121 cap = Adafruit_MPR121();

// Keeps track of the last pins touched
uint16_t currtouched = 0;

int tp = 4; //change this if you aren't using them all, start at pin 0
//////////////////////////capacitive input


void setup() {
  Serial.begin(9600);

  if (!cap.begin(0x5A)) {
    Serial.println("MPR121 not found, check wiring?");
    while (1);
  }
  Serial.println("MPR121 found!");

  //Call .begin() to configure the IMU (Inertial Measurement Unit)
  nano33IMU.begin();
}

void loop() {
  //run the function to check the cap interface
  checkAllPins(tp);
  //make a new line to separate the message
  Serial.println();
  // put a delay so it isn't overwhelming
  delay(100);
}

void checkAllPins(int totalPins)
{
  // Get the currently touched pads
  currtouched = cap.touched();

  for (uint8_t i = 0; i < totalPins; i++)
  {
    // it if *is* touched set 1 if no set 0
    if ((currtouched & _BV(i)))
    {
      Serial.print(1);
    }
    else
    {
      Serial.print(0);
    }

    Serial.print(",");

  }
}
