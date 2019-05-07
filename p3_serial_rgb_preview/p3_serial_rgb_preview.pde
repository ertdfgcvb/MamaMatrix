/**
 * Example 3.
 * This sketch sends all the pixels rendered to a texture to the serial port.
 * A preview is rendere also to the main canvas.
 * A helper function to scan all the serial ports for a configured controller is provided. 
 *
 * Note 
 * The serial object is disabled for preview purposes. 
 * Make sure to initialize it properly
 */
 
 import processing.serial.*;

final int NUM_TILES_X   = 2; // The number of tiles, make sure that the NUM_TILES const
final int NUM_TILES_Y   = 2; // has the correct value in the slave program
final int MATRIX_WIDTH  = 64;  
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; 

Serial serial;
PGraphics tex;
byte[]buffer;  

void setup() {
  size(810, 600, P3D);  

  int buffer_length = NUM_TILES_X * MATRIX_WIDTH * NUM_TILES_Y * MATRIX_HEIGHT * NUM_CHANNELS;
  buffer = new byte[buffer_length];
  tex = createGraphics(NUM_TILES_X * MATRIX_WIDTH, NUM_TILES_Y * MATRIX_HEIGHT, P3D);

  // Init serial
  // serial = scanSerial();             // Mac
  // serial = new Serial(this, "COM3"); // Windows
}

void draw() {

  // Render something to a render target
  tex.beginDraw();
  tex.background(0);
  tex.ortho();
  tex.stroke(255);
  tex.noStroke();
  tex.fill(0);  
  tex.translate(tex.width/2, tex.height/2);
  float b = min(tex.width, tex.height) * 0.5;
  for (int i=-20; i<=20; i++) {
    tex.fill((i+100) % 2 * 255);  
    tex.pushMatrix();
    tex.translate(i * b * 0.2, 0);
    float a = frameCount + i * 5;
    tex.rotateX(a * 0.011);
    tex.rotateY(a * 0.012);
    tex.rotateZ(a * 0.013);
    tex.box(b);
    tex.popMatrix();
  } 
  tex.endDraw();
  tex.loadPixels();

  // Write to the serial port (if open)
  if (serial != null) {    
    int idx = 0;
    for (int j=0; j<NUM_TILES_Y; j++) {
      for (int i=0; i<NUM_TILES_X; i++) {
        PImage tmp = tex.get(i * MATRIX_WIDTH, j * MATRIX_HEIGHT, MATRIX_WIDTH, MATRIX_HEIGHT);        
        for (color c : tmp.pixels) { 
          buffer[idx++] = (byte)(c >> 16 & 0xFF); 
          buffer[idx++] = (byte)(c >> 8 & 0xFF);
          buffer[idx++] = (byte)(c & 0xFF);
        }
      }
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  } 

  // Preview
  background(80);

  // Offset and size of the preview
  int preview_size = 6;
  int ox = 20;
  int oy = 40;

  // Grid background
  fill(0);
  noStroke();
  rect(ox, oy, tex.width * preview_size, tex.height * preview_size);  

  // LEDs
  for (int j=0; j<tex.height; j++) {
    for (int i=0; i<tex.width; i++) {
      int idx = i + j * tex.width;
      color c = tex.pixels[idx];
      fill(c); 
      int x = ox + i * preview_size;
      int y = oy + j * preview_size;
      rect(x, y, preview_size-1, preview_size-1);
    }
  }

  // Matrix outline
  noFill();
  stroke(255);
  for (int j=0; j<NUM_TILES_Y; j++) {
    for (int i=0; i<NUM_TILES_X; i++) {
      int x = i * MATRIX_WIDTH * preview_size + ox;
      int y = j * MATRIX_HEIGHT * preview_size + oy;
      rect(x, y, MATRIX_WIDTH * preview_size, MATRIX_HEIGHT * preview_size);
    }
  }
}
