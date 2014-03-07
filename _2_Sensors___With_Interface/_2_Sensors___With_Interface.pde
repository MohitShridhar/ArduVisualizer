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

Serial myPort1;
Serial myPort2;
PrintWriter output;
float xPos = 1; // Intial position of pointer
float xPos2 = 1;
//float newTime;
float timeX = 0;

int inByte1;
int inByte2;
float lastTimeX = 0;


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
        output = createWriter("Force_vs._Time.txt");      
    //    newTime = 0.0;
        
	size(1280,700);

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
		 
	g = new Graph2D(this, 1100, 600, false);
        g.setAxisColour(255, 255, 255); // White
        g.setFontColour(255, 255, 255); // White
	g.addTrace(r);
        g.addTrace(r2);
	g.position.y = 50;
	g.position.x = 100;
	g.setYAxisTickSpacing(100); 
        g.setXAxisTickSpacing(2);
        
        // Added:
        g.setXAxisLabel("Time (sec)");
        g.setYAxisLabel("Force (5V Range)");

        g.setYAxisMax(1023);
	g.setXAxisMax(10f);


        output.println("Time  Force1  Force2"); 
        
}

float fixDec(float n, int d) {
  return Float.parseFloat(String.format("%." + d + "f", n));
}

void draw(){
        
	background(0);
	g.draw();

        
       // textFont(mono);
        fill(255);
        textSize(26);
        text("Toothbrush Tribology", 510, 40);
                
        output.println(timeX + "  " + xPos + "  " + xPos2);
       
    //    newTime = newTime + 0.01;
}


void serialEvent (Serial mySerialPort) {  
  
  if (mySerialPort == myPort1) {
  
  String inString =  myPort1.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    
    int[] data = int(split(inString, ","));
    if (data.length >=1) {
      inByte1 = data[0]; //map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
//      inByte2 = data[1]; //map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor
      

    xPos = ((inByte1));
//    xPos2 = ((inByte2)); //4000.0 * (inByte2 / 1023.0);
    
    
 //   lastTimeX = timeX;
 //   timeX = data[2] / 1000.0; // Stamp time - from arduino
   
    }
    
  }
  }
  
  else if (mySerialPort == myPort2) {
    String inString =  myPort2.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    
    int[] data2 = int(split(inString, ","));
    if (data2.length >=1) {
      inByte2 = data2[0]; //map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
//      inByte2 = data[1]; //map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor
      

    xPos2 = ((inByte2));
//    xPos2 = ((inByte2)); //4000.0 * (inByte2 / 1023.0);
    
    
 //   lastTimeX = timeX;
 //   timeX = data[2] / 1000.0; // Stamp time - from arduino
   
    }
    
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

