import processing.serial.*;
import java.lang.reflect.*;

int MATRIX_WIDTH   = 64;  
int MATRIX_HEIGHT = 32;

Serial serial;
byte[]buffer; 
PGraphics tex;

void setup() {
  size(640, 480); 
  noSmooth();

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * 3];
  tex = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);

  // init serial:
  // serial = new Serial(this, "COM3");
  // serial = scanSerial();
}

void draw() {
  background(160);

  tex.beginDraw();
  tex.background(0);
  tex.stroke(255);
  for (int i=0; i<200; i++) {
    tex.point(random(tex.width), random(tex.height));
  }
  tex.endDraw();
  
  // preview:
  int s = 9;  
  int ox = (width - s * MATRIX_WIDTH) / 2;
  int oy = 80;
  image(tex, ox , 20);
  noStroke();
  for (int j=0; j<tex.height; j++) {
    for (int i=0; i<tex.width; i++) {    
      color col = tex.pixels[i + j * tex.width];
      fill(col);
      rect(i * s + ox, j * s + oy, s-1, s-1);
    }
  }

  // serial write
  if (serial != null) {
    tex.loadPixels();

    int b = 0; // brightness adjust
    int idx = 0;
    color c;
    for (int i=0; i<tex.pixels.length; i++) { 
      c = tex.pixels[i];
      buffer[idx++] = (byte) max((c >> 16 & 0xFF) - b, 0); 
      buffer[idx++] = (byte) max((c >> 8 & 0xFF) - b, 0);
      buffer[idx++] = (byte) max((c & 0xFF) - b, 0);
    }
    serial.write('*');
    serial.write(buffer);
  }
}
