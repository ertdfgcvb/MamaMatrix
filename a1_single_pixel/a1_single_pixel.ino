/**
 * Example 1.
 * Control a single LED of a RGB matrix, directly from the controller.
 * 
 * For ease of connection a SmartLED Shield is used (but is not strictly necessary):
 * http://docs.pixelmatix.com/SmartMatrix/
 * The library offers many tools (and examples) to display graphics, animations and texts. 
 * 
 * Dependencies (and docs):
 * https://github.com/pixelmatix/SmartMatrix 
 */ 

#include <SmartLEDShieldV4.h>
#define COLOR_DEPTH 24               

const uint16_t TOTAL_WIDTH    = 64;   // Total size of the chained matrices
const uint16_t TOTAL_HEIGHT   = 32;   
const uint8_t  kRefreshDepth  = 24;   // Valid: 24, 36, 48
const uint8_t  kDmaBufferRows = 4;    // Valid: 2-4
const uint8_t  kPanelType     = SMARTMATRIX_HUB75_32ROW_MOD16SCAN;
const uint8_t  kMatrixOptions = (SMARTMATRIX_OPTIONS_NONE);
const uint8_t  kbgOptions     = (SM_BACKGROUND_OPTIONS_NONE);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {
 
  bg.enableColorCorrection(false);    // bg is the "background" layer
  matrix.addLayer(&bg);              
  matrix.setBrightness(255);         
  matrix.begin();
  
}


void loop() {

  bg.fillScreen({0, 0, 0});           // Clear to a color {r,g,b}
  
  bg.drawPixel(10, 10, {255, 0, 0});  // Draw some red pixels
  bg.drawPixel(12, 10, {255, 0, 0});
  bg.drawPixel(11, 11, {255, 0, 0});
  bg.drawPixel(10, 12, {255, 0, 0});
  bg.drawPixel(12, 12, {255, 0, 0});

  bg.swapBuffers();                   // The library offers double buffering
  
}
