Serial microPC;

void uCPUinit(int which_cpu) {
  microPC = new Serial(this, Serial.list()[which_cpu], 115200);
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
  microPC.write(temp);
  }
  
  microPC.write(timeString);
  microPC.write(turnString);
  
  return charArr;
}
