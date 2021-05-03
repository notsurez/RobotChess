Serial microPC;
boolean board_connected = false;

void uCPUinit(int which_cpu) {
  print("Initializing uCPU on COM port ");
  microPC = new Serial(this, Serial.list()[which_cpu], 4800, 'N', 8, 1.0);
  board_connected = true;
  println(which_cpu);
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
  if (board_connected) {
    microPC.write(temp);
  }
  }
  
  if ( board_connected) {
    String tempString = str(timeString);
    microPC.write(tempString);
    microPC.write(turnString);
    delay(800); //wait for uCPU to process incoming commands
  }
  if (!board_connected) {
    print(timeString);
    println(turnString);
    //delay(800); //wait for uCPU to process incoming commands
  }
  
  castling_occured = false;
  castling_side = false;
  
  return charArr;
}

long m = 0;
void keepTime() {
   //Black Clock and player
  textSize(25);
  fill(220);
  rect(boardSize, 0, (width-boardSize), (height)); 
  fill(0);
  if (which_side == 'w') text("Black: CPU ("+str(cpu_diff)+")", cpuX, cpuY-5);
  if (which_side == 'b') text("White: CPU ("+str(cpu_diff)+")", cpuX, cpuY-5);
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
  if (which_side == 'w') text("White: Player", playerX, playerY-5);
  if (which_side == 'b') text("Black: Player", playerX, playerY-5);
  fill(50);
  rect(playerX, playerY, 200, 50, 10);
  fill(255);
  textSize(40);
  String player_displayTime = null;
  if (player_time%60 > 9)  player_displayTime = str(player_time/60) + str(':')  + str(player_time%60);
  if (player_time%60 < 10) player_displayTime = str(player_time/60) + ":0" + str(player_time%60);
  text(player_displayTime, playerX+50, playerY+40);
  
  if (paused == true) m = millis();
 if(millis() - m >= 1000) {
   //print("decrementing ");
   //println(turnState);
   
   if(turnState == 'P') {
     if (player_time == 0) game_gg = true;
     player_time--;
     
     //print("Emulated clock  communications --> ");
     //println(str(toBase64(BitBoard, false, false, ((player_time / 60)*100) + (player_time % 60) + 1000, turnState))); //the bitboard, is castling, castling queen(false) or king(true), time string, player turn ('P' or 'p')
     
     if (board_connected == true) {
     microPC.write("xxxx");
     microPC.write(str(((player_time / 60)*100) + (player_time % 60) + 1000));
     microPC.write("UU");
     }
   }else {
    if (computer_time == 0) game_gg = true;
    computer_time--; 
   }
  m = millis(); 
 }
}
