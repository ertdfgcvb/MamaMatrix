/**
 * Example 2.
 * Animate some LEDs of a RGB matrix, directly from the controller.
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

const uint16_t TOTAL_WIDTH    = 64;       // Total size of the chained matrices
const uint16_t TOTAL_HEIGHT   = 32;
const uint8_t  kRefreshDepth  = 24;       // Valid: 24, 36, 48
const uint8_t  kDmaBufferRows = 4;        // Valid: 2-4
const uint8_t  kPanelType     = SMARTMATRIX_HUB75_32ROW_MOD16SCAN;
const uint8_t  kMatrixOptions = (SMARTMATRIX_OPTIONS_NONE);
const uint8_t  kbgOptions     = (SM_BACKGROUND_OPTIONS_NONE);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {

  pinMode(LED_BUILTIN, OUTPUT);

  bg.enableColorCorrection(false);            // bg is the "background" layer
  matrix.addLayer(&bg);
  matrix.setBrightness(255);
  matrix.begin();
  
}



void loop() {
  static uint32_t count = 0;                   // Just a counter
  static uint8_t offs_y = TOTAL_HEIGHT / 2;

  bg.fillScreen({0, 0, 0});                    // Clear to a color {r,g,b}

  uint16_t x, y;
  for (uint16_t i = 0; i < TOTAL_WIDTH; i++) { // Draw a sine wave
    x = i;
    y = sin((i + 1) * count * 0.0005) * offs_y + offs_y;
    bg.drawPixel(x, y, {255, 255, 255});      
  }

  bg.swapBuffers();                            // The library offers double buffering
    
  digitalWrite(LED_BUILTIN, count / 10 % 2);   // Let's animate the built-in LED as well
  count++;
}
