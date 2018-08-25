class GlowRect {

  float renderW;
  float renderH;
  float targetW;
  float targetH;

  float alpha = 0;
  // float alpha = 255;
  TimeLine startTimer;
  float pow = 8;

  boolean fill = false;
  // boolean fill = true;
  boolean showingDataPoints = false;
  boolean noise = false;
  float noisePos;


  GlowRect() {
    renderW = rectWidth;
    renderH = rectWidth;

    startTimer = new TimeLine(10000);
  }

  PGraphics drawGlow(PGraphics src) {
    update();
    render(src);
    return glowManager.dowGlow(src);
  }

  void draw(PGraphics src) {
    update();
    render(src);
  }

  void update() {
    updateFadeIn();
  }

  void render(PGraphics src) {
    src.pushMatrix();
    if (colorReverse) {
      src.background(255);
    } else {
      src.background(0);
    }
    // src.lights();
    src.translate(width / 2, height / 2);
    // src.rotateX(frameCount * 0.005f);
    src.rectMode(CENTER);

    if (fill) {
      src.noStroke();
      if (colorReverse) {
        src.fill(255 - alpha);
      } else {
        src.fill(alpha);
      }

      src.rect(0, 0, renderW, renderH);

    } else {
      src.noStroke();
      src.fill(alpha);
      src.rect(0, 0, renderW, renderH);
      src.fill(0);
      src.rect(0, 0, renderW * 0.98, renderH * 0.98);
    }

    if (noise) {
      src.translate(noisePos, dataUnit);
      src.fill(0);
      // src.rect(0, 0, dataUnit, dataUnit);
      src.rect(0, 0, dataUnit, dataUnit * 0.2);
    }
    src.popMatrix();

    if (showingDataPoints) {
      dataPoints(src);
    }

  }

  void updateNoisePos() {
    if (random(1) > 0.5) {
      float range = rectWidth * 0.05;
      noisePos = random(-range, range);
    }
  }

  // utilities
  void startFadeIn() {
    pow = 8;
    startTimer.startTimer();
  }
  void startFadeIn(int ll) {
    pow = 0.8;
    startTimer.limit = ll;
    startTimer.startTimer();
  }
  void updateFadeIn() {
    if (startTimer.state) {
      alpha = startTimer.getPowIn(pow) * 255;
    }
  }
}

float dataX = 0;
float dataY = 0;
float dataUnit;
float dataGap;
boolean dataHold = false;

void initDataPoints() {
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

void drawText() {
  pushMatrix();
  translate(width / 2, height / 2);
  textFont(font);
  textSize(16);
  textAlign(CENTER, CENTER);
  if (colorReverse) {
    fill(255);
  } else {
    fill(0);
  }
  text(boxStr, 0, 0);
  popMatrix();
}
void updateText() {
  float rand = random(1);
  if (rand > 0.5) {
    boxStr += newWord();
  } else if (rand > 0.2) {
    // boxStr = "-$" + newWord();
    if (boxStr.length() > 2) {
      boxStr = boxStr.substring(0, boxStr.length() - 1);
    }
  } else if (rand > 0.1) {
    boxStr = "-$";
  }
}
void updateText(String s) {
  boxStr = s;
}
char newWord() {
  return char(int(random(33, 127)));
}
