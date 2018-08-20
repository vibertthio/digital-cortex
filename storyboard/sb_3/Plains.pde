class Plains {
  float longitude = height * 0.6;
  float centerX = width * 0.5;
  float centerY = height * 0.5;
  float centerZ = -200;


  float boxWidth = 800;
  float boxHeight = 666;
  float boxDepth = 800;

  color lineColor = color(255, 0, 0);

  int horizontalIndex = 4;
  int horizontalCount = 0;
  boolean[] horizontalFaces = { false, true, false, false };

  int shiftIndex = 2;

  Plains() {

  }


  void update() {
    // float h = map(mouseY, height, 0, -200, -1000);
    // centerZ = h;
    // boxDepth = map(h, -200, -400, 800, 1200);

    flash();
  }

  void changeDepth(float rate) {
    float d = map(rate, 0, 1, -200, -1000);
    centerZ = d;
    boxDepth = map(d, -200, -400, 800, 1200);
  }

  void flash() {
    if (horizontalIndex == 4) {
      if (random(1) < 0.05) {
        horizontalIndex = 2;
        shiftIndex = floor(random(0, 10));
        changeDepth(random(1));
      }
    } else if (horizontalIndex == 2) {
      if (random(1) < 0.5) {
        horizontalIndex = 4;
        // shiftIndex = -1;
      }
    }
  }
  void startFlashHorizontal() {
    horizontalIndex = 1;
    horizontalCount = 0;
  }
  void updateHorizontalFaces() {
    if (horizontalIndex < 4) {
      if (horizontalCount > 5) {
        horizontalIndex += 1;
        horizontalCount = 0;
      }
    }
    horizontalCount++;
  }

  void draw(PGraphics src) {
    src.pushMatrix();
    src.translate(
      centerX,
      centerY,
      centerZ
    );

    drawGrid(src);
    drawPlains(src);
    src.popMatrix();
  }

  void drawGrid(PGraphics src) {
    src.pushMatrix();

    src.stroke(lineColor);
    src.noFill();
    src.box(boxWidth, boxHeight, boxDepth);

    for (int i = 0; i < 4; i++) {
      if (horizontalIndex == i) {
        drawFaceHorizontal(src, i);
      }
      // if (horizontalFaces[i]) {
      //   drawFaceHorizontal(src, i);
      // }
    }

    src.popMatrix();
  }

  void drawFaceHorizontal(PGraphics src, int id) {
    src.rectMode(CENTER);
    src.noStroke();
    src.fill(lineColor);

    switch(id) {
      case 0:
        src.pushMatrix();
        src.translate(0, 0, boxDepth * 0.5);
        src.rect(0, 0, boxWidth, boxHeight);
        src.popMatrix();
        break;
      case 1:
        src.pushMatrix();
        src.translate(boxWidth * -0.5, 0, 0);
        src.rotateY(PI * 0.5);
        src.rect(0, 0, boxDepth, boxHeight);
        src.popMatrix();
        break;
      case 2:
        src.pushMatrix();
        src.translate(0, 0, -boxDepth * 0.5);
        src.rect(0, 0, boxWidth, boxHeight);
        src.popMatrix();
        break;
      case 3:
        src.pushMatrix();
        src.translate(boxWidth * 0.5, 0, 0);
        src.rotateY(PI * 0.5);
        src.rect(0, 0, boxDepth, boxHeight);
        src.popMatrix();
        break;

    }
  }

  void drawPlains(PGraphics src) {
    src.pushMatrix();
    src.translate(0, 0, -centerZ - 300);
    src.noStroke();
    src.fill(255);
    src.rectMode(CENTER);
    src.translate(0, longitude * 0.65, 0);
    src.rotateX(0.5 * PI);

    float shift = longitude / 10;
    src.translate(0, 0, shift);
    for (int i = 0; i < 10; i++) {
      src.pushMatrix();
      src.translate(0, 0, shift * i);

      if (i == shiftIndex) {
        src.translate(100, 0, 0);
        src.pushMatrix();
        src.translate(0, 0, shift * 0.5);
        src.rotateX(-0.5 * PI);
        src.textSize(20);
        src.fill(lineColor);
        src.textFont(font);
        // src.text("a", 0, 0);
        src.popMatrix();
      } else {
        src.rotateZ(frameCount * 0.02);
        src.fill(255);
      }
      src.rect(0, 0, 150, 150);
      src.popMatrix();
    }
    src.popMatrix();

  }

}
