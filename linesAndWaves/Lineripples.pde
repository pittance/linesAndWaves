
class Lineripple {
  
  
  int xNum = 0;
  int yNum = 0;
  Stripe[] stripes;
  float pad = 50;
  float spacingX;
  float spacingY;
  
  Lineripple(int xNum, int yNum, float spacingX, float spacingY, float pad) {
    //println("Linestripe: constructor - "+xNum+","+yNum+","+spacingX+","+spacingY+","+pad);
    this.xNum = xNum;
    this.yNum = yNum;
    stripes = new Stripe[yNum];
    this.spacingX = spacingX;
    this.spacingY = spacingY;
    this.pad = pad;
    for (int j=0;j<yNum;j++) {
      stripes[j] = new Stripe(xNum,pad+j*spacingY);
    }
  }
  
  void pushRipple(float xin, float yin, float falloffRad, float freqMult, float ampMult) {
    //loop down the stripes, checking if they're in the range of this ripple
    //if they are then we apply the ripple
    for (int j=0;j<yNum;j++) {
      stripes[j].setRipple(xin, yin, falloffRad, freqMult, ampMult);
    }
  }
  
  void reset() {
    for (int j=0;j<yNum;j++) {
      stripes[j].init(pad,spacingX);
    }
  }
  
  void draw() {
    for(int j=0;j<yNum;j++) {
      stripes[j].draw();
    }
  }
  
  
  class Stripe {
    int num;    //number of points in the stripe
    float[] xs; //array to store the coordinate values of the line
    float[] ys;
    float ybase;  //baseline y value for the stripe (ys will vary around this)
    
    Stripe(int num, float ybase) {
      //println("Stripe: constructor - "+num);
      this.num = num;
      xs = new float[num];
      ys = new float[num];
      this.ybase = ybase;
    }
    
    void setV(int numIn, float dy) {
      ys[numIn] = ys[numIn]+dy;
    }
    
    void setV(int numIn, float xval, float dy) {
      xs[numIn] = xs[numIn]+xval;
      ys[numIn] = ys[numIn]+dy;
    }
    
    void init(float pad, float space) {
      for(int i=0;i<num;i++) {
        xs[i] = pad+i*space;
        ys[i] = ybase;
      }
      //println(xs);
      //println(ys);
    }
    
    void setRipple(float xCentre, float yCentre, float falloffRad, float freqMult, float ampMult) {
      //xCen & yCen are the centre of the falloff
      for(int i=0;i<num;i++) {
        ys[i] = ys[i]+getAmp(xCentre,yCentre,xs[i],ys[i],falloffRad)*sin(map(xs[i]-xCentre,0,falloffRad,0,PI*freqMult))*ampMult;
      }
    }
    
    float getAmp(float xCentre, float yCentre, float xCoord, float yCoord, float falloffRad) {
      // amp is zero at falloffRad, amp is 1.0 at exact coord
      if(dist(xCentre,yCentre,xCoord,yCoord)==0)println("error in getAmp");
      return (cos(map(constrain(dist(xCentre,yCentre,xCoord,yCoord),0,falloffRad),0,falloffRad,0,PI))+1)/2;
    }
    
    void draw() {
      //println(xs);
      noFill();
      beginShape();
      for(int i=0;i<num;i++) vertex(xs[i],ys[i]);
      endShape();
    }
  }
  
}
