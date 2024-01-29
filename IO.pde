//
//
//
// io fields
String imgPath = "data/original";
PImage img;
PGraphics output;



// called in settings()
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
// called by button savePaint
void savePaint()
{
  output.clear();
  drawBackground(output);
  drawOriginal(output);
  drawCanvas(output, splashed);
  drawBubbles(output);
  output.save("save-" + saveCount++ + ".tif");
}
