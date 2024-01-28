// imports
import controlP5.*;



// global fields
String imgPath = "data/original";
PImage img;
PGraphics splashed;
PGraphics debugLayer;
color strokeColor = 0xff363532;



// main thread
void settings()
{
  // init of fields
  if (!tryLoadImage())
  {
    exit(); return;
  };
  
  // need to cover the whole screen first
  // so that controlP5 won't do culling
  size(img.width+2*bleedingX+guiColumnWidth, img.height+2*bleedingY);
}
void setup()
{
  // brush setup
  ellipseMode(RADIUS);
  strokeWeight(2);
  stroke(strokeColor);
  
  initChunks();
  splashed = newCanvas();
  gui = new GUI(this).init();
  
  // deal with too-small original image
  bleedingY += max((600-img.height)/2, 0);
}
void draw()
{
  if (mousePressed && mouseButton == LEFT)
    setBubble(mouseX, mouseY);

  drawBackground();
  drawOriginal();
  tryBlurCanvas(splashed);
  drawCanvas(splashed);
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
    tryPokeFrom(mouseX, mouseY);
  if (mouseButton == CENTER)
    blowFrom(mouseX, mouseY);
}
void mouseWheel(MouseEvent event)
{
  scale += -event.getCount();
  scale = constrain(scale, minScale, maxScale);
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
