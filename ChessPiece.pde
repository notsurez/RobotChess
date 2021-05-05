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
  boolean legalMoves[] = new boolean[64];
  
class ChessPiece {
  
  PImage wp, wr, wn, wb, wq, wk, bp, br, bn, bb, bq, bk; //Initialize individual PImages for each piece
  float x, y, size;
  int bbIndex; //Variable to store the bit board index of each piece (0-63)
  char pieceType; 
  Boolean selected = false;
  boolean firstMove = false;
  
  boolean first = true; 
  boolean isPinnedup = false;   boolean isPinnedright = false;   boolean isPinneddown = false;   boolean isPinnedleft = false;  boolean isPinnednorthwest = false;  boolean isPinnednortheast = false;   boolean isPinnedsouthwest = false;   boolean isPinnedsoutheast = false;
  boolean southwest = false, southeast = false, northeast = false , northwest = false, up = false, right = false, down = false, left = false;
  boolean whiteinchecksw = false, whiteincheckse = false, whiteinchecknw = false,whiteincheckne = false, whiteincheckup = false, whiteincheckrt = false,whiteincheckdn = false,whiteinchecklt = false, whiteincheckknight = false, whiteincheckpawn = false;
  boolean blackincheck = false;
  boolean whiteincheckking = false;
  boolean incheck[] = new boolean[64];
  boolean kingcheck = false;
  
  //byte BitBoard[] = new byte[64];
  
