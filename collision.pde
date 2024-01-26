// global fields
PImage img;
PGraphics canvas;
ArrayList<Balloon> balls;
GUI gui;



// GUI variables
int TTL;
String imagePath = "resources/mona_lisa.jpg";



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
  
  img = loadImage(imagePath);
  canvas = newCanvas();
  balls = new ArrayList<Balloon>();
  gui = new GUI(this).init();
  
  windowResize(img.width+gui.columnWidth, img.height);
}
void draw()
{
  tryBlurCanvas(canvas);
  image(canvas, 0, 0);
  
  if (mousePressed)
    if (mouseX < img.width)
      setBalloon(mouseX, mouseY);
  
  for (int i = 0; i < balls.size(); i++)
    balls.get(i).onDraw();
    
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
    // clear canvas
    case 'c':
      canvas = newCanvas(); break;
    // flush all balloons to drops
    case 'f':
      flushAll(); break;
    // save current frame to file
    case 's':
      saveFrame(); break;
  }
}
void mouseWheel(MouseEvent event)
{
  scale += -event.getCount();
  scale = constrain(scale, 2, 16);
}


 //<>//
// custom functions
void blowAll()
{
  for (int i = 0; i < balls.size(); i++)
    balls.get(i).blowFrom(mouseX, mouseY);
}
void flushAll()
{
  for (int i = balls.size() - 1; i >= 0; i--)
    balls.get(i).flushToCanvas();
}
Balloon setBalloon(int x, int y)
{
  if (balls.size() < 512)
  {
    Balloon ball = new Balloon(
      x + round(random(-1, 1)),
      y + round(random(-1, 1)),
      img, canvas, TTL);
    balls.add(ball);
    ball.parent = balls;
    return ball;
  }
  else
    return null;
}
void setCluster(int x, int y)
{
  for (int i = 0; i < 64; i++)
    setBalloon(x, y);
}
