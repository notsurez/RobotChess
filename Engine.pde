import java.lang.ProcessBuilder;
import java.io.*;

/*
  Class to handle the communication between the GUI and any
  chess engine using UCI (universal chess engine)
  
  Functions
  -Init
      *
  - Listen
      * WIP
  -Say
      * Sends a string to the engine using process builder io streams
  
  Written by: Christian Brazeau
  Other Contributers:
  Last modified: 03/12/2021
*/

int lineToSay = -1; // ????
boolean guiHasToSaySomething = true; 

int delayPeriod = 11;

class Engine {
  ProcessBuilder pb;
  Process p = null;
 
  InputStream in    = null; 
  OutputStream out  = null;
  BufferedReader reader;
  
  Engine(String path) { 
    pb = new ProcessBuilder(path);
  }
  
  void init() {
    try {
      p = pb.start();
      println("engine was sucessfully initialized");
    }catch(Exception e) {
        println("An error has occured while attempting to start the engine");
    }
    
    in = p.getInputStream();
    out = p.getOutputStream();
    if(in == null || out == null) {
        println("error in creating input/output streams");
    }else {
       println("sucessfully initialized output/input streams"); 
    }
    
    
  }
  
  /*
    Say function sends a message to the output stream of the process builder process 
    running the UCI chess engine. It first converts a given string to
  */
  void say(String message) {
    println("saying:", message);
    out = p.getOutputStream();
    try {
      byte buf[] = message.getBytes();
      out.write(buf);
      out.write(10);
    }catch(Exception e) {
      println("failed to write");
    }
    
    try {
      out.flush();
    }catch(Exception e) {
      println("failed to flush");
    }
    
  }
  
String listen() {
 
  // gui gets from engine
 
  int c = 13;
  String inputStr = ""; 
 
  try {
 
    // http : // stackoverflow.com/questions/22563986/understanding-getinputstream-and-getoutputstream
 
    do
    {
      //print("inread");
      c=in.read();      //the crashing occurs here
      //print("readin");
      //  print((char) c);
      inputStr += (char) c;
    }
    while (c != 13);
 
    // println (inputStr);
  }
  catch (Exception e) {
    println("Can't read");
  }

  if (inputStr != null && !inputStr.equals("")) {
    heardBestmove = inputStr.contains("bestmove");
    if (heardBestmove) {
      println(inputStr);
      String moveString = "";
      
      if ( inputStr.contains("ponder")) moveString = inputStr.substring(10, inputStr.indexOf("ponder")-1);
      if (!inputStr.contains("ponder")) {
        moveString = inputStr.substring(10, 14); //the game is over btw
      println("GG");
      delay(10000);
      }
      print("move string = ");
      println(moveString);
      if (moveString.length() == 4 && !moveString.contains("(non")) { //move the piece
        int fromChar = (int) moveString.charAt(0) - 97;
        int  fromInt  = (int) moveString.charAt(1) - 48;
        int toChar   = (int) moveString.charAt(2) - 97;
        int  toInt    = (int) moveString.charAt(3) - 48;
        print(fromChar);
        print(" ");
        print(fromInt);
        print(" ");
        print(toChar);
        print(" ");
        print(toInt);
        println(" ");
        int fromPos = fromChar + (8 - fromInt)*8;
        int toPos   = toChar   + (8 - toInt)*8;
        print(fromPos);
        print("-->");
        println(toPos);
        
        byte oldPiece = BitBoard[fromPos];
        
        BitBoard[fromPos] = ' '; //Clear where the piece moved FROM

    //println(BitBoard[fromPos]); // Print which 

    if(BitBoard[toPos] != 32 && BitBoard[toPos] != 0) { //if the TO position contains a piece
      BitBoard[toPos] = ' '; 
      board[toPos%8][floor(toPos/8)] = null; //Remove the piece object
      println("Computer PIECE REMOVED ", (char)BitBoard[toPos], " on (", toPos%8, ",",floor(toPos/8), ")"  );
    }

    if (fromPos != toPos) movesHistory = movesHistory + bbCoordString(fromPos) + bbCoordString(toPos) + " ";

    fromPos = toPos;
    BitBoard[fromPos] = oldPiece;
    
    //board[fromChar][8 - fromInt].selected = true;
    //board[fromChar][8 - fromInt].x = 50 + 100*toChar;
    //board[fromChar][8 - fromInt].y = 50 + 100*(8 - toInt);
    //board[fromChar][8 - fromInt].selected = false;
    //board[toChar][8 - toInt] = board[fromChar][8 - fromInt];    
    //board[fromChar][8 - fromInt] = null;      
          
      }
    }
    return inputStr ;
  } else {
    println("inputStr is null");
    return null;
  }
}
  
