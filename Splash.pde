//
//
//
// single object splash
class Splash
{
  int x, y;
  float size;
  PVector velocity;
  color colour;
  PGraphics canvas;
  
  Splash(int x, int y, float size, PVector velocity, color colour, PGraphics canvas)
  {
    this.x = x;
    this.y = y;
    this.size = size;
    this.velocity = velocity;
    this.colour = colour;
    this.canvas = canvas;
  }
  
  void onDraw()
  {
    float angle = velocity.magSq() > 4 ? velocity.heading() : PI/2;
    float dither = random(1, 6);
    int particleCount = 30;
    canvas.beginDraw();
    for (int i = 0; i < particleCount; i++)
    {
      int centerX =
        x + round(dither*random(-2,3) + (size * i / (float)particleCount) * dither*cos(angle));
      int centerY =
        y + round(dither*random(-2,3) + (size * i / (float)particleCount) * dither*sin(angle));
      canvas.strokeWeight(size *
        constrain((particleCount-i) + random(-3,4), 1, size) / particleCount);
      //canvas.strokeWeight(
      //  Palette.SimilarTo(colour,0xffb5a55a,30) ?
      //  0.3*size * constrain((particleCount-i) + random(-3,4), 1, size) / particleCount :
      //  size * constrain((particleCount-i) + random(-3,4), 1, size) / particleCount);
      canvas.stroke(colour & 0x80ffffff);
      canvas.point(bleedingX+centerX, bleedingY+centerY);
    }
    canvas.endDraw();
  }
}
