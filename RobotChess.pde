/*
  Driver file for the the "Robot Chess" project
  
  Written by: Christian Brazeau, Timothy Reichert, and Peter Taranto
  Last modified: 04/29/2021
*/

import processing.serial.*;

Star[] stars;           //initialize array of Star objects (used for start menu)
ChessPiece[][] board;   // Initialize 2d array of ChessPiece Objects
Engine stockfish;       // Create new chess engine object (see Engine.pde)
String path = "C:\\Users\\cwbra\\Documents\\Stockfish\\stockfish_20090216_x64_bmi2.exe"; //Path for UCI Chess engine

//Initialize button objects (I will add more buttons when we start making menus)
Button start_button; 
Button menu_button;
Button returnToMenu;
Button black, white, random, diff_slider, resign, Q, R, B, N;

//setup variables
char which_side = 'w';
int cpu_diff = 1600;
int player_time = 900;
int computer_time = 900;
boolean show_analysis = true;

//Global variables for the size of different elements in the GUI, I should have made this dynamic
int boardSize = 800;
float gridSize = boardSize/8;
int pieceSize = (int)gridSize;

int pressed_x = 0;
int pressed_y = 0;
int the_x = 0;
int the_y = 0;

int cpuAnal = 0; //centipawns or number of moves until forced mate
boolean forced_mate = false;
boolean game_gg = false;
int gg_countdown = 300;
float bar_pos = 400;

float cpuY = 60;
float cpuX = 870;
float playerX = 870;
float playerY = 180;

int game_state = 0; //initialize game state variable used to toggle between (game, menu, endgame, etc)

long cherry = 0;

char newPiece = ' ';
int bbcIndex = 420;

//A string storing the current board state in FEN notation
String cur_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
String blk_fen = "rnbqkbnr/pppp1ppp/8/4p3/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

byte BitBoard[] = new byte[64];
byte TempBoard[] = new byte[64];

char turnState = 'P'; //P for white/player, p for black/computer

String movesHistory = " moves ";
String evalString = "e2e4";
//long frameCounter = 0;

boolean castling_occured = false;
boolean castline_side = false;      //false = queenside, true = kingside

char promoted_pawn = 'Q';     //what will the promoted pawn become
char promoted_cpu_pawn = 'p'; //what the cpu promoted its pawn to
boolean promotionNotSelected = true;

void setup() { 
  for(int i = 0; i < 64; i++) BitBoard[i] = ' ';
  
  size(1200,800);
  background(50,50,70);
  
  int dia = int(random(1,6));
  int numbStars = width;
  stars = new Star[numbStars];
  for(int i = 0; i < stars.length; i++){
    float x = random(width);
    dia = int(random(1,5));
    stars[i] = new Star(x,random(height),dia,dia, random(10,255));
  }
  //initialize all buttons
  start_button = new Button("Start Game", width/2, height/2, 300, 75, color(255), color(0), 50);
  menu_button = new Button("Setup Game", width/2, height/2+100, 300, 75, color(255), color(0), 50);
  random = new Button("Rand", width/2, 150, 60, 60, color(255), color(0), 20);
  white = new Button("White", width/2-150, 150, 60, 60, color(255), color(0), 20);
  black = new Button("Black", width/2+150, 150, 60, 60, color(0), color(255), 20);
  white.active = true;
  
  diff_slider = new Button(" ", width/2, 300, 30, 50, color(40), color(0), 20);
  
  resign = new Button("Resign", width-65, 140, 75, 60, color(255), color(0), 20);
  returnToMenu = new Button("Main Menu", width/2, height/2+150, 300, 75, color(255), color(0), 50);
  //Promotion buttons
  Q = new Button("Q", boardSize+100, height/2.5, 60, 60, color(255), color(0), 30);
  R = new Button("R", boardSize+180, height/2.5, 60, 60, color(255), color(0), 30);
  B = new Button("B", boardSize+260, height/2.5, 60, 60, color(255), color(0), 30);
  N = new Button("N", boardSize+340, height/2.5, 60, 60, color(255), color(0), 30);
  Q.active = true;
  stockfish = new Engine(path);
  stockfish.init();
  
  board = new ChessPiece[8][8];
  //readFen(cur_fen);
  //drawPieces();
  
  //uCPUinit(0); //use the 2nd COM port
}

