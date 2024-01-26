class Balloon
{
  PVector coord;
  PVector vel;
  PVector acc;
  float radius;
  float mass;
  PImage img;
  PGraphics canvas;
  ArrayList<Balloon> parent;
  int TTL, initTTL;
  
  Balloon(int x, int y, int scale, PImage img, PGraphics canvas, int TTL)
  {
    this.vel = new PVector();
    this.acc = new PVector();
    this.radius = random(scale, scale * 3);
    this.mass = radius * radius;
    this.img = img;
    this.canvas = canvas;
    this.parent = null;
    setCoord(x, y);
    this.TTL = this.initTTL = TTL;
  }
  
  void onDraw()
  {
    calcAcc();
    calcVel();
    calcPos();
    
    int pixel = img.pixels[(int)coord.x + (int)coord.y*img.width];
    //int fade = (int)map(TTL, initTTL, 0, 0x0, 0xff);
    //fill(pixel & ((fade << 24) + 0xffffff));
    {
      int grayValue =
        (int)((pixel >> 16 & 0xff) * 0.299) +
        (int)((pixel >> 8  & 0xff) * 0.587) +
        (int)((pixel       & 0xff) * 0.114);
      // initTTL+2 to ensure when TTL==-1(infinity)
      // the balloon is colored
      float grayScale = map(TTL, initTTL+2, 0, 0, 1);
      stroke(0xff363532);
      fill(lerpColor(color(grayValue), pixel, grayScale));
    }
    ellipse(coord.x, coord.y, radius, radius);
    
    // Highlight
    noStroke();
    fill(0xddffffff);
    ellipse(coord.x-radius/3, coord.y-radius/3, radius/3, radius/3);
    
    TTLCheck();
  }
  void TTLCheck()
  {
    if (TTL == 0) flushToCanvas();
    if (TTL >= 0) TTL--;
  }
  void flushToCanvas()
  {
    Drop corpse = new Drop(
      (int)coord.x, (int)coord.y, radius*1.2, vel,
      img.pixels[(int)coord.x + (int)coord.y*img.width], canvas);
    corpse.splash();
    //canvas.fill(img.pixels[(int)coord.x + (int)coord.y*img.width] & 0x80ffffff);
    //canvas.ellipse(coord.x, coord.y, radius, radius);
    
    if (parent != null) parent.remove(this);
  }
  
  
  
  // PHYSICAL CALCULATION
  
  void collisionTest()
  {
    for (int i = 0; i < parent.size(); i++)
    {
      Balloon target = parent.get(i);
      if (target == this) continue;
      
      float dist = PVector.dist(coord, target.coord);
      float collideLength = (radius + target.radius) - dist;
      if (collideLength > 0)
      {
        addForce(
          PVector.mult(
            PVector.sub(coord, target.coord).normalize(),
            target.mass
          )
        );
      }
    }
    
    // border
    if (coord.x+radius >= img.width)
      addForce(PVector.mult(PVector.sub
        (new PVector(img.width-1 - radius, coord.y), coord).normalize(), mass));
    if (coord.x-radius < 0)
      addForce(PVector.mult(PVector.sub
        (new PVector(radius, coord.y), coord).normalize(), mass));
    if (coord.y+radius >= img.height)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, img.height-1 - radius), coord).normalize(), mass));
    if (coord.y-radius < 0)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, radius), coord).normalize(), mass));
  }
  void blowFrom(float x, float y)
  {
    PVector fromVector = new PVector(x, y);
    PVector direction = PVector.sub(coord, fromVector).normalize();
    addForce(direction.mult(8 * (img.height - PVector.dist(coord, fromVector))));
    calcVel();
  }
  void addForce(float x, float y)
  {
    addForce(new PVector(x, y));
  }
  void addForce(PVector force)
  {
    acc.add(PVector.div(force, mass));
  }
  void calcAcc()
  {
    acc = new PVector();
    // gravity
    addForce(0, gravity * mass);
    // fraction
    addForce(PVector.mult(vel, mass * -fraction));
    collisionTest();
  }
  void calcVel()
  {
    vel.add(acc);
  }
  void calcPos()
  {
    setCoord(PVector.add(coord, vel));
  }
  
  
  void setCoord(int x, int y)
  {
    setCoord(new PVector(x, y));
  }
  void setCoord(PVector v)
  {
    coord = v;
    coord.x = constrain(coord.x, 0, img.width-1);
    coord.y = constrain(coord.y, 0, img.height-1);
  }
}
