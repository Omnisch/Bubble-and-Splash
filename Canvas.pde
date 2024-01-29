//
//
//
// canvas fields
PGraphics splashed;
PGraphics output;
PGraphics gizmos;
int blurLoopTick = 0;



// canvas functions
PGraphics newCanvas(int canvasWidth, int canvasHeight)
{
  PGraphics canvas;
  canvas = createGraphics(canvasWidth, canvasHeight);
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
  
  if (++blurLoopTick > 128)
  {
    blurLoopTick = 0;
    blurCanvas(canvas);
    return true;
  }
  else
    return false;
}



void drawCanvas(PGraphics canvas, PGraphics toDraw)
{
  if (canvas != g) canvas.beginDraw();
  canvas.image(toDraw, 0, 0);
  if (canvas != g) canvas.endDraw();
}
void drawBackground(PGraphics canvas)
{
  if (canvas != g) canvas.beginDraw();
  canvas.background(darkMode ? 0xff1d1d1f : 0xfff5f5f7);
  if (canvas != g) canvas.endDraw();
}
void drawOriginal(PGraphics canvas)
{
  if (canvas != g) canvas.beginDraw();
  canvas.tint(0xff, imageAlpha);
  canvas.image(img, bleedingX, bleedingY);
  canvas.tint(0xff);
  if (canvas != g) canvas.endDraw();
}
void drawCursor(PGraphics canvas)
{
  if (canvas != g) canvas.beginDraw();
  canvas.stroke(strokeColor);
  canvas.strokeWeight(2);
  canvas.noFill();
  canvas.ellipse(mouseX, mouseY, scale * 4, scale * 4);
  if (canvas != g) canvas.endDraw();
}
void drawChunkGrid(PGraphics canvas)
{
  canvas.beginDraw();
  canvas.stroke(0xffa0a0a0);
  canvas.strokeWeight(1);
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
