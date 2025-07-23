//Gergely Tarcsay, 2025. Arduino code for second day of habituation. Reward delivered at all 8 ports, but nose poke is required.

//DO NOT CHANGE THESE PARAMETERS
int LEDstrip[8] = {12,11,10,9,8,7,6,5}; 
int IRSensor[8] = {A0, A1,A2,A3,A4,A5,A6,A7};
int PortLED[8] = {40,41,42,43,44,45,46,47};     
int Valve[8] = {30,31,32,33,34,35,36,37};
int LEDIdx[8] = {0,1,2,3,4,5,6,7}; //for randomizing led strips
int LastState[8] = {-1,-1,-1,-1,-1,-1,-1,-1}; //for storing the last sensorstate of each port
int SensorState = 0;
String Position[8] = {"W", "SW", "S", "SE", "E", "NE", "N", "NW"}; // position of ports
int VisitCounter = 0; //to count the number of port visitations
String command;
String LedState = "off";


//CHANGE ONLY THESE PARAMETERS
int ValveOpenTime[8] = {66,66,58,58,66,66,66,66}; //valve open time for each port  
int IRThreshold[8] = {500,500,500,500,500,500,500,500};
long TimeOut = 300000; //time limit for each round is 5 min


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.setTimeout(10); //important to ensure that IR ports are sampled around 100 Hz. Default is 1 Hz so it's really important to set.
  randomize(LEDIdx,8);
  for(int i = 0; i<=7; i++){
    pinMode(LEDstrip[i],OUTPUT);
    analogWrite(LEDstrip[i],0);
    pinMode(PortLED[i],OUTPUT);
    analogWrite(PortLED[i],0);
    pinMode(Valve[i],OUTPUT);
    digitalWrite(Valve[i],LOW);
    pinMode(IRSensor[i],INPUT);

  }
}



//function for swap two numbers
void swap (int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

//function for randomize an array
void randomize ( int arr[], int n )
{
    // Use a different seed value so that we don't get same
    // result each time we run this program. Read from A9 since A0-A7 is used
    randomSeed(analogRead(9));
    
    // Start from the last element and swap one by one. We don't
    // need to run for the first element that's why i > 0
    for (int i = n-1; i > 0; i--)
    {
        long j = random(0, n);
        swap(&arr[i], &arr[j]);
    }
}

void TrackIRPorts(){
  for(int port = 0; port <=7; port++){
      SensorState = analogRead(IRSensor[port]);
      // if sensor is broken and it was not broken before
      if(SensorState > IRThreshold[port] &&  LastState[port] < IRThreshold[port]){

        Serial.println("Wrong_"+ Position[port]);
      }
      LastState[port] = SensorState;
  }
}

// function to turn on and off all LED cues
void ControlVisualCue(String command){
  
  int OutputVal = 0;
  //check if cue has to be turned on or off
  if(command.substring(3,5) == "on" && LedState == "off"){
    randomize(LEDIdx,8);
    OutputVal = 5;
    for(int i =0;i<=3;i++){
      analogWrite(LEDstrip[LEDIdx[i]],OutputVal);
    }   
    Serial.println("LED on" );
    LedState = "on";
  }
  if(command.substring(3,6) == "off"){
    
    for(int i =0;i<=7;i++){
      analogWrite(LEDstrip[i],OutputVal);
    }   
    Serial.println("LED off");
    LedState = "off";
  }
 }

   //function for blinking port led or led strip. 1st argument - the vector, 2nd argument - how many times should it blink? 3rd argument - what should be the time interval between blinkings
void BlinkLED(int arr[], int n, int interval) {
   for(int counter = 0; counter < n; counter++){
          for(int j = 0; j<= 7; j++){
            analogWrite(arr[j], 5);
          }
          delay(interval);
          for(int j = 0; j<= 7; j++){
            analogWrite(arr[j], 0);
          }
          delay(interval);
   }
}

void resetPortLEDs(){
  for(int n = 0; n<=7;n++){
    analogWrite(PortLED[n],0);
  }
}
  

void RunHabituation() {
  bool SessionOn = 1;
  bool PortFlags[8] = {0, 0, 0, 0, 0, 0, 0, 0}; //init flags. 0 if port unvisited, 1 if visited
  int LastActivePort = -1; // tracking which port was active last time
  long t0 = millis(); // start timer
  int PortCounter =0;
  for(int port = 0; port <=7; port++){
    analogWrite(PortLED[port],150); //turn on LED
  }
  while(SessionOn == 1){
    
    for(int port = 0; port <=7; port++){
     SensorState = analogRead(IRSensor[port]); // read IR value
     
      //if IR is broken and has been broken before and this port has not been visited right before this detection 
      if(SensorState > IRThreshold[port] && PortFlags[port] == 1 && LastState[port] < IRThreshold[port]){

        Serial.println("Wrong_"+ Position[port]);
      }
     
     //if IR is broken and has not been broken before
      if(SensorState > IRThreshold[port] && PortFlags[port] == 0){
        VisitCounter ++;
        PortCounter++;
        analogWrite(PortLED[port],0); // turn off LED if IR was broken
        digitalWrite(Valve[port],HIGH); // open valve
        delay(ValveOpenTime[port]); // wait some time based on the user input
        digitalWrite(Valve[port],LOW); // close valve
        PortFlags[port] = 1; //count the visit
        Serial.println("Correct_"+ Position[port] + VisitCounter); //send message to Bonsai which one was visited 
         int sumVisit = 0;
         for(int i = 0; i<= 7;i++){
          sumVisit += PortFlags[i];
         }
        delay(1000);
        LastActivePort = port; //set last active port to this port     
        if(PortCounter==8){ // if all the 8 ports were visited, reset the task
          Serial.println("End_"+ Position[port] + VisitCounter);
          SessionOn = 0;
          break;
        } 
      }
      //reset if time limit is reached
      if(millis()-t0 > TimeOut){
          Serial.println("End_Timeout");//+ Position[port]+"_"+ VisitCounter);
          resetPortLEDs();
          BlinkLED(LEDstrip, 3, 500);
          SessionOn = 0;
          break;
      }
      LastState[port] = SensorState;
      
    }

  }
  ControlVisualCue("ledoff");//turn off lights
 
 }

void loop() {
  // put your main code here, to run repeatedly:
  TrackIRPorts();
  command = Serial.readString();
  if(command.substring(0,1) == "s"){
 
    RunHabituation(); 

  }
  if(command.substring(0,1) == "l"){
  
    ControlVisualCue(command);

  }
}
