int blinkCount = 0;
boolean blinkRed = false;
boolean blinkSwitching = false;
int lastMode;
void blink(int c) {
  blinkCount = c;
}
void blinkRed(int c) {
  blinkCount = c;
  blinkRed = true;
}
void blink(PGraphics src) {
  if (blinkCount > 0) {
    src.pushMatrix();
    if (blinkRed) {
      src.fill(255, 0, 0);
    } else {
      src.fill(255);
    }
    src.rectMode(CORNER);
    src.rect(0, 0, widthRender, heightRender);
    src.popMatrix();

    if (blinkRed && blinkSwitching) {
      // drawLines(src, 1);
      if (mode != 7) {
        lastMode = mode;
        mode = 7;
      } else {
        mode = lastMode;
      }
    }

    blinkCount--;
    if (blinkCount == 0) {
      blinkRed = false;
    }
  }
}
