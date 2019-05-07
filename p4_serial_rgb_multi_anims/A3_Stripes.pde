/**
 * Just some stripes.
 */

class A3_Stripes extends Anim {

  public A3_Stripes() {
  }

  void render(PGraphics target, int t) {
    float offs_x = map(cos(t * 0.00035), -1, 1, -target.width*2, target.width*2);    
    float ang    = map(sin(t * 0.00058), -1, 1, -QUARTER_PI, QUARTER_PI);
    float rect_w = map(sin(t * 0.00081), -1, 1, 4, 32);
    float rect_h = height * 2;
        
    target.pushMatrix();
    target.background(255,0,0);
    target.fill(0,255,0);
    target.noStroke();
    target.translate(target.width/2 + offs_x, target.height/2);
    target.rotate(ang);

    for (int i=-60; i<=60; i++) {
      float rect_x = i * (rect_w * 2);
      float rect_y = -rect_h / 2;
      target.rect(rect_x, rect_y, rect_w, rect_h);
    }

    target.popMatrix();
  }
}
