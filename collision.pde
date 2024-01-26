// global fields
String imgPath = "resources/original";
PImage img;
PGraphics canvas;
ArrayList<Balloon> balloons;
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
  //noStroke();
  ellipseMode(RADIUS);
  
  tryLoadImage();
  bleedingY += constrain((600-img.height)/2, 0, 300);
  canvas = newCanvas();
  balloons = new ArrayList<Balloon>();
  gui = new GUI(this).init();
  
  windowResize(img.width+2*bleedingX+gui.columnWidth, img.height+2*bleedingY);
}
void draw()
{
  background(darkMode ? 0xff1d1d1f : 0xfff5f5f7);
  tint(0xff, imageAlpha);
  image(img, bleedingX, bleedingY);
  tint(0xff);
  tryBlurCanvas(canvas);
  image(canvas, 0, 0);
  
  if (mousePressed)
    setBalloon(mouseX, mouseY);
  
  for (int i = 0; i < balloons.size(); i++)
    balloons.get(i).onDraw();
    
  stroke(0xff363532);
  noFill();
  ellipse(mouseX, mouseY, scale * 3, scale * 3);
}



// messages
void keyPressed()
{
  switch (key)
  {
    // set a cluster
    case ' ':
      setCluster(mouseX, mouseY); break;
    // blow away balloons
    case 'b':
      blowAll(); break;
  }
}
void mouseWheel(MouseEvent event)
{
  scale += -event.getCount();
  scale = constrain(scale, 2, 16);
}



// custom functions
void tryLoadImage()
{
  String[] extensions = { ".jpg", ".png", ".gif", };
  for (int i = 0; i < extensions.length; i++)
  {
    img = loadImage(imgPath + extensions[i]);
    if (img != null) return;
  }
  // failed to load any image, exit program
  exit();
}
void blowAll()
{
  for (int i = 0; i < balloons.size(); i++)
    balloons.get(i).blowFrom(mouseX, mouseY);
}
Balloon setBalloon(int x, int y)
{
  // border limits
  if (x < bleedingX || x > bleedingX+img.width) return null;
  if (y < bleedingY || y > bleedingY+img.height) return null;
  
  
  if (balloons.size() < 512)
  {
    Balloon balloon = new Balloon(
      x + round(random(-1, 1)),
      y + round(random(-1, 1)),
      scale, img, canvas, TTL);
    balloons.add(balloon);
    balloon.parent = balloons;
    return balloon;
  }
  else
    return null;
}
void setCluster(int x, int y)
{
  for (int i = 0; i < 64; i++)
    setBalloon(x, y);
}