  void drawfunc() {
//getting from engine this:   
  String inputStr = "";
  inputStr = listen();
  print("listened (inputStr = ");
  print(inputStr);
  println(")");
  
  if (inputStr!=null) {
    print(inputStr);
 
    switch (lineToSay) {
 
    case -1:
      lineToSay ++;
      guiHasToSaySomething=true; 
      break; 
 
    case 0:
      // say( "uci\n"); // with \n  !!!!!
      if (inputStr.equals("uciok")||inputStr.contains("uciok")) {
        lineToSay ++;        
        guiHasToSaySomething=true;
        //  println ("Here 2");
      }
      break;
 
    case 1:    
      //say( "isready\n");
      inputStr=inputStr.trim();
      if (inputStr.equals("readyok")||inputStr.contains("readyok")) {
        lineToSay ++;
        //  lineToSay ++;
        guiHasToSaySomething=true;
        //println ("Here 1");
      }
      break;
 
    case 2:
    case 3:
      // say( "debug off\n"); 
      if (inputStr.equals("readyok")||inputStr.contains("readyok")) {
        guiHasToSaySomething=true;
        //println ("  Here 2 " + lineToSay);
        lineToSay ++;
      }
      //lineToSay ++;
      //guiHasToSaySomething=true;
 
      break ; 
 
    case 6:
      if (inputStr.equals("bestmove")||inputStr.contains("bestmove")) {
        //println (" !!!!!!!!!!!!!!!!!!!!!!!!!!!! bestmove 2 " + lineToSay);
      }
        //println("STUCK HERE");
      break; 
 
    default:
      //println ("Here default " + lineToSay);
      delay(delayPeriod); 
      lineToSay ++;
      guiHasToSaySomething=true;
      break;
    } // switch
  } // if
  else {
    delay(delayPeriod); 
    lineToSay ++;
    //println("STUCK IN ELSE");
    guiHasToSaySomething=true;
  }
 
  // --------------------------------------------
 
  if (guiHasToSaySomething) {
    switch (lineToSay) {
    case 0:
      say( "uci\n"); // with \n  !!!!!
      break;
 
    case 1:    
      say( "isready\n");
      break;
 
    case 2:
      guiHasToSaySomething=true;
      // say( "debug off\n"); 
      say( "isready\n");
      break;
 
    case 3:    
      guiHasToSaySomething=true;
      //  say( "ucinewgame\n");
      say( "isready\n");
      break; 
 
    case 4: 
      // now the GUI sets some values in the engine
      // set hash to 32 MB
      //   guiHasToSaySomething=true;
      say("setoption name UCI_Elo value " + str(cpu_diff) + " \n"); 
      guiHasToSaySomething=true;
 
      say( "position startpos moves e2e4 e7e5 Ke2\n");  
      guiHasToSaySomething=true;
 
      say("go infinite\n");
 
      guiHasToSaySomething=true;
 
      delay(delayPeriod*20);
      // lineToSay ++;
      say("stop\n");
 
      guiHasToSaySomething=true;
      delay(delayPeriod/5);
      // lineToSay ++;
 
      break; 
 
    case 5: 
      // init tbs
      guiHasToSaySomething=true;
      //println("STUCK in 5");
      //say("position startpos moves e2e4 e7e5 Ke2\n"); 
      delay(delayPeriod/5);
      lineToSay ++;
      break; 
    default:
      //println ("STUCK AFTER CASE 5");
      break;
    } // switch
  }
 
  //println ("Here draw() " + lineToSay);
  }
  
  /*
    Say function sends a message to the output stream of the process builder process 
    running the UCI chess engine. It first converts a given string to
  */
void say2 (String str) {
  println(""); 
  println("----->"+str);
  //  println(lineToSay);
 
  out = p.getOutputStream();
 
  try {
    byte buf[] = str.getBytes();
    out.write(buf);
  }
  catch (Exception e) {
    println("Can't write ! ");
  }
 
  try {
    out.flush();
  }
  catch (Exception e) {
    println("Can't flush ! ");
  }
 
  // !!!!!!!!!!!!!!!!!!!!!!!! kill all speaking here  
  guiHasToSaySomething=false;
}

void send_config() {
    String stringToSend;
    stringToSend = "setoption name UCI_Elo value " + str(cpu_diff);
    this.listen();
    delay(20);
    this.say(stringToSend);
    delay(20);
    this.say("isready");
    delay(20);
    this.listen();
    delay(20);
    this.say("ucinewgame");
    delay(20);
  }
}// end of class
