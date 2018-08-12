String randStr = newStr(200, 1);
void drawGrid(PGraphics src) {
  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5);
  src.fill(255);
  src.rectMode(CENTER);
  // src.rect(0, 0, 90, 90);

  src.textFont(font);
  src.textSize(16);
  src.textAlign(CENTER, CENTER);
  src.fill(255);

  if (random(0, 1) < 0.01) {
    // randStr = newStr(200, 1);
    randStr[int(random(200))] = newWord();
  }
  src.text(randStr, 0, 0);


  // for (int i = 0; i < 5; i++) {
  //   int rX = floor(random(-5, 6));
  //   int rY = floor(random(-5, 6));
  //   src.pushMatrix();
  //   src.translate(rX * 100, rY * 100);
  //   src.fill(255);
  //   // src.rect(0, 0, 90, 90);
  //
  //   src.textFont(font);
  //   src.textSize(16);
  //   src.textAlign(CENTER, CENTER);
  //   src.fill(255);
  //   src.text(newStr(), 0, 0);
  //
  //   src.popMatrix();
  //
  //
  // }

  src.popMatrix();
}

String newStr() {
  String s = "";
  int n = int(random(5, 8));
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
    s += "\n";
  }
  return s;
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
