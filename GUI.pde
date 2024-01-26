import controlP5.*;

class GUI
{
  ControlP5 cp;
  int columnWidth;
  
  GUI(processing.core.PApplet theParent)
  {
    this.cp = new ControlP5(theParent);
    this.columnWidth = 260;
  }
  
  GUI init()
  {
    // TTL
    this.cp.addSlider("TTL")
           .setPosition(img.width+40,50)
           .setSize(200,20)
           .setColorLabel(0)
           .setRange(0,512)
           .setValue(256)
           ;
    this.cp.getController("TTL").getCaptionLabel().align(ControlP5.LEFT_OUTSIDE, ControlP5.CENTER).setPaddingX(0);
    this.cp.getController("TTL").getCaptionLabel().getFont().setSize(20);
    this.cp.getController("TTL").getValueLabel().getFont().setSize(16);
    
    return this;
  }
}
