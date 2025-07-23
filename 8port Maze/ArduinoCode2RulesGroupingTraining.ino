//Gergely Tarcsay, 2023. Arduino code for grouping, 2 rules training. Set MaxStrike to 10 for day 1-2 when any mistake is allowed. Set it to 1 after that. Set TrainingBlock to 800 for only cued trials, set to 8 & 24 for actual cued-noncued training. Set rules in the LEDIdx and PortIdx vectors.
//Number-location relationship:0 = W, 1 = SW and so on counterclockwise to 7 = NW. Set calibrated valve open time in the ValveOpenTime vector. Trials are randomized in blocks of 8.


//DO NOT CHANGE THESE PARAMETERS
int LEDstrip[8] = {12,11,10,9,8,7,6,5}; 
int IRSensor[8] = {A0, A1,A2,A3,A4,A5,A6,A7};
int PortLED[8] = {40,41,42,43,44,45,46,47};     
int Valve[8] = {30,31,32,33,34,35,36,37};
String Position[8] = {"W", "SW", "S", "SE", "E", "NE", "N", "NW"}; // position of ports
int LastState[8] = {-1,-1,-1,-1,-1,-1,-1,-1}; //for storing the last sensorstate of each port
String command; //bonsai msg will be stored here
String LedState = "off"; //switch for led strip. 0 if it's off 1 if it's on 
int SensorState =0; // tracking ir sensor state
//counters for all trials & for possible outcomes
int TotalTrialCounter =0; //goes until session ends
int TrialCounter = 0; //reset when reaches end of randomization block
int CorrectCounter = 0;
int IncorrectCounter = 0;
int TimeoutCounter =0;
bool IsTest = 0;
int BlockCounter = 1;

//CHANGE ONLY THESE PARAMETERS
int ValveOpenTime[8] = {66,66,58,58,66,58,66,66}; //valve open time for each port  
int IRThreshold[8] = {400,400,300,300,300,300,300,360};
int LEDIdx[4] = {0,1,2,3}; // rule1: W,SW LEDs on, rule2: S, SE LEDs on
int PortIdx[2] = {5,5}; //rule1-2: Nport
int TrialType[8] = {0,1,0,1,0,1,0,1}; //init trial type 0 = rule1, 1 = rule2, 2 = rule3, 3 = rule4 length should be the same as randomizetrials
int RandomizeTrials = 8;
long TimeOut = 60000; //max time in MILLISECONDS that a mouse can spend to find the right port once the sound is on
int OutputVal = 30; // LED cue brightness. set to 5 for dim light set 250 or higher to bright light (depends on battery life)

int TrainingBlock =0; //  X trials are training - portLED will turn on to guide the mouse. Set it 0 if you don't want any trainin trial.
int TestingBlock = 24; //testing block - set this to 0 to only have training blocks
int MaxStrike =1; // mouse has MaxStrike-1 chance to find reward


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.setTimeout(10); //important to ensure that IR ports are sampled around 100 Hz. Default is 1 Hz so it's really important to set.
  randomize(TrialType,RandomizeTrials); //randomize the TrialType vector twice - we want the rules in random order
  randomize(TrialType,RandomizeTrials);

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

