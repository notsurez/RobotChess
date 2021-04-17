/*
  Driver file for the the "Robot Chess" project
  
  Written by: Christian Brazeau
  Other Contributers:
  Last modified: 03/12/2021
*/
import processing.serial.*;

Star[] stars;           //initialize array of Star objects (used for start menu)
ChessPiece[][] board;   // Initialize 2d array of ChessPiece Objects
Engine stockfish;       // Create new chess engine object (see Engine.pde)
String path = "C:\\Users\\cwbra\\Documents\\Stockfish\\stockfish_20090216_x64_bmi2.exe"; //Path for UCI Chess engine

//Initialize button objects (I will add more buttons when we start making menus)
Button start_button; 
Button menu_button;
Button black, white, random;

//setup variables
char which_side = 'r';
int cpu_diff = 800;
int player_time = 900;
int computer_time = 900;
boolean show_analysis = true;

//Global variables for the size of different elements in the GUI, I should have made this dynamic
int boardSize = 800;
float gridSize = boardSize/8;
int pieceSize = (int)gridSize;

int game_state = 0; //initialize game state variable used to toggle between (game, menu, endgame, etc)

//A string storing the current board state in FEN notation
String cur_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1";
byte BitBoard[] = new byte[64];
char turnState = 'P'; //P for white/player, p for black/computer

//long frameCounter = 0;

/*
  setup is a 
*/
void setup() {
  
  for(int i = 0; i < 64; i++) BitBoard[i] = ' ';
  
  size(1200,800);
  background(50,50,70);
  
  int dia = int(random(1,5));
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
  random = new Button("Rand", width/2, 200, 60, 60, color(255), color(0), 20);
  white = new Button("White", width/2-100, 200, 60, 60, color(255), color(0), 20);
  black = new Button("Black", width/2+100, 200, 60, 60, color(0), color(255), 20);
  stockfish = new Engine(path);
  stockfish.init();
  
  board = new ChessPiece[8][8];
  readFen(cur_fen);
  //drawPieces();
  
  println("Initializing uCPU");
  //uCPUinit(1); //use the 2nd COM port
}

void draw() {  
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
    exampleCPUAnal();
    keepTime();
    //println("running drawfun");
    stockfish.drawfunc(); //if (frameCounter % 10 == 0) ...
    //frameCounter++;
    //println("made it out alive");
  break;
  default:
  }
  
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
        board[i][j].highlightLegal();
      }
    }
  }
}

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
  for(int i = 0; i < stars.length;i++){
    stars[i].move();
    stars[i].display();
  }
  //card
  fill(100);
  rect(width/2 - width/4, 50, width/2, height-100, 20);
  
  white.display();
  random.display();
  black.display();
  
  start_button.display();
}

//Built in processing function that runs whenever the mouse is clicked.
void mousePressed() {
  for (int i = 0; i<8; i++){
    for (int j = 0; j<8; j++) { 
      if (board[i][j] != null){
        if(board[i][j].MouseIsOver()) {
          board[i][j].selected = true;
        }
        
      }
    }
  }
  // If the start menu is pressed, advance the game menu.
 if(start_button.MouseIsOver() && game_state !=2 ) {
  game_state = 2; 
  stockfish.send_config();
 }
 if(menu_button.MouseIsOver()  && game_state != 2) {
  game_state = 1; 
 }
 
} //end of mousePressed

void mouseReleased() {
    for (int i = 0; i<8; i++){
    for (int j = 0; j<8; j++) { 
      if (board[i][j] != null){
        if(board[i][j].MouseIsOver() && mouseX < boardSize && mouseY < boardSize) {
          board[i][j].selected = false;
          board[i][j].x = int(mouseX/gridSize)*(gridSize)+gridSize/2;
          board[i][j].y = int(mouseY/gridSize)*(gridSize)+gridSize/2;
          board[i][j].updateBB();
        }
      }
    }
  }
}


void exampleCPUAnal(){
  float cpuAnal = 15;
  float cpuY = 60;
  float cpuX = 870;
  float playerY = 180;
  float playerX = 870;
  
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
  
  //Indicator Bar
  fill(0);
  rect(boardSize, 0, 50, cpuAnal);
  fill(255);
  rect(boardSize, cpuAnal, 50, height);
  textSize(20);
  fill(0);
  text("+M2", boardSize, height/2);
  
  text("Indication for best moves here", boardSize+ 50, 300);
  
  text("Menu Buttons down here", boardSize+50, height-70);
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
