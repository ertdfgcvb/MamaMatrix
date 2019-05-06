/**
 * Checks all the serial ports for a connected controller (for example a Teensy).
 *
 * @return a Serial port or null 
 */

Serial scanSerial() {

  String[] list = Serial.list();

  Serial p;

  // Loop backwards: more likely to find the Teensy at the bottom of the list...
  for (int i=list.length-1; i>=0; i--) {  
    String portName = list[i];
    try {
      p = new Serial(this, portName);
    } 
    catch (Exception e) {
      println("Serial port " + portName + " could not be initialized... Skipping.");
      continue;
    }      
    // 1
    // Query the controller with the info '?' command:
    p.clear();
    p.write('?');
    delay(50);
    while (p.available () > 0) {
      String buf = p.readString();
      if (buf != null && buf.contains("MAT")) {
        println("Matrix controller found!");
        println(parseInfo(buf));
        return p;
      }
    }
  }

  // Nothing found.
  return null;
}

/**
 * Tries to parse the info string coming from the micro controller.
 *
 * @return a String 
 */
String parseInfo(String info) {
  String[] chunks = split(trim(info), ',');
  String out = "";
  if (chunks == null || chunks.length != 8) {
    out = "Wrong parameters";
  } else {
    out += "Version str.           : " + chunks[0] + "\n";
    out += "MATRIX_WIDTH           : " + chunks[1] + "\n";
    out += "MATRIX_HEIGHT          : " + chunks[2] + "\n";
    out += "NUM_CHANNELS           : " + chunks[3] + "\n";
    out += "NUM_TILES              : " + chunks[4] + "\n";
    out += "brightnessValue        : " + chunks[5] + "\n";
    out += "colorCorrectionEnabled : " + chunks[6] + "\n";
    out += "swapBuffersEnabled     : " + chunks[7] + "\n";
  }
  return out;
}