void draw() {  
  cherry++;
  //println((int) floor(mouseX/(int)gridSize)+floor(mouseY/(int)gridSize)*8);
  //println((mouseX)/100 + 8*((mouseY)/100));
  //print("mouseX: ");
  //print(mouseX);
  //print(" mouseY: ");
  //println(mouseY);
  
  switch(game_state){
  //Start Menu
  case 0:
    startMenu();
  break;
  
  //Setup Menu
  case 1:
    setup_menu();
  break;
  
  case 2:
    drawBoard();
    drawPieces();
    keepTime();
    exampleCPUAnal();
    
    resign.display();
    if(game_gg == true) game_state = 3;
    //println("running drawfunc");
    //stockfish.drawfunc(); //if (frameCounter % 10 == 0) ...
    //frameCounter++;
    //println("made it out alive");
  break;
  
  case 3:
    if (gg_countdown >  0) gg_countdown--;
    if (gg_countdown == 0) lossCard();
  break;
  
  default:
  }
  
  if (bbcIndex == 400) updatePieces();
  if (bbcIndex != 420) bbcIndex = 400;
}//end "draw" function

//Function to draw the chess board itself, string for which side the player is on
void drawBoard(){
  color g_color;
  color g_color_w = color(246, 232, 177);
  color g_color_b = color(10, 130, 30);
  g_color = g_color_w;
  
  for(float i = 0; i<8; i++){
      for(float j = 0; j<8; j++){
        fill(g_color);
        noStroke();
        rect(j*gridSize,i*gridSize,gridSize,gridSize);
        fill(0);
        //text(num, g_x+20,g_y+20);
        //Change the color after each square
        if(g_color == g_color_b){
          g_color = g_color_w;
        }else{
          g_color = g_color_b;
        }
        
      }//inner for loop
      
      //Change the color after each square
        if(g_color == g_color_b){
            g_color = g_color_w;
          }else{
            g_color = g_color_b;
          }
  }//outer for loop
}// end "drawBoard"


//Function to read a fen string and initialize required variables for legal move logic
void readFen(String curFen){
  String fen = curFen;
  int row = 0;
  int col = 0;
  int i = 0;
  
  //First loop exclusively for reading piece postion, forecully terminates upon reading a ' ' (space)
  while(fen.charAt(i) != ' '){
    if(fen.charAt(i) == '/'){
      row++;
      col=0;
    }else if( (int)fen.charAt(i) <= 114 && (int)fen.charAt(i) >= 65) {
      board[col][row] = new ChessPiece(fen.charAt(i), col*gridSize+(gridSize/2), row*gridSize+(gridSize/2), pieceSize, 8*row+col);
      BitBoard[8*row+col] = (byte)fen.charAt(i);
      col++;
    }else if( (int)fen.charAt(i) <= 56 && (int)fen.charAt(i) >= 49) {
      for(int j = i; j < (int)fen.charAt(i)-48; j++) {
        BitBoard[8*row+col] = ' ';
      }
          col += ((int)fen.charAt(i)-48);
    }
    i++;
  }
}

void drawPieces() {
  for (int i = 0; i<8; i++){
    for (int j = 0; j<8; j++) { 
      if (board[i][j] != null){
        board[i][j].display();//piece
        board[i][j].MouseIsOver();
        board[i][j].move();
        board[i][j].fillArray();
        board[i][j].highlightLegal();
      }
    }
  }
}

