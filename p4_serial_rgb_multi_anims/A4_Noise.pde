/**
 * A Perlin noise example.
 */

class A4_Noise extends Anim {
  
  int step_x, step_y;
  int blur;
  PGraphics target;

  public A4_Noise() {
    step_x = 8;
    step_y = 8;
    blur = 4;
  }

  void render(PGraphics target, int t) {
    target.background(0);
    target.noStroke();

    float ns = 0.25;
    float nx = t * 0.0002;
    float nz = t * 0.0006;
    for (int j=0; j<target.height; j+=step_y) {
      for (int i=0; i<target.width; i+=step_x) {
        float n = noise(i/step_x * ns + nx, j/step_y * ns + nx, nz);
        color a = color(0, 0, 255);
        color b = color(255, 0, 0);
        float l = constrain(map(n, 0.6, 0.7, 0, 1), 0, 1);
        color c = lerpColor(a, b, l);
        target.fill(c);
        if (n > 0.4) {
          float d = map(n, 0.4, 0.7, 0, step_x);
          target.rect(i, j, d, d);
        }
      }
    }

    // Add some blur the whole thing
    if (blur > 0) {
      target.filter(BLUR, blur);
    }

    // Add the grid (could be better)
    for (int j=0; j<target.height; j+=step_y) {
      for (int i=0; i<target.width; i+=step_x) {
        float n = noise(i/step_x * ns + nx, j/step_y * ns + nx, nz);
        float l = constrain(map(n, 0.4, 0.7, 0, 255), 50, 255);
        target.fill(l);       
        target.rect(i, j, 1, 1);
      }
    } 
  }

  void keyPressed(int key, int keyCode) {
    if (key == '1') {
      step_x = 8;
      step_y = 8;
      blur = 4;
    } else if (key == '2') {
      step_x = 4;
      step_y = 4;
      blur = 4;
    } else if (key == '3') {
      step_x = 4;
      step_y = 4;
      blur = 0;
    } else if (key == '4') {
      step_x = 8;
      step_y = 8;
      blur = 0;
    } else if (key == '5') {
      step_x = 16;
      step_y = 16;
      blur = 0;
    }
  }
}
