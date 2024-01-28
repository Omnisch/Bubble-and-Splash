//
//
//
// canvas fields
int blurLoopTick = 0;



// canvas functions
PGraphics newCanvas()
{
  PGraphics canvas;
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.ellipseMode(RADIUS);
  canvas.endDraw();
  return canvas;
}
void blurCanvas(PGraphics canvas)
{
  PImage blurred = createImage(canvas.width, canvas.height, ARGB);
  blurred.loadPixels();
  for (int y = 1; y < canvas.height-1; y++)
    for (int x = 1; x < canvas.width-1; x++)
      for (int i = 0; i < 32; i += 8)
      {
        blurred.pixels[y*blurred.width + x] |= (int)(
          1/16.0 * (canvas.get(x-1, y-1) >> i & 0xff) +
          2/16.0 * (canvas.get(x-1, y+0) >> i & 0xff) +
          1/16.0 * (canvas.get(x-1, y+1) >> i & 0xff) +
          2/16.0 * (canvas.get(x+0, y-1) >> i & 0xff) +
          4/16.0 * (canvas.get(x+0, y+0) >> i & 0xff) +
          2/16.0 * (canvas.get(x+0, y+1) >> i & 0xff) +
          1/16.0 * (canvas.get(x+1, y-1) >> i & 0xff) +
          2/16.0 * (canvas.get(x+1, y+0) >> i & 0xff) +
          1/16.0 * (canvas.get(x+1, y+1) >> i & 0xff)) << i;
      }
  blurred.updatePixels();
  canvas.beginDraw();
  canvas.clear();
  canvas.image(blurred, 0, 0);
  canvas.endDraw();
}
boolean tryBlurCanvas(PGraphics canvas)
{
  if (!autoBlur) return false;
  
  if (++blurLoopTick > 256)
  {
    blurLoopTick = 0;
    blurCanvas(canvas);
    return true;
  }
  else
    return false;
}
void drawCanvas(PGraphics canvas)
{
  image(canvas, 0, 0);
}
// no need to call in draw()
void drawAssistantGrid(PGraphics canvas)
{
  canvas.strokeWeight(1);
  canvas.stroke(0xffa0a0a0);
  canvas.beginDraw();
  int maxX = bleedingX+img.width + 8*maxScale - img.width%(8*maxScale);
  int maxY = bleedingY+img.height + 8*maxScale - img.height%(8*maxScale);
  for (int x = bleedingX; x <= maxX; x += 8*maxScale)
  {
    canvas.line(x, bleedingY, x, maxY);
    for (int y = bleedingY; y <= maxY; y += 8*maxScale)
      canvas.line(bleedingX, y, maxX, y);
  }
  canvas.endDraw();
}
