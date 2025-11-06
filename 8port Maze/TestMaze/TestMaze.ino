 /*Gergely Tarcsay, 2022. Code for testing the maze before and after experiment.
 * Code for testing LED strips, Port LED, IR beam and Valve
 * Set the N variable to -1 to test all of the ports together. LED strips and Port LED will turn on one-by-one. Break the IR beam - liquid will be delivered within 0.5 s. Set Valve open time in the ValveOpenTime vector
 * If you have issues with breaking the IR beam, you can test ports individually. Set N from 0 to 7 (see on the side of the computer which one is which). 
 */
//do not change these parameters
int LEDstrip[8] = {11, 4, 10,6,5,7,9,8};
int IRSensor[8] = {A3, A4,A1,A6,A0,A5,A7,A2};
int PortLED[8] = {42,43,46,40,45,44,41,47};     
int Valve[8] = {30,31,32,33,34,35,36,37}; 
int PortFlag[8]= {0,0,0,0,0,0,0,0};
int SensorState =0;

//only change this parameters
int N =-1; //-1 if all IR beam is tested, 0-7 if individual ports
int ValveOpenTime[8] = {66,66,58,66,66,58,58,66};// // valve opening time for individual ports
int IRThreshold[8] = {400,500,300,300,300,300,300,1000};//ir threshold

void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  for(int i = 0; i<=7; i++){
    pinMode(LEDstrip[i],OUTPUT);
    pinMode(PortLED[i],OUTPUT);
    pinMode(Valve[i],OUTPUT);
    pinMode(IRSensor[i],INPUT);
    if(N==-1){
    analogWrite(LEDstrip[i],0);
    digitalWrite(PortLED[i],0);
    }
  }

delay(1000);
if(N==-1){
for(int i = 0; i<=7; i++){
  analogWrite(LEDstrip[i],30);  
  analogWrite(PortLED[i],150);
}
}
}
void loop() {
  // put your main code here, to run repeatedly:
  if(N == -1){
    for(int i =0; i<=7; i++){
    SensorState = analogRead(IRSensor[i]);
    if(i==5){
      Serial.println(SensorState);
    }
    if (SensorState > IRThreshold[i] && PortFlag[i] ==0){
      analogWrite(PortLED[i],0);
      delay(500);
      digitalWrite(Valve[i],HIGH);
      delay(ValveOpenTime[i]);
      digitalWrite(Valve[i],LOW);
    }
    }
  }
  else{
      analogWrite(LEDstrip[N],200);  
    
      SensorState = analogRead(IRSensor[N]);
      Serial.println(SensorState);
      if (SensorState > IRThreshold[N]){
        digitalWrite(PortLED[N],LOW);
  
      }else{
        digitalWrite(PortLED[N],HIGH);
      }
    
    
  }
  
}
