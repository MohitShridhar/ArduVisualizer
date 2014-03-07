/*

Built and Tested on Processing.

Title: Live Graphing + Dynamic Data Storage

This program reads serial data from two arduino's simultaneously.
It extracts Position & Time data from the first arduino; Force 1 and 
Force 2 data from the second arduino. The GWOptics graphing library is used
to plot the force measurements in real time. The data is also instantaneously
flushed to a text file for future analysis. 


Year 1 Students: Dipti Motwani, Fardin Ashfaque, Mohit Shridhar
EDIC Staff: Dr. Jian Huei Choo
06/08/13

*/

// Standard serial communication library

import processing.serial.*;

/* Graphing Library by GWOptics - Used for gravitational waves research: 
http://www.gwoptics.org/processing/gwoptics_p5lib/
*/


import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;
import org.gwoptics.graphics.*;
import org.gwoptics.graphics.graph2D.backgrounds.GridBackground;

// Save and quit the application after certain amount of time:
int timeOut = 4*60*60*1000; //Change timer duration in SECONDS // 60*60*1000

//Serial port identification:
Serial myPort1;
Serial myPort2;


PrintWriter output;
float xPos = 1; // Position Sensor
float xPos2 = 1; // Force 1
float xPos3 = 1; // Force 2
//float newTime;
float timeX = 0; // Clock

float inByte1;
float inByte2;
float inByte3;
float inByte4;
int initialTime;


// Graphing Library Requirements

class eq implements ILine2DEquation{
	public double computePoint(double x, int pos) {
             return xPos2;
	}		
}

class eq2 implements ILine2DEquation{
        public double computePoint(double x, int pos) {
             return xPos3; 
        }

}


RollingLine2DTrace r, r2;
Graph2D g;

	
void setup(){ 
  
        // Save to txt file:
        output = createWriter("3_Sensor_Readings_" + day() +"-" + month() + "_" + hour() + "-" + minute() + "-" + second() + ".txt");       
        
	size(800,600);

        // Added:
        println(Serial.list());
        myPort1 = new Serial(this, Serial.list()[4], 9600); //Use 38400
        myPort1.bufferUntil('\n');  
        myPort2 = new Serial(this, Serial.list()[6], 9600);
        myPort2.bufferUntil('\n');
      
	
	r  = new RollingLine2DTrace(new eq() , 1, 0.001f); // original: 0.01f changed: 1, 0.001f
	r.setTraceColour(255, 0, 0);

        r2 = new RollingLine2DTrace(new eq2(), 1, 0.001f);
        r2.setTraceColour(0, 255, 0);
		 
        
        //Graph Display Settings

	g = new Graph2D(this, 650, 500, false);
        g.setAxisColour(255, 255, 255); // White
        g.setFontColour(255, 255, 255); // White
	g.addTrace(r);
        g.addTrace(r2);
	g.position.y = 50;
	g.position.x = 100;
	g.setYAxisTickSpacing(100); 
        g.setXAxisTickSpacing(1);
        
        // Added:
        g.setXAxisLabel("Time (sec)");
        g.setYAxisLabel("Force (5V Range)");

        g.setYAxisMax(1023);
	g.setXAxisMax(5f);
        
}

void draw(){
        
	background(0);
	g.draw();
        
       // textFont(mono);
        fill(255);
        textSize(26);
        text("Toothbrush Tribology", 300, 40);
                
        //Flushing output to text file        
                
        output.println(timeX + "  " + xPos + "  " + xPos2 + "  " + xPos3);
        output.flush();
        
        //Timeout timer - Check
        
        if (millis() - initialTime >= timeOut*1000) {
             output.close();
             exit();   
        }     
}


void serialEvent (Serial mySerialPort) {
  if (mySerialPort == myPort1) { // First arduino
    String inString =  myPort1.readStringUntil('\n');
    if (inString != null) {
      inString = trim(inString);
      
     int[] data1 = int(split(inString, ","));
      if (data1.length >=2) {
        inByte1 = data1[1]; //map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
        timeX = data1[0] / 1000.0; //map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor

    //Calibrate Position Data from arduino1:
    
      xPos = inByte1;
     
      }
    
    }
  }
  
  else if (mySerialPort == myPort2) { // Second Arduino
    String inString2 =  myPort2.readStringUntil('\n');
    if (inString2 != null) {
      inString2 = trim(inString2);
      
     int[] data2 = int(split(inString2, ","));
      if (data2.length >=2) {
        inByte3 = data2[0]; //map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
        inByte4 = data2[1]; //map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor

    //Calibrate Force Sensor from arduino2:
    
      xPos2 = inByte3; // Red Graph
      xPos3 = inByte4; // Green Graph
     
      }
    
    }
  }
}

// Save and quit command if button 's' is pressed

void keyPressed() {
  if (key == 's') {
    output.flush();
    output.close();
    exit();
  }
}

