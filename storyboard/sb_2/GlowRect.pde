class GlowRect {

  float renderW;
  float renderH;
  float targetW;
  float targetH;

  GlowRect() {
    renderW = unit * 2;
    renderH = unit * 2;
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

  }

  void render(PGraphics src) {
    src.beginDraw();
    if (colorReverse) {
      src.background(255);
    } else {
      src.background(0);
    }
    // src.lights();
    src.translate(width / 2, height / 2);
    // src.rotateX(frameCount * 0.005f);
    src.rectMode(CENTER);
    src.noStroke();
    if (colorReverse) {
      src.fill(0);
    } else {
      src.fill(255);
    }

    src.rect(0, 0, renderW, renderH);
    src.endDraw();
  }

}

void drawText() {
  float rand = random(1);
  if (rand > 0.95) {
    boxStr += newWord();
  } else if (rand > 0.9) {
    boxStr = "" + newWord();
  } else if (rand > 0.88) {
    boxStr = "";
  }

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
}

class GlowRects {

}
