/**
 * The animation class, meant to be extended.
 */
 
 class Anim {
  
  int count = 0; // a counter
  PFont f;

  public Anim() {

  }

  void pre(PGraphics target) {
    target.resetMatrix();
    target.pushStyle();
  }

  void render(PGraphics target, int t) {
    
  }

  void post(PGraphics target) {
    target.popStyle();
    count++;
  }
  
  void keyPressed(int key, int keyCode){
  
  }
  
  void mousePressed(int x, int y){
  
  }
  
}