//function for tracking ports during foraging & breaks
void TrackIRPorts(){
  for(int port = 0; port <=7; port++){
      SensorState = analogRead(IRSensor[port]);
      // if sensor is broken and it was not broken before
      if(SensorState > IRThreshold[port] &&  LastState[port] < IRThreshold[port]){
        Serial.println("Poke_"+ Position[port]);
      }
      LastState[port] = SensorState;
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
    // result each time we run this program
    randomSeed(analogRead(9)); // never use 0-7 as the ports are connected there and won't give you a random value
 
    // Start from the last element and swap one by one. We don't
    // need to run for the first element that's why i > 0
    for (int i = n-1; i > 0; i--)
    {
        long j = random(0, n);
        swap(&arr[i], &arr[j]);
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

// function to turn on and off all LED cues
void ControlVisualCue(String command){
  
  OutputVal = 0;
  //check if cue has to be turned on or off
  if(command.substring(3,5) == "on"&& LedState == "off"){
    OutputVal = 100; // set to 5 for dim light
    if(TrialType[TrialCounter] == 0){
      analogWrite(LEDstrip[LEDIdx[0]],OutputVal);
      analogWrite(LEDstrip[LEDIdx[1]],OutputVal);
    }else{
      analogWrite(LEDstrip[LEDIdx[2]],OutputVal);
      analogWrite(LEDstrip[LEDIdx[3]],OutputVal);
    }
    
    Serial.println("LED on"); //+ Position[LEDIdx[TrialType[TrialCounter]]] );
    LedState = "on";
        //if training block is on
    if (IsTest == 0){
      
      //if counter is below or equal the # of training block - turn on portLED
      if (BlockCounter > TrainingBlock){
       // analogWrite(PortLED[PortIdx[TrialType[TrialCounter]]], 150);
       // 
        BlockCounter = 1; // this is the first test trial
        IsTest = 1;
      }else{
        Serial.println("Training");
      }
 
    }
    //if test block is on
    if (IsTest == 1){
      
      //if counter is greater then traning block turn on portLED, reset the counter and turn off the IsTest flag
      if (BlockCounter > TestingBlock){
        //
        //Serial.println("PortLED on " + Position[PortIdx[TrialType[TrialCounter]]]);
        BlockCounter = 1;
        IsTest = 0;
        Serial.println("Training");
      }else{
        Serial.println("Testing");
      }
      
    }
    if(TrialType[TrialCounter] == 0){
      Serial.println("Context B");
     
    }else{
      Serial.println("Context B'");
    }
    
    BlockCounter++; //increase counter in every trial
  }

  //if command is to turn led off and it is currently switched on
  if(command.substring(3,6) == "off" && LedState == "on"){

    for(int i =0;i<=7;i++){
      analogWrite(LEDstrip[i],OutputVal);
    }   
    Serial.println("LED off" );
    LedState = "off";
    }
    
 }
  

void RunTest() {
  bool PortOn = 1;
  bool PortFlags[8] = {0, 0, 0, 0, 0, 0, 0, 0}; //init flags. 0 if port unvisited, 1 if visited
  int Strike =0;
  long t0 = millis(); 
  //ControlVisualCue("ledoff");//turn off lights
  long elapsed_time = 0;
    if(IsTest == 0){
      analogWrite(PortLED[PortIdx[TrialType[TrialCounter]]], 150);
      Serial.println("PortLED on " + Position[PortIdx[TrialType[TrialCounter]]]);
    }
    

    //wait until mouse visits this port
    while(PortOn == 1){
      //loop on all ports to track wrong pokes as well
      for(int port = 0; port <= 7; port++){
        SensorState = analogRead(IRSensor[port]); // read IR value
        //if IR is broken and this is not the the reward port and previously it was not broken
        if(SensorState > IRThreshold[port] && port != PortIdx[TrialType[TrialCounter]] && LastState[port] < IRThreshold[port]){
          Serial.println("Poke_"+ Position[port]);
            //count wrong port pokes for incorrect trials (counted only once)
            if(PortFlags[port] == 0){
              PortFlags[port] =1;
              Strike++;
            }
        }
        //when the mouse made MaxStrike number of mistakes, consider trial as incorrect and terminate it
        if(Strike == MaxStrike){
          long dt = millis()-t0;
          analogWrite(PortLED[PortIdx[TrialType[TrialCounter]]], 0);
          IncorrectCounter++;
          TrialCounter++;
          TotalTrialCounter++;
          PortOn =0;
          Serial.println("Incorrect_" + Position[PortIdx[TrialType[TrialCounter-1]]]+ "_" + TotalTrialCounter +"_"+ dt + "ms"); 
          //blink LEDs as a signal of trial end
          BlinkLED(LEDstrip, 3, 500);
          //rerandomize trials when 20 is reached
          if(TrialCounter == RandomizeTrials){ // if 20 trials are done, rerandomize the index vector
            randomize(TrialType, RandomizeTrials);
            TrialCounter =0; //reset counter for the next round
          }          
 
          
          break;
        }
        
        //if IR is broken and this is the actual reward port and this is the first time it's broken
        if(SensorState > IRThreshold[port] && port == PortIdx[TrialType[TrialCounter]] && PortFlags[port] == 0){
          long dt = millis()-t0;
          analogWrite(PortLED[PortIdx[TrialType[TrialCounter]]], 0);
          CorrectCounter++;
          TrialCounter++;
          TotalTrialCounter++;
          digitalWrite(Valve[port],HIGH); // open valve
          delay(ValveOpenTime[port]); // wait some time based on the user input
          digitalWrite(Valve[port],LOW); // close valve
          PortFlags[port] = 1; //count the visit
          Serial.println("Correct_"+ Position[port] + CorrectCounter + "_" + TotalTrialCounter + "_" +dt+"ms"); //send message to Bonsai which one was visited
          if(TrialCounter == RandomizeTrials){ // if 10 trials are done, rerandomize the index vector
            randomize(TrialType, RandomizeTrials);
            TrialCounter =0; //reset counter for the next round
          }
          delay(1000); 
          PortOn =0;
          break;
        }

        //timeout - if elapsed time is greater than a predefined max time to find the reward
        
        if(millis()-t0 > TimeOut){
          analogWrite(PortLED[PortIdx[TrialType[TrialCounter]]], 0);
          TrialCounter++;
          TotalTrialCounter++;
          TimeoutCounter++;
          PortOn =0;
          Serial.println("TimeOut_"+ Position[PortIdx[TrialType[TrialCounter-1]]] +  "_" + TotalTrialCounter);
          //blink LEDs as a signal of trial end
          BlinkLED(LEDstrip, 3, 500);
          //rerandomize trials when 20 is reached
          if(TrialCounter == RandomizeTrials){ // if 10 trials are done, rerandomize the index vector
            randomize(TrialType, RandomizeTrials);
            TrialCounter =0; //reset counter for the next round
          }  
        
          break;
        }
        LastState[port]= SensorState; //save the last sensor value 
    
      }

    }
    ControlVisualCue("ledoff"); // switch off cues
   
  }
 

void loop() {
  // put your main code here, to run repeatedly:
  TrackIRPorts();
  command = Serial.readString();
  if(command.substring(0,1) == "s"){
    Serial.println("Triggered");
    
    RunTest();
     
  }


  if(command.substring(0,1) == "l"){
    
          ControlVisualCue(command);  
         
            
  }


}
