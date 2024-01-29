// Processing 4.3 & ControlP5
// designed and programmed by Omnistudio @2023
//
import controlP5.*;


void settings()
{
  if (!tryLoadImage())
  {
    exit(); return;
  }
  // deal with too-small original image
  bleedingX += max((600-img.width)/2, 0);
  bleedingY += max((720-img.height)/2, 0);
  size(img.width+2*bleedingX+guiColumnWidth, img.height+2*bleedingY);
}


void setup()
{
  // canvas setup
  ellipseMode(RADIUS);
  stroke(0xff363532);
  strokeWeight(2);
  int canvasWidth = img.width+2*bleedingX;
  int canvasHeight = img.height+2*bleedingY;
  splashed = newCanvas(canvasWidth, canvasHeight);
  output = newCanvas(canvasWidth, canvasHeight);
  gizmos = newCanvas(canvasWidth, canvasHeight);
  // chunk setup
  initChunks();
  // gui setup
  gui = new GUI(this).init();
}


void draw()
{
  if (mousePressed && mouseButton == LEFT)
    if (!singleMode)
      setBubble(mouseX, mouseY);
  // background
  drawBackground(g);
  drawOriginal(g);
  // splashes
  tryBlurCanvas(splashed);
  drawCanvas(g, splashed);
  // bubbles
  updateBubbles();
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
  if (mouseButton == LEFT)
    if (singleMode)
      setBubble(mouseX, mouseY);
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
