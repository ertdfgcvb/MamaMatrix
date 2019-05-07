/**
 * A small testcard sketch to help with the configuration.
 */
 
 class A0_Testcard extends Anim {
  
  PFont f;
  
  public A0_Testcard() {
    f = loadFont("akz.vlw");
  }

  void render(PGraphics target, int t) {
    target.textFont(f);    
    target.noStroke();
    target.textAlign(CENTER, CENTER);
    target.background(0);
    int num = 0;
    for (int j=0; j<NUM_TILES_Y; j++) {
      for (int i=0; i<NUM_TILES_X; i++) {
        int x = i * MATRIX_WIDTH + MATRIX_WIDTH / 2;
        int y = j * MATRIX_HEIGHT + MATRIX_HEIGHT / 2;
        //target.fill(255,0,0);
        //target.rect(i * MATRIX_WIDTH, j * MATRIX_HEIGHT, MATRIX_WIDTH, MATRIX_HEIGHT);
        target.fill(255);
        target.text(1 + num++, x, y);
      }
    }
  }
}
