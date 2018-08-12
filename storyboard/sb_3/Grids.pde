String randStr = newStr(200, 1);
int pointX = 0;
int pointY = 0;
void drawGrid(PGraphics src) {
  src.stroke(255, 0, 0);
  src.line(frameCount % width, 0, frameCount % width, height);

  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5);

  src.textFont(font);
  src.textSize(14);
  src.textAlign(CENTER, CENTER);
  src.fill(255);

  if (random(0, 1) < 0.3) {
    // randStr = newStr(200, 1);
    randStr = shiftStr(randStr, 1);
  }
  src.text(randStr, 0, 0);

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

  for (int i = 0; i < 11; i++) {
    // int rX = floor(random(-5, 6));
    // int rY = floor(random(-5, 6));
    for (int j = 0; j < 9; j++) {
      int rX = i - 5;
      int rY = j - 4;
      if (rY != 0) {
        // if (j == 1) {
        //   rY = 4;
        // }
        src.pushMatrix();
        src.translate(rX * 100, rY * 100);
        // src.fill(255);
        // src.noStroke();
        src.noFill();
        if (pointX == i && pointY ==j) {
          src.fill(255);
          src.rect(0, 0, 90, 90);
          src.stroke(255, 0, 0);
          // src.line(0, 0, -rX * 100, -rY * 100);
          src.line(0, 0, 0, -rX * 100, -rY * 100, 0);
        }
        src.stroke(100);
        // src.rect(0, 0, 90, 90);
        // src.fill(0);
        // src.rect(0, 0, 30, 30);

        src.textFont(font);
        src.textSize(16);
        src.textAlign(CENTER, CENTER);
        src.fill(255);
        // src.fill(0);
        src.text(randStr.charAt(i * 11 + j), 0, 0);

        src.popMatrix();
      }
    }

  }
  src.popMatrix();


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
  translate(width / 2 + 100 * x, height / 2 + 100 * y);
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
