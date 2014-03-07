int sensorReading1 = 0;
int sensorReading2 = 0;

double vcc;

analogReference(2);

long readVcc() {
  long result;
  // Read 1.1V reference against AVcc
  ADMUX = _BV(REFS0) | _BV(MUX3) | _BV(MUX2) | _BV(MUX1);
  delay(2); // Wait for Vref to settle
  ADCSRA |= _BV(ADSC); // Convert
  while (bit_is_set(ADCSRA,ADSC));
  result = ADCL;
  result |= ADCH<<8;
  result = 1125300L / result; // Back-calculate AVcc in mV
  return result;
}


void setup()
{
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  Serial.begin(9600);
}

void loop() 
{
  sensorReading1 = analogRead(A0);
  sensorReading2 = analogRead(A8);
    
  vcc = readVcc()/1000.0;
  
  Serial.print(sensorReading1);
  Serial.print(",");
  Serial.print(sensorReading2);
  Serial.print(",");
  Serial.print(vcc);
  Serial.print(",");
  Serial.println(millis());
  
  delayMicroseconds(5);
}
