/**
 * Displaying and animating a loaded image.
 */

class A2_Texture extends Anim {

  PImage tex;
  
  public A2_Texture() {
    tex = loadImage("pat.png");
  }

  void render(PGraphics target, int t) {  
    float offs_x = map(cos(t * 0.000095), -1, 1, -tex.width*0.2, tex.width*0.2);
    float offs_y = map(sin(t * 0.000077), -1, 1, -tex.height*0.2, tex.height*0.2);
    float ang    = map(sin(t * 0.000058), -1, 1, -PI*4, PI*4);
    float scale  = map(sin(t * 0.000081), -1, 1, 0.25, 1.0);
    target.pushMatrix();
    target.background(0);
    target.translate(target.width/2, target.height/2);
    target.scale(scale);
    target.translate(offs_x, offs_y);
    target.rotate(ang);
    target.image(tex, -tex.width/2, -tex.height/2);
    target.popMatrix();
  }
}
