/*
Measuring the force from a force sensor.
Record Data - TXT File

Mohit Shridhar
13/06/13

*/


import processing.serial.*;


int timeOut = 120; //Change timer duration in SECONDS // 60*60*1000

Serial myPort;
PrintWriter output;

float xPos = 1; // Intial position of pointer
float xPos2 = 1;
float xPos3 = 1;
//float newTime;
float timeX = 0;

int inByte1;
int inByte2;
int inByte3;
int initialTime;
	
void setup(){ 
  
        size(200, 140);
        initialTime = millis();
        // Save to txt file:
        output = createWriter("3_Sensor_Readings_" + day() +"-" + month() + "_" + hour() + "-" + minute() + "-" + second() + ".txt");      

        // Added:
        println(Serial.list());
        myPort = new Serial(this, Serial.list()[4], 9600); //Use 38400
        myPort.bufferUntil('\n');  
        
}

void draw(){
  
        background(0);


        
       // textFont(mono);
        fill(255);
        textSize(26);
        text("Data Recording", 5, 40);
        
        fill(255);
        textSize(16);
        text("Press 's': Save & Exit", 20, 70);
        
        fill(255);
        textSize(16);
        text("Time-out " + timeOut + " sec", 30, 100);

                
        output.println(timeX + "  " + xPos + "  " + xPos2 + "  " + xPos3);
        output.flush();
        
        if (millis() - initialTime >= timeOut*1000) {
             output.close();
             exit();   
        }       
}


void serialEvent (Serial myPort) {
  String inString =  myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    
    int[] data = int(split(inString, ","));
    if (data.length >=4) {
      inByte1 = data[0]; //map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
      inByte2 = data[1]; //map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor
      inByte3 = data[2];

    //Calibrate:
    
    xPos = inByte1;
    xPos2 = inByte2;
    xPos3 = inByte3;
    
    timeX = data[3] / 1000.0; // Stamp time - from arduino
   
    }
    
  }
}

void keyPressed() {
  if (key == 's') {
    output.flush();
    output.close();
    exit();
  }
}
