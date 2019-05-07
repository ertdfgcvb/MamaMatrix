/**
 * Example 4.
 * This sketch sends all the pixels rendered to a texture to the serial port.
 * An animation class is provided to facilitate the management of multiple scenes.
 * A helper function to scan all the serial ports for a configured controller is provided. 
 *
 * Keys
 * LEFT/RIGHT : previous/next scene
 * 1-9        : some scenes have a few different modes
 *
 * NOTE: 
 */

import processing.serial.*;
import java.lang.reflect.*; 

final int NUM_TILES_X   = 2;
final int NUM_TILES_Y   = 2;
final int MATRIX_WIDTH  = 64;  
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; 

Serial serial;
PGraphics tex;
byte[]buffer;   

Anim anim;
int current_anim_id = 0;
ArrayList <Class> anim_classes;

void setup() {
  size(810, 600); 

  textFont(loadFont("mono.vlw"));

  int buffer_length = NUM_TILES_X * MATRIX_WIDTH * NUM_TILES_Y * MATRIX_HEIGHT * NUM_CHANNELS;
  buffer = new byte[buffer_length];
  tex = createGraphics(NUM_TILES_X * MATRIX_WIDTH, NUM_TILES_Y * MATRIX_HEIGHT, JAVA2D);

  // intit anims:  
  String superClassName = "Anim";
  anim_classes = new ArrayList<Class>();
  for (Class c : this.getClass().getDeclaredClasses()) {
    if (c.getSuperclass() != null && (c.getSuperclass().getSimpleName().equals(superClassName) )) {
      println("<" + superClassName + ">: [" + anim_classes.size() + "] " + c.getSimpleName());
      anim_classes.add(c);
    }
  }

  // init serial:
  // serial = scanSerial();      
  anim = createInstance(current_anim_id);
}

void draw() {

  // Animate and render the current animation to a texture
  tex.beginDraw();
  anim.pre(tex);
  anim.render(tex, millis());
  anim.post(tex);
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
  int oy = 160;
  
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

  // Some info
  String txt = "";
  txt += "FPS           : " + round(frameRate) + "\n";
  txt += "NUM_TILES_X   : " + NUM_TILES_X + "\n";
  txt += "NUM_TILES_Y   : " + NUM_TILES_Y + "\n";
  txt += "MATRIX_WIDTH  : " + MATRIX_WIDTH + "\n";
  txt += "MATRIX_HEIGHT : " + MATRIX_HEIGHT + "\n";
  txt += "NUM_CHANNELS  : " + NUM_CHANNELS + "\n";
  txt += "Serial        : " + (serial != null ? "connected" : "disconnected") + "\n";
  txt += "<Anim>        : [" + current_anim_id  +"] " + anim.getClass().getSimpleName() + "\n"; 

  fill(255);
  textAlign(LEFT, TOP);
  text(txt, ox, 15);
}

/**
 * Creates an instance of the super Anim classes
 *
 * @return An Anim object
 */
Anim createInstance(int id) {
  try {
    Class c = anim_classes.get(id);
    Constructor[] constructors = c.getConstructors();
    Anim instance = (Anim) constructors[0].newInstance(this);
    return instance;
  } 
  catch (Exception e) {
    println(e);
  }
  return null;
}

void keyPressed() {
  if (keyCode == RIGHT) {
    tex.beginDraw();
    tex.background(0);
    tex.endDraw();
    current_anim_id = min(current_anim_id + 1, anim_classes.size()-1);
    anim = createInstance(current_anim_id);
  } else if (keyCode == LEFT) {
    tex.beginDraw();
    tex.background(0);
    tex.endDraw();
    current_anim_id = max(current_anim_id - 1, 0);
    anim = createInstance(current_anim_id);
  } 
  
  // Forward the keyPress to the current anim
  anim.keyPressed(key, keyCode);
}

void mousePressed() {
  // Forward the mousePress to the current anim
  anim.mousePressed(mouseX, mouseY);
}

void mouseDragged() {
}

void mouseReleased() {
}
