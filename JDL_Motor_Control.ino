#include <Servo.h>
Servo Mag_Servo;
int mag_x = 50;
int mag_y = 50;
int Player_Discard = 0;
int Computer_Discard = 0;
int Player_Discard_X = 0;
int Player_Discard_Y_1 = -50;
int Player_Discard_Y_2 = 850;
int Computer_Discard_X = 0;
int Computer_Discard_Y_1 = -50;
int Computer_Discard_Y_2 = 850;
double a_S = 0;
double a_E = 0;
int ST_X = 0;
int ST_Y = 0;
int FL_X = 0;
int FL_Y = 0;
int cap_X = 0;
int cap_Y = 0;
byte start = 56;
byte finish = 7;

boolean debug_print = false;

//Pin connected to ST_CP of 74HC595
#define latchPin A1
//Pin connected to SH_CP of 74HC595
#define clockPin A0
////Pin connected to DS of 74HC595
#define dataPin A2

#define pulseTrain_X 4
#define pulseTrain_Y 2
#define direction_X 5
#define direction_Y 3
#define motorDriver_Reset 10
#define servoPWM 11
#define limit_X 8
#define limit_Y 7

//chess pieces
#define EMPTY_TILE '.'
#define P_KING 'K'
#define P_QUEEN 'Q'
#define P_BISHOP 'B'
#define P_HORSE 'N'
#define P_ROOK 'R'
#define P_PAWN 'P'
#define C_KING 'k'
#define C_QUEEN 'q'
#define C_BISHOP 'b'
#define C_HORSE 'n'
#define C_ROOK 'r'
#define C_PAWN 'p'

char bitBoard[66];
char oldbitBoard[66];

char gameBoardState[96];
char discardPile[16];
byte number_discarded = 0;
byte discard_cherry = 0;

const char default_gameBoardState[96] = {C_ROOK, C_HORSE, C_BISHOP, C_QUEEN, C_KING, C_BISHOP, C_HORSE, C_ROOK,
                    C_PAWN, C_PAWN, C_PAWN, C_PAWN, C_PAWN, C_PAWN, C_PAWN, C_PAWN,  
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, 
                    P_PAWN, P_PAWN, P_PAWN, P_PAWN, P_PAWN, P_PAWN, P_PAWN, P_PAWN,
                    P_ROOK, P_HORSE, P_BISHOP, P_QUEEN, P_KING, P_BISHOP, P_HORSE, P_ROOK,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE};

const char default_discardPile[16] = {EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE,
                    EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE, EMPTY_TILE};

byte numPieces = 32;
byte oldnumPieces = 32;

byte from_location = 69;
byte to_location = 69;
byte old_to_location = 69;
byte changed = 0;

char serialBase64input[11];
char serialPlayerinput[4];

byte cd = 0;
byte columnPhase = 0;

unsigned int playerTimeRemaining = 1500;

unsigned long lastMillis = 0;
unsigned int  serialTimeout = 0;

byte skip_castling = 0;

char rgbLedColor = '7';
//0 - off, 1 - red, 2 - green, 3 - blue, 4 - yellow, 5 - purple, 6 - turquoise, 7 - white
//this keeps track of who's turn it is

