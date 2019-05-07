class Anim {
  
  int count = 0;
  int w = -0;
  int h = -0;
  PFont f;

  public Anim() {

  }

  void pre(PGraphics target) {
    target.resetMatrix();
    target.pushStyle();
    w = target.width;
    h = target.height;
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
