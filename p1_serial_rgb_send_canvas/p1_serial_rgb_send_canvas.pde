/**
 * This sketch sends all the pixels of the canvas to the serial port.
 * A helper function to scan all the serial ports for a configured controller is provided. 
 */

import processing.serial.*;

final int MATRIX_WIDTH  = 64;  
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; 
final int NUM_TILES     = 1; 

Serial serial;
byte[]buffer; 

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // so we can't do: size(MATRIX_WIDTH, NUM_TILES * MATRIX_HEIGHT);
  // NOTE: the default layout is vertically stacked tiles.
  size(64, 32, P3D); 

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_TILES * NUM_CHANNELS];

  // init serial manually (on Windows):
  // serial = new Serial(this, "COM3");
  // or trough the helper function:
  serial = scanSerial();  

  // Defaults:
  /*
  if (serial != null) {
   serial.write('b'); // brightess command
   serial.write(255); // brightess value (0-255)
   
   serial.write('c'); // color correction command
   serial.write(1);   // 0 to disable, 1 to enable
   
   serial.write('s'); // double buffer command
   serial.write(0);   // 0 to disable, 1 to enable
   }
   */
}

void draw() {

  // Render some forms to the canvas
  background(0);
  ortho();
  stroke(255);
  fill(0);  
  translate(width/2, height/2);
  float b = min(width, height) * 0.48;
  for (int i=-10; i<=10; i++) {
    pushMatrix();
    translate(i * b * 0.35, 0);
    float a = frameCount + i * 5;
    rotateX(a * 0.011);
    rotateY(a * 0.015);
    rotateZ(a * 0.017);
    box(b);
    popMatrix();
  }

  // Write to the serial port (if open)
  if (serial != null) {    
    loadPixels();    
    int idx = 0;
    for (int i=0; i<pixels.length; i++) { 
      color c = pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
      buffer[idx++] = (byte)(c & 0xFF);       // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}
