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
    // TTL
    TTLSlider = (Slider)arrangeLabels(
      cp.addSlider("TTL")
        .setSize(200, 20)
        .setRange(0, 512)
        .setValue(128)
      );
    
    // fraction
    arrangeLabels(
      cp.addSlider("fraction")
        .setSize(200, 20)
        .setRange(0, 1)
        .setValue(0.1)
      );
    
    // gravity
    gravitySlider = (Slider)arrangeLabels(
      cp.addSlider("gravity")
        .setSize(200, 20)
        .setRange(0, 3)
        .setNumberOfTickMarks(7)
        .setColorTickMark(0)
        .setValue(0)
      );
    
    return this;
  }
  
  
  
  // TTL operations
  void checkEdgeTTL()
  {
    if (TTLSlider.getValue() == 512)
    {
      TTL = -1;
      TTLSlider.getValueLabel().setText("infinity");
    }
  }
  void clampTTL()
  {
    int times = (int)map(gravitySlider.getValue(), 0, gravitySlider.getMax(), 0, 6);
    int maxTTL = (int)(512 * pow(0.5, times));
    
    if (TTLSlider.getMax() != maxTTL)
      TTLSlider.setRange(0, maxTTL)
               .setValue(constrain(TTLSlider.getValue(), 0, maxTTL))
               .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
  }
  
  
  
  // arranging functions
  Controller arrangeLabels(Controller ctrl)
  {
    ctrl.setPosition(cx(), cy());
    ctrl.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE);
    ctrl.getCaptionLabel().setColor(0).getFont().setSize(20);
    ctrl.getValueLabel().getFont().setSize(16);
    return ctrl;
  }
  int controllerCount = 0;
  int cx() { return img.width + 30; }
  int cy() { return ++controllerCount * 50; }
}
