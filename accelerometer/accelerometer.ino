
const int xpin = A0;                  // x-axis of the accelerometer
const int ypin = A1;                  // y-axis
const int zpin = A2;                  // z-axis (only on 3-axis models)
int buttonPin = 8;
int buttonState = 0;

int xpinval;
int ypinval;
int zpinval;
int xpinvaltemp;
int ypinvaltemp;

void setup()
{
  pinMode(buttonPin,INPUT);
  Serial.begin(9600);
}

void loop()
{

  xpinval = analogRead(xpin);
  ypinval = analogRead(ypin);
  zpinval = analogRead(zpin);
  buttonState = digitalRead(buttonPin);
  
  if (buttonState == HIGH)
  {
    Serial.write(244);
  }

 
  if(xpinval > 570)
  {
    //xpinvaltemp = xpinval - 512;
   // Serial.print("XLEFT ");
  //  Serial.println(xpinvaltemp);
    
    Serial.write(240);
   //Serial.write(xpinvaltemp);
  }
  
  if (xpinval < 450)
  {
    //xpinvaltemp = 512 - xpinval;
   // Serial.print("XRIGHT ");
   // Serial.println(xpinvaltemp);
    
    Serial.write(241);
    //Serial.write(xpinvaltemp);
  }
  
  if (ypinval > 570)
  {
   // ypinvaltemp = ypinval - 512;
    //Serial.print("YBACK ");
   // Serial.println(ypinvaltemp);
    
    Serial.write(242);
   //Serial.write(ypinvaltemp);
  }
  
    if (ypinval < 450)
  {
    //ypinvaltemp = 512 - ypinval;
   // Serial.print("YFORWARD ");
   // Serial.println(ypinvaltemp);
    
    Serial.write(243);
   //Serial.write(ypinvaltemp);
  }

  delay(100);
}
