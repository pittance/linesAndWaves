

class Linegrid {
  
  int xNum = 0;
  int yNum = 0;
  float[][] ang;
  float[][] len;
  boolean centre = true;
  float pad = 50;
  float spacing = 12;
  
  Linegrid(int xNum, int yNum, float spacing, float pad) {
    this.xNum = xNum;
    this.yNum = yNum;
    this.spacing = spacing;
    this.pad = pad;
    resetGrid();
  }
  
  void resetGrid() {
    ang = new float[xNum][yNum];
    len = new float[xNum][yNum];
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        ang[i][j] = 0;
        len[i][j] = 1;
      }
    }
  }
  
  void draw(float lenScale) {
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        pushMatrix();
        //translate(map(i,0,xNum-1,pad,width-pad),map(j,0,yNum-1,pad,height-pad));
        translate(pad+i*spacing,pad+j*spacing);
        rotate(ang[i][j]);
        if(centre) {
          line(-lenScale*len[i][j]/2,0,lenScale*len[i][j]/2,0);
        } else {
          line(0,0,lenScale*len[i][j],0);
        }
        popMatrix();
      }
    }
  }
  
  void pushAngPointer(int xin, int yin, float falloffRad) {
    //based on the mouse position (or anything) do some mods to the angle array
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        float dist = dist(xin,yin,i*spacing+pad,j*spacing+pad);
        if(dist<falloffRad) {
          //we have updating to do
          float fac = PI*(cos(map(dist,0,falloffRad,0,PI))+1)/2;
          ang[i][j] = ang[i][j]+fac;
        }
      }
    }
  }
  
  void resetAng() {
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        ang[i][j] = 0;
      }
    }
  }
  
  void pushAngPointer(int xin, int yin, float falloffRad, float shifty) {
    for (int i=0;i<xNum;i++) {
      for (int j=0;j<yNum;j++) {
        float dist = dist(xin,yin,i*spacing+pad,j*spacing+pad);
        if(dist<falloffRad) {
          //we have updating to do
          float fac = (PI*shifty)*(cos(map(dist,0,falloffRad,0,PI))+1)/2;
          ang[i][j] = ang[i][j]+fac;
        }
      }
    }
  }
  
  
  
}
