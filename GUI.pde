//
//
//
// GUI fields
GUI gui;
int bleedingX = 50;
int bleedingY = 50;
int guiColumnWidth = 240;
int saveCount = 0;



// GUI variables
int TTL;
float fraction;
float gravity;
int imageAlpha;
boolean darkMode;
boolean autoBlur;
boolean drawStroke;
boolean translucent;
boolean highlight;
boolean singleMode;
boolean rawSplash;



// packaged GUI part
class GUI
{
  ControlP5 cp;
  Slider TTLSlider;
  Slider gravitySlider;
  
  GUI(processing.core.PApplet theParent)
  {
    this.cp = new ControlP5(theParent);
  }
  
  GUI init()
  {
    // clear canvas
    arrangeControllers(
      cp.addButton("clearSplash")
        .setSize(180, 20)
      ,false).getCaptionLabel().setText("clear  canvas").setColor(0xff);
    
    // poke all
    arrangeControllers(
      cp.addButton("pokeAll")
        .setSize(180, 20)
      ,false).getCaptionLabel().setText("poke  all").setColor(0xff);
    
    // save frame
    arrangeControllers(
      cp.addButton("savePaint")
        .setSize(180, 20)
      ,false).getCaptionLabel().setText("save  paint").setColor(0xff);
    
    // TTL
    TTLSlider = (Slider)arrangeControllers(
      cp.addSlider("TTL")
        .setSize(180, 20)
        .setRange(0, 512)
        .setValue(128)
      ,true);
    
    // fraction
    arrangeControllers(
      cp.addSlider("fraction")
        .setSize(180, 20)
        .setRange(0, 1)
        .setValue(0.1)
      ,true);
    
    // gravity
    gravitySlider = (Slider)arrangeControllers(
      cp.addSlider("gravity")
        .setSize(180, 20)
        .setRange(0, 3)
        .setValue(0)
      ,true);
    
    // alpha value of original image
    arrangeControllers(
      cp.addSlider("imageAlpha")
        .setSize(180, 20)
        .setRange(0, 255)
        .setValue(63)
      ,true).getCaptionLabel().setText("image  alpha");
    
    // dark mode
    arrangeControllers(
      cp.addToggle("darkMode")
        .setSize(60, 20)
        .setValue(false)
        .setMode(ControlP5.SWITCH)
      ,true).getCaptionLabel().setText("dark  mode");
    
    // auto blur splash canvas
    arrangeControllers(
      cp.addToggle("autoBlur")
        .setSize(60, 20)
        .setValue(true)
      ,true).getCaptionLabel().setText("auto  blur");
    
    // draw strokes of bubbles
    arrangeControllers(
      cp.addToggle("drawStroke")
        .setSize(60, 20)
        .setValue(true)
      ,true).getCaptionLabel().setText("draw  stroke");
    
    // translucent bubbles
    arrangeControllers(
      cp.addToggle("translucent")
        .setSize(60, 20)
        .setValue(true)
      ,true);
    
    // highlights on bubbles
    arrangeControllers(
      cp.addToggle("highlight")
        .setSize(60, 20)
        .setValue(true)
      ,true);
    
    // single mode
    arrangeControllers(
      cp.addToggle("singleMode")
        .setSize(60, 20)
        .setValue(false)
      ,true).getCaptionLabel().setText("single  mode");
    
    // raw splash
    arrangeControllers(
      cp.addToggle("rawSplash")
        .setSize(60, 20)
        .setValue(false)
      ,true).getCaptionLabel().setText("raw  splash");
    
    return this;
  }
  
  
  
  // arrangement functions
  Controller arrangeControllers(Controller ctrl, boolean align)
  {
    ctrl.setPosition(cx(), cy());
    ctrl.getCaptionLabel().setColor(0xff2255bb).getFont().setSize(20);
    ctrl.getValueLabel().getFont().setSize(16);
    if (align) ctrl.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
    return ctrl;
  }
  int controllerCount = 0;
  int cx() { return img.width + 2*bleedingX + 10; }
  int cy() { return ++controllerCount * 50 + 30; }
}



// GUI messages
void controlEvent(ControlEvent event)
{
  if (gui == null) return;
  
  if (event.isFrom("clearSplash"))
    splashed = newCanvas(splashed);
  if (event.isFrom("gravity"))
    clampTTL();
  if (event.isFrom("TTL"))
    checkTTLEdge();
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