  ChessPiece(char pt, float xpos, float ypos,float s, int bitBI){
    imageMode(CENTER);

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

    //println(BitBoard[bbIndex]); //Print which 

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
    //for(int i = 0; i < 64; i++) {
    // print(legalMoves[i]);
    // if(i == 7 || i == 15 || i == 23 || i == 31 || i == 39 || i == 47 || i == 55) {
    //   println();
    // }
    //}
    println(" ");
    //print("base64 string: ");
    //println(toBase64(BitBoard, false, false, ((player_time / 60)*100) + (player_time % 60) + 1000, turnState)); //the bitboard, is castling, castling queen(false) or king(true), time string, player turn ('P' or 'p')
    
    //addMove(bbIndex, TobbIndex, true);
}
  
void fillArray() {
    boolean forward[] = new boolean[64];
    boolean backward[] = new boolean[64];
      blockedup = false;
      blockeddown = false;
      blockedleft = false;
      blockedright = false;
      blockednorthwest = false; 
      blockednortheast = false; 
      blockedsoutheast = false; 
      blockedsouthwest = false;
    //      for(int i = 0; i < 64; i++) {
    // print(legalMoves[i]);
    // if(i == 7 || i == 15 || i == 23 || i == 31 || i == 39 || i == 47 || i == 55) {
    //   println();
    // }
    //}
    if(selected){ 
   for(int i = 0; i < 64; i++) {
    if(isLegal1(bbIndex, i)) {
      forward[i] = true;
    }else{
      forward[i] = false;
    }
   }
  
   for(int i = 63; i > -1; i--) {
    if(isLegal2(bbIndex, i)) {
      backward[i] = true;
    }else{
      backward[i] = false;
    }
   }
   up = false;
   down = false;
   right = false;
   left = false;
   northwest = false;
   northeast = false;
   southwest = false;
   southeast = false;
   //println();
   //println(isPinnednorthwest);
   //println(isPinnednortheast);
   //println(isPinnedup);
   //println(isPinnedleft);
   //println(whiteinchecklt);
   //println(whiteincheckup);
   //println(whiteinchecknw);
   //println(whiteincheckne);
   if(isPinnednorthwest == true||isPinnednortheast == true||isPinnedup == true||isPinnedleft == true||whiteinchecklt == true||whiteincheckup == true||whiteinchecknw == true||whiteincheckne == true){
      for(int i = 0; i < 64; i++) {
    if(isLegal1(bbIndex, i)) {
      forward[i] = true;
    }else{
      forward[i] = false;
    }
   }
   }
 
   for(int i = 0; i < 64; i++) {
     if(forward[i] && backward[i]){
      legalMoves[i] = true;
     }else{
       legalMoves[i] = false;
     }
   }

}

}
  void testcheck(){
      for(int j = 0; j < 64; j++){
        TempBoard[j] = BitBoard[j];
      }
   
        for(int i = 0; i < 64;i++){
              for(int j = 0; j < 64; j++){
        BitBoard[j] = TempBoard[j];
      }
      up = false;
      right = false;
      down = false;
      left = false;
      northwest = false;
      northeast = false;
      southeast = false;
      southwest = false;
      whiteincheckup = false; 
      whiteincheckrt = false;
      whiteincheckdn = false;
      whiteinchecklt = false;
      whiteinchecknw = false;
      whiteincheckne = false;
      whiteinchecksw = false;
      whiteincheckse = false;
      whiteincheckknight = false;
      whiteincheckpawn = false;
      whiteincheckking = false;
                if(legalMoves[i] == false){
            legalMoves[i] = false;
          }
          if(legalMoves[i] == true){
            BitBoard[i] = BitBoard[bbIndex];
            BitBoard[bbIndex] = ' ';
for(int k = 0; k < 64; k++){
  isLegal1(i,k);
}

for(int k = 63; k > -1; k--){
  isLegal2(i,k);
}
//          for(int z = 0; z < 64; z++) {
//     print((char)BitBoard[z]);
//     if(z == 7 || z == 15 || z == 23 || z == 31 || z == 39 || z == 47 || z == 55) {
//       println();
//     }
//    }

if(whiteinchecknw||whiteincheckne||whiteinchecksw||whiteincheckse||whiteincheckup||whiteinchecklt||whiteincheckdn||whiteincheckrt||whiteincheckknight||whiteincheckpawn||whiteincheckking){
  legalMoves[i] = false;
}
          }
        }
          
        for(int j = 0; j < 64; j++){
        BitBoard[j] = TempBoard[j];
      }

  }
  void kingincheck(){
          for(int j = 0; j < 64; j++){
        TempBoard[j] = BitBoard[j];
      }
  int kingpos = positionOfPlayerKing();
  for(int z = 0; z < 64; z++){
                  for(int j = 0; j < 64; j++){
        BitBoard[j] = TempBoard[j];
      }
      kingcheck = false;
      up = false;
      right = false;
      down = false;
      left = false;
      northwest = false;
      northeast = false;
      southeast = false;
      southwest = false;
            blockedup = false;
      blockeddown = false;
      blockedleft = false;
      blockedright = false;
      blockednorthwest = false; 
      blockednortheast = false; 
      blockedsoutheast = false; 
      blockedsouthwest = false;
      whiteincheckup = false; 
      whiteincheckrt = false;
      whiteincheckdn = false;
      whiteinchecklt = false;
      whiteinchecknw = false;
      whiteincheckne = false;
      whiteinchecksw = false;
      whiteincheckse = false;
      whiteincheckknight = false;
      whiteincheckpawn = false;
      whiteincheckking = false;
      if(legalMoves[z] == false){
        legalMoves[z] = false;
      }
      if(legalMoves[z] == true){
        BitBoard[z] = BitBoard[bbIndex];
            BitBoard[bbIndex] = ' ';
      for(int k = 0; k < 64; k++){
  isLegal1(kingpos,k);
}

for(int k = 63; k > -1; k--){
  isLegal2(kingpos,k);
}
if(whiteinchecknw||whiteincheckne||whiteinchecksw||whiteincheckse||whiteincheckup||whiteinchecklt||whiteincheckdn||whiteincheckrt||whiteincheckknight||whiteincheckpawn||whiteincheckking){
  legalMoves[z] = false;
  }
  }
  }
          for(int j = 0; j < 64; j++){
        BitBoard[j] = TempBoard[j];
      }
  }
    
