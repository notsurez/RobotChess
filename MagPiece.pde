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
  
  long cherry = 0;
  char which_side = 'w';
  
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
  
  void move(String moveToMake) {
    switch(moveToMake) {
      case "X1":
        x+=10;
      break;
      case "X0":
        x-= 10;
        break;
      case "Y1":
        y+=10;
      case "Y0":
        y-=10;
      
    }
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

 

  boolean magIsOver() {
    if (mag_x > x-(size/2) && mag_x < x+(size/2) && mag_y > y-(size/2) && mag_y < y+(size/2)) {
        //println(pieceType, bbIndex);
      return true;
    }
    return false;
  }
}

//void addMove(int fromLocation, int toLocation, boolean tellStockfish) {
//  heardBestmove = false;
//  if (fromLocation == toLocation) return;
//  //if (turnState == 'P') movesHistory = movesHistory + "\n"; //P for white/player, p for black/computer
//  if (cherry < 50) return;
//  cherry = 0;
  
//  movesHistory = movesHistory + bbCoordString(fromLocation) + bbCoordString(toLocation) + " ";
  
//  if (tellStockfish) {
//  stockfish.say(movesHistory);
//  delay(20);
//  stockfish.say("go movetime 1000"); //replace the 1000 with the amount of time to run engine in millis
//  m = millis();
//  for(int t = 1; t < 30; t++) {
//  delay(100);
//  print("=");
//  keepTime();
//  }
//  println(">");
//  while(!heardBestmove) {
//  stockfish.listen();
//  delay(20);
//  }
//}
//}

String bbCoordString(int Location) {
String buffer = "";
int alpha = 97 + (Location % 8);
char alphaChar = (char) alpha;
int numeric = 8 - (Location / 8);
buffer = buffer + str(alphaChar) + str(numeric);
return buffer;  
}
