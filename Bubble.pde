//
//
//
// bubble fields
int scale = 7;
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
  PGraphics canvasSplash;
  ArrayList<Bubble> parent;
  int TTL, initTTL;
  
  Bubble(int x, int y, int scale, PImage img, PGraphics canvasSplash, int TTL)
  {
    this.vel = new PVector();
    this.acc = new PVector();
    this.radius = random(scale, scale * 4);
    this.mass = radius * radius;
    this.img = img;
    this.canvasSplash = canvasSplash;
    this.parent = null;
    setCoord(x, y);
    this.TTL = this.initTTL = TTL;
  }
  
  
  
  // draw and sub-functions
  void onDraw(PGraphics canvas)
  {
    calcAcc();
    calcVel();
    calcPos();
    
    if (canvas != g) canvas.beginDraw();
    int pixel = img.pixels[(int)coord.x + (int)coord.y*img.width];
    // translucent or grayscaled
    if (translucent)
    {
      int fade = (int)map(TTL, initTTL+2, 0, 0x0, 0xff);
      canvas.fill(pixel & ((fade << 24) + 0xffffff));
    }
    else
    {
      int grayValue =
        (int)((pixel >> 16 & 0xff) * 0.299) +
        (int)((pixel >> 8  & 0xff) * 0.587) +
        (int)((pixel       & 0xff) * 0.114);
      // initTTL+2 to ensure when TTL==-1(infinity)
      // the bubble is colored
      float grayScale = map(TTL, initTTL+2, 0, 0, 1);
      canvas.fill(lerpColor(color(grayValue), pixel, grayScale));
    }
    // stroke
    if (hideStroke)
      canvas.noStroke();
    else
      canvas.stroke(0xff363532);
    // draw bubble
    canvas.ellipse(bleedingX+coord.x, bleedingY+coord.y, radius, radius);
    if (canvas != g) canvas.endDraw();
    // highlight
    if (highlight) drawHighlight(canvas);
  }
  void drawHighlight(PGraphics canvas)
  {
    if (canvas != g) canvas.beginDraw();
    canvas.noStroke();
    canvas.fill(0xddffffff);
    canvas.ellipse(bleedingX+coord.x-radius/3, bleedingY+coord.y-radius/3, radius/3, radius/3);
    if (canvas != g) canvas.endDraw();
  }
  
  
  
  // update and sub-functions
  void updateData()
  {
    updateTTL();
    
    // update parent in every 4 frames
    if ((TTL & 3) == 0)
      updateParentChunk();
  }
  void updateTTL()
  {
    if (TTL == 0) poke();
    if (TTL >= 0) TTL--;
  }
  void updateParentChunk()
  {    
    if (parent != getChunkByPixel((int)coord.x, (int)coord.y))
    {
      parent.remove(this);
      parent = getChunkByPixel((int)coord.x, (int)coord.y);
      parent.add(this);
    }
  }
  
  
  
  // poke operations
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
      img.pixels[(int)coord.x + (int)coord.y*img.width], canvasSplash);
    corpse.onDraw();
    //canvas.fill(img.pixels[(int)coord.x + (int)coord.y*img.width] & 0x80ffffff);
    //canvas.ellipse(coord.x, coord.y, radius, radius);
    if (parent != null) parent.remove(this);
  }
  
  
  
  // physical calculation
  void collisionTest()
  {
    // collision force
    ArrayList<ArrayList<Bubble>> adjacentChunks =
      get3x3ChunksByPixel((int)coord.x, (int)coord.y);
    for (int i = 0; i < adjacentChunks.size(); i++)
    {
      for (int j = 0; j < adjacentChunks.get(i).size(); j++)
      {
        Bubble target = adjacentChunks.get(i).get(j);
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
    }
    
    // border
    if (coord.x+radius >= img.width)
      addForce(PVector.mult(PVector.sub
        (new PVector(img.width-radius, coord.y), coord).normalize(), mass));
    if (coord.x-radius < 0)
      addForce(PVector.mult(PVector.sub
        (new PVector(radius, coord.y), coord).normalize(), mass));
    if (coord.y+radius >= img.height)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, img.height-radius), coord).normalize(), mass));
    if (coord.y-radius < 0)
      addForce(PVector.mult(PVector.sub
        (new PVector(coord.x, radius), coord).normalize(), mass));
  }
  void blowFrom(int x, int y)
  {
    PVector fromVector = new PVector(x, y);
    PVector direction = PVector.sub(coord, fromVector).normalize();
    addForce(direction.mult(8 * (img.height - PVector.dist(coord, fromVector))));
    calcVel();
  }
  
  
  
  // Newton's F-a-v-d system
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
  
  
  
  // coordination operations
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



// bubble functions
void updateBubbles()
{
  for (int i = 0; i < chunks.size(); i++)
  {
    for (int j = 0; j < chunks.get(i).size(); j++)
    {
      chunks.get(i).get(j).updateData();
    }
  }
}
void drawBubbles(PGraphics canvas)
{
  for (int i = 0; i < chunks.size(); i++)
  {
    for (int j = 0; j < chunks.get(i).size(); j++)
    {
      chunks.get(i).get(j).onDraw(canvas);
    }
  }
}
// instantiate one bubble
Bubble setBubble(int x, int y)
{
  // border limits
  if (x < bleedingX || x > bleedingX+img.width) return null;
  if (y < bleedingY || y > bleedingY+img.height) return null;
  
  // canvas coord to image coord
  x -= bleedingX;
  y -= bleedingY;
  
  Bubble bubble = new Bubble(
    x + round(random(-1, 1)),
    y + round(random(-1, 1)),
    scale, img, splashed, TTL);
  getChunkByPixel(x, y).add(bubble);
  bubble.parent = getChunkByPixel(x, y);
  return bubble;
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
  // canvas coord to image coord
  x -= bleedingX;
  y -= bleedingY;
  
  for (int i = 0; i < chunks.size(); i++)
  {
    for (int j = 0; j < chunks.get(i).size(); j++)
    {
      chunks.get(i).get(j).blowFrom(x, y);
    }
  }
}
// poke the bubble under cursor
boolean tryPokeFrom(int x, int y)
{
  // canvas coord to image coord
  x -= bleedingX;
  y -= bleedingY;
  
  ArrayList<ArrayList<Bubble>> adjacentChunks =
    get3x3ChunksByPixel(x, y);
  for (int i = 0; i < adjacentChunks.size(); i++)
  {
    for (int j = 0; j < adjacentChunks.get(i).size(); j++)
    {
      adjacentChunks.get(i).get(j).tryPokeFrom(x, y);
    }
  }
  return false;
}
// poke all the bubbles
void pokeAll()
{
  for (int i = 0; i < chunks.size(); i++)
  {
    // poke() lets the size of the ArrayList minus 1
    while (chunks.get(i).size() > 0)
    {
      chunks.get(i).get(0).poke();
    }
  }
}
