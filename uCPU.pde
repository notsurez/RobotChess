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
   //Black Clock and player
  textSize(25);
  fill(220);
  rect(boardSize, 0, (width-boardSize), (height)); 
  fill(0);
  text("Black: CPU (3200)", cpuX, cpuY-5);
  fill(50);
  rect(cpuX, cpuY, 200, 50, 10);
  fill(255);
  textSize(40);
  String computer_displayTime = null;
  if (computer_time%60 > 9)  computer_displayTime = str(computer_time/60) + str(':')  + str(computer_time%60);
  if (computer_time%60 < 10) computer_displayTime = str(computer_time/60) + ":0" + str(computer_time%60);
  text(computer_displayTime, cpuX+50, cpuY+40);
  
  //White Clock and Player
  textSize(25);
  fill(0);
  text("White: Player (900)", playerX, playerY-5);
  fill(50);
  rect(playerX, playerY, 200, 50, 10);
  fill(255);
  textSize(40);
  String player_displayTime = null;
  if (player_time%60 > 9)  player_displayTime = str(player_time/60) + str(':')  + str(player_time%60);
  if (player_time%60 < 10) player_displayTime = str(player_time/60) + ":0" + str(player_time%60);
  text(player_displayTime, playerX+50, playerY+40);
  
 if(millis() - m >= 1000) {
   //print("decrementing ");
   //println(turnState);
   
   if(turnState == 'P') {
     player_time--;
   }else {
    computer_time--; 
   }
  m = millis(); 
 }
}