void updatePieces() {
  
  for (int i = 0; i<8; i++) {
    for (int j = 0; j<8; j++) { 
      if (board[i][j] != null) {
        board[i][j].x=0;
        board[i][j].y=0;
      }
    }
  }
  
       bbcIndex = (int) floor(pressed_x/(int)gridSize)+floor(pressed_y/(int)gridSize)*8;
  int TobbIndex = (int) floor(the_x/(int)gridSize)+floor(the_y/(int)gridSize)*8;
  
  if (BitBoard[bbcIndex] == 'K' && TobbIndex-bbcIndex ==  2) { //kingside  castle white
          BitBoard[61] = 'R';
          BitBoard[63] = ' ';
        }
        if (BitBoard[bbcIndex] == 'K' && TobbIndex-bbcIndex == -2) { //queenside castle white
          BitBoard[59] = 'R';
          BitBoard[56] = ' ';
        }
        if (BitBoard[bbcIndex] == 'k' && TobbIndex-bbcIndex ==  2) { //kingside  castle black
          BitBoard[5]  = 'r';
          BitBoard[7]  = ' ';
        }
        if (BitBoard[bbcIndex] == 'k' && TobbIndex-bbcIndex == -2) { //queenside castle black
          BitBoard[3]  = 'r';
          BitBoard[0]  = ' ';
        }
  
  if (BitBoard[bbcIndex] == 'P' && TobbIndex < 8) newPiece = promoted_pawn;
  if(TobbIndex != ' ') {
    BitBoard[TobbIndex] = ' ';
  }
  
  BitBoard[bbcIndex] = ' ';
  BitBoard[TobbIndex] = (byte)newPiece;
  turnState = 'C';
  addMove(bbcIndex, TobbIndex, true);
  turnState = 'P';
  
  for (int i = 0; i<8; i++) {
    for (int j = 0; j<8; j++) { 
      if (board[i][j] != null) {
        if (board[i][j].pieceType == 'k' || board[i][j].pieceType == 'q' || board[i][j].pieceType == 'r' || board[i][j].pieceType == 'n' || board[i][j].pieceType == 'b' || board[i][j].pieceType == 'p') board[i][j].testcheck((8*i) + j);
      }
    }
  }
  
      // Print BitBoard for debugging
    println("Print BitBoard for debugging");
    for(int i = 0; i < 64; i++) {
     print((char)BitBoard[i]);
     if(i == 7 || i == 15 || i == 23 || i == 31 || i == 39 || i == 47 || i == 55) {
       println();
     }
    }
    println(" ");
  
  println(movesHistory);
  
  print("Emulated serial communications --> ");
  println(str(toBase64(BitBoard, false, false, ((player_time / 60)*100) + (player_time % 60) + 1000, turnState))); //the bitboard, is castling, castling queen(false) or king(true), time string, player turn ('P' or 'p')
  
  for(int i = 0; i<64; i++) {
      board[i%8][floor(i/8)] = null;
  }
  for(int i = 0; i<64; i++) {
    if(BitBoard[i] != ' ') {
      board[i%8][floor(i/8)] = new ChessPiece((char)BitBoard[i], (i%8)*gridSize+(gridSize/2), floor(i/8)*gridSize+(gridSize/2), pieceSize, i);
    }else{
      board[i%8][floor(i/8)] = null;
    }
  }
  
  /*
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
    */
  
  bbcIndex = 420;
} //end of update pieces

/*
  Function for displaying the start menu
  This is what the user will be greated with when they first launch the program
*/
void startMenu() {
  background(0);
  //fill(255);
  for(int i = 0; i < stars.length;i++){
    stars[i].move();
    stars[i].display();
  }
  
  textAlign(CENTER, CENTER);
  textSize(100);
  fill(100,100,200);
  text("Robot Chess", width/2, height/4);
  start_button.display();
  menu_button.display();
}

void setup_menu() {
  background(0);
  noStroke();
  for(int i = 0; i < stars.length;i++){
    stars[i].move();
    stars[i].display();
  }
  //card
  fill(100);
  rect(width/2 - width/4, 50, width/2, height-100, 20);
  textAlign(CENTER,CENTER);
  fill(0);
  text("Choose player side", width/2, 75);
  white.display();
  random.display();
  black.display();
  
  if(diff_slider.active && mouseX < (width/2+250) && mouseX > width/2-250){
     diff_slider.x = mouseX;
     cpu_diff = (int)map(diff_slider.x, width/2-250, width/2+250, 1350, 2800);
  }
  fill(0);
  textAlign(CENTER,CENTER);
  text("CPU DIFFICULTY: " + cpu_diff, width/2, 250);
  fill(255,0,255);
  rect(width/2-250, 275, diff_slider.x-(width/2-250), 50, 10);
  fill(255);
  rect(diff_slider.x, 275, width/2+250-diff_slider.x, 50, 10);
  diff_slider.display();
  start_button.display();
}

