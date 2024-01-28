//
//
//
// bubble fields
ArrayList<Bubble> bubbles;
int scale = 8;
int minScale = 2, maxScale = 16;



// single object bubble
class Bubble
{
  PVector coord;
  PVector vel;
  PVector acc;
  float radius;
  float mass;
  PImage img;
  PGraphics canvas;
  ArrayList<Bubble> parent;
  int TTL, initTTL;
  
  Bubble(int x, int y, int scale, PImage img, PGraphics canvas, int TTL)
  {
    this.vel = new PVector();
    this.acc = new PVector();
    this.radius = random(scale, scale * 4);
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
    
    int pixel = img.pixels[(int)coord.x-bleedingX + (int)(coord.y-bleedingY)*img.width];
    int fade = (int)map(TTL, initTTL, 0, 0x0, 0xff);
    fill(pixel & ((fade << 24) + 0xffffff));
    {
      int grayValue =
        (int)((pixel >> 16 & 0xff) * 0.299) +
        (int)((pixel >> 8  & 0xff) * 0.587) +
        (int)((pixel       & 0xff) * 0.114);
      // initTTL+2 to ensure when TTL==-1(infinity)
      // the bubble is colored
      float grayScale = map(TTL, initTTL+2, 0, 0, 1);
      // stroke
      if (hideStroke)
        noStroke();
      else
        stroke(0xff363532);
      fill(lerpColor(color(grayValue), pixel, grayScale));
    }
    ellipse(coord.x, coord.y, radius, radius);
    
    // highlight
    if (highlight)
    {
      noStroke();
      fill(0xddffffff);
      ellipse(coord.x-radius/3, coord.y-radius/3, radius/3, radius/3);
    }
    
    TTLCheck();
  }
  void TTLCheck()
  {
    if (TTL == 0) poke();
    if (TTL >= 0) TTL--;
  }
  boolean tryPokeFrom(int x, int y)
  {
    PVector fromVector = new PVector(x, y);
    if (PVector.dist(coord, fromVector) < radius)
    {
      poke();
      return true;
    }
    else
      return false;
  }
  void poke()
  {
    Splash corpse = new Splash(
      (int)coord.x, (int)coord.y, radius*1.2, vel,
      img.pixels[(int)coord.x-bleedingX + (int)(coord.y-bleedingY)*img.width], canvas);
    corpse.onDraw();
    //canvas.fill(img.pixels[(int)coord.x + (int)coord.y*img.width] & 0x80ffffff);
    //canvas.ellipse(coord.x, coord.y, radius, radius);
    
    if (parent != null) parent.remove(this);
  }
  
  
  
  // physics calculation
  void collisionTest()
  {
    // collision force
    for (int i = 0; i < parent.size(); i++)
    {
      Bubble target = parent.get(i);
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
    if (coord.x+radius >= img.width + bleedingX)
      addForce(PVector.mult(PVector.sub
        (new PVector(img.width+bleedingX-radius, coord.y), coord).normalize(), mass));
    if (coord.x-radius < bleedingX)
      addForce(PVector.mult(PVector.sub
        (new PVector(bleedingX+radius, coord.y), coord).normalize(), mass));
    if (coord.y+radius >= img.height + bleedingY)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, img.height+bleedingY-radius), coord).normalize(), mass));
    if (coord.y-radius < bleedingY)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, bleedingY+radius), coord).normalize(), mass));
  }
  void blowFrom(int x, int y)
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
    coord.x = constrain(coord.x, bleedingX, img.width+bleedingX-1);
    coord.y = constrain(coord.y, bleedingY, img.height+bleedingY-1);
  }
}



// bubble functions
void drawBubbles()
{
  for (int i = 0; i < chunks.size(); i++)
  {
    for (int j = 0; j < chunks.get(i).size(); j++)
    {
      chunks.get(i).get(j).onDraw();
    }
  }
}
// instantiate one bubble
Bubble setBubble(int x, int y)
{
  // border limits
  if (x < bleedingX || x > bleedingX+img.width) return null;
  if (y < bleedingY || y > bleedingY+img.height) return null;
  
  
  //if (bubbles.size() < 512)
  {
    Bubble bubble = new Bubble(
      x + round(random(-1, 1)),
      y + round(random(-1, 1)),
      scale, img, splashed, TTL);
    getChunkByPixel(x, y).add(bubble);
    bubble.parent = getChunkByPixel(x, y);
    return bubble;
  }
  //else
  //  return null;
}
// set a cluster of bubbles
void setCluster(int x, int y)
{
  for (int i = 0; i < 64; i++)
    setBubble(x, y);
}
// blow away bubbles
void blowFrom(int x, int y)
{
  for (int i = 0; i < bubbles.size(); i++)
    bubbles.get(i).blowFrom(x, y);
}
// poke the bubble under cursor
boolean tryPokeFrom(int x, int y)
{
  for (int i = 0; i < bubbles.size(); i++)
  {
    if (bubbles.get(i).tryPokeFrom(x, y))
      return true;
  }
  return false;
}
