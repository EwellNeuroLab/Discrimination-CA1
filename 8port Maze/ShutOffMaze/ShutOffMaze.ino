

  
    //Gergely Tarcsay, 2022. Run this for shutting off the maze.
int LEDstripCuePins[8] = {12,11,10,9,8,7,6,5}; 
int PortLED[8] = {40,41,42,43,44,45,46,47};     
int Valve[8] = {30,31,32,33,34,35,36,37}; 
void setup() {


 
  // put your setup code here, to run once:
  for(int i =0;i<=7;i++){
   // pinMode(LEDstripCuePins[i],OUTPUT);
   // digitalWrite(LEDstripCuePins[i],0);
    pinMode(PortLED[i],OUTPUT);
    digitalWrite(PortLED[i],0);
    pinMode(Valve[i],OUTPUT);
    digitalWrite(Valve[i],0); 
    
  }

}

void loop() {
  // put your main code here, to run repeatedly:

}
