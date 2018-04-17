void randomHorizontalLines(PGraphics src) {
  src.background(0);
  src.stroke(255);
  src.translate(width * 0.5 - rectWidth * 0.5, height * 0.5 - rectWidth * 0.5);

  float pos = 0;
  while(pos < rectWidth) {
    pos += random(0, rectWidth * 0.05);
    float h = random(0, rectWidth * 0.05);
    src.fill(255);
    src.rectMode(CORNER);
    if (pos + h < rectWidth) {
      src.rect(0, pos, rectWidth, h);
    } else {
      src.rect(0, pos, rectWidth, rectWidth - pos);
    }
    pos += h;
  }
}

void randomVerticalLines(PGraphics src) {
  src.pushMatrix();
  src.background(0);
  src.stroke(255);
  src.translate(width * 0.5 - rectWidth * 0.5, height * 0.5 - rectWidth * 0.5);

  float pos = 0;
  float h = random(0, rectWidth * 0.05);

  while(pos + h < rectWidth * 1.0) {
    pos += random(0, rectWidth * 0.05);
    src.fill(255);
    src.rectMode(CORNER);
    // src.rect(pos, 0, rectWidth, h);
    // src.rect(pos, 0, h, rectWidth);
    src.rect(pos, 0, h, random(rectWidth * 0.5, rectWidth * 1.5));
    pos += h;
    h = random(0, rectWidth * 0.05);
  }
  src.popMatrix();
}

void randomDots(PGraphics src) {
  src.pushMatrix();

  src.background(0);
  src.stroke(255);
  src.translate(width * 0.5 - rectWidth * 0.5, height * 0.5 - rectWidth * 0.5);

  for (int i = 0; i < 300; i++) {
    src.line(random(rectWidth), random(rectWidth), random(rectWidth), random(rectWidth));
  }
  src.popMatrix();
}

int blinkCount = 0;
void blink(PGraphics src) {
  if (blinkCount > 0) {
    src.pushMatrix();
    src.fill(255);
    src.rectMode(CORNER);
    src.rect(0, 0, width, height);
    src.popMatrix();
    blinkCount--;
  }
}
