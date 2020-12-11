/*
  Graph

  A simple example of communication from the Arduino board to the computer: The
  value of analog input 0 is sent out the serial port. We call this "serial"
  communication because the connection appears to both the Arduino and the
  computer as a serial port, even though it may actually use a USB cable. Bytes
  are sent one after another (serially) from the Arduino to the computer.

  You can use the Arduino Serial Monitor to view the sent data, or it can be
  read by Processing, PD, Max/MSP, or any other program capable of reading data
  from a serial port. The Processing code below graphs the data received so you
  can see the value of the analog input changing over time.

  The circuit:
  - any analog input sensor attached to analog in pin 0

  created 2006
  by David A. Mellis
  modified 9 Apr 2012
  by Tom Igoe and Scott Fitzgerald

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/Graph
*/

//define the pins for the joystick
#define X_AXIS A0
#define Y_AXIS A1
#define BUTTON 7

//define pins for RGB LED
#define REDL 9
#define GREENL 10
#define BLUEL 11

//define pin for photoresistor
#define REDP A2
#define YELLOWP A3
#define BLUEP A4

//set up buttons
#define BUTUP 12
#define BUTDOWN 8
#define ERASER 5

//initialize the button state to 1 so it doesn't automatically activate
int buttonState = 1;
int upState = 1;
int downState = 1;
int redState = 1;
int yellowState = 1;
int blueState = 1;
int eraserState = 1;
int lightR;
int lightY;
int lightB;

char val;

void setup() {
  // initialize the serial communication:
  pinMode(BUTTON, INPUT_PULLUP); //initialize the button pin, as it requires that
  pinMode(BUTUP, INPUT_PULLUP);
  pinMode(BUTDOWN, INPUT_PULLUP);
  pinMode(ERASER, INPUT_PULLUP);
  pinMode(REDL, OUTPUT);
  pinMode(GREENL, OUTPUT);
  pinMode(BLUEL, OUTPUT);
  Serial.begin(9600); //start the serial monitor
}

void loop() {
  // send the value of analog input 0:
  //format: number,number,number/n
  
  buttonState = digitalRead(BUTTON); //set buttonState to actual button state
  eraserState = digitalRead(ERASER);
  lightR = analogRead(REDP);
  lightY = analogRead(YELLOWP);
  lightB = analogRead(BLUEP);

  if(lightR > 350) {
    redState = 0;
  } else {
    redState = 1;
  }
  if(lightY > 350) {
    yellowState = 0;
  } else {
    yellowState = 1;
  }
  if(lightB > 350) {
    blueState = 0;
  } else {
    blueState = 1;
  }
  Serial.print(analogRead(X_AXIS));
  Serial.print(',');
  Serial.print(analogRead(Y_AXIS));
  Serial.print(',');
  Serial.print(buttonState);
  Serial.print(',');
  Serial.print(digitalRead(BUTUP));
  Serial.print(',');
  Serial.print(digitalRead(BUTDOWN));
  Serial.print(',');
  Serial.print(redState);
  Serial.print(',');
  Serial.print(yellowState);
  Serial.print(',');
  Serial.print(blueState);
  Serial.print(',');
  Serial.println(eraserState);

  while(Serial.available()) {
    val = Serial.read();
  }

  if(val == 'R') {
    analogWrite(9, 128);
    analogWrite(10, 0);
    analogWrite(11, 0);
  }

  else if(val == 'Y') {
    analogWrite(9, 128);
    analogWrite(10, 128);
    analogWrite(11, 0);
  }

  else if(val == 'B') {
    analogWrite(9, 0);
    analogWrite(10, 0);
    analogWrite(11, 128);
  }

  else if(val == 'T') {
    analogWrite(9, 128);
    analogWrite(10, 83);
    analogWrite(11, 0);
  }

  else if(val == 'O') {
    analogWrite(9, 128);
    analogWrite(10, 83);
    analogWrite(11, 0);
  }

  else if(val == 'P') {
    analogWrite(9, 74);
    analogWrite(10, 0);
    analogWrite(11, 106);
  }

  else if(val == 'G') {
    analogWrite(9, 0);
    analogWrite(10, 128);
    analogWrite(11, 0);
  }

  else if(val == 'W') {
    analogWrite(9, 128);
    analogWrite(10, 128);
    analogWrite(11, 128);
  }

  else {
    analogWrite(9, 0);
    analogWrite(10, 0);
    analogWrite(11, 0);
  }
  
  // wait a bit for the analog-to-digital converter to stabilize after the last
  // reading:
  delay(50);
}
