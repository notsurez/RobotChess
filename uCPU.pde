Serial microPC;
boolean board_connected = false;

void uCPUinit(int which_cpu) {
  microPC = new Serial(this, Serial.list()[which_cpu], 115200);
  board_connected = true;
}

char[] toBase64(byte[] bb, boolean castling, boolean castling_side, int timeString, char turnString) {
  char charArr[] = new char[11]; 
  char temp = ':';
  for(int i = 0; i < 11; i++) {
    temp = ':';
    if(bb[((6*i)+0)] != ' ') temp += 32;
    if(bb[((6*i)+1)] != ' ') temp += 16;
    if(bb[((6*i)+2)] != ' ') temp += 8;
    if(bb[((6*i)+3)] != ' ') temp += 4;
    if (i < 10) {
    if(bb[((6*i)+4)] != ' ') temp += 2;
    if(bb[((6*i)+5)] != ' ') temp += 1;
    }
    if (i == 10 && castling == true) {
       temp += 2;
    }
    if (i == 10 && castling_side == true) {
       temp += 1;
    }
  charArr[i] = temp;
  if(board_connected){
    microPC.write(temp);
  }
  }
  
  if(board_connected){
    microPC.write(timeString);
    microPC.write(turnString);
  }
  
  return charArr;
}

long m = 0;
void keepTime() {
 if(millis() - m >= 1000) {
   if(turnState == 'P') {
     player_time--;
   }else {
    computer_time--; 
   }
  m = millis(); 
 }
}
