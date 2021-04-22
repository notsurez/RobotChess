/*
  Class for the chess piece object. The object will contain all the information used to display each chess piece
  determine legal moves, and allow the user to select pieces
  
  Written by: Christian Brazeau, Timothy Reichert, and Peter Taranto
  Last modified: 03/12/2021
*/

import java.lang.Object;
import java.util.BitSet;

  boolean bqsc = true;
  boolean bksc = true;
  
  boolean wqsc = true;
  boolean wksc = true;
  
  boolean heardBestmove = false;
  
class ChessPiece {
  
  PImage wp, wr, wn, wb, wq, wk, bp, br, bn, bb, bq, bk; //Initialize individual PImages for each piece
  float x, y, size;
  int bbIndex; //Variable to store the bit board index of each piece (0-63)
  char pieceType; 
  Boolean selected = false;
  boolean firstMove = false;
  //byte BitBoard[] = new byte[64];
  
  ChessPiece(char pt, float xpos, float ypos,float s, int bitBI){
    imageMode(CENTER);
    if((which_side == 'r')) {
      int pick = ceil(random(2));
      if(pick == 1) {
        which_side = 'b';
      }else{
        which_side = 'w';
      }
    }
    if(which_side == 'w'){
      wp = loadImage("wp.png");
      wr = loadImage("wr.png");
      wn = loadImage("wn.png");
      wb = loadImage("wb.png");
      wk = loadImage("wk.png");
      wq = loadImage("wq.png");
      bp = loadImage("bp.png");
      br = loadImage("br.png");
      bn = loadImage("bn.png");
      bb = loadImage("bb.png");
      bq = loadImage("bq.png");
      bk = loadImage("bk.png");
    }else{
      bp = loadImage("wp.png");
      br = loadImage("wr.png");
      bn = loadImage("wn.png");
      bb = loadImage("wb.png");
      bk = loadImage("wk.png");
      bq = loadImage("wq.png");
      wp = loadImage("bp.png");
      wr = loadImage("br.png");
      wn = loadImage("bn.png");
      wb = loadImage("bb.png");
      wq = loadImage("bq.png");
      wk = loadImage("bk.png");
    }
    
    wp.resize(pieceSize, pieceSize);
    wr.resize(pieceSize, pieceSize);
    wn.resize(pieceSize, pieceSize);
    wb.resize(pieceSize, pieceSize);
    wk.resize(pieceSize, pieceSize);
    wq.resize(pieceSize, pieceSize);
    bp.resize(pieceSize, pieceSize);
    br.resize(pieceSize, pieceSize);
    bn.resize(pieceSize, pieceSize);
    bb.resize(pieceSize, pieceSize);
    bq.resize(pieceSize, pieceSize);
    bk.resize(pieceSize, pieceSize);
    
    x = xpos;
    y = ypos;
    size = s;
    pieceType = pt;
    bbIndex = bitBI;
  }
  
  void move() {
    //x++;
  }
  
  void display() {
    switch(pieceType){
      case 'p':
        image(bp, x,y);
      break;
      
      case 'r': //Black Rook
        image(br, x,y);
      break;
            
      case 'n': //Black Knight
        image(bn, x,y);
      break;      
      
      case 'b': //Black Bishop
        image(bb, x,y);
      break;
      
      case 'q': //Black Queen
        image(bq, x,y);
      break;
      
      case 'k': //Black King
        image(bk, x,y);
      break;
      
      case 'P': // White Pawn
        image(wp, x,y);
      break;
           
      case 'R': //White Rook
       image(wr, x,y);
      break;     
      
      case 'N': //White Knight
        image(wn, x,y);
      break;      
      
      case 'B': //White Bishop
        image(wb, x,y);
      break;
      
      case 'Q': //White Queen
        image(wq, x,y);
      break;
      
      case 'K': //White King
        image(wk, x,y);
      break;
    }
    
    if(selected) {
     x = mouseX;
     y = mouseY;
    }
  }
  
void updateBB() {
  println("UPDATING BB");
    int TobbIndex = (int) floor(x/(int)gridSize)+floor(y/(int)gridSize)*8; //Calculate new BB position

    
    BitBoard[bbIndex] = ' '; //Clear where the piece moved FROM

    println(BitBoard[bbIndex]); // Print which 

    if(BitBoard[TobbIndex] != 32 && BitBoard[TobbIndex] != 0) { //if the TO position contains a piece
      BitBoard[TobbIndex] = ' '; 
      board[TobbIndex%8][floor(TobbIndex/8)] = null; //Remove the piece object
      println("PIECE REMOVED ", (char)BitBoard[TobbIndex], " on (", TobbIndex%8, ",",floor(TobbIndex/8), ")"  );
    }

    bbIndex = TobbIndex;
    BitBoard[bbIndex] = (byte)pieceType;
    println("UPDATE:", bbIndex, "=", pieceType);

    // Print BitBoard for debugging
    println("Print BitBoard for debugging");
    for(int i = 0; i < 64; i++) {
     print((char)BitBoard[i]);
     if(i == 7 || i == 15 || i == 23 || i == 31 || i == 39 || i == 47 || i == 55) {
       println();
     }
    }
    println(" ");
    //print("base64 string: ");
    //println(toBase64(BitBoard, false, false, ((player_time / 60)*100) + (player_time % 60) + 1000, turnState)); //the bitboard, is castling, castling queen(false) or king(true), time string, player turn ('P' or 'p')
    
    //addMove(bbIndex, TobbIndex, true);
}
  
