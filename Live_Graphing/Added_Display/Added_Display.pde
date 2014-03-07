/**
 * RollingGraph
 * This sketch makes ise of the RollingLine2DTrace object to
 * draw a dynamically updated plot.
 */

import processing.serial.*;

import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;
import org.gwoptics.graphics.*;
import org.gwoptics.graphics.graph2D.backgrounds.GridBackground;

Serial myPort;
int xPos = 1;


class eq implements ILine2DEquation{
	public double computePoint(double x,int pos) {
		return mouseX;
	}		



}



RollingLine2DTrace r;
Graph2D g;

	
void setup(){
	size(800,600);
	
	r  = new RollingLine2DTrace(new eq() ,10,0.01f);
	r.setTraceColour(255, 0, 0);
	
	 
	g = new Graph2D(this, 650, 500, false);
        g.setAxisColour(255, 255, 255);
        g.setFontColour(255, 255, 255);
	g.setYAxisMax(600);
	g.addTrace(r);
	g.position.y = 50;
	g.position.x = 100;
	g.setYAxisTickSpacing(100); // Changed from 100
        
        // Added:
        g.setXAxisLabel("Time (sec)");
        g.setYAxisLabel("Force (1024 Bit)");

        g.setYAxisMax(1024);
	g.setXAxisMax(5f);

        
}

void draw(){
	background(0);
	g.draw();

}


