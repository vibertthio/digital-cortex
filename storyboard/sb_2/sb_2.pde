PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;

boolean colorReverse = false;

void setup() {
  size(960, 540, OPENGL);
  smooth(8);
  unit = height / 9;

  src = createGraphics(width, height, P3D);
  initGlow();
  font = createFont("TickingTimebombBB.ttf", 24);
  rec = new GlowRect();
}

void draw() {
  PGraphics graphics = rec.drawGlow(src);
  image(graphics, 0, 0);
  drawText();
}


void initGlow() {
  glowManager = new GlowManager();
  glowManager.initGlow(this, src, 0.25f);
  glowManager.blur.set("blurSize", 7);
  glowManager.blur.set("sigma", 3.0f);
  glowManager.glowShader.set("BlendMode", 1);
}

void keyPressed() {
  if (key == '1') {
    colorReverse = !colorReverse;
  }
}
