//
//
//
// optimized algorithm
// to find adjacent bubble
ArrayList<ArrayList<Bubble>> chunks;
int xCount, yCount;



void initChunks()
{
  chunks = new ArrayList<ArrayList<Bubble>>();
  
  xCount = ceil(img.width / (float)(8*maxScale));
  yCount = ceil(img.height / (float)(8*maxScale));
  
  for (int x = 0; x < xCount; x++)
  {
    for (int y = 0; y < yCount; y++)
    {
      ArrayList<Bubble> chunk = new ArrayList<Bubble>();
      chunks.add(chunk);
    }
  }
}



ArrayList<Bubble> getChunkByCount(int x, int y)
{
  return chunks.get(x*yCount + y);
}
ArrayList<Bubble> getChunkByPixel(int x, int y)
{
  return getChunkByCount(x/(8*maxScale), y/(8*maxScale));
}



ArrayList<ArrayList<Bubble>> get3x3ChunksByPixel(int x, int y)
{
  ArrayList<ArrayList<Bubble>> result = new ArrayList<ArrayList<Bubble>>();
  
  // canvas coord to image coord
  x -= bleedingX;
  y -= bleedingY;
  
  int xCurr = x / (8*maxScale);
  int yCurr = y / (8*maxScale);
  int xLeft = max(xCurr-1, 0);
  int xRight = min(xCurr+1, xCount-1);
  int yUp = max(yCurr-1, 0);
  int yDown = min(yCurr+1, yCount-1);
  
  for (int i = xLeft; i <= xRight; i++)
  {
    for (int j = yUp; j <= yDown; j++)
    {
      result.add(getChunkByCount(i, j));
    }
  }
  
  return result;
}
