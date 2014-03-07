/*
Measuring the force from a force sensor.
Need to calibrate - Force

Mohit Shridhar
13/06/13

*/


import processing.serial.*;

import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;
import org.gwoptics.graphics.*;
import org.gwoptics.graphics.graph2D.backgrounds.GridBackground;

int timeOut = 10; //Change timer duration in SECONDS // 60*60*1000

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

//Change Noise Reduction intensity:
int numReads = 500;


class eq implements ILine2DEquation{
	public double computePoint(double x, int pos) {
             return xPos;
	}		
}

class eq2 implements ILine2DEquation{
        public double computePoint(double x, int pos) {
             return xPos2; 
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
        myPort = new Serial(this, Serial.list()[4], 9600); //Use 38400
        myPort.bufferUntil('\n');  
      
	
	r  = new RollingLine2DTrace(new eq() , 1, 0.001f); // original: 0.01f changed: 1, 0.001f
	r.setTraceColour(255, 0, 0);

        r2 = new RollingLine2DTrace(new eq2(), 1, 0.001f);
        r2.setTraceColour(0, 255, 0);
		 
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

