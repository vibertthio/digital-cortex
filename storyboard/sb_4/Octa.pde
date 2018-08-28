class Octa {
  PShape octa;
  PShader octaShader;
  float octaAlpha;
  boolean octaMerging = true;
  float octaTimeOffset = 0;
  float octaTime = 0;
  float octaTimeUnit = 1500;
  float scale = 1.0;

  OctaLine[] lines;
  int nOFLines = 15;

  Octa() {
    octaShader = loadShader("octahedron/frag.glsl", "octahedron/vert.glsl");
    octaShader.set("size", 0.2);
    octa = createOctahedron(heightRender * 0.2, 4);
    octaAlpha = 0;
    initLines();
  }
  void draw(PGraphics src) {
    update();
    src.shader(octaShader);
    src.pushMatrix();
    // src.background(0);
    src.translate(widthRender * 0.5, heightRender * 0.5);
    // src.ambientLight(0, 0, 0);
    src.rotateY(octaAlpha);
    octaAlpha += 0.005;
    src.scale(scale, scale, scale);
    src.shape(octa);
    src.resetShader();
    src.popMatrix();

    // drawLines(src);
  }
  void draw(PGraphics src, float _x, float _y, float _z) {
    update();
    src.shader(octaShader);
    src.pushMatrix();
    // src.background(0);
    src.translate(_x, _y, _z);
    // src.ambientLight(0, 0, 0);
    src.rotateY(octaAlpha);
    // octaAlpha += 0.005;
    src.scale(scale, scale, scale);
    src.shape(octa);
    src.resetShader();
    src.popMatrix();
  }
  void update() {
    if (octaMerging) {
      // println((millis() - octaTime) / octaTimeUnit);
      octaShader.set("uTime", (millis() - octaTime) / octaTimeUnit);
    } else {
      octaShader.set("uTime", (octaTimeOffset - (millis() - octaTime)) / octaTimeUnit);
    }
  }
  void reset() {
    octaTime = millis();
  }
  void reverse() {
    octaMerging = !octaMerging;
    if (octaMerging) {
      float now = octaTimeOffset - (millis() - octaTime);
      if (now > 0) {
        octaTime = millis() - now;
      } else {
        octaTime = millis();
      }
    } else {
      octaTimeOffset = millis() - octaTime;
      octaTime = millis();

      if (octaTimeOffset > 5000) {
        octaTimeOffset = 5000;
      }
    }
  }

  void changeSize() {
    octaShader.set("size", random(0.1, 1.5));
  }
  void changeSize(float s) {
    octaShader.set("size", s);
  }

  void drawIndexLines(PGraphics src) {
    float rate = 0.01;
    float radius = 100;
    src.pushMatrix();
    src.translate(widthRender * 0.5, heightRender * 0.5);
    src.stroke(255);
    // src.rotateY(frameCount * rate);
    // src.rotateZ(frameCount * rate);
    float x = radius * cos(frameCount * rate);
    float y = radius * sin(frameCount * rate);
    float z = 250;
    // float z = 10 * sin(frameCount * rate);
    // float z = 0;


    src.line(0, 0, 0, x, y, z);
    src.translate(x, y, z);

    src.line(0, 0, 0, 50, 0, 0);
    src.translate(53, 0, 0);

    // src.noStroke();
    // src.fill(255);
    // src.rect(10, 0, 20, 20);

    src.textFont(font);
    src.textSize(10);
    src.textAlign(LEFT, CENTER);
    // src.textAlign(CENTER, CENTER);
    src.fill(255);
    src.text("vibert", 0, 0);

    src.popMatrix();

  }
  void drawIndexLines1(PGraphics src) {
    float rate = 0.01;
    float radius = 100;
    src.pushMatrix();
    src.translate(widthRender * 0.5, heightRender * 0.5);
    src.stroke(255);
    // src.rotateY(frameCount * rate);
    // src.rotateZ(frameCount * rate);
    float x = -300 + 10 * cos(frameCount * rate);
    float y = -200 + 50 * sin(frameCount * rate);
    float z = 0;
    // float z = 10 * sin(frameCount * rate);
    // float z = 0;


    src.line(0, 0, 0, x, y, z);
    src.translate(x, y, z);

    src.line(0, 0, 0, -50, 0, 0);
    src.translate(-53, 0, 0);

    // src.noStroke();
    // src.fill(255);
    // src.rect(10, 0, 20, 20);

    src.textFont(font);
    src.textSize(10);
    src.textAlign(RIGHT, CENTER);
    // src.textAlign(CENTER, CENTER);
    src.fill(255);
    src.text("vertical", 0, 0);

    src.popMatrix();

  }
  void drawIndexLines2(PGraphics src, String txt, float _x, float _y, float _z, float _phase) {
    float rate = 0.01;
    float radius = 100;
    src.pushMatrix();
    src.translate(widthRender * 0.5, heightRender * 0.5);
    src.stroke(255);
    src.rotateY(frameCount * rate);
    // src.rotateZ(frameCount * rate);
    float x = _x + 10 * cos(frameCount * rate + _phase);
    float y = _y + 50 * sin(frameCount * rate + _phase);
    float z = _z;
    // float z = 10 * sin(frameCount * rate);
    // float z = 0;


    src.line(0, 0, 0, x, y, z);
    src.translate(x, y, z);

    if (x < 0) {
      src.line(0, 0, 0, -50, 0, 0);
      src.translate(-53, 0, 0);
      src.textAlign(RIGHT, CENTER);
    } else {
      src.line(0, 0, 0, 50, 0, 0);
      src.translate(53, 0, 0);
      src.textAlign(LEFT, CENTER);
    }

    // src.noStroke();
    // src.fill(255);
    // src.rect(10, 0, 20, 20);

    src.textFont(font);
    src.textSize(10);
    // src.textAlign(RIGHT, CENTER);
    // src.textAlign(CENTER, CENTER);
    src.fill(255);
    src.text(txt, 0, 0);

    src.popMatrix();

  }

  void initLines() {
    lines = new OctaLine[nOFLines];
    for (int i = 0; i < nOFLines; i++) {
      lines[i] = new OctaLine();
    }
  }
  void drawLines(PGraphics src) {
    for (int i = 0; i < nOFLines; i++) {
      lines[i].draw(src);
    }
  }

  int arrayCol = 7;
  int arrayRow = 6;
  int arrayNumber = 0;
  void drawOctaArray(PGraphics src) {
    int c = arrayCol;
    int r = arrayRow;
    for (int k = 0; k < min(arrayNumber, c * r); k++) {
      int i = k % c;
      int j = k / c;

      float x = (widthRender / c) * (i + 0.5);
      float y = (heightRender / r) * (j + 0.5);

      src.noFill();
      src.stroke(255, 0, 0);
      src.rectMode(CENTER);
      src.rect(x, y, widthRender / c, heightRender / r);
      draw(src, x, y, 0);
    }
  }
}



class OctaLine {
  float radius = 300;
  float alpha = random(-PI * 0.8, PI * 0.8);
  float xpos;
  float ypos;
  float zpos;
  float phase = random(-PI, PI);
  float rate = 0.01;

  // 0: extending
  // 1: floating
  // 2: shrinking
  int mode;

  OctaLine() {

  }

  void render(PGraphics src) {
    update();
    draw(src);
  }

  void update() {

  }

  void draw(PGraphics src) {
    float x = radius * cos(alpha + 0.1 * PI * cos(frameCount * rate));
    float y = radius * sin(alpha + 0.1 * PI * cos(frameCount * rate));
    float z = 0;

    src.pushMatrix();
    src.translate(width * 0.5, heightRender * 0.5);
    src.stroke(255, 0, 0);
    src.rotateY(frameCount * rate + phase);

    src.line(0, 0, 0, x, y, z);
    src.translate(x, y, z);
    // src.fill(255);
    // src.noStroke();
    src.line(0, 0, 0, 40 * abs(x)/x, 0, 0);
    src.popMatrix();

  }

}
