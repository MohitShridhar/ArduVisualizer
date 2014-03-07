/*

Built and Tested on Arduino IDE.

Title: First Arduino - Position and Time Data

This code prints the values of time and position (analog
pin connected to A0).

Year 1 Students: Dipti Motwani, Fardin Ashfaque, Mohit Shridhar
EDIC Staff: Dr. Jian Huei Choo
06/08/13

*/

void setup()
{

  Serial.begin(9600);
 
}

void loop() 
{ 
  Serial.print(millis());
  Serial.print(",");
  Serial.println(analogRead(A0));
}
