class Octa {
  PShape octa;
  PShader octaShader;
  float octaAlpha;
  boolean octaMerging = true;
  float octaTimeOffset = 0;
  float octaTime = 0;
  float octaTimeUnit = 1500;
  float scale = 1.0;

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


  OctaLine[] lines;
  int nOfLines = 30;
  int nOfLinesShow = 0;
  int highlightedIndex = 0;

  void initLines() {
    lines = new OctaLine[nOfLines];
    for (int i = 0; i < nOfLines; i++) {
      lines[i] = new OctaLine(
        "-$" + newWord() + newWord(),
        random(widthRender * 0.1, widthRender * 0.3),
        random(widthRender * -0.2, widthRender * 0.2),
        0
      );
    }
  }
  void drawLines(PGraphics src) {
    highlightLines();
    for (int i = 0; i < min(nOfLinesShow, nOfLines); i++) {
      if (i != highlightedIndex) {
        lines[i].draw(src);
      } else {
        lines[i].draw(src, true);
      }
    }
  }
  void highlightLines() {
    if (random(1) < 0.01) {
      highlightedIndex += 1;
      if (highlightedIndex > min(nOfLinesShow, nOfLines) - 1) {
        highlightedIndex = 0;
      }
    } else {
      lines[highlightedIndex].update();
    }
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
  float radius = 100;
  float xpos;
  float ypos;
  float zpos;
  float phase;
  float phaseDrift;
  float rate = 0.01;
  float alpha = random(-PI * 0.8, PI * 0.8);

  String str;

  // 0: extending
  // 1: floating
  // 2: shrinking
  int mode;

  OctaLine(String _s, float _x, float _y, float _z) {
    str = _s;
    xpos = _x;
    ypos = _y;
    zpos = _z;

    phase = random(0, 2 * PI);
    phaseDrift = random(0, 2 * PI);

    rate = random(0.002, 0.005);
  }

  void render(PGraphics src) {
    update();
    draw(src);
  }

  void update() {
    float rand = random(1);
    if (rand > 0.9) {
      str += newWord();
    } else if (rand > 0.85) {
      if (str.length() > 2) {
        str = str.substring(0, str.length() - 1);
      }
    } else if (rand > 0.8) {
      str = "-$";
    }
  }

  void draw(PGraphics src) {
    draw(src, false);
  }
  void draw(PGraphics src, boolean highlighted) {
    src.pushMatrix();
    src.translate(widthRender * 0.5, heightRender * 0.5);
    if (highlighted) {
      src.stroke(255, 0, 0);
    } else {
      src.stroke(255);
    }
    src.rotateY(rate * frameCount + phase);
    // src.rotateZ(frameCount * rate);
    float x = xpos + unit * 0.3 * cos(frameCount * rate + phaseDrift);
    float y = ypos + unit * 0.3 * sin(frameCount * rate + phaseDrift);
    float z = zpos;

    src.line(0, 0, 0, x, y, z);
    src.translate(x, y, z);
    src.line(0, 0, 0, 50, 0, 0);
    src.translate(53, 0, 0);
    src.textAlign(LEFT, CENTER);

    src.textFont(font);
    src.textSize(10);
    if (highlighted) {
      src.fill(255, 0, 0);
    } else {
      src.fill(255);
    }
    src.text(str, 0, 0);

    src.popMatrix();
  }

}
