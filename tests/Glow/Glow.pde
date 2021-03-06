/**
 adapted from http://forum.devmaster.net/t/shader-effects-glow-and-bloom/3100

 keys 1,2,3 change blendmode
 keys 5,7,9 change blur parameters

 **/

PGraphics src;
PGraphics glowCanvas;

GlowManager postProduction;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);

  src = createGraphics(width, height, P3D);

  glowCanvas = createGraphics(width, height, P2D);

  postProduction = new GlowManager();
  postProduction.initGlow(this, src, 0.25f);

  postProduction.blur.set("blurSize", 23);
  postProduction.blur.set("sigma", 19.0f);

  postProduction.glowShader.set("BlendMode", 1);
}

void draw() {

  drawGeometry(src);

  PGraphics graphics = postProduction.dowGlow(src);

  image(graphics, 0, 0);
}

void drawGeometry(PGraphics src) {
  src.beginDraw();
  src.background(0);
  // src.lights();
  src.translate(width / 2, height / 2);
  src.rectMode(CENTER);
  src.noStroke();
  src.fill(255);
  src.rect(0, 0, src.width * 0.3, src.height * 0.3);

  src.textSize(16);
  src.textAlign(CENTER, CENTER);
  src.fill(0);
  src.text("6", 0, 0);
  // src.rotateY(frameCount * 0.005f);
  // src.stroke(255, 0, 0);
  // src.sphere(200);
  src.endDraw();
}

void keyPressed() {
  if (key == '9') {
    postProduction.blur.set("blurSize", 23f);
    postProduction.blur.set("sigma", 19.0f);
  } else if (key == '7') {
    postProduction.blur.set("blurSize", 7f);
    postProduction.blur.set("sigma", 3.0f);
  } else if (key == '5') {
    postProduction.blur.set("blurSize", 5f);
    postProduction.blur.set("sigma", 2.0f);
  } else if (key == '1') {
    postProduction.glowShader.set("BlendMode", 0);
  } else if (key == '2') {
    postProduction.glowShader.set("BlendMode", 1);
  } else if (key == '3') {
    postProduction.glowShader.set("BlendMode", 2);
  }
}
