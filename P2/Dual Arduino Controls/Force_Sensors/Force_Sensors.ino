/*

Built and Tested on Arduino IDE.

Title: Second Arduino - Force 1 and Force 2 Data

This code reads the force sensors connected to the two
analog pins and uses a noise cancelling algorithm to
smoothen out the data.

Year 1 Students: Dipti Motwani, Fardin Ashfaque, Mohit Shridhar
EDIC Staff: Dr. Jian Huei Choo
06/08/13

*/

/* Noise Cancelling Algorithm:
Credit: http://www.elcojacobs.com/eleminating-noise-from-sensor-readings-on-arduino-with-digital-filtering/
*/

#define NUM_READS 80 // Noise processing buffer

float reduceNoise(int sensorpin){
   // read multiple values and sort them to take the mode
   int sortedValues[NUM_READS];
   for(int i=0;i<NUM_READS;i++){
     int value = analogRead(sensorpin);
     int j;
     if(value<sortedValues[0] || i==0){
        j=0; //insert at first position
     }
     else{
       for(j=1;j<i;j++){
          if(sortedValues[j-1]<=value && sortedValues[j]>=value){
            // j is insert position
            break;
          }
       }
     }
     for(int k=i;k>j;k--){
       // move all values higher than current reading up one position
       sortedValues[k]=sortedValues[k-1];
     }
     sortedValues[j]=value; //insert current reading
   }
   //return scaled mode of 10 values
   float returnval = 0;
   for(int i=NUM_READS/2-5;i<(NUM_READS/2+5);i++){
     returnval +=sortedValues[i];
   }
 
   return returnval/10;
}

void setup()
{

  Serial.begin(9600);
  
  //The reference voltage is 1.1V, not 5.0V.
  //This improves the resolution of low-input readings.
  analogReference(INTERNAL1V1);

}

void loop() 
{ 
  Serial.print(int(reduceNoise(A8)));
  Serial.print(",");
  Serial.println(int(reduceNoise(A14)));
}
