/**
 * This sketch sends all the pixels of the canvas to the serial port.
 * A helper function to scan all the serial ports for a configured controller is provided. 
 *
 * Keys
 * ?   : read some info
 * c/C : enable/disable color correction
 * s/s : enable/disable double buffer
 * +/- : increase/decrease brightness (steps of 10)
 */

import processing.video.*;
import processing.serial.*;

final int MATRIX_WIDTH  = 64;  
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; 
final int NUM_TILES     = 1; 

Serial serial;
byte[]buffer; 

Capture cam;

int brightness = 255;

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

  if (serial != null) {
    serial.write('b');        // brightess command
    serial.write(brightness); // brightess value (0-255)
  }

  // Init the webcam: depending on the driver this resolution may or may not be accepted.
  cam = new Capture(this, 640, 480);
  cam.start();
}

void draw() {

  if (cam.available()) {
    cam.read();

    float aspect = (float)(cam.height) / cam.width;
    float w = width;
    float h = w * aspect;

    // Display the scaled webcam image on the canvas
    image(cam, 0, 0, w, h);
    
    // Uncomment to enable a threshold filter:
    // filter(THRESHOLD, map(sin(frameCount*0.02), -1, 1, 0.1, 0.7));
    
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
}

void keyPressed() {
  if (serial == null) return;

  if (key == 'c') {   
    serial.write('c');        // enable color correction 
    serial.write(1);
  } else if (key == 'C') {
    serial.write('c');        // disable color correction
    serial.write(0);
  } else if (key == 's') {
    serial.write('s');        // enable double buffer
    serial.write(1);
  } else if (key == 'S') {
    serial.write('s');        // disable double buffer
    serial.write(0);
  } else if (key == '+') {
    brightness = min(brightness + 10, 255);
    serial.write('b');        // brightess command
    serial.write(brightness); // brightess value (0-255)
  } else if (key == '-') {
    brightness = max(brightness - 10, 0);
    serial.write('b');        // brightess command
    serial.write(brightness); // brightess value (0-255)
  } else if (key == '?') {
    serial.write('?');
    delay(50);                // not optimal
    String buf = serial.readString();
    println(parseInfo(buf));
  }
}
