PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;
float rectWidth;

int mode = 1;
int triggerCount = 0;
boolean colorReverse = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;


void setup() {
  size(960, 540, OPENGL);
  // size(1920, 1080, OPENGL);
  smooth(8);
  unit = height / 9;
  rectWidth = unit * 3;

  src = createGraphics(width, height, P3D);
  initGlow();
  font = createFont("TickingTimebombBB.ttf", 24);
  rec = new GlowRect();

  oscP5 = new OscP5(this, 2204);
  // remoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  showFrameRate();
  src.beginDraw();

  if (mode == 0) {
    rec.draw(src);
  } else if (mode == 1) {
    randomHorizontalLines(src);
    if (triggerCount-- < 1) {
      mode = 0;
    }
  } else if (mode == 2) {
    randomVerticalLines(src);
    if (triggerCount-- < 1) {
      mode = 0;
    }
  }

  src.endDraw();
  PGraphics graphics = glowManager.dowGlow(src);
  image(graphics, 0, 0);

  if (mode == 0) {
    drawText();
  }
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
  if (key == '2') {
    mode = 0;
  }
  if (key == '3') {
    mode = 1;
    triggerCount = 10;
  }
  if (key == '4') {
    mode = 2;
    triggerCount = 10;
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  // print("### received an osc message.");
  // print(" addrpattern: "+theOscMessage.addrPattern());
  // println(" typetag: "+theOscMessage.typetag());

  if(theOscMessage.checkAddrPattern("/test")) {
    if(theOscMessage.checkTypetag("f")) {
      float value = theOscMessage.get(0).floatValue();
      rec.alpha = map(value, 0, 1, 150, 255);
    }
  }
}

void showFrameRate() {
  String f="digital cortex, fr:"+int((int(frameRate/4))*4);
  surface.setTitle(f);
}