//Built in processing function that runs whenever the mouse is clicked.
void mousePressed() {
  pressed_x = mouseX;
  pressed_y = mouseY;
  
  for (int i = 0; i<8; i++){
    for (int j = 0; j<8; j++) { 
      //do not allow picking up enemy pieces
      if (board[i][j] != null && (board[i][j].pieceType == 'K' || board[i][j].pieceType == 'Q' || board[i][j].pieceType == 'R' || board[i][j].pieceType == 'N' || board[i][j].pieceType == 'B' || board[i][j].pieceType == 'P')) {
        if(board[i][j].MouseIsOver()) {
          board[i][j].selected = true;
        }    
      }
    }
  }
  // If the start menu is pressed, advance the game menu.
 if(start_button.MouseIsOver() && game_state != 2) {
  newGame();
  game_state = 2; 
 }
 if(menu_button.MouseIsOver()  && game_state == 0) {
  game_state = 1; 
 }
 if(white.MouseIsOver()  && game_state == 1) {
   which_side = 'w'; 
  white.active = true; 
  black.active = false;
  random.active = false;
  cur_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
 }
 if(black.MouseIsOver()  && game_state == 1) {
  which_side = 'b';
   white.active = false; 
  black.active = true;
  random.active = false;
  cur_fen = blk_fen;
 }
 if(random.MouseIsOver()  && game_state == 1) {
  white.active = false; 
  black.active = false;
  random.active = true;
  int pick = ceil(random(2));
      if(pick == 1) {
        which_side = 'b';
        cur_fen = blk_fen;
      }else{
        which_side = 'w';
        cur_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
      }
    
 }
 if(diff_slider.MouseIsOver() && game_state == 1) {
   diff_slider.active = true;
 }
 
 if(resign.MouseIsOver() && game_state == 2) {
   game_gg = true;
 }
 
 if(Q.MouseIsOver() && game_state == 2) {
   Q.active = true;
   R.active = false;
   B.active = false;
   N.active = false;
   promoted_pawn = 'Q';
 }
 
  if(R.MouseIsOver() && game_state == 2) {
   Q.active = false;
   R.active = true;
   B.active = false;
   N.active = false;
   promoted_pawn = 'R';
 }
 
  if(B.MouseIsOver() && game_state == 2) {
   Q.active = false;
   R.active = false;
   B.active = true;
   N.active = false;
   promoted_pawn = 'B';
 }
 
 if(N.MouseIsOver() && game_state == 2) {
   Q.active = false;
   R.active = false;
   B.active = false;
   N.active =true;
   promoted_pawn = 'N';
 }
 
 if(returnToMenu.MouseIsOver() && game_state == 3) {
   game_state = 0;
 }
} //end of mousePressed

void mouseReleased() {
  the_x = mouseX;
  the_y = mouseY;
  
          int the_new_x = int(int(pressed_x/gridSize)*(gridSize)+gridSize/2);
          int the_new_y = int(int(pressed_y/gridSize)*(gridSize)+gridSize/2);
  
  diff_slider.active = false;
    
//    for (int i = 0; i < 8; i++){
//    for (int j = 0; j < 8; j++) { 
  int i = (the_new_x)/100;
  int j = (the_new_y)/100;
  
  if (i > 7 || j > 7) println("Overflow error!"); //this should never happen
    if (i < 8 && j < 8) {
      //do not allow moving enemy pieces
      if (board[i][j] != null && (board[i][j].pieceType == 'K' || board[i][j].pieceType == 'Q' || board[i][j].pieceType == 'R' || board[i][j].pieceType == 'N' || board[i][j].pieceType == 'B' || board[i][j].pieceType == 'P')) {
        if(board[i][j].MouseIsOver() && mouseX < boardSize && mouseY < boardSize) {
          board[i][j].selected = false;
          board[i][j].x = int(mouseX/gridSize)*(gridSize)+gridSize/2;
          board[i][j].y = int(mouseY/gridSize)*(gridSize)+gridSize/2;
          //board[i][j].updateBB();

          newPiece = (char) BitBoard[i+(8*j)]; 
          bbcIndex = board[i][j].bbIndex;
        }
      }
    }
//    }
//  }
}

