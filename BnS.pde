// imports
import controlP5.*;



// global fields
String imgPath = "data/original";
PImage img;
PGraphics canvas;
color strokeColor = 0xff363532;



// main thread
void settings()
{
  // need to cover the whole screen first
  // so that controlP5 won't do culling
  size(displayWidth, displayHeight);
}
void setup()
{
  // brush setup
  ellipseMode(RADIUS);
  strokeWeight(2);
  stroke(strokeColor);
  
  // init of fields
  if (!tryLoadImage())
  {
    exit(); return;
  };
  bubbles = new ArrayList<Bubble>();
  canvas = newCanvas();
  gui = new GUI(this).init();
  
  // deal with too-small original image
  bleedingY += max((600-img.height)/2, 0);
  // de facto size()
  windowResize(img.width+2*bleedingX+gui.columnWidth, img.height+2*bleedingY);
}
void draw()
{
  if (mousePressed && mouseButton == LEFT)
    setBubble(mouseX, mouseY);

  drawBackground();
  drawOriginal();
  drawCanvas();  
  drawBubbles();
  drawCursor();
}



// input messages
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
    blowFrom(mouseX, mouseY);
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
void drawBackground()
{
  background(darkMode ? 0xff1d1d1f : 0xfff5f5f7);  
}
void drawOriginal()
{
  tint(0xff, imageAlpha);
  image(img, bleedingX, bleedingY);
  tint(0xff);
}
void drawCursor()
{
  stroke(strokeColor);
  noFill();
  ellipse(mouseX, mouseY, scale * 3, scale * 3);
}