  float m = 0, x_1 = 0, x_2 = 0, y_1 = 0, y_2 = 0;
  float d = 0;
  boolean blockedup = false, blockeddown = false, blockedleft = false, blockedright = false, blockednorthwest = false, blockednortheast = false, blockedsoutheast = false, blockedsouthwest = false;
  boolean blockeduppin = false, blockedrightpin = false, blockeddownpin = false, blockedleftpin = false, blockednorthwestpin = false, blockednortheastpin =false, blockedsoutheastpin = false, blockedsouthwestpin = false;
  //Tim, put your logic in here
boolean isLegal1(int From, int To){
    boolean IsitLegal = false;
    if (From == -1) return false;
    byte PlayersPiece = BitBoard[From];
    m = 0; x_1 = 0; x_2 = 0; y_1 = 0; y_2 = 0;
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
      d = sqrt(sq(x_2-x_1)+sq(y_2-y_1));
    
    switch(PlayersPiece){
      case 'P': // White Pawn
        if(From >= 48 && From < 56){//Condition for testing if the pawn is on the 2nd rank and can move two squares
          if(To-From == -16 || To-From == -8){
          IsitLegal = true;
          if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
        if(BitBoard[To] == 'P'||BitBoard[To] == 'R'||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
            return false;
        }
          }
        }
                
      if(To-From == -8){ //Condition for testing if the pawn is moving one square
        IsitLegal = true;
              if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
        if(BitBoard[To] == 'P'||BitBoard[To] == 'R'||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
            return false;
        }
            }

      if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p'||BitBoard[To] =='q'||BitBoard[To] =='b'||BitBoard[To] == 'n'||BitBoard[To] == 'r')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
              }
      }
      
  break;
           
