void drawPlain(PGraphics src) {
  float longitude = height * 0.6;

  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5, -200);

  src.stroke(255, 0, 0);
  src.noFill();
  // float h = map(mouseY, height, 0, 500, 800);
  // println(h);
  src.box(800, 666, 800);

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
