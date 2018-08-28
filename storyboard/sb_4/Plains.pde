class Plains {
  float longitude;
  float normalLongitude;
  float finalLongitude;
  float centerX = widthRender * 0.5;
  float centerY = heightRender * 0.5;
  float centerZ = -200;


  float boxWidth = 800;
  float boxHeight = 666;
  float boxDepth = 800;

  color lineColor = color(255, 0, 0);
  // color lineColor = color(255, 255, 255);
  color groundColor = color(0, 0, 0);
  boolean[] horizontalFaces = { false, false, false, false };
  int shiftRightIndex = 2;
  int shiftLeftIndex = 8;

  int monitorGridDim = 10;
  int monitorGridMargin = 50;
  boolean[] monitorGrid;

  boolean scanningVertical = false;
  boolean scanVerticalDir = false;
  boolean scanning = false;
  boolean scanDir = true;

  float scanningPosition = 0.1;
  float scanHeight = 0;
  float scanDepth = 50;

  boolean plainShifting = true;
  boolean alligning = false;
  float plainShift = 150;

  Plains() {
    monitorGrid = new boolean[monitorGridDim * monitorGridDim];
    for (int i = 0; i < monitorGridDim; i++) {
      for (int j = 0; j < monitorGridDim; j++) {
        // monitorGrid[i + monitorGridDim * j] = (random(1) > 0.5);
        monitorGrid[i + monitorGridDim * j] = true;
      }
    }
    longitude = boxHeight * 0.8;
    normalLongitude = longitude;
    finalLongitude = longitude;
  }


  void update() {
    // dimGroundColor();
    if (random(1) < 0.2) {
      updateText();
      randStr = shiftStr(randStr, 1);
      // int id = floor(random(monitorGridDim * monitorGridDim));
      // monitorGrid[id] = !monitorGrid[id];
    }

    // flash();

    scanShift();
    plainShifting();
    updateLongitude();

    mouseControlDepth();
  }
  void updateLongitude() {
    if (abs(longitude - finalLongitude) < 0.1) {
      longitude = finalLongitude;
    } else {
      longitude += 0.09 * (finalLongitude - longitude);
    }
  }
  void flash() {
    if (!horizontalFaces[0]) {
      if (random(1) < 0.05) {
        horizontalFaces[0] = true;
        shiftRightIndex = floor(random(0, 10));
        shiftLeftIndex = floor(random(0, 10));
        // changeDepth(random(1));
      }
    } else {
      if (random(1) < 0.5) {
        horizontalFaces[0] = false;
      }
    }
  }
  void changeDepth(float rate) {
    float d = map(rate, 0, 1, -190, -220);
    centerZ = d;
    boxDepth = map(d, -200, -400, 800, 1200);
  }
  void dimGroundColor() {
    float dim = (sin(frameCount * 0.04 + 0.5 * PI) + 1) * 0.5;
    groundColor = lerpColor(color(0, 0, 0), color(100, 0, 0), dim);
  }
  void scanShift() {
    if (scanningVertical) {
      if (!scanning) {
        if (!scanVerticalDir) {
          scanHeight += 2 * random(0.5) + 1;
          if (scanHeight > boxHeight) {
            scanVerticalDir = true;
          }
        } else {
          scanHeight -= 2 * random(0.5) + 1;
          if (scanHeight < 0) {
            scanVerticalDir = false;
            scanningVertical = false;
          }
        }

        if (random(1) < 0.003) {
          scanning = true;
          scanDir = !scanDir;
          scanningPosition = 0;
        }
      } else {
        if (boxWidth - scanningPosition < 0.1) {
          scanning = false;
        }
      }
    }

  }
  void startScanning() {
    scanningVertical = true;
  }
  void plainShifting() {
    float rate = 0.09;
    if (plainShifting) {
      if (alligning) {
        plainShift *= (1 - rate);
        if (plainShift < 1) {
          shiftRightIndex = floor(random(0, 10));
          shiftLeftIndex = floor(random(0, 10));
        }
      } else {
        plainShift += rate * (150 - plainShift);
      }
    }
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
    drawMonitor(src);
    if (scanningVertical) { drawScan(src); }

    // src.scale(0.8, 0.8, 0.8);
    // drawParticles(src, 0, 0);
    drawFaceVertical(src, frameCount % 4);
    src.popMatrix();
  }
  void drawGrid(PGraphics src) {
    src.pushMatrix();

    src.stroke(lineColor);
    src.noFill();
    // src.box(boxWidth, boxHeight, boxDepth);

    for (int i = 0; i < 4; i++) {
      if (horizontalFaces[i]) {
        // drawFaceHorizontal(src, i);
      }
    }
    // drawFaceVertical(src, 1, groundColor);

    src.popMatrix();
  }
  void drawFaceHorizontal(PGraphics src, int id) {
    drawFaceHorizontal(src, id, lineColor);
  }
  void drawFaceHorizontal(PGraphics src, int id, color col) {
    src.rectMode(CENTER);
    src.noStroke();
    src.fill(col, 100);

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
  void drawFaceVertical(PGraphics src, int id) {
    drawFaceVertical(src, id, lineColor);
  }
  void drawFaceVertical(PGraphics src, int id, color col) {
    src.rectMode(CENTER);
    src.noStroke();
    src.fill(col);

    switch(id) {
      case 0:
        src.pushMatrix();
        src.translate(0, 0, boxDepth * 0.5);
        src.rect(0, 0, boxWidth, boxHeight);
        src.popMatrix();
        break;
      case 1:
        src.pushMatrix();
        src.translate(0, boxHeight * 0.5, 0);
        src.rotateX(PI * 0.5);
        src.rect(0, 0, boxWidth, boxDepth);
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
        src.translate(0, boxHeight * -0.5, 0);
        src.rotateY(PI * 0.5);
        src.rect(0, 0, boxWidth, boxDepth);
        src.popMatrix();
        break;

    }
  }
  void drawPlains(PGraphics src) {
    src.pushMatrix();
    src.pushStyle();

    src.translate(0, normalLongitude * 0.5, -centerZ - 300);
    src.noStroke();
    src.fill(255);
    src.rectMode(CENTER);
    src.rotateX(0.5 * PI);

    float shift = longitude / 10;
    // float rotationZ = 0.2 * PI * sin(frameCount * 0.01);
    float rotationZ = 0.2 * PI * sin(frameCount * 0.03);
    src.translate(0, 0, shift * 0.5);

    for (int i = 0; i < 10; i++) {
      src.pushMatrix();
      src.translate(0, 0, shift * i);

      if (i == shiftRightIndex) {
        src.translate(plainShift, 0, 0);

        if (plainShift > 100) {
          src.pushMatrix();
          src.rotateZ(rotationZ);
          src.stroke(lineColor);
          src.strokeWeight(1);
          src.line(0, 0, 0, shift, 0, shift);
          src.line(shift, 0, shift, shift * 2, 0, shift);
          src.translate(shift * 2, 0, shift);
          src.rotateX(-0.5 * PI);

          src.textAlign(LEFT, CENTER);
          src.textSize(20);
          src.fill(lineColor);
          src.textFont(font);
          src.text(boxStr, 0, 0);
          src.popMatrix();
        }
      } else if (i == shiftLeftIndex) {
        src.translate(-plainShift, 0, 0);

        if (plainShift > 100) {
          src.pushMatrix();
          src.rotateZ(rotationZ);
          src.stroke(lineColor);
          src.strokeWeight(1);
          src.line(0, 0, 0, -shift, 0, shift);
          src.line(-shift, 0, shift, -shift * 2, 0, shift);
          src.translate(-shift * 2, 0, shift);
          src.rotateX(-0.5 * PI);

          src.textAlign(RIGHT, CENTER);
          src.textSize(20);
          src.fill(lineColor);
          src.textFont(font);
          src.text(boxStr, 0, 0);
          src.popMatrix();
        }
      }else {
        // src.rotateZ(frameCount * 0.02);
        src.fill(255);
      }

      src.rotateZ(rotationZ + (i - 5) * 0.1 * sin(frameCount * 0.03));
      src.fill(255);
      src.noStroke();
      src.rect(0, 0, 150, 150);
      src.popMatrix();
    }

    src.popStyle();
    src.popMatrix();

  }
  void drawScan(PGraphics src) {
    src.pushMatrix();
    src.pushStyle();

    float w = boxWidth * 0.5;
    float h = boxHeight * 0.5;
    float d = boxDepth * 0.5;
    float s = scanHeight;

    // src.stroke(255, 0, 0);
    src.stroke(255);
    src.strokeWeight(2);
    src.line(-w, h - s, d, -w, h - s, -d);
    src.line(-w, h - s, -d, w, h - s, -d);
    src.line(w, h - s, -d, w, h - s, d);
    src.line(w, h - s, d, -w, h - s, d);

    if (scanning) {
      float rate = 0.09;
      if (scanningPosition == 0) {
        scanningPosition = 0.1;
      } else if (scanningPosition < 0.5) {
        scanningPosition *= (1 + rate);
      } else {
        scanningPosition += rate * (boxWidth - scanningPosition);
      }
      float xpos;
      if (scanDir) {
        xpos = w - scanningPosition;
      } else {
        xpos = scanningPosition - w;
      }

      src.translate(xpos, h - s, 0);
      src.stroke(255, 0, 0);
      src.strokeWeight(3);
      src.line(0, 0, d, 0, 0, -d);



      /****
      TESTING
      ****/

      //
      // float xpos = map(
      //   scanningPosition,
      //   0,
      //   4,
      //   -boxWidth * 0.4,
      //   boxWidth * 0.4
      // );
      // src.translate(xpos, h - s, 0);
      // src.rotateX(0.5 * PI);
      // src.rectMode(CENTER);
      // src.noStroke();
      // src.fill(255, 0, 0, 100);
      // src.rect(0, 0, boxWidth * 0.2, boxDepth);
    }

    // s = scanDepth;
    // src.line(-w, h, s - d, -w, -h, s - d);
    // src.line(-w, h, s - d, w, h, s - d);
    // src.line(w, -h, s - d, -w, -h, s - d);
    // src.line(w, -h, s - d, w, h, s - d);

    src.popStyle();
    src.popMatrix();
  }

  void drawMonitor(PGraphics src) {
    src.pushMatrix();
    src.translate(0, 0, -boxDepth * 0.5);
    drawWords(src, boxWidth, boxHeight);
    src.popMatrix();

    src.pushMatrix();
    src.translate(0, -boxHeight * 0.5, 0);
    src.rotateX(0.5 * PI);
    // drawLights(src);
    drawWords(src, boxWidth, boxDepth);
    src.popMatrix();

    src.pushMatrix();
    src.translate(0, boxHeight * 0.5, 0);
    src.rotateX(0.5 * PI);
    // drawLights(src);
    drawWords(src, boxWidth, boxDepth);
    src.popMatrix();

    src.pushMatrix();
    src.translate(boxWidth * 0.5, 0, 0);
    src.rotateY(0.5 * PI);
    // drawLights(src, boxDepth, boxHeight);
    drawWords(src, boxDepth, boxHeight);
    src.popMatrix();

    src.pushMatrix();
    src.translate(boxWidth * -0.5, 0, 0);
    src.rotateY(0.5 * PI);
    // drawLights(src, boxDepth, boxHeight);
    drawWords(src, boxDepth, boxHeight);
    src.popMatrix();
  }
  void drawWords(PGraphics src) {
    drawWords(src, boxWidth, boxHeight);
  }
  void drawWords(PGraphics src, float w, float h) {
    src.pushMatrix();
    src.pushStyle();
    for (int i = 0; i < monitorGridDim; i++) {
      for (int j = 0; j < monitorGridDim; j++) {
        src.pushMatrix();
        float xt = map(
          i,
          0,
          monitorGridDim - 1,
          monitorGridMargin - w * 0.5,
          w * 0.5 - monitorGridMargin
        );
        float yt = map(
          j,
          0,
          monitorGridDim - 1,
          monitorGridMargin - h * 0.5,
          h * 0.5 - monitorGridMargin
        );
        src.translate(xt, yt);
        src.rectMode(CENTER);
        if (monitorGrid[i + monitorGridDim * j]) {
          src.fill(255);
        } else {
          src.fill(255, 0, 0);
        }
        src.textSize(14);
        src.textAlign(CENTER, CENTER);
        src.textFont(font);
        src.text(randStr.charAt(i + monitorGridDim * j), 0, 0);
        // src.noStroke();
        // src.stroke(255, 0, 0);
        // src.noFill();
        // src.rect(0, 0, 40, 40);
        src.popMatrix();
      }
    }
    src.popStyle();
    src.popMatrix();
  }
  void drawLights(PGraphics src) {
    drawLights(src, boxWidth, boxDepth);
  }
  void drawLights(PGraphics src, float w, float h) {
    for (int i = 0; i < monitorGridDim; i++) {
      for (int j = 0; j < monitorGridDim; j++) {
        src.pushMatrix();
        float xt = map(
          i,
          0,
          monitorGridDim - 1,
          monitorGridMargin - w * 0.5,
          w * 0.5 - monitorGridMargin
        );
        float yt = map(
          j,
          0,
          monitorGridDim - 1,
          monitorGridMargin - h * 0.5,
          h * 0.5 - monitorGridMargin
        );
        src.translate(xt, yt);
        if (monitorGrid[i + monitorGridDim * j]) {
          src.fill(255);
        } else {
          src.fill(255, 0, 0);
        }
        src.rectMode(CENTER);
        src.noStroke();
        src.ellipse(0, 0, 40, 40);

        src.popMatrix();
      }
    }
  }


  // debug
  void mouseControlDepth() {
    float w = map(mouseX, widthRender, 0, 800, 1200);
    println("boxWidth: " + w);
    boxWidth = w;

    float h = map(mouseY, heightRender, 0, 666, 1000);
    println("boxHeight: " + h);
    boxHeight = h;

    // centerZ = h;
    // boxDepth = map(h, -200, -400, 800, 1200);
  }

}
