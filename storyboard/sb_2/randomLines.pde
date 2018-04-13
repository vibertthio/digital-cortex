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
    src.rect(0, pos, rectWidth, h);
    pos += h;
  }
}

void randomVerticalLines(PGraphics src) {
  src.background(0);
  src.stroke(255);
  src.translate(width * 0.5 - rectWidth * 0.5, height * 0.5 - rectWidth * 0.5);

  float pos = 0;
  while(pos < rectWidth) {
    pos += random(0, rectWidth * 0.05);
    float h = random(0, rectWidth * 0.05);
    src.fill(255);
    src.rectMode(CORNER);
    src.rect(pos, 0, rectWidth, h);
    pos += h;
  }
}
