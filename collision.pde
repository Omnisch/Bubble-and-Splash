PImage img;
PGraphics canvas;
ArrayList<Balloon> balls;
boolean setTTL;

void setup()
{
  stroke(0xff363532);
  strokeWeight(2);
  //noStroke();
  ellipseMode(RADIUS);
  
  img = loadImage("resources/mona_lisa.jpg");
  windowResize(img.width, img.height);

  canvas = newCanvas();
  balls = new ArrayList<Balloon>();
  setTTL = true;
}

void draw()
{
  tryBlurCanvas(canvas);
  image(canvas, 0, 0);
  
  if (mousePressed)
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
    case ' ':
      setCluster(mouseX, mouseY); break;
    case 'b':
      blowAll(); break;
    case 'c':
      canvas = newCanvas(); break;
    case 'f':
      flushAll(); break;
    case 'i':
      setTTL = true; break;
    case 'o':
      setTTL = false; break;
    case 's':
      saveFrame(); break;
  }
}
void mouseWheel(MouseEvent event)
{
  scale += -event.getCount();
  scale = constrain(scale, 2, 16);
}

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
Balloon setBalloon(int x, int y) //<>//
{
  if (balls.size() < 512)
  {
    Balloon ball = new Balloon(
      x + round(random(-1, 1)),
      y + round(random(-1, 1)),
      img, canvas, setTTL);
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
