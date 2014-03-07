/*
Measuring the force from a force sensor.
Need to calibrate - Force

Mohit Shridhar
13/06/13
*/

import org.gwoptics.graphics.graph3D.*;
import org.gwoptics.graphics.colourmap.*;
import org.gwoptics.graphics.graph2D.backgrounds.*;
import org.gwoptics.graphics.graph2D.traces.*;
import org.gwoptics.graphics.camera.*;
import org.gwoptics.graphics.graph2D.effects.*;
import org.gwoptics.graphics.graph2D.*;
import org.gwoptics.*;
import org.gwoptics.gaussbeams.*;
import org.gwoptics.graphicsutils.*;
import org.gwoptics.mathutils.*;
import org.gwoptics.graphics.*;
import org.gwoptics.graphics.colourmap.presets.*;

import processing.serial.*;


/*
import processing.serial.*;
import org.gwoptics.graphics.*;
*/

/*
import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;
import org.gwoptics.graphics.graph2D.backgrounds.GridBackground;
*/

Serial myPort;
PrintWriter output;
float xPos = 1; // Intial position of pointer
float xPos2 = 1;
//float newTime;
float timeX;


class eq implements ILine2DEquation{
	public double computePoint(double x,int pos) {
             return xPos;
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
        
	size(800,600);

        // Added:
        println(Serial.list());
        myPort = new Serial(this, Serial.list()[4], 9600);
        myPort.bufferUntil('\n');  
      
	
	r  = new RollingLine2DTrace(new eq() ,10,0.01f);
	r.setTraceColour(255, 0, 0);
	
        r2 = new RollingLine2DTrace(new eq2(), 10, 0.01f);
        r.setTraceColour(0, 255, 0);
	 
	g = new Graph2D(this, 650, 500, false);
        g.setAxisColour(255, 255, 255); // White
        g.setFontColour(255, 255, 255); // White
	g.addTrace(r);
	g.position.y = 50;
	g.position.x = 100;
	g.setYAxisTickSpacing(100); 
        
        // Added:
        g.setXAxisLabel("Time (sec)");
        g.setYAxisLabel("Force (1024 Bit)");

        g.setYAxisMax(1024);
	g.setXAxisMax(5f);

        output.println("Time  Force"); 
        
}

float fixDec(float n, int d) {
  return Float.parseFloat(String.format("%." + d + "f", n));
}

void draw(){
        
	background(0);
	g.draw();
        
        timeX = millis() / 1000.0;
        output.println(fixDec(timeX, 3) + "  " + xPos);
       
    //    newTime = newTime + 0.01;
}


void serialEvent (Serial myPort) {
  String inString =  myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    
    float[] data = float(split(inString, ","));
    if (data.length >=2) {
      inByte1 = map(data[0], 0, 1023, 0, 1023); // Calibrate 1st sensor
      inByte2 = map(data[1], 0, 1023, 0, 1023); // Calibrate 2nd sensor
    }
    
    xPos = 1023.0 - (inByte1 * 1.0);
    xPos2 = 1023.0 - (inByte2 * 1.0);
  }
    
    /* Previous code: One data source
    float inByte = float(inString);
    inByte = map(inByte, 0, 1023, 0, 1023); // Insert force range here
    
    int inByteTransfer = int(inByte);
    int heightTransfer = int(1023);
    xPos = heightTransfer - inByte;
    */
  }
}

void keyPressed() {
  if (key == 's') {
    output.flush();
    output.close();
    exit();
  }
}

