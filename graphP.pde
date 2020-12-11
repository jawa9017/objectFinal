// Graphing sketch

// This program takes ASCII-encoded strings from the serial port at 9600 baud
// and graphs them. It expects values in the range 0 to 1023, followed by a
// newline, or newline and carriage return

// created 20 Apr 2005
// updated 24 Nov 2015
// by Tom Igoe
// This example code is in the public domain.

import processing.serial.*;

PrintWriter output; //create the writer that stores the painted points

Serial myPort; // The serial port
int canvasWidth = 800;
int canvasHeight = 600;
int xPos = canvasWidth/2; // horizontal position of the graph
int yPos = canvasHeight/2;
float inByte = 0;
float xData = 516;
float yData = 532;
float buttonState = 1;
float brushSize = 50;
float upButton = 1;
float downButton = 1;
float red = 50;
float yellow = 0;
float blue = 0;
float redState = 1;
float yellowState = 1;
float blueState = 1;
float eraserState = 1;
boolean eraserFlag = false;
int eraseNum = 1;
boolean printFlag = false;
color paintColor = color(255, 0, 0);
color oldColor = color(255, 0, 0);

void setup () {
  // set the window size:
  size(800, 600);

  // List all the available serial ports
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my Mac is always my
  // Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  output = createWriter("painted.txt");

  // set initial background:
  background(255);
}

void draw () {
  clear();
  
  background(255);
  
  String[] paint = loadStrings("painted.txt");
  for(int i = 0; i < paint.length; i++) {
    if(paint[i].equals(".") == false) {
      String[] paintCoords = paint[i].split(",");
      noStroke();
      if(float(paintCoords[3]) > float(paintCoords[4]) && float(paintCoords[3]) > float(paintCoords[5])) {
        oldColor = color(255, 0, 0);
      } else if(float(paintCoords[4]) > float(paintCoords[3]) && float(paintCoords[4]) > float(paintCoords[5])) {
        oldColor = color(255, 255, 0);
      } else if(float(paintCoords[5]) > float(paintCoords[4]) && float(paintCoords[5]) > float(paintCoords[3])) {
        oldColor = color(0, 0, 255);
      }
      
      if(abs(float(paintCoords[3]) - float(paintCoords[4])) < 35 && abs(float(paintCoords[3]) - float(paintCoords[5])) < 35) {
        oldColor = color(150, 75, 0);
      } else if(abs(float(paintCoords[3]) - float(paintCoords[4])) < 35 && float(paintCoords[3]) > float(paintCoords[5]) && float(paintCoords[4]) > float(paintCoords[5])) {
        oldColor = color(255, 165, 0);
      } else if(abs(float(paintCoords[3]) - float(paintCoords[5])) < 35 && float(paintCoords[3]) > float(paintCoords[4]) && float(paintCoords[5]) > float(paintCoords[4])) {
        oldColor = color(148, 0, 211);
      } else if(abs(float(paintCoords[4]) - float(paintCoords[5])) < 35 && float(paintCoords[4]) > float(paintCoords[3]) && float(paintCoords[5]) >  float(paintCoords[3])) {
        oldColor = color(0, 255, 0);
      }
      
      if(float(paintCoords[6]) == 0) {
        oldColor = color(255, 255, 255);
      }
      fill(oldColor);
      circle(float(paintCoords[0]), float(paintCoords[1]), float(paintCoords[2]));
    }
  }
  
  if(eraserState == 0) {
    eraserFlag = !eraserFlag;
    delay(300);
  }
  
  if(upButton == 0) {
    brushSize += 3;
  } else if(downButton == 0) {
    brushSize -= 3;
  }
  
  if(redState == 0) {
    red += 5;  
  } else if(yellowState == 0) {
    yellow += 5;
  } else if(blueState == 0) {
    blue += 5;
  }
  
  if(red > yellow && red > blue) {
    paintColor = color(255, 0, 0);
    myPort.write('R');
  } else if(yellow > red && yellow >blue) {
    paintColor = color(255, 255, 0);
    myPort.write('Y');
  } else if(blue > yellow && blue > red) {
    paintColor = color(0, 0, 255);
    myPort.write('B');
  }
  
  if(abs(red - yellow) < 35 && abs(red - blue) < 35) {
    paintColor = color(150, 75, 0);
    myPort.write('T');
  } else if(abs(red - yellow) < 35 && red > blue && yellow > blue) {
    paintColor = color(255, 165, 0);
    myPort.write('O');
  } else if(abs(red - blue) < 35 && red > yellow && blue > yellow) {
    paintColor = color(148, 0, 211);
    myPort.write('P');
  } else if(abs(yellow - blue) < 35 && yellow > red && blue > red) {
    paintColor = color(0, 255, 0);
    myPort.write('G');
  }
  
  if(eraserFlag == true) {
    paintColor = color(255, 255, 255);
    myPort.write('W');
    eraseNum = 0;
  } else {
    eraseNum = 1;
  }
  
  if(xData < 500) {
    xPos -= (516 - xData) / 150;  
  } else if(xData > 560) {
    xPos += xData / 150;  
  }
  
  if(yData > 560) {
    yPos += yData / 150;
  } else if(yData < 495) {
    yPos -= (535 - yData) / 150; 
  }
  
  if(buttonState == 0) {
    output.println(xPos + "," + yPos + "," + brushSize + "," + red + "," + yellow + "," + blue + "," + eraseNum);
    output.flush();
    printFlag = true;
  }
  
  if(printFlag == true && buttonState == 1) {
    output.println(".");
    printFlag = false;
    output.flush();
  }
  
  // draw the line:
  noStroke();
  fill(paintColor);
  circle(xPos, yPos, brushSize);
  
    println("red is " + red);
    println("yellow is " + yellow);
    println("blue " + blue);
    println(abs(red - yellow));
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    //format: Xnumber,Ynumber/n
    //split inString at the comma
    String[] XYcoords = inString.split(","); // OR split(inString, ',')
    xData = float(XYcoords[0]);
    yData = float(XYcoords[1]);
    buttonState = float(XYcoords[2]);
    upButton = float(XYcoords[3]);
    downButton = float(XYcoords[4]);
    redState = float(XYcoords[5]);
    yellowState = float(XYcoords[6]);
    blueState = float(XYcoords[7]);
    eraserState = float(XYcoords[8]);
  }
}

void keyPressed() {
  output.close();
  output.flush();
  exit();
}
