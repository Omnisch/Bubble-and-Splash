// global fields
String imgPath = "data/original";
PImage img;
PGraphics canvas;
ArrayList<Bubble> bubbles;
GUI gui;
int bleedingX = 50;
int bleedingY = 50;
int scale = 8;



// main loop
void settings()
{
  // need to cover the whole screen first
  // so that controlP5 won't do culling
  size(displayWidth, displayHeight);
}
void setup()
{
  stroke(0xff363532);
  strokeWeight(2);
  ellipseMode(RADIUS);
  
  if (!tryLoadImage())
  {
    exit(); return;
  };
  canvas = newCanvas();
  bubbles = new ArrayList<Bubble>();
  gui = new GUI(this).init();
  
  bleedingY += constrain((600-img.height)/2, 0, 300);
  windowResize(img.width+2*bleedingX+gui.columnWidth, img.height+2*bleedingY);
}
void draw()
{
  background(darkMode ? 0xff1d1d1f : 0xfff5f5f7);
  tint(0xff, imageAlpha);
  image(img, bleedingX, bleedingY);
  tint(0xff);
  if (autoBlur)
    tryBlurCanvas(canvas);
  image(canvas, 0, 0);
  
  if (mousePressed && mouseButton == LEFT)
    setBubble(mouseX, mouseY);
  
  for (int i = 0; i < bubbles.size(); i++)
    bubbles.get(i).onDraw();
    
  stroke(0xff363532);
  noFill();
  ellipse(mouseX, mouseY, scale * 3, scale * 3);
}



// messages
void keyPressed()
{
  if (key == ' ')
  {
    setCluster(mouseX, mouseY);
  }
}
void mousePressed()
{
  if (mouseButton == RIGHT)
  {
    blowAll();
  }
}
void mouseWheel(MouseEvent event)
{
  scale += -event.getCount();
  scale = constrain(scale, 2, 16);
}



// custom functions
boolean tryLoadImage()
{
  String[] extensions = { ".jpg", ".png", ".gif", };
  for (int i = 0; i < extensions.length; i++)
  {
    img = loadImage(imgPath + extensions[i]);
    if (img != null) return true;
  }
  return false;
}
// blow away bubbles
void blowAll()
{
  for (int i = 0; i < bubbles.size(); i++)
    bubbles.get(i).blowFrom(mouseX, mouseY);
}
Bubble setBubble(int x, int y)
{
  // border limits
  if (x < bleedingX || x > bleedingX+img.width) return null;
  if (y < bleedingY || y > bleedingY+img.height) return null;
  
  
  if (bubbles.size() < 512)
  {
    Bubble bubble = new Bubble(
      x + round(random(-1, 1)),
      y + round(random(-1, 1)),
      scale, img, canvas, TTL);
    bubbles.add(bubble);
    bubble.parent = bubbles;
    return bubble;
  }
  else
    return null;
}
// set a cluster of bubbles
void setCluster(int x, int y)
{
  for (int i = 0; i < 64; i++)
    setBubble(x, y);
}
