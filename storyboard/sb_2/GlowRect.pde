class GlowRects {

}

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
    src.background(0);
    // src.lights();
    src.translate(width / 2, height / 2);
    // src.rotateX(frameCount * 0.005f);
    src.rectMode(CENTER);
    src.noStroke();
    src.fill(255);
    src.rect(0, 0, renderW, renderH);

    src.endDraw();
  }


}
