// Processing 4.3 & ControlP5
// designed and programmed by Omnistudio @2023
//
// imports
import controlP5.*;



// global fields
String imgPath = "data/original";
PImage img;
color strokeColor = 0xff363532;



// main thread
void settings()
{
  if (!tryLoadImage())
  {
    exit(); return;
  };
  
  // deal with too-small original image
  bleedingY += max((600-img.height)/2, 0);
  size(img.width+2*bleedingX+guiColumnWidth, img.height+2*bleedingY);
}
void setup()
{
  // brush setup
  ellipseMode(RADIUS);
  stroke(strokeColor);
  strokeWeight(2);
  
  initChunks();
  
  // init canvases
  int canvasWidth = img.width+2*bleedingX;
  int canvasHeight = img.height+2*bleedingY;
  splashed = newCanvas(canvasWidth, canvasHeight);
  output = newCanvas(canvasWidth, canvasHeight);
  gizmos = newCanvas(canvasWidth, canvasHeight);
  
  gui = new GUI(this).init();
}
void draw()
{
  if (mousePressed && mouseButton == LEFT)
    setBubble(mouseX, mouseY);

  drawBackground(g);
  drawOriginal(g);
  // splashes
  tryBlurCanvas(splashed);
  drawCanvas(g, splashed);
  // bubbles
  drawBubbles(g);
  // gizmos
  gizmos.clear();
  drawCursor(gizmos);
  drawCanvas(g, gizmos);
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
    if (img != null)
    {
      resizeImage(img);
      return true;
    }
  }
  return false;
}
// resize the image so that
// it won't be out of the screen
PImage resizeImage(PImage source)
{
  float xRatio = (displayWidth-2*bleedingX-guiColumnWidth) / (float)source.width;
  float yRatio = (displayHeight-2*bleedingY-40) / (float)source.height;
  float ratio = min(xRatio, yRatio);
  if (ratio < 1 && ratio > 0)
  {
    source.resize(floor(source.width*ratio), floor(source.height*ratio));
  }
  return source;
}
