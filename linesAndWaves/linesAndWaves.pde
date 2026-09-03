
import processing.svg.*;

//set this if you want a grid, otherwise it will be lines
boolean grid = false;
boolean stripe = false;

Linegrid lg;
Linestripe ls;
Lineripple lr;

int[] xin;
int[] yin;
float[] rads;
float[] rots;
float[] freqs;
float[][] angShift;

boolean export = false;  //set by key

float a3ratio = 420f/297f;

int numX;
int numY;
float spacerX;
float spacerY;
float padder;

float lineLen;

//for the Linestripes these settings affect the output curves
float amp = 10;        //amplitude multiplier
float baseFreq = 15;   //spatial frequency, multiplier on PI
float rotFreq = 3;
float rotRange = 0.9;  //range goes from -rotRange to rotRange
float freqLo = 5;
float freqHi = 20;
float radLo = 50;
float radHi = 350;

//used to control the twists in the lines
int numins = 20;  //number of input twists
int numShifts = 3;  //for each twist there will be a set of different shifts, each one will produce a different output
                    //this means that angShifts is a 2D array

int countExportShifts = 0;  //used to set which shift we're using when exporting

boolean doneWrite = false;

void setup() {
  size(1000,707);
  
  padder = 10;
  spacerY = 8;  //5 for linestripes
  spacerX = 0.8;  //0.3 for linestripes
  
  numX = int((width-(padder*2))/spacerX); //for grid limit the x numbers a lot more
  numY = int((height-(padder*2))/spacerY);  
  
  lineLen = 15;
  
  println("How many lines?");
  println("There are: " + (numX * numY * 2) + " lines to draw");
  
  
  if(grid) {
    lg = new Linegrid(numX,numY,spacerX,padder);
  } else {
    if(stripe) {
      println("setup: Linestripe constructor call");
      ls = new Linestripe(numX,numY,spacerX,spacerY,padder);
    } else {
      println("setup: Lineripple constructor call");
      println("numX,numY,spacerX,spacerY,padder");
      println(numX,numY,spacerX,spacerY,padder);
      lr = new Lineripple(numX,numY,spacerX,spacerY,padder);
    }
  }
  
  
  
  xin = new int[numins];
  yin = new int[numins];
  rads = new float[numins];
  rots = new float[numins];
  freqs = new float[numins];
  angShift = new float[numins][numShifts];
  
  for(int i=0;i<numins;i++) {
    xin[i] = int(random(0,width));
    yin[i] = int(random(0,height));
    rads[i] = random(radLo,radHi);
    rots[i] = sq(random(-rotRange,rotRange));
    freqs[i] = random(freqLo,freqHi);
    float angShiftBase = random(0.05,0.15);
    float shiftMul = random(0.1,0.5);
    for(int j=0;j<numShifts;j++) angShift[i][j] = angShiftBase + j*shiftMul;
  }
  
  
  
  //noLoop();
}

void write() {
  //println("write: setup initial");
  if(grid) {
    lg.resetAng();
    
    for(int i=0;i<xin.length;i++) {
      lg.pushAngPointer(xin[i],yin[i],rads[i],angShift[i][countExportShifts]);
    }
    
  } else {
    if(stripe) {
      //println("write: reset and pushPattern");
      ls.reset();
      
      for(int i=0;i<xin.length;i++) {
        ls.pushPatternR(xin[i],yin[i],rads[i],rots[i],angShift[i][countExportShifts],amp);
      }
    } else {
      lr.reset();   
      for(int i=0;i<xin.length;i++) {
        //println("i",i,"to",xin.length);
        //println("float(xin[i]),float(yin[i]),rads[i],amp");
        //println(float(xin[i]),float(yin[i]),rads[i],amp);
        lr.pushRipple(float(xin[i]),float(yin[i]),rads[i],freqs[i]+angShift[i][countExportShifts],amp);
      }
    }
  }
}


void draw(){
  //println("frame start");
  
  if(export){
    beginRecord(SVG, "out_" + countExportShifts + ".svg");
  }
  
  stroke(lerpColor(color(255,0,0),color(0,0,255),map(countExportShifts,0,numShifts-1,0,1)));
  
  write();
  
  if(grid) {
    lg.draw(lineLen);
  } else {
    if(stripe) {
      ls.draw();
    } else {
      lr.draw();
    }
  }

  
  
  if(export) {
    //complete the current export
    endRecord();
    
    //are we done?
    if(countExportShifts<numShifts-1){
      //no, we're not done - increment the counter to get a different shift
      countExportShifts++;
    } else {
      //yes, we're done - all shifts are applied
      exit();
    }
  }
  
  //println("frame end");
}

void keyPressed() {
  if(key=='e'){
    export = true;
    countExportShifts = 0;
  }
}
