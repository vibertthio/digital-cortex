PGraphics src;

GlowRect rec;
GlowManager glowManager;

String str = "";
PFont font;

float unit;

void setup() {
  // size(960, 540, OPENGL);
  fullScreen(OPENGL);
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


char newWord() {
  return char(int(random(33, 127)));
}

void drawText() {
  float rand = random(1);
  if (rand > 0.95) {
    str += newWord();
  } else if (rand > 0.9) {
    str = "" + newWord();
  } else if (rand > 0.88) {
    str = "";
  }

  translate(width / 2, height / 2);
  textFont(font);
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  text(str, 0, 0);
}

void initGlow() {
  glowManager = new GlowManager();
  glowManager.initGlow(this, src, 0.25f);
  glowManager.blur.set("blurSize", 7);
  glowManager.blur.set("sigma", 3.0f);
  glowManager.glowShader.set("BlendMode", 1);
}
