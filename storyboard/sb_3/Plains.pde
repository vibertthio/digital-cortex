class Plains {
  float longitude = height * 0.6;
  float centerX = width * 0.5;
  float centerY = height * 0.5;
  float centerZ = -200;

  float boxDepth = 800;

  color lineColor = color(255, 0, 0);

  Plains() {

  }

  void update() {
    float h = map(mouseY, height, 0, -200, -5000);
    // println(h);
    centerZ = h;
    boxDepth = map(h, -200, -400, 800, 1200);
  }

  void draw(PGraphics src) {
    src.pushMatrix();
    src.translate(
      centerX,
      centerY,
      centerZ
    );

    src.stroke(lineColor);
    src.noFill();
    // src.box(800, 666, 1200 - 0.5 * centerZ);
    // float h = map(mouseY, height, 0, 200, 1500);
    // println(h);
    src.box(800, 666, boxDepth);

    src.noStroke();
    src.fill(255);
    src.rectMode(CENTER);
    src.translate(0, longitude * 0.65, 0);
    src.rotateX(0.5 * PI);

    src.rotateZ(frameCount * 0.02);

    float shift = longitude / 10;
    for (int i = 0; i < 10; i++) {
      // src.translate(0, -1 * shift, 0);
      src.translate(0, 0, shift);
      src.rect(0, 0, 150, 150);
    }

    src.popMatrix();
  }

  void drawGrid() {

  }

}
