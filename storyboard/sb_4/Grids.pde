String randStr = newStr(200, 1);

class Grid {
  boolean showSequence = false;
  boolean showNavigate = false;
  boolean showScanning = false;

  float redLineAlpha = 255;

  int col = 11;
  int row = 9;

  float gw;
  float gh;

  int pointX = 0;
  int pointY = 0;

  Grid() {
    gw = widthRender / col;
    gh = heightRender / row;
  }
  void draw(PGraphics src) {
    if (random(0, 1) < 0.3) {
      randStr = shiftStr(randStr, 1);
    }

    if (showScanning) {
      drawScanLine(src);
    }

    src.pushMatrix();
    src.translate(widthRender * 0.5, heightRender * 0.5);

    src.textFont(font);
    src.textSize(14);
    src.textAlign(CENTER, CENTER);

    if (showSequence) {
      src.fill(255);
      src.text(randStr, 0, 0);
    }

    src.fill(0);
    src.stroke(255);
    src.rectMode(CENTER);
    // src.rect(0, 0, 90, 90);

    float rand = random(0, 10);
    if (rand < 1) {
      if (pointX < 10) {
        pointX++;
      } else {
        pointX = 0;
        if (pointY < 8) {
          pointY++;
        } else {
          pointY = 0;
        }
      }
    } else if (rand < 1.2) {
      pointX = int(random(0, 11));
      pointY = int(random(0, 9));
    }

    for (int i = 0; i < col; i++) {
      for (int j = 0; j < row; j++) {
        float rX = i - ((col - 1) * 0.5);
        float rY = j - ((row - 1) * 0.5);
        if (rY != 0 || !showSequence) {
          src.pushMatrix();
          src.translate(rX * gw, rY * gh);
          // src.fill(255);
          // src.noStroke();
          src.noFill();
          if (showNavigate && pointX == i && pointY == j) {
            src.fill(255);
            src.rect(0, 0, 90, 90);
            src.stroke(255, 0, 0);
            src.line(0, 0, 0, -rX * gw, -rY * gh, 0);
          }

          if (redLineAlpha > 0.1) {
            redLineAlpha = redLineAlpha * 0.9995;
            src.stroke(redLineAlpha, 0, 0);
            src.noFill();
            src.rect(0, 0, gw, gh);
          }

          src.textFont(font);
          src.textSize(16);
          src.textAlign(CENTER, CENTER);
          src.fill(255);
          src.text(randStr.charAt(i * 11 + j), 0, 0);

          src.popMatrix();
        }
      }

    }
    src.popMatrix();


  }
  void drawScanLine(PGraphics src) {
    src.stroke(255, 0, 0);
    src.line(frameCount % widthRender, 0, frameCount % widthRender, height);
  }
}

String newStr() {
  String s = "";
  int n = int(random(3, 3));
  for (int k = 0; k < 5; k++) {
    for (int i = 0; i < n; i++) {
      s += newWord();
    }
    s += "\n";
  }
  return s;
}

String newStr(int n, int m) {
  String s = "";
  for (int k = 0; k < m; k++) {
    for (int i = 0; i < n; i++) {
      s += newWord();
    }
    if (k < m - 1) {
      s += "\n";
    }
  }
  return s;
}

String shiftStr(String in, int n) {
  String rtn;
  rtn = in.substring(1);
  rtn += newWord();
  return rtn;
}

void drawSingleText(String s, int x, int y) {
  pushMatrix();
  translate(widthRender / 2 + 100 * x, height / 2 + 100 * y);
  textFont(font);
  textSize(16);
  textAlign(CENTER, CENTER);
  if (colorReverse) {
    fill(255);
  } else {
    fill(0);
  }
  text("a", 0, 0);
  popMatrix();
}