      case 'R': //White Rook
           if((x_2 == x_1&&(y_2 < y_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         //blockedup = true;
         IsitLegal = false;
       }
     }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From)&&down == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         down = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      down = true;
      IsitLegal = true;
     }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         //blockedleft = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From)&&right == false)){
       IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         right = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      right = true;
      IsitLegal = true;
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
    if((m == -1)&&(y_2 > y_1)&&(southwest == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'P' ||BitBoard[To] == 'R' ||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
          southwest = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          southwest = true;
          IsitLegal = true;
        }
      }
      if((m == 1)&&(y_2 > y_1)&&(southeast == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'P' ||BitBoard[To] == 'R' ||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
          southeast = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          southeast = true;
          IsitLegal = true;
        }
      }
      if((m == -1)&&(y_2 < y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R'||BitBoard[To] == 'N'||BitBoard[To] == 'B'||BitBoard[To] == 'Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K'){
          IsitLegal = false;
        }
      }
       if((m == 1)&&(y_2 < y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R'||BitBoard[To] == 'N'||BitBoard[To] == 'B'||BitBoard[To] == 'Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K'){
          IsitLegal = false;
        }
      }
      break;
      
      case 'Q': //White Queen  
       if((m == -1)&&(y_2 > y_1)&&(southwest == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'P' ||BitBoard[To] == 'R' ||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
          southwest = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          southwest = true;
          IsitLegal = true;
        }
      }
      if((m == 1)&&(y_2 > y_1)&&(southeast == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'P' ||BitBoard[To] == 'R' ||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
          southeast = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          southeast = true;
          IsitLegal = true;
        }
      }
      if((m == -1)&&(y_2 < y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R'||BitBoard[To] == 'N'||BitBoard[To] == 'B'||BitBoard[To] == 'Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K'){
          IsitLegal = false;
        }
      }
       if((m == 1)&&(y_2 < y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R'||BitBoard[To] == 'N'||BitBoard[To] == 'B'||BitBoard[To] == 'Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K'){
          IsitLegal = false;
        }
      }
      if((x_2 == x_1&&(y_2 < y_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         //blockedup = true;
         IsitLegal = false;
       }
     }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From)&&down == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         down = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      down = true;
      IsitLegal = true;
     }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         //blockedleft = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From)&&right == false)){
       IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P')){
         right = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      right = true;
      IsitLegal = true;
       }
     }     
        if(To > 63 ||To < 0){ //Returns false if the knight is moved off the board
        return false;
      }  
     
      break;
      case 'K': //White King
      if((m == -1)&&(y_2 > y_1)&&(southwest == false)){
         if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'r'||BitBoard[To] == 'k'){
             southwest = true;
           }
       if((BitBoard[To] == 'b'||BitBoard[To] == 'q')){
         whiteinchecksw = true;
         southwest = true;
       }
      }
        if((abs(m) == 0.5||abs(m) == 2)&&(d == sqrt(5))){
             if(BitBoard[To] == 'n'){ 
        whiteincheckknight= true;
      }
     }      
      if((m == 1)&&(y_2 > y_1)&&(southeast == false)){
                 if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'r'||BitBoard[To] == 'k'){
             southeast = true;
           }
       if((BitBoard[To] == 'b'||BitBoard[To] == 'q')){
         whiteincheckse = true;
         southeast = true;
       }
      }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From)&&down == false)){
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'b'||BitBoard[To] == 'k'){
             down = true;
           }
        if((BitBoard[To] == 'r'||BitBoard[To] == 'q')){
         whiteincheckdn = true;
         down = true;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From)&&right == false)){
             if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'b'||BitBoard[To] == 'k'){
             right= true;
           }
       if((BitBoard[To] == 'r'||BitBoard[To] == 'q')){
         whiteincheckrt = true;
         right = true;
       }
     }
           if((d == sqrt(2)) && (y_2 < y_1)){ 
              if(BitBoard[To] == 'p'){ 
        whiteincheckpawn = true;
      }
      }
                      if((abs(m) == 0.5||abs(m) == 2)&&(d == sqrt(5))){
             if(BitBoard[To] == 'n'){ 
               whiteincheckknight = true;
      }
                      } 
            if(d == 1||d == sqrt(2)){
       if(BitBoard[To] == 'k'){
         whiteincheckking = true;
       }
     }
          if(whiteincheckking){
            return false;
          }
                      
      if(whiteincheckrt == false&&whiteincheckdn == false&&whiteinchecklt == false&&whiteincheckup == false && whiteinchecknw==false && whiteincheckne==false && whiteinchecksw == false && whiteincheckse == false){

            
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'k'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'k'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      //castling logic
      if(which_side == 'w') {
        if(To == 58 && queenside_cherry == true && BitBoard[57] == ' ' && BitBoard[58] == ' ' && BitBoard[59] == ' ') IsitLegal = true;
        if(To == 62 &&  kingside_cherry == true && BitBoard[61] == ' ' && BitBoard[62] == ' ') IsitLegal = true;
      }else{
        if(To == 61 && queenside_cherry == true && BitBoard[60] == ' ' && BitBoard[61] == ' ' && BitBoard[62] == ' ') IsitLegal = true;
        if(To == 57 &&  kingside_cherry == true && BitBoard[57] == ' ' && BitBoard[58] == ' ') IsitLegal = true;
      }
      }
      if(whiteincheckrt == true){
                if(To-From == 1){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteinchecklt == true){
        if(To-From == -1){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
                if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckup == true){
                if(To-From == -8){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
               if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteincheckdn == true){
        if(To-From == 8){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                 
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteinchecksw == true){
        if(To-From == 7){
                        if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteincheckse == true){
                if(To-From == 9){
                        if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -8||To-From == - 7||To-From == -1||To-From == 1||To-From == 7|| To-From == 8){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
    
      }
      if(whiteincheckne == true){
        if(To-From == -7){
                         
                       if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
 if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteinchecknw == true){
        if(To-From == -7){
                               if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
                      
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      
      if(whiteincheckpawn == true){
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      }
      if(whiteincheckknight == true && whiteincheckpawn == false && whiteincheckup == false && whiteinchecklt == false && whiteincheckdn == false && whiteincheckrt == false && whiteinchecknw == false && whiteincheckne == false && whiteincheckse == false && whiteinchecksw == false){
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
              
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
            }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      }
      if(whiteincheckknight == true && whiteinchecknw == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      if(whiteincheckknight == true && whiteincheckne == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      if(whiteincheckknight == true && whiteincheckse == true){
                if(To-From == -8||To-From == - 7||To-From == -1||To-From == 1||To-From == 7|| To-From == 8){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckknight == true && whiteinchecksw == true){
                if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckknight == true && whiteincheckup == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      if(whiteincheckknight == true && whiteincheckrt == true){
                if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
  if(whiteincheckknight == true && whiteincheckdn == true){
            if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                 
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteincheckknight == true && whiteinchecklt == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      if(whiteincheckknight == true && whiteincheckpawn == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      }   
      break;
      }
    return IsitLegal;
  }

   boolean isLegal2(int From, int To){
    boolean IsitLegal = false;
    if (From == -1) return false;
    byte PlayersPiece = BitBoard[From];
    m = 0; x_1 = 0; x_2 = 0; y_1 = 0; y_2 = 0;
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
      d = sqrt(sq(x_2-x_1)+sq(y_2-y_1));
    
    switch(PlayersPiece){
      case 'P': // White Pawn
                   if((x_2 == x_1&&(y_2 < y_1)&&(To != From)&&up == false)){
                     IsitLegal = true;
         if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'b'||BitBoard[To] == 'k'||BitBoard[To] == 'r'||BitBoard[To] == 'q'){
             up = true;
             return false;
           }
     }
     if(up == false){
        if(From >= 48 && From < 56){//Condition for testing if the pawn is on the 2nd rank and can move two squares
          if(To-From == -16 || To-From == -8){
          IsitLegal = true;
          if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
        if(BitBoard[To] == 'P'||BitBoard[To] == 'R'||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
            return false;
        }
          }
        }
                
      if(To-From == -8){ //Condition for testing if the pawn is moving one square
        IsitLegal = true;
              if(BitBoard[To] == 'p' ||BitBoard[To] == 'r' ||BitBoard[To] == 'b'||BitBoard[To] == 'n'||BitBoard[To] == 'q'||BitBoard[To] == 'k'){
          return false;
        }
        if(BitBoard[To] == 'P'||BitBoard[To] == 'R'||BitBoard[To] == 'B'||BitBoard[To] == 'N'||BitBoard[To] == 'Q'||BitBoard[To] == 'K'){
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
     }
     
     if (up == true){
         if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p'||BitBoard[To] =='q'||BitBoard[To] =='b'||BitBoard[To] == 'n'||BitBoard[To] == 'r')){ // Condition to test if the pawn is making a capture
           IsitLegal = true;
           if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }  
     }
      break;
           
      case 'R': //White Rook
       if((x_2 == x_1&&(y_2 < y_1)&&(To != From)&&up == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         up = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      up = true;
      IsitLegal = true;
     }
     }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         //blockeddown = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From)&&left == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         left = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      left = true;
      IsitLegal = true;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From))){
       IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         //blockedright = true;
         IsitLegal = false;
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
     if((m == 1)&&(y_2 < y_1)&&(northwest == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          northwest = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          northwest = true;
          IsitLegal = true;
        }
      }
      if((m == -1)&&(y_2 < y_1)&&(northeast == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          northeast = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          northeast = true;
          IsitLegal = true;
        }
      }
      
      if(( m == 1)&&(y_2 > y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          IsitLegal = false;
        }
      }
      if((m == -1)&&(y_2 > y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          IsitLegal = false;
        }
      }
      break;
      
      case 'Q': //White Queen
   if((m == 1)&&(y_2 < y_1)&&(northwest == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          northwest = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          northwest = true;
          IsitLegal = true;
        }
      }
      if((m == -1)&&(y_2 < y_1)&&(northeast == false)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          northeast = true;
          IsitLegal = false;
        }
        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
          northeast = true;
          IsitLegal = true;
        }
      }
      if(( m == 1)&&(y_2 > y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          IsitLegal = false;
        }
      }
      if((m == -1)&&(y_2 > y_1)){
        IsitLegal = true;
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
          IsitLegal = false;
        }
      }
             if((x_2 == x_1&&(y_2 < y_1)&&(To != From)&&up == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         up = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      up = true;
      IsitLegal = true;
     }
     }
     if((x_2 == x_1&&(y_2 > y_1)&&(To != From))){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         //blockeddown = true;
         IsitLegal = false;
       }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From)&&left == false)){
         IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         left = true;
         IsitLegal = false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
      left = true;
      IsitLegal = true;
       }
     }
     if((y_2 == y_1&&(x_2 > x_1)&&(To != From))){
       IsitLegal = true;
       if((BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'K')){
         //blockedright = true;
         IsitLegal = false;
       }
     }
      break;
      
      case 'K': //White King
         if((m == 1)&&(y_2 < y_1)&&(northwest == false)){
           if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'r'||BitBoard[To] == 'k'){
             northwest = true;
           }
       if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
      northwest = true;
      whiteinchecknw = true;
       }
      }
      if((m == -1)&&(y_2 < y_1)&&(northeast == false)){
               if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         //println("this has been reached");
      northeast = true;
      whiteincheckne = true;
               }
               
           if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'r'||BitBoard[To] == 'k'){
             northeast = true;
             //println("This piece triggered the cherry");
             //println((char)BitBoard[To]);
           }
      }
    if((x_2 == x_1&&(y_2 < y_1)&&(To != From)&&up == false)){
         if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'b'||BitBoard[To] == 'k'){
             up = true;
           }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
      up = true;
      whiteincheckup = true;
       }
     }
     if((y_2 == y_1&&(x_2 < x_1)&&(To != From)&&left == false)){
        if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'n'||BitBoard[To] == 'p'||BitBoard[To] == 'b'||BitBoard[To] == 'k'){
             left = true;
           }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
      left = true;
      whiteinchecklt = true;
       }
     }
          if((abs(m) == 0.5||abs(m) == 2)&&(d == sqrt(5))){
             if(BitBoard[To] == 'n'){ 
        whiteincheckknight = true;
      }
     }
     if(d == 1||d == sqrt(2)){
       if(BitBoard[To] == 'k'){
         whiteincheckking = true;
       }
     }
        if(whiteincheckrt == false&&whiteincheckdn == false&&whiteinchecklt == false&&whiteincheckup == false && whiteinchecknw==false && whiteincheckne==false && whiteinchecksw == false && whiteincheckse == false){
                
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'k'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'||BitBoard[To] == 'k'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      if(which_side == 'w') {
        if(To == 58 && queenside_cherry == true && BitBoard[57] == ' ' && BitBoard[58] == ' ' && BitBoard[59] == ' ') IsitLegal = true;
        if(To == 62 &&  kingside_cherry == true && BitBoard[61] == ' ' && BitBoard[62] == ' ') IsitLegal = true;
      }else{
        if(To == 61 && queenside_cherry == true && BitBoard[60] == ' ' && BitBoard[61] == ' ' && BitBoard[62] == ' ') IsitLegal = true;
        if(To == 57 &&  kingside_cherry == true && BitBoard[57] == ' ' && BitBoard[58] == ' ') IsitLegal = true;
      }
      }
      if(whiteincheckking == true){
        return false;
      }
      if(whiteincheckrt == true){
                if(To-From == 1){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteinchecklt == true){
        if(To-From == -1){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
                if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckup == true){
                if(To-From == -8){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
               if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteincheckdn == true){
        if(To-From == 8){
                        if(BitBoard[To] == 'r'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                 
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteinchecksw == true){
        if(To-From == 7){
                        if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteincheckse == true){
                if(To-From == 9){
                        if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
        if(To-From == -8||To-From == - 7||To-From == -1||To-From == 1||To-From == 7|| To-From == 8){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
    
      }
      if(whiteincheckne == true){
        if(To-From == -7){
                         
                       if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
 if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      if(whiteinchecknw == true){
        if(To-From == -7){
                               if(BitBoard[To] == 'b'||BitBoard[To] == 'q'){
         IsitLegal = true;
      }
        }
                      
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      }
      }
      if(whiteincheckpawn == true){
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      }
      if(whiteincheckknight == true && whiteincheckpawn == false && whiteincheckup == false && whiteinchecklt == false && whiteincheckdn == false && whiteincheckrt == false && whiteinchecknw == false && whiteincheckne == false && whiteincheckse == false && whiteinchecksw == false){
        if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
      }
            if(whiteincheckknight == true && whiteinchecksw == true){
                if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      
      if(whiteincheckknight == true && whiteincheckse == true){
        if(To-From == -8||To-From == - 7||To-From == -1||To-From == 1||To-From == 7|| To-From == 8){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
    
      }
    
      if(whiteincheckknight == true && whiteinchecknw == true){
                if(To-From == -8||To-From == - 7||To-From == -1||To-From == 1||To-From == 7|| To-From == 8){
                         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckknight == true && whiteincheckne == true){
                if(To-From == -9||To - From == -8||To - From == -1||To - From == 1|| To - From == 8 || To - From == 9){         
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      if(whiteincheckknight == true && whiteincheckdn == true){
                if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){
                 
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
        
      }
      
      if(whiteincheckknight == true && whiteincheckrt == true){
                if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
  if(whiteincheckknight == true && whiteincheckup == true){
            if(To-From == -9||To - From == -1|| To - From == 7|| To-From == -7||To - From == 1|| To-From == 9){        
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }   
      }
      if(whiteincheckknight == true && whiteinchecklt == true){
         if((To-From == -7||To - From == -8||To - From == -9||To - From == 7||To - From == 8||To - From == 9)){
          IsitLegal = true;
                if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
              if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
        }
      }
      
      if(whiteincheckknight == true && whiteincheckpawn == true){
                if((To-From == -7||To-From == -9) && (BitBoard[To] == 'p')){ // Condition to test if the pawn is making a capture
        IsitLegal = true;
      }
            if(d == 1||d == sqrt(2)){
        IsitLegal = true;
              if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){ // Condition to test if the pawn is trying to move to a square occupied by a friendly piece
        return false;
      }
      }
              if((To-From == -7||To-From == -9)){ // Condition to test if the pawn is making a capture
       if(BitBoard[To] == 'R' ||BitBoard[To] =='N'||BitBoard[To] == 'B'||BitBoard[To] =='Q'||BitBoard[To] =='K'||BitBoard[To] == 'P'){
         return false;
       }
       if(BitBoard[To] == 'r'||BitBoard[To] == 'n'||BitBoard[To] == 'b'||BitBoard[To] == 'q'||BitBoard[To] == 'k'||BitBoard[To] == 'p'){
         IsitLegal = true;
      }
              }
      
      if(To > 63 ||To < 0){ //Returns false if the king is moved off the board
        return false;
      } 
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
}//end of class

void addMove(int fromLocation, int toLocation, boolean tellStockfish) {
  heardBestmove = false;
  if (fromLocation == toLocation) return;
  //if (turnState == 'P') movesHistory = movesHistory + "\n"; //P for white/player, p for black/computer
  if (cherry < 50) return;
  cherry = 0;
  
  //If the rook or the king moves, set castling rights to false
  if(which_side == 'w'){
    if (fromLocation == 56 || fromLocation == 60) queenside_cherry = false;
    if (fromLocation == 63 || fromLocation == 60) kingside_cherry = false;
  }else if(which_side == 'b'){
    if (fromLocation == 63 || fromLocation == 59) queenside_cherry = false;
    if (fromLocation == 56 || fromLocation == 59) kingside_cherry = false;
  }

  if (promoted_player_cherry == false) movesHistory = movesHistory + bbCoordString(fromLocation) + bbCoordString(toLocation) + " ";
  if (promoted_player_cherry == true)  movesHistory = movesHistory + bbCoordString(fromLocation) + bbCoordString(toLocation) + (char)(promoted_pawn ^ 0x20) + " ";
  promoted_player_cherry = false;
  println(castling_occured);
  if (board_connected == true) {
    println("sending white move to uCPU: " + bbCoordString(fromLocation) + bbCoordString(toLocation) + str(((player_time / 60)*100) + (player_time % 60) + 1000) + turnState);
    microPC.write(bbCoordString(fromLocation));
    microPC.write(bbCoordString(toLocation));
    microPC.write(str(((player_time / 60)*100) + (player_time % 60) + 1000));
    microPC.write(turnState);
    microPC.write(turnState);
    delay(250);
  }
  
  if (tellStockfish) {
    generate_fen();
  stockfish.say("position fen " + new_fen + movesHistory);
  movesHistory = " moves ";
  delay(20);
  stockfish.say("go movetime 1000"); //replace the 1000 with the amount of time to run engine in millis
  m = millis();
  for(int t = 1; t < 20; t++) {
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

byte positionOfPlayerKing() {
  //return the location of the player's king
  for(byte c = 0; c < 64; c++) {
    if (BitBoard[c] == 'K') return c;
  }
  return -1; //error
}
