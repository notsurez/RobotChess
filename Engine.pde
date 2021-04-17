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
  
  Written by: Christian Brazeau, Timothy Reichert, and Peter Taranto
  Last modified: 03/12/2021
*/

int lineToSay = -1; // ????
boolean guiHasToSaySomething = true; 

int delayPeriod = 11;

class Engine {
  ProcessBuilder pb;
  Process p = null;
 
  InputStream  in   = null; 
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
void say (String str) {
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
}//func 
  
  String listen() {
  // gui gets from engine
 
  int c = 13;
  String inputStr = ""; 
 
  try {
    // http://stackoverflow.com/questions/22563986/understanding-getinputstream-and-getoutputstream
    while (c != 13)
    {
      c=in.read();
      //  print((char) c);
      inputStr += (char) c;
    }
    // println (inputStr);
  }
  catch (Exception e) {
    println("Can't read");
  }

  if (!inputStr.equals("")) {
    return inputStr ;
  } else {
    //println("inputStr is null");
    return null;
  }
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
    this.say("d");
    delay(20);
    this.listen();
  }
}// end of class
