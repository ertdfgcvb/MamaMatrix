/**
 * Random squares of different sizes.
 */
 
class A1_Squares extends Anim {

  public A1_Squares() {
  }

  void render(PGraphics target, int t) {    
    target.noStroke();    
    //target.stroke(0);    
    int tile = (int) pow(2, (t / 1000) % 6 + 1);
    randomSeed(t / 500);
    int numX = target.width / tile;
    int numY = target.width / tile;
    for (int j=0; j<numY; j++) {
      for (int i=0; i<numX; i++) {
        target.fill(random(255),random(255),random(255));
        target.rect(tile * i, tile * j, tile, tile);
      }
    }
  }
}
