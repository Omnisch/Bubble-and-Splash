import controlP5.*;

// GUI variables
String imagePath = "resources/mona_lisa.jpg";
int TTL;
float fraction;
float gravity;



class GUI
{
  ControlP5 cp;
  Slider TTLSlider;
  Slider gravitySlider;
  int columnWidth = 260;
  
  GUI(processing.core.PApplet theParent)
  {
    this.cp = new ControlP5(theParent);
  }
  
  GUI init()
  {
    // clear canvas
    arrangeControllers(
      cp.addButton("clearCanvas")
        .setSize(200, 20)
      ,false).getCaptionLabel().setText("clear  canvas").setColor(0xff);
    
    // poke all
    arrangeControllers(
      cp.addButton("pokeAll")
        .setSize(200, 20)
      ,false).getCaptionLabel().setText("poke  all").setColor(0xff);
    
    // TTL
    TTLSlider = (Slider)arrangeControllers(
      cp.addSlider("TTL")
        .setSize(200, 20)
        .setRange(0, 512)
        .setValue(128)
      ,true);
    
    // fraction
    arrangeControllers(
      cp.addSlider("fraction")
        .setSize(200, 20)
        .setRange(0, 1)
        .setValue(0.1)
      ,true);
    
    // gravity
    gravitySlider = (Slider)arrangeControllers(
      cp.addSlider("gravity")
        .setSize(200, 20)
        .setRange(0, 3)
        .setNumberOfTickMarks(7)
        .setColorTickMark(0)
        .setValue(0)
      ,true);
    
    // save frame
    arrangeControllers(
      cp.addButton("saveFrame")
        .setSize(200, 20)
      ,false).getCaptionLabel().setText("save  current  frame").setColor(0xff);
    
    return this;
  }
  
  
  
  // arrangement functions
  Controller arrangeControllers(Controller ctrl, boolean align)
  {
    ctrl.setPosition(cx(), cy());
    ctrl.getCaptionLabel().setColor(0).getFont().setSize(20);
    ctrl.getValueLabel().getFont().setSize(16);
    if (align) ctrl.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
    return ctrl;
  }
  int controllerCount = 0;
  int cx() { return img.width + 30; }
  int cy() { return ++controllerCount * 50; }
}


// messages
void controlEvent(ControlEvent event)
{
  if (gui == null) return;
  
  if (event.isFrom("gravity"))
    clampTTL();
  else if (event.isFrom("TTL"))
    checkTTLEdge();
}
// called by button clearCanvas
void clearCanvas()
{
  canvas = newCanvas();
}
// called by button pokeAll
void pokeAll()
{
  for (int i = balloons.size() - 1; i >= 0; i--)
    balloons.get(i).flushToCanvas();
}
// called by slider TTL
void checkTTLEdge()
{
  if (gui.TTLSlider.getValue() == 512)
  {
    TTL = -1;
    gui.TTLSlider.getValueLabel().setText("infinity");
  }
}
// called by slider gravity
void clampTTL()
{
  int times = (int)map(gui.gravitySlider.getValue(), 0, gui.gravitySlider.getMax(), 0, 6);
  int maxTTL = (int)(512 * pow(0.5, times));
  
  if (gui.TTLSlider.getMax() != maxTTL)
    gui.TTLSlider.setRange(0, maxTTL)
             .setValue(constrain(gui.TTLSlider.getValue(), 0, maxTTL))
             .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
}