void setup() {
  // put your setup code here, to run once:
  pinMode(limit_X, INPUT_PULLUP);
  pinMode(limit_Y, INPUT_PULLUP);

  Serial.begin(4800);
  
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  digitalWrite(dataPin, LOW);
  digitalWrite(clockPin, LOW);
  digitalWrite(latchPin, LOW);

  pinMode(direction_X, OUTPUT);
  digitalWrite(direction_X, LOW);
  pinMode(direction_Y, OUTPUT);
  digitalWrite(direction_Y, LOW);
  pinMode(pulseTrain_X, OUTPUT);
  digitalWrite(pulseTrain_X, LOW);
  pinMode(pulseTrain_Y, OUTPUT);
  digitalWrite(pulseTrain_Y, LOW);

  pinMode(servoPWM, OUTPUT);
  analogWrite(servoPWM, 0);

  pinMode(motorDriver_Reset, OUTPUT);
  digitalWrite(motorDriver_Reset, LOW);

  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(7, INPUT_PULLUP);
  pinMode(8, INPUT_PULLUP);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  
  Mag_Servo.attach(9);
  Reset_stepper();
  if (debug_print == true) Serial.println();
  delay(20);
  if (debug_print == true) Serial.println("Program begin");

//reset the board
  for(byte i = 0; i < 16; i++) {
    bitBoard[i] = 1;
    oldbitBoard[i] = 1;
    bitBoard[i+48] = 1;
    oldbitBoard[i+48] = 1;
  }

  for(byte i = 16; i < 48; i++) {
    bitBoard[i] = 0;
    oldbitBoard[i] = 0;
  }

  bitBoard[64] = 0;
  bitBoard[65] = 0;
  oldbitBoard[64] = 0;
  oldbitBoard[65] = 0;

memcpy(gameBoardState, default_gameBoardState, 96);
memcpy(discardPile, default_discardPile, 16);

  digitalWrite(motorDriver_Reset, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:
serialTimeout = 0;
  while ((Serial.available() > 1) && (Serial.available() != 16) && (serialTimeout < 1000)) {
    delay(1);
    serialTimeout++;
    if (serialTimeout > 750) {
      while(Serial.available() > 0) {
    char garbage = Serial.read();
  }
    serialTimeout = 10000;
    }
  }
  if (Serial.available() > 15) {
    //process incoming data
 //11 bytes - led board state in base64
 //4 bytes - player timer
 //1 byte  - who's turn is it

    for (byte a = 0; a < 11; a++)     serialBase64input[a] = Serial.read();
    for (byte b = 0; b < 4;  b++)     serialPlayerinput[b] = Serial.read();
    rgbLedColor = Serial.read();

    for (byte d = 0; d < 11; d++) {
      //decode base64
      byte dataIn = serialBase64input[d] - 58;
      for (byte n = 0; n < 6; n++) bitBoard[(d*6)+(5-n)] = ((dataIn >> n) & 0x01);
    }

  debug_message();
      //compare the bitboards

 from_location = 69;
 to_location = 69;
 changed = 0;
 numPieces = 0;

/*
Reserved locations:
69 - garbage
71 - black queenside
72 - black kingside
73 - white queenside
74 - white kingside
*/

      //check if castling occured
      if (bitBoard[64] == 1) {
          //castling occured
          if (rgbLedColor == 'C') {
            //white is castling
            if (bitBoard[65] == 0) {
                //white is castling queenside
                motorMovement(60, 73);
                motorMovement(56, 59);
                motorMovement(73, 58);
            }
            if (bitBoard[65] == 1) {
                //white is castling kingside
                motorMovement(60, 74);
                motorMovement(63, 61);
                motorMovement(74, 62);               
            }
          }
          if (rgbLedColor == 'P') {
            //black is castling
            if (bitBoard[65] == 0) {
                //black is castling queenside
                motorMovement(04, 71);
                motorMovement(00, 03);
                motorMovement(71, 02);
            }
            if (bitBoard[65] == 1) {
                //black is castling kingside
                motorMovement(04, 72);
                motorMovement(07, 05);
                motorMovement(72, 06);                
            }
          }
          //skip any further steps
          skip_castling = 1;
      }
 
      for (int i = 0; i < 64; i++) {
        if (bitBoard[i] == 1) numPieces++;
        
        if (oldbitBoard[i] != bitBoard[i]) {
          changed++;
          if (bitBoard[i] == 0 && skip_castling == 0) from_location = i;
          if (bitBoard[i] == 1 && skip_castling == 0) to_location = i;
        }

        if (to_location != 69) old_to_location = to_location;
        
        oldbitBoard[i] = bitBoard[i];
      }

if (skip_castling == 0) {
      if (oldnumPieces > numPieces) {
        //elimination logic
        if (debug_print == true) Serial.println(F("A piece was eliminated."));
      }

      if (changed > 0) {
        //movement logic
        if (debug_print == true) Serial.println(F("A piece was moved."));
      }

      if (debug_print == true) Serial.print(F("There were previously "));
      if (debug_print == true) Serial.print(oldnumPieces);
      if (debug_print == true) Serial.print(F(" pieces on the board. Now there are "));
      if (debug_print == true) Serial.print(numPieces);
      if (debug_print == true) Serial.println(F(" pieces on the board."));
      if (debug_print == true) Serial.print(changed);
      if (debug_print == true) Serial.println(F(" pieces changed position."));      
      if (debug_print == true) Serial.print(F("The piece at location "));
      if (debug_print == true) Serial.print(from_location);
      if (debug_print == true) Serial.print(F(" moved to location "));
      if (debug_print == true) Serial.print(to_location);
      if (debug_print == true) Serial.println(F("."));
           
      oldnumPieces = numPieces;

      //move motors
      start_motor(from_location, to_location);
}

skip_castling = 0;

      if (debug_print == true) Serial.print(F("Decoding clock. "));
      //decode clock
      playerTimeRemaining = 1000 * (serialPlayerinput[0] - 48);
      playerTimeRemaining = playerTimeRemaining + (100 * (serialPlayerinput[1] - 48));
      playerTimeRemaining = playerTimeRemaining + (10 * (serialPlayerinput[2] - 48));
      playerTimeRemaining = playerTimeRemaining + (serialPlayerinput[3] - 48);
      playerTimeRemaining = playerTimeRemaining - 1000;
      if (debug_print == true) Serial.println(playerTimeRemaining);
  }

  digitalWrite(latchPin, LOW);
  shiftOut(dataPin, clockPin, dec2bcd((playerTimeRemaining/100)%100));
  shiftOut(dataPin, clockPin, dec2bcd(playerTimeRemaining%100));
  digitalWrite(latchPin, HIGH);

  
//finally, print back to the serial port
if (millis() - lastMillis > 1000) {
  //if (debug_print == true) Serial.println(F("ROBOTCHESS"));
  lastMillis = millis();
  //if (debug_print == true) Serial.print(F("LED Board State"));
  //for(byte j = 0; j < 64; j++) {
  //  if (j%8 == 0) if (debug_print == true) Serial.println(F(" "));
  //  if (debug_print == true) Serial.print(ledBoardState[j], HEX);
  //}
  //if (debug_print == true) Serial.println(F(" "));
}  
}

byte pow_byte(byte x, byte y)
{
 byte val=x;
 for(byte z=0;z<=y;z++)
 {
   if(z==0)
     val=1;
   else
     val=val*x;
 }
 return val;
}

void shiftOut(byte dp, byte cp, byte d) {
digitalWrite(dp, LOW);
digitalWrite(cp, LOW);
for (int i = 7; i >= 0; i--) {
  digitalWrite(cp, LOW);
  if (d & (1<<i)) {
    digitalWrite(dp, HIGH);
  }
  else {
    digitalWrite(dp, LOW);
  }
  digitalWrite(cp, HIGH);
  digitalWrite(dp, LOW);
}
digitalWrite(cp, LOW);
}

byte dec2bcd(byte p) {
return ((p/10)*16) + (p%10);
}

void debug_message() {
  for(int i = 0; i < 66; i++) {
    if (i%8 == 0) if (debug_print == true) Serial.println(F(" "));
    if (debug_print == true) Serial.print(bitBoard[i], HEX);
    if (debug_print == true) Serial.print(F(" "));
  }
  if (debug_print == true) Serial.println(F(" "));
}

void copyArray(int* src, int* dst, int len) {
    memcpy(dst, src, sizeof(src[0])*len);
}

void start_motor(byte from, byte to) {
  //motor controller logic
  
if ((from == 69) && (to == 69)) {  
  //regular piece movement
  if (debug_print == true) Serial.println(F("No pieces were moved.")); 
}

if ((from < 69) && (to == 69)) {  
  //regular piece movement
  if (debug_print == true) Serial.print(F("Eliminating piece at location "));
  if (debug_print == true) Serial.print(from);
  if (debug_print == true) Serial.println(F("."));
  motorEliminate(old_to_location);
  motorMovement(from, old_to_location);
}

if ((from < 69) && (to < 69)) {  
  //regular piece movement
  if (debug_print == true) Serial.print(F("Moving piece at location "));
  if (debug_print == true) Serial.print(from);
  if (debug_print == true) Serial.print(F(" to location "));
  if (debug_print == true) Serial.print(to);
  if (debug_print == true) Serial.println(F("."));
  motorMovement(from, to);
}
  if (discard_cherry != 0 && false) {
   char temp = discardPile[number_discarded - 1];
   discardPile[number_discarded - 1] = gameBoardState[from]; 
   gameBoardState[from] = temp;
   discard_cherry = 0;
  }
  
  if (debug_print == true) Serial.print(F("gameBoardState "));
    for(byte b = 0; b < 64; b++) {
      if (b % 8 == 0) if (debug_print == true) Serial.println(F(""));
      if (debug_print == true) Serial.print(gameBoardState[b]);
    }
    if (debug_print == true) Serial.println(F(""));
    if (debug_print == true) Serial.println(F("Discard pile:"));
  for(byte nig = 0; nig < 16; nig++) {
  if (debug_print == true) Serial.print(nig + 1);
  if (debug_print == true) Serial.print(F(": "));
  if (debug_print == true) Serial.println(discardPile[nig]);
  }
}

/*
Reserved locations:
69 - garbage
71 - black queenside
72 - black kingside
73 - white queenside
74 - white kingside
*/
void motorEliminate(byte tile_eliminated) {
  //write motor driver code here
  if (debug_print == true) Serial.print(F("debug: motorEliminate("));
  if (debug_print == true) Serial.print(tile_eliminated);
  if (debug_print == true) Serial.println(F(");"));
  discardPile[number_discarded] = gameBoardState[tile_eliminated];
  number_discarded++;
  gameBoardState[tile_eliminated] = EMPTY_TILE;
  discard_cherry = 1;
  Initial_Handling(tile_eliminated, 69);
}

void motorMovement(byte tile_from, byte tile_to) {
  //write motor driver code here
  if (debug_print == true) Serial.print(F("debug: motorMovement("));
  if (debug_print == true) Serial.print(tile_from);
  if (debug_print == true) Serial.print(F(", "));
  if (debug_print == true) Serial.print(tile_to);
  if (debug_print == true) Serial.println(F(");"));
  gameBoardState[tile_to] = gameBoardState[tile_from];
  gameBoardState[tile_from] = EMPTY_TILE;
  Initial_Handling(tile_from, tile_to);
}

//David's code begins here
void Reset_stepper(){
  digitalWrite(10, LOW);
  delay(10);
  digitalWrite(10, HIGH);
}
//=========================================================

void Initial_Handling(byte startPass, byte finishPass){ //byte start, byte finish){
  delay(500);
  
  start = startPass;
  finish = finishPass;
  
  if (finish == 69){
    if (rgbLedColor == 'P'){
      if (debug_print == true) Serial.println(F("Starting player capture sequence"));
      Player_Discard++;
      Det_Dir_Pl_Cap(start, Player_Discard);
    }
    if (rgbLedColor == 'C'){
      if (debug_print == true) Serial.println(F("Starting computer capture sequence"));
      Computer_Discard++;
      Det_Dir_Com_Cap(start, Computer_Discard);
    }
  }else{
    if (debug_print == true) Serial.println(F("Starting piece movement sequence"));
    Det_Dir(start,finish);
  }
  delay(2000);
}
//=========================================================

void Det_Dir(byte start_loc, byte end_loc){
  Det_XY_S(start_loc);
  Det_XY_E(end_loc);
  if (debug_print == true) Serial.print(F("start x position is: "));
  if (debug_print == true) Serial.println(ST_X);
  if (debug_print == true) Serial.print(F("start y position is: "));
  if (debug_print == true) Serial.println(ST_Y);
  if (debug_print == true) Serial.print(F("final x position is: "));
  if (debug_print == true) Serial.println(FL_X);
  if (debug_print == true) Serial.print(F("final y position is: "));
  if (debug_print == true) Serial.println(FL_Y);
  move_mag_DE(ST_X, ST_Y);
  if (debug_print == true) Serial.println(F("Magnet Engaging"));
  engage_mag();
  move_to_p(FL_X, FL_Y);
  if (debug_print == true) Serial.println(F("Magnet Disengaging"));
  disengage_mag();
  if (debug_print == true) Serial.println(F("move has been completed"));
  if (debug_print == true) Serial.println(F("========================================="));
  if (debug_print == true) Serial.println();
  Serial.print(F("F"));
}
//=========================================================

void Det_Dir_Pl_Cap(byte start_loc_cap, int pl_cnt){
  if (pl_cnt <= 8){
    Player_Discard_X = 1150;
    Player_Discard_Y_1 += 100;
    if (debug_print == true) Serial.print(F("X discard position: "));
    if (debug_print == true) Serial.println(Player_Discard_X);
    if (debug_print == true) Serial.print(F("Y discard position: "));
    if (debug_print == true) Serial.println(Player_Discard_Y_1);
    Det_XY(start_loc_cap);
    if (debug_print == true) Serial.print(F("captured piece x location: "));
    if (debug_print == true) Serial.println(cap_X);
    if (debug_print == true) Serial.print(F("captured piece y location: "));
    if (debug_print == true) Serial.println(cap_Y);
    move_mag_DE(cap_X, cap_Y);
    if (debug_print == true) Serial.println(F("Magnet Engaging"));
    engage_mag();
    move_to_p(Player_Discard_X, Player_Discard_Y_1);
    if (debug_print == true) Serial.println(F("Magnet Disengaging"));
    disengage_mag();
    if (debug_print == true) Serial.println(F("move has been completed"));
  }
  if (pl_cnt >= 9 and pl_cnt <= 16){
    Player_Discard_X = 1050;
    Player_Discard_Y_2 -= 100;
    if (debug_print == true) Serial.print(F("X discard position: "));
    if (debug_print == true) Serial.println(Player_Discard_X);
    if (debug_print == true) Serial.print(F("Y discard position: "));
    if (debug_print == true) Serial.println(Player_Discard_Y_2);
    Det_XY(start_loc_cap);
    if (debug_print == true) Serial.print(F("captured piece x location: "));
    if (debug_print == true) Serial.println(cap_X);
    if (debug_print == true) Serial.print(F("captured piece y location: "));
    if (debug_print == true) Serial.println(cap_Y);
    move_mag_DE(cap_X, cap_Y);
    if (debug_print == true) Serial.println(F("Magnet Engaging"));
    engage_mag();
    move_to_p(Player_Discard_X, Player_Discard_Y_2);
    if (debug_print == true) Serial.println(F("Magnet Disengaging"));
    disengage_mag();
    if (debug_print == true) Serial.println(F("move has been completed"));
    Serial.print(F("F"));
  }
}
//========================================================

void Det_Dir_Com_Cap(byte start_loc_cap, int com_cnt){
  if (com_cnt <= 8){
    Computer_Discard_X = 50;
    Computer_Discard_Y_1 += 100;
    if (debug_print == true) Serial.print(F("X discard position: "));
    if (debug_print == true) Serial.println(Computer_Discard_X);
    if (debug_print == true) Serial.print(F("Y discard position: "));
    if (debug_print == true) Serial.println(Computer_Discard_Y_1);
    Det_XY(start_loc_cap);
    if (debug_print == true) Serial.print(F("captured piece x location: "));
    if (debug_print == true) Serial.println(cap_X);
    if (debug_print == true) Serial.print(F("captured piece y location: "));
    if (debug_print == true) Serial.println(cap_Y);
    move_mag_DE(cap_X, cap_Y);
    if (debug_print == true) Serial.println(F("Magnet Engaging"));
    engage_mag();
    move_to_p(Computer_Discard_X, Computer_Discard_Y_1);
    if (debug_print == true) Serial.println(F("Magnet Disengaging"));
    disengage_mag();
    if (debug_print == true) Serial.println(F("move has been completed"));
    Serial.print(F("F"));
  }
  if (com_cnt >= 9 and com_cnt <= 16){
    Computer_Discard_X = 150;
    Computer_Discard_Y_2 -= 100;
    if (debug_print == true) Serial.print(F("X discard position: "));
    if (debug_print == true) Serial.println(Computer_Discard_X);
    if (debug_print == true) Serial.print(F("Y discard position: "));
    if (debug_print == true) Serial.println(Computer_Discard_Y_2);
    Det_XY(start_loc_cap);
    if (debug_print == true) Serial.print(F("captured piece x location: "));
    if (debug_print == true) Serial.println(cap_X);
    if (debug_print == true) Serial.print(F("captured piece y location: "));
    if (debug_print == true) Serial.println(cap_Y);
    move_mag_DE(cap_X, cap_Y);
    if (debug_print == true) Serial.println(F("Magnet Engaging"));
    engage_mag();
    move_to_p(Computer_Discard_X, Computer_Discard_Y_2);
    if (debug_print == true) Serial.println(F("Magnet Disengaging"));
    disengage_mag();
    if (debug_print == true) Serial.println(F("move has been completed"));
    Serial.print(F("F"));
  }  
}
//========================================================

void Det_XY(byte st_loc){
    
  a_S = st_loc/8;
  int b = st_loc % 8;
  int i = 0;
  if (a_S < 1){
    cap_Y = 50;
    cap_X = (st_loc * 100) + 250;
  }else if (a_S >= 1 and a_S < 2){
    cap_Y = 150;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 2 and a_S < 3){
    cap_Y = 250;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 3 and a_S < 4){
    cap_Y = 350;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 4 and a_S < 5){
    cap_Y = 450;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 5 and a_S < 6){
    cap_Y = 550;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 6 and a_S < 7){
    cap_Y = 650;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }else if (a_S >= 7){
    cap_Y = 750;
    while (b != i ){
      i++;
    }
    cap_X = (i * 100) + 250;
  }
}
//==========================================================

void Det_XY_S(byte st_loc){
    
  a_S = st_loc/8;
  int b = st_loc % 8;
  int i = 0;
  if (a_S < 1){
    ST_Y = 50;
    ST_X = (st_loc * 100) + 250;
  }else if (a_S >= 1 and a_S < 2){
    ST_Y = 150;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 2 and a_S < 3){
    ST_Y = 250;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 3 and a_S < 4){
    ST_Y = 350;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 4 and a_S < 5){
    ST_Y = 450;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 5 and a_S < 6){
    ST_Y = 550;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 6 and a_S < 7){
    ST_Y = 650;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }else if (a_S >= 7){
    ST_Y = 750;
    while (b != i ){
      i++;
    }
    ST_X = (i * 100) + 250;
  }
}
//==========================================================

void Det_XY_E(byte st_loc){
    
  a_E = st_loc/8;
  int b = st_loc % 8;
  int i = 0;
  if (a_E < 1){
    FL_Y = 50;
    FL_X = (st_loc * 100) + 250;
  }else if (a_E >= 1 and a_E < 2){
    FL_Y = 150;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 2 and a_E < 3){
    FL_Y = 250;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 3 and a_E < 4){
    FL_Y = 350;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 4 and a_E < 5){
    FL_Y = 450;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 5 and a_E < 6){
    FL_Y = 550;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 6 and a_E < 7){
    FL_Y = 650;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }else if (a_E >= 7){
    FL_Y = 750;
    while (b != i ){
      i++;
    }
    FL_X = (i * 100) + 250;
  }
}
//==========================================================

void move_mag_DE(int PX, int PY){
  if (debug_print == true) Serial.print(F("magnet X position is: "));
  if (debug_print == true) Serial.println(mag_x);
  if (debug_print == true) Serial.print(F("magnet Y position is: "));
  if (debug_print == true) Serial.println(mag_y);
  int dis_x = PX - mag_x;
  if (debug_print == true) Serial.print(F("The distance difference in the X is: "));
  if (debug_print == true) Serial.println(dis_x);
  if (dis_x > 0){
    X_CW_Stepper(PX);
  }else if(dis_x < 0){
    X_CCW_Stepper(PX);
  }
  //maybe add handler for if = to 0
  int dis_y = PY - mag_y;
  //if (debug_print == true) Serial.println();
  if (debug_print == true) Serial.print(F("The distance difference in the Y is: "));
  if (debug_print == true) Serial.println(dis_y);
  if (dis_y > 0){
    Y_CCW_Stepper(PY);
  }else if(dis_y < 0){
    Y_CW_Stepper(PY);
  }
  if (debug_print == true) Serial.println(F("Magnet has gotten to start location"));
}
//==========================================================

void move_to_p(int pmX, int pmY){
  To_Gridline();
  int dis_px = pmX - mag_x;
  if (debug_print == true) Serial.print(F("The difference in X from start to finish is: "));
  if (debug_print == true) Serial.println(dis_px);
  if (debug_print == true) Serial.println(F("Starting movement in X direction"));
  if (dis_px > 0){
    X_CW_Stepper_P(pmX);
  }else if(dis_px < 0){
    X_CCW_Stepper_P(pmX);
  }else if(dis_px == 0){
    if(mag_x <= 600){
      From_Gridline_R();
    }else if(mag_x > 600){
      From_Gridline_L();
    }
  }

  int dis_py = pmY - mag_y;
  if (debug_print == true) Serial.print(F("The distance in Y from start to finish is: "));
  if (debug_print == true) Serial.println(dis_py);
  if (debug_print == true) Serial.println(F("Starting motor movement in Y direction"));
  //fix the return to center here
  if (dis_py > 0){
    Y_CCW_Stepper_P(pmY);
    //From_Gridline_L();
  }else if(dis_py < 0){
    Y_CW_Stepper_P(pmY);
    //From_Gridline_R();
  }
  if (debug_print == true) Serial.println(F("Moving back to the center of the tile"));
  if(mag_x < pmX){
    From_Gridline_R();
  }else if(mag_x > pmX){
    From_Gridline_L();
  }
}
//==========================================================

void X_CW_Stepper_P(int DX){
   /*
  digitalWrite(5, HIGH);
  while (x < 11) {
    digitalWrite(4, HIGH);
    delay(50);
    digitalWrite(4, LOW);
    x++;
    delay(200);
  }
  */
  int DL = DX - 50;
  //if (debug_print == true) Serial.println(F("The gridline distance is: "));
  //if (debug_print == true) Serial.print(DL);
  if (debug_print == true) Serial.println(F("X stepper toggle clockwise"));
  digitalWrite(5, HIGH);
  while (mag_x != DL){
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x + 10;
    Serial.print(F("R"));
    //send pulse to christian, write via serial ===> Serial.write("X or Y" 0 or 1) to every motion funtion
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
  if (debug_print == true) Serial.println(F("arrived at desired X location"));
}
//==========================================================

void X_CCW_Stepper_P(int DX){
  /*
  digitalWrite(5, LOW);
  while (x > 0) {
    digitalWrite(4, HIGH);
    delay(50);
    digitalWrite(4, LOW);
    x--;
    delay(200);
  }
  */
  int DL = DX + 50;
  //if (debug_print == true) Serial.println(F("The gridline distance is: "));
  //if (debug_print == true) Serial.print(DL);
  if (debug_print == true) Serial.println(F("X stepper toggle counter clockwise"));
  digitalWrite(5, LOW);
  while (mag_x != DL ) {
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x - 10;
    Serial.print(F("L"));
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
  if (debug_print == true) Serial.println(F("arrived at desired X location"));
}
//==============================================

void Y_CW_Stepper_P(int DY){
  /*
  digitalWrite(3, HIGH);
  while (x < 11) {
    digitalWrite(2, HIGH);
    delay(50);
    digitalWrite(2, LOW);
    x++;
    delay(200);
  }
  */
  if (debug_print == true) Serial.println(F("Y stepper toggle clockwise"));
  digitalWrite(3, HIGH);
  while (mag_y != DY) {
    digitalWrite(2, HIGH);
    delay(20);
    digitalWrite(2, LOW);
    if (debug_print == true) Serial.println(mag_y);
    mag_y = mag_y - 10;
    Serial.print(F("U"));
    //Serial.write(mag_y);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_y);
  if (debug_print == true) Serial.println(F("arrived at desired Y location"));
}
//==============================================

void Y_CCW_Stepper_P(int DY){
  /*
  digitalWrite(3, LOW);
  while (x > 0) {
    digitalWrite(2, HIGH);
    delay(50);
    digitalWrite(2, LOW);
    x--;
    delay(200);
    }
  */
  if (debug_print == true) Serial.println(F("Y stepper toggle counter clockwise"));
  digitalWrite(3, LOW);
  while (mag_y != DY) {
    digitalWrite(2, HIGH);
    delay(20);
    digitalWrite(2, LOW);
    if (debug_print == true) Serial.println(mag_y);
    mag_y = mag_y + 10;
    Serial.print(F("D"));
    //Serial.write(mag_y);
    delay(100);
    }
    if (debug_print == true) Serial.println(mag_y);
    if (debug_print == true) Serial.println(F("arrived at desired Y location"));
}
//==========================================================

void X_CW_Stepper(int DX){
   /*
  digitalWrite(5, HIGH);
  while (x < 11) {
    digitalWrite(4, HIGH);
    delay(50);
    digitalWrite(4, LOW);
    x++;
    delay(200);
  }
  */
  if (debug_print == true) Serial.println(F("X stepper toggle clockwise"));
  digitalWrite(5, HIGH);
  while (mag_x != DX){
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x + 10;
    Serial.print(F("R"));
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
  if (debug_print == true) Serial.println(F("arrived at desired X location"));
}
//==========================================================

void X_CCW_Stepper(int DX){
  /*
  digitalWrite(5, LOW);
  while (x > 0) {
    digitalWrite(4, HIGH);
    delay(50);
    digitalWrite(4, LOW);
    x--;
    delay(200);
  }
  */
  if (debug_print == true) Serial.println(F("X stepper toggle counter clockwise"));
  digitalWrite(5, LOW);
  while (mag_x != DX ) {
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x - 10;
    Serial.print(F("L"));
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
  if (debug_print == true) Serial.println(F("arrived at desired X location"));
}
//==============================================

void Y_CW_Stepper(int DY){
  /*
  digitalWrite(3, HIGH);
  while (x < 11) {
    digitalWrite(2, HIGH);
    delay(50);
    digitalWrite(2, LOW);
    x++;
    delay(200);
  }
  */
  if (debug_print == true) Serial.println(F("Y stepper toggle clockwise"));
  digitalWrite(3, HIGH);
  while (mag_y != DY) {
    digitalWrite(2, HIGH);
    delay(20);
    digitalWrite(2, LOW);
    if (debug_print == true) Serial.println(mag_y);
    mag_y = mag_y - 10;
    Serial.print(F("U"));
    //Serial.write(mag_y);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_y);
  if (debug_print == true) Serial.println(F("arrived at desired Y location"));
}
//==============================================

void Y_CCW_Stepper(int DY){
  /*
  digitalWrite(3, LOW);
  while (x > 0) {
    digitalWrite(2, HIGH);
    delay(50);
    digitalWrite(2, LOW);
    x--;
    delay(200);
    }
  */
  if (debug_print == true) Serial.println(F("Y stepper toggle counter clockwise"));
  digitalWrite(3, LOW);
  while (mag_y != DY) {
    digitalWrite(2, HIGH);
    delay(20);
    digitalWrite(2, LOW);
    if (debug_print == true) Serial.println(mag_y);
    mag_y = mag_y + 10;
    Serial.print(F("D"));
    //Serial.write(mag_y);
    delay(100);
    }
    if (debug_print == true) Serial.println(mag_y);
    if (debug_print == true) Serial.println(F("arrived at desired Y location"));
}
//==============================================

void To_Gridline(){
  int h = 0;
  if (debug_print == true) Serial.println(F("Moving to gridline"));
  if (a_S <= 4){
    digitalWrite(3, LOW);
    while (h < 50) {
      digitalWrite(2, HIGH);
      delay(20);
      digitalWrite(2, LOW);
      if (debug_print == true) Serial.println(mag_y);
      h = h + 5;
      mag_y = mag_y + 5;
      if(h%10==0) Serial.print(F("d"));
      //Serial.write(mag_y);
      delay(100);
    }
    if (debug_print == true) Serial.println(mag_y);
  }else if(a_S > 4){
    digitalWrite(3, HIGH);
    while (h < 50) {
      digitalWrite(2, HIGH);
      delay(20);
      digitalWrite(2, LOW);
      if (debug_print == true) Serial.println(mag_y);
      h = h + 5;
      mag_y = mag_y - 5;
      if(h%10==0) Serial.print(F("u"));
      //Serial.write(mag_y);
      delay(100);
    }
    if (debug_print == true) Serial.println(mag_y);
  }
}
//==============================================

void From_Gridline_R(){
  int g = 0;
  digitalWrite(5, HIGH);
  while (g < 50){
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    g = g + 5;
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x + 5;
    if(g%10==0) Serial.print(F("r"));
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
}
//==============================================

void From_Gridline_L(){
  int g = 0;
  digitalWrite(5, LOW);
  while (g < 50) {
    digitalWrite(4, HIGH);
    delay(20);
    digitalWrite(4, LOW);
    g = g + 5;
    if (debug_print == true) Serial.println(mag_x);
    mag_x = mag_x - 5;
    if(g%10==0) Serial.print(F("l"));
    //Serial.write(mag_x);
    delay(100);
  }
  if (debug_print == true) Serial.println(mag_x);
}
//==============================================

void engage_mag(){
  Mag_Servo.write(0);
  delay(500);
  Serial.print(F("E"));
  delay(100);
}

void disengage_mag(){
  Mag_Servo.write(93.5);
  delay(500);
  Serial.print(F("S"));
  delay(100);
}
