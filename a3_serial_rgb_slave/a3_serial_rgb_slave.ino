/**
 * Example 3.
 * The controller turns into a sort of server: 
 * (raw) RGB data is sent trough the serial port and forwarded to the matrices.
 *
 * For ease of connection a SmartLED Shield is used (but is not strictly necessary):
 * http://docs.pixelmatix.com/SmartMatrix/
 * 
 * The library offers many tools (and examples) to display graphics, animations and texts.
 * Dependencies (and docs):
 * https://github.com/pixelmatix/SmartMatrix
 */

#include <SmartLEDShieldV4.h>
#define COLOR_DEPTH 24

const uint16_t MATRIX_WIDTH   = 64;                         // Number of leds per tile
const uint16_t MATRIX_HEIGHT  = 32;
const uint8_t  NUM_CHANNELS   = 3;                          // Let's assume RGB data with a depth of 8 bits (also check the COLOR_DEPTH define)
const uint16_t NUM_TILES      = 2;                          // The number of chained matrices; 
                                                            // let the software handle the display configuration.
const uint16_t TOTAL_WIDTH    = MATRIX_WIDTH;               // Total 
const uint16_t TOTAL_HEIGHT   = MATRIX_HEIGHT * NUM_TILES;  // The matrices are configured as a vertical stack.
const uint16_t NUM_LEDS       = TOTAL_WIDTH * TOTAL_HEIGHT;
const uint16_t BUFFER_SIZE    = NUM_LEDS * NUM_CHANNELS;

const uint8_t  kRefreshDepth  = 24;                         // Valid: 24, 36, 48
const uint8_t  kDmaBufferRows = 4;                          // Valid: 2-4
const uint8_t  kPanelType     = SMARTMATRIX_HUB75_32ROW_MOD16SCAN;
const uint8_t  kMatrixOptions = (SMARTMATRIX_OPTIONS_NONE);
const uint8_t  kbgOptions     = (SM_BACKGROUND_OPTIONS_NONE);

uint8_t buf[BUFFER_SIZE];                                   // A buffer for the incoming data

uint8_t brightnessValue = 255;
bool    colorCorrectionEnabled = true;
bool    swapBuffersEnabled = false;

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {

  Serial.setTimeout(50);

  pinMode(LED_BUILTIN, OUTPUT);
  
  bg.enableColorCorrection(colorCorrectionEnabled);
  matrix.setBrightness(brightnessValue);
  matrix.addLayer(&bg);
  matrix.begin();

}


void loop() {

  static uint32_t count = 0;

  char chr = Serial.read();

  if (chr == '*') {             // Incoming data
    // masterFrame
    uint16_t count = Serial.readBytes((char *)buf, BUFFER_SIZE);
    if (count == BUFFER_SIZE) {
      rgb24 *buffer = bg.backBuffer();
      uint16_t idx = 0;
      for (uint16_t i = 0; i < NUM_LEDS; i++) {
        rgb24 *col = &buffer[i];
        col->red   = buf[idx++];
        col->green = buf[idx++];
        col->blue  = buf[idx++];
      }      
      bg.swapBuffers(swapBuffersEnabled);     
    }
  } else if (chr == '?') {      // Write out some (parseable) info
    Serial.print("MAT,");       // 
    Serial.print(MATRIX_WIDTH);
    Serial.print(',');
    Serial.print(MATRIX_HEIGHT);
    Serial.print(',');
    Serial.print(NUM_CHANNELS);
    Serial.print(',');
    Serial.print(NUM_TILES);
    Serial.print(',');
    Serial.print(brightnessValue);
    Serial.print(',');    
    Serial.print(colorCorrectionEnabled);    
    Serial.print(',');    
    Serial.print(swapBuffersEnabled);    
    Serial.println();
  } else if (chr == 'b') {
    brightnessValue = Serial.read();
    matrix.setBrightness(brightnessValue);    
  } else if (chr == 'c') {
    colorCorrectionEnabled = (byte) (Serial.read()) == 0 ? false : true; 
    bg.enableColorCorrection(colorCorrectionEnabled); 
  } else if (chr == 's') {
    swapBuffersEnabled = (byte) (Serial.read()) == 0 ? false : true;  
  }
  
  digitalWrite(LED_BUILTIN, count / 10 % 2);   // Let's animate the built-in LED as well
  count++;

}
