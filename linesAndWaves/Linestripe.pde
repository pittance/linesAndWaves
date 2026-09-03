
class Linestripe {
  
  int xNum = 0;
  int yNum = 0;
  Stripe[] stripes;
  float pad = 50;
  float spacingX;
  float spacingY;
  
  Linestripe(int xNum, int yNum, float spacingX, float spacingY, float pad) {
    //println("Linestripe: constructor - "+xNum+","+yNum+","+spacingX+","+spacingY+","+pad);
    this.xNum = xNum;
    this.yNum = yNum;
    stripes = new Stripe[yNum];
    this.spacingX = spacingX;
    this.spacingY = spacingY;
    this.pad = pad;
    for (int j=0;j<yNum;j++) {
      //println("Linestripe: stripes constructor call - " + j);
      stripes[j] = new Stripe(xNum);
    }
  }
  
  void pushPattern(int xin, int yin, float falloffRad, float shifty, float amp) {
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        float dist = dist(xin,yin,i*spacingX+pad,j*spacingY+pad);
        if(dist<falloffRad) {
          //we have updating to do
          float blend = (cos(map(dist,0,falloffRad,0,PI))+1)/2;  //used to blend out the effect of the other things
          float fac = cos(map(dist,0,falloffRad,0,shifty));
          stripes[j].setV(i,amp*fac*blend);
        }
      }
    }
  }
  
  void pushPattern(int xin, int yin, float falloffRad, float roty, float shifty, float amp) {
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        float dist = dist(xin,yin,i*spacingX+pad,j*spacingY+pad);
        if(dist<falloffRad) {
          //we have updating to do
          float blend = (cos(map(dist,0,falloffRad,0,PI))+1)/2;  //used to blend out the effect of the other things
          float fac = cos(map(dist,0,falloffRad,0,roty));
          float rot = sin(map(dist,0,falloffRad,0,roty));
          stripes[j].setV(i,amp*rot*blend,amp*fac*blend);
        }
      }
    }
  }
  
  void pushPatternR(int xin, int yin, float falloffRad, float rot, float angShift, float amp){
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        float dist = dist(xin,yin,i*spacingX+pad,j*spacingY+pad);
        if(dist<falloffRad) {
          //we have updating to do
          float ang = atan2((j*spacingY+pad)-yin,(i*spacingX+pad)-xin);
          float blend = (cos(map(dist,0,falloffRad,0,PI))+1)/2;  //used to blend out the effect of the other things
          float mapRot = rot*blend;
          float h = dist*mapRot;
          //println("rot: " + rot + ", dist: " + dist + ", h: " + h);
          float xshift = h*cos(HALF_PI-(ang+angShift));
          float yshift = h*sin(HALF_PI-(ang+angShift));  
          stripes[j].setV(i,amp*xshift*blend,amp*yshift*blend);
        }
      }
    }
  }
  
  void draw() {
    for(int j=0;j<yNum;j++) {
      stripes[j].draw();
    }
  }
  
  void reset() {
    
    for(int j=0;j<yNum;j++) {
      //println("Linestripe: stripes reset call - "+pad+","+spacingX+","+(pad+j*spacingY));
      stripes[j].reset(pad,spacingX,pad+j*spacingY);
    }
  }
  
  
  class Stripe {
    int num;
    float[] xs;
    float[] ys;
    
    Stripe(int num) {
      //println("Stripe: constructor - "+num);
      this.num = num;
      xs = new float[num];
      ys = new float[num];
    }
    
    void setV(int numIn, float yval) {
      ys[numIn] = ys[numIn]+yval;
    }
    
    void setV(int numIn, float xval, float yval) {
      xs[numIn] = xs[numIn]+xval;
      ys[numIn] = ys[numIn]+yval;
    }
    
    void reset(float pad, float space, float y) {
      //println("Stripe: reset - "+pad+","+space+","+y); 
      for(int i=0;i<num;i++) {
        xs[i] = pad+i*space;
        ys[i] = y;
      }
      //println(xs);
      //println(ys);
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
