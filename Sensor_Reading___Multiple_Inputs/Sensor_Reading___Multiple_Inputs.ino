void setup()
{

  Serial.begin(9600);
 
}

void loop() 
{ 
  Serial.print(analogRead(A0));
  Serial.print(",");
  Serial.print(analogRead(A8));
  Serial.print(",");
  Serial.print(analogRead(A14));
  Serial.print(",");
  Serial.println(millis());

}