  void highlightLegal() {
    if(selected){
      //println(pieceType, " on ",bbIndex);
      for(int i = 0; i < 64; i++) {
        if(isLegal(bbIndex,i)){
          fill(40, 40, 80);
          //println(bbIndex, " => ", i);
          ellipse(gridSize/2 + (i%8)*(gridSize),gridSize/2 + (floor(i/8))*(gridSize),gridSize/4,gridSize/4);
        }
      }

      blockedup = false;
      blockeddown = false;
      blockedleft = false;
      blockedright = false;
    }
  }
  
  boolean blockedup = false, blockeddown = false, blockedleft = false, blockedright = false;
  //Tim, put your logic in here
  boolean isLegal(int From, int To){
    boolean IsitLegal = false;
    byte PlayersPiece = BitBoard[From];
    float m = 0, x_1 = 0, x_2 = 0, y_1 = 0, y_2 = 0;
      x_1 = From%8;
      x_2 = To%8;
      y_1 = floor(From/8);
      y_2 = floor(To/8);
      if(x_1 == x_2){
        m = 0;
      }
      else{
      m = (y_2-y_1)/(x_2-x_1);
      }
      float d = sqrt(sq(x_2-x_1)+sq(y_2-y_1));
    
    switch(PlayersPiece){
      case 'p':
      if(From >= 8 && From < 16){ //Condition for testing if the pawn is on the 2nd rank and can move two squares
        if(To-From == 16 || To-From == 8){
          IsitLegal = true;
           if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
          }
        }
      }
                
      if(To-From == 8){ //Condition for testing if the pawn is moving one square
        IsitLegal = true;
         if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
            }
      if((To-From == 7||To-From == 9) && (BitBoard[To] == 'P'||BitBoard[To] =='Q'||BitBoard[To] =='B'||BitBoard[To] == 'N'||BitBoard[To] == 'R')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }

      if(To > 63|| To < 0){ //returns false if move is off the board
        return false;
        } 
      break;
      
      case 'r': //Black Rook
     if((x_2 == x_1&&(y_2 < y_1)&&(To != From)&&blockedup == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'r' ||BitBoard[To] =='n'||BitBoard[To] == 'b'||BitBoard[To] =='q'||BitBoard[To] =='k'||BitBoard[To] == 'p')){
         blockedup = true;
         IsitLegal = false;
       }
     }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From)&&blockeddown == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'r' ||BitBoard[To] =='n'||BitBoard[To] == 'b'||BitBoard[To] =='q'||BitBoard[To] =='k'||BitBoard[To] == 'p')){
         blockeddown = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From)&&blockedleft == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'r' ||BitBoard[To] =='n'||BitBoard[To] == 'b'||BitBoard[To] =='q'||BitBoard[To] =='k'||BitBoard[To] == 'p')){
         blockedleft = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From)&&blockedright == false)){
       IsitLegal = true;
       if((BitBoard[To] == 'r' ||BitBoard[To] =='n'||BitBoard[To] == 'b'||BitBoard[To] =='q'||BitBoard[To] =='k'||BitBoard[To] == 'p')){
         blockedright = true;
         IsitLegal = false;
       }
     }
     
        if(To > 63 ||To < 0){ //Returns false if the knight is moved off the board
        return false;
      }  
      break;
            
      case 'n': //Black Knight
     if((abs(m) == 0.5||abs(m) == 2)&&(d == sqrt(5))){
       IsitLegal = true;
       if(BitBoard[To] == 'r' ||BitBoard[To] =='n'||BitBoard[To] == 'b'||BitBoard[To] =='q'||BitBoard[To] =='k'||BitBoard[To] == 'p'){ // Condition to test if the knight is trying to move to a square occupied by a friendly piece
        return false;
     }
     }
      if(To > 63 ||To < 0){ //Returns false if the knight is moved off the board
        return false;
      }   
      break;      
      
      case 'b': //Black Bishop

      if(m == 1 || m == -1){
        IsitLegal = true;
         if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
      }
       if(To < 0|| To > 63){ //returns false if move is off the board
        return false;
      }     
      break;
      
      case 'q': //Black Queen
        if((y_2 == y_1|| m == 0)||(m == 1 || m == -1)){
       IsitLegal = true;
        if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
     }       
      break;
      
      case 'k': //Black King
   if(d == 1||d == sqrt(2)){
        IsitLegal = true;
         if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
      }
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      break;
      
      case 'P': // White Pawn
        if(From >= 48 && From < 56){//Condition for testing if the pawn is on the 2nd rank and can move two squares
          if(To-From == -16 || To-From == -8){
          IsitLegal = true;
          if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
            }
          }
        }
                
      if(To-From == -8){ //Condition for testing if the pawn is moving one square
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
            }

      if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p'||BitBoard[To] =='q'||BitBoard[To] =='b'||BitBoard[To] == 'n'||BitBoard[To] == 'r')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }

      if(To < 0|| To > 63){ //returns false if move is off the board
        return false;
      }

      break;
           
      case 'R': //White Rook
       if(y_2 == y_1|| x_2 == x_1){
       IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
     }

        if(To > 63 ||To < 0){ //Returns false if the knight is moved off the board
        return false;
      }
      break;     
      
      case 'N': //White Knight
     if((abs(m) == 0.5||abs(m) == 2)&&(d == sqrt(5))){
       IsitLegal = true;
             if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
     }
     
      if(To > 63 ||To < 0){ //Returns false if the knight is moved off the board
        return false;
      }
      break;      
      
      case 'B': //White Bishop// 
      if(m == 1 || m == -1){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
       if(To < 0|| To > 63){ //returns false if move is off the board
        return false;
      }
      break;
      
      case 'Q': //White Queen
        if((y_2 == y_1|| m == 0)||(m == 1 || m == -1)){
       IsitLegal = true;
             if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
     }
      break;
      case 'K': //White King
      if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      break;
      }
    return IsitLegal;
  }

  boolean MouseIsOver() {
    if (mouseX > x-(size/2) && mouseX < x+(size/2) && mouseY > y-(size/2) && mouseY < y+(size/2)) {
        //println(pieceType, bbIndex);
      return true;
    }
    return false;
  }
}

void addMove(int fromLocation, int toLocation, boolean tellStockfish) {
  heardBestmove = false;
  if (fromLocation == toLocation) return;
  //if (turnState == 'P') movesHistory = movesHistory + "\n"; //P for white/player, p for black/computer
  if (cherry < 50) return;
  cherry = 0;
  
  movesHistory = movesHistory + bbCoordString(fromLocation) + bbCoordString(toLocation) + " ";
  
  if (tellStockfish) {
  stockfish.say(movesHistory);
  delay(20);
  stockfish.say("go movetime 1000"); //replace the 1000 with the amount of time to run engine in millis
  m = millis();
  for(int t = 1; t < 30; t++) {
  delay(100);
  print("=");
  keepTime();
  }
  println(">");
  while(!heardBestmove) {
  stockfish.listen();
  delay(20);
  }
}
}

String bbCoordString(int Location) {
String buffer = "";
int alpha = 97 + (Location % 8);
char alphaChar = (char) alpha;
int numeric = 8 - (Location / 8);
buffer = buffer + str(alphaChar) + str(numeric);
return buffer;  
}
