int Valve[8] = {30,31,32,33,34,35,36,37};
int LED[8] = {40,41,42,43,44,45,46,47}; 
int N =4;//type 0-7 for individual port, type -1 for all.
void setup() {
  // put your setup code here, to run once:
  for(int i=0; i<=7; i++){ 
    pinMode(Valve[i], OUTPUT);
    pinMode(LED[i], OUTPUT);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  if (N == -1){
    for(int i=0; i<=7; i++){
      digitalWrite(LED[i],HIGH);
      digitalWrite(Valve[i], HIGH);

      }
  }
  else{
    digitalWrite(Valve[N],HIGH);
    digitalWrite(LED[N],HIGH);
  }
}
