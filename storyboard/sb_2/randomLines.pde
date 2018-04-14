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



float dataX = 0;
float dataY = 0;
float dataUnit;
float dataGap;
boolean dataHold = false;

void dataPointsInit() {
   dataUnit = rectWidth * 0.05;
   dataGap = rectWidth * 0.025;
   dataX = dataUnit;
}
void dataPoints(PGraphics src) {

  src.pushMatrix();
  src.noStroke();
  src.fill(255);
  src.translate(width * 0.5 + rectWidth * 0.5 + dataGap, height * 0.5 - rectWidth * 0.5);
  src.rectMode(CORNER);

  if (!dataHold) {
    // updateDataY();
    src.rect(0, dataY, dataUnit, dataUnit);
  } else {
    src.rect(0, dataY, dataX, dataUnit);
  }
  src.popMatrix();
}
void updateDataY() {
  dataY += dataUnit;
  dataX = dataUnit;
  if (dataY + dataUnit >= rectWidth) {
    dataY = 0;
  }
}
void updateDataX() {
  dataX += dataUnit;
  if (random(1) > 0.7) {
    dataX = dataUnit;
  }
}
