int sensorReading = 0;

void setup()
{
  pinMode(A0, INPUT);
  Serial.begin(9600);
}

void loop() 
{
  sensorReading = analogRead(A0);
  Serial.println(sensorReading); 
  
}
