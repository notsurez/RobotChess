import processing.serial.*;

Serial visPort;

//Global variables for the size of different elements in the GUI, I should have made this dynamic
int boardSize = 800;
float gridSize = boardSize/8;


int pieceSize = (int)gridSize/2;

ChessPiece[][] board;   // Initialize 2d array of ChessPiece Objects

String cur_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1";
String movesHistory = "position startpos moves ";
byte BitBoard[] = new byte[64];

int x_dir = 0;
int y_dir = 1;

int mag_x = 50;
int mag_y = 50;
int inc = 10;

int pulses = 1;

int row, col;

boolean magnet_engaged = false;

boolean is_moving = false;

int move_number = 0;

void setup() {
  
  for(int i = 0; i < 64; i++) BitBoard[i] = ' ';
  //========================================================================
  // SET COM PORT HERE
  visPort = new Serial(this, Serial.list()[1], 57600);
  size(1200,800);
  
  background(50,50,70);
  
  board = new ChessPiece[8][8];
  readFen(cur_fen);
  
  //drawPieces();
  
  println("Initializing uCPU");
  //uCPUinit(1); //use the 2nd COM port
  frameRate(60);
}

void draw() {
  if (is_moving == false) {
   delay(1000);
   is_moving = true;
   move_number++;
   if (move_number == 1)  visPort.write("yyv:::Z:wyv2458C");
   if (move_number == 2)  visPort.write("ywv:B:Z:wyv2458P");
   if (move_number == 3)  visPort.write("ywv:B:ZZwuv2421C");
   if (move_number == 4)  visPort.write("ywVBB:ZZwuv2421P");
   if (move_number == 5)  visPort.write("ywVBF:Z:wuv2339C");
   if (move_number == 6)  visPort.write("ywV:F:Z:wuv2339P");
   if (move_number == 7)  visPort.write("ywV:F<Z:wuf2246C");
   if (move_number == 8)  visPort.write("ywV:B<Z:wuf2246P");
   if (move_number == 9)  visPort.write("ywV:B<Z>wu^2200C");
   if (move_number == 10) visPort.write("ywV:F<Z>wu^2200P");
   if (move_number == 11) visPort.write("yvV:F<Z>wuU2127C");
   if (move_number == 12) visPort.write("yvV:B<Z>wuS2127P");
  }
  
  background(0);
  while (visPort.available() > 0) {
    String inBuffer = visPort.readString();   
    if (inBuffer != null) {
      board[row][col].move(inBuffer);
      is_moving = true;
      if(inBuffer.contains("E")){
        magnet_engaged = true;
      }else if(inBuffer.contains("S")) {
        magnet_engaged = false;
      }else if(inBuffer.contains("R")){
        mag_x += inc;
      }else if(inBuffer.contains("L")){
        mag_x -= inc;
      }else if(inBuffer.contains("U")){
        mag_y -= inc;
      }else if(inBuffer.contains("D")){
        mag_y += inc;
      }else if(inBuffer.contains("R") || inBuffer.contains("r")){
        mag_x += inc;
      }else if(inBuffer.contains("L") || inBuffer.contains("l")){
        mag_x -= inc;
      }else if(inBuffer.contains("U") || inBuffer.contains("u")){
        mag_y -= inc;
      }else if(inBuffer.contains("D") || inBuffer.contains("d")){
        mag_y += inc;
      }else if(inBuffer.contains("F")){
        is_moving = false;
      }
      println(inBuffer);
    }
  }
    
    delay(10);
    drawBoard();
    drawPieces();
    drawMag(mag_x, mag_y, magnet_engaged);
    
    textSize(10);
    text(round(frameRate) + " FPS", width - 50, 20);
}

void drawMag(int x, int y, boolean state) {
  if(state) {
    fill(0, 255, 0);
  }else{
    fill(255, 0, 255);
  }
  
  ellipse(x, y, 25,25);
}

void drawBoard(){
  color g_color;
  color g_color_w = color(246, 232, 177);
  color g_color_b = color(10, 130, 30);
  g_color = g_color_w;
  
  for(float i = 0; i<8; i++){
      for(float j = 0; j<8; j++){
        fill(g_color);
        noStroke();
        rect(j*gridSize+200,i*gridSize,gridSize,gridSize);
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
      board[col][row] = new ChessPiece(fen.charAt(i), col*gridSize+(gridSize/2)+200, row*gridSize+(gridSize/2), pieceSize, 8*row+col);
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
        if(board[i][j].magIsOver() && magnet_engaged) {
         board[i][j].x = mag_x;
         board[i][j].y = mag_y;
        }
      }
    }
  }
}