void exampleCPUAnal(){
  //Indicator Bar
  int bound = 2500;
  if (forced_mate == false && game_gg == false) bar_pos = map(cpuAnal, -bound, bound, 20, 780);
  if(cpuAnal > bound){
     bar_pos = 780;
  }else if(cpuAnal < -bound){
     bar_pos =  20;
  }

  fill(0);
  rect(boardSize, 0, 50, bar_pos, 10);
  fill(255);
  rect(boardSize, bar_pos, 50, height, 10);
  textSize(13);
  if(bar_pos > height/2-5 ){
    fill(255);
  }else{
      fill(0);
  }

  if (game_gg == false) {
  if (forced_mate == false) text(nf((float)(0-cpuAnal)/100, 2, 2), boardSize + 5, height/2);
  if (forced_mate == true && cpuAnal < 0)   {
    text("+M" + str(abs(cpuAnal)), boardSize + 5, height/2);
    bar_pos = 0;
  }
  if (forced_mate == true && cpuAnal > -1)  {
    text("-M" + str(abs(cpuAnal)), boardSize + 5, height/2);
    bar_pos = 800;
  }
  }
  if (game_gg == true && turnState == 'P')  {
    text("0-1", boardSize + 5, height/2);
    bar_pos = 800;  
  }
  if (game_gg == true && turnState == 'C')  {
    text("1-0", boardSize + 5, height/2);
    bar_pos = 0;
  }
  textSize(25);
  fill(0);
  text("Pawn Promotion", boardSize + 60, height/2.5-50);
  
  text("Your Best Move: " + evalString, boardSize + 50, height - 70);
  fill(100);
  rect(boardSize+60, height/2.5-40, 320, 80, 15);
  Q.display();
  R.display();
  B.display();
  N.display();
}

//Star class for start menu background
class Star {
  float x, y;
  float diameter;
  float speed;
  float direction = 1;
  float fade;
  Star(float xpos, float ypos,float dia, float sp,float f){
    x = xpos;
    y = ypos;
    diameter = dia;
    speed = sp*0.3;
    fade = f; 
  }
  
  void move() {
    x += speed * direction;
    if(x >= width){
      x = 0;
      y = random(height);
    }
  }
  
  void display() {
    fill(255, fade);
    ellipse(x,y,diameter,diameter);
  }
}

//Button class for creating menus
class Button {
 float x, y, w, h;
 color c, t;
 String text;
 int ts;
 boolean active;
 int ol = 10;
 Button(String txt, float xp, float yp, float wt, float lt, color back_color, color txt_color, int text_size) {
   text = txt;
   x = xp;
   y = yp;
   w = wt;
   h = lt;
   c = back_color;
   t = txt_color;
   ts = text_size;
 }
 
 void display() {
   fill(50,255,50);
   if(active) rect(x-((w+ol)/2),y-((h+ol)/2),w+ol,h+ol,10);
   fill(c);
   rect(x-(w/2),y-(h/2),w,h,10);
   fill(t);
   textAlign(CENTER, CENTER);
   textSize(ts);
   text(text, x,y);
   textAlign(BASELINE);
 }
 
 //Function for determining if the mouse is over the button.
 boolean MouseIsOver() {
    if (mouseX > x-(w/2) && mouseX < x+(w/2) && mouseY > y-(h/2) && mouseY < y+(h/2)) {
      return true;
    }
    return false;
  }
}

void lossCard() {
  rectMode(CENTER);
  fill(75, 50, 200);
  rect(width/2, height/2, width/2.5, height - 200, 20);
  fill(200);
  rect(width/2, height/2, width/2.6, height - 220, 20);
  rectMode(CORNER);
  start_button.display();
  returnToMenu.display();
  game_gg = true;
}

void newGame() {
    gg_countdown = 300;
    game_gg = false;
    forced_mate = false;
    cpuAnal = 0;
    for(int i = 0; i < 8; i++) {
     for(int j = 0; j < 8; j++) {
      board[i][j] = null; 
      BitBoard[i*8+j] = ' ';
     }
    }
    readFen(cur_fen);
    stockfish.send_config();
    player_time = 900;
    computer_time = 900;
    movesHistory = " moves ";
}
