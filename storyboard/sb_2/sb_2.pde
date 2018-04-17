PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;
float rectWidth;

int mode = 0;
int triggerCount = 0;
boolean colorReverse = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;


void setup() {
  size(960, 540, OPENGL);
  // size(1920, 1080, OPENGL);
  // fullScreen(OPENGL);
  smooth(8);
  unit = height / 9;
  rectWidth = unit * 3;

  src = createGraphics(width, height, P3D);
  initGlow();
  font = createFont("fonts/TickingTimebombBB.ttf", 24);
  rec = new GlowRect();

  oscP5 = new OscP5(this, 2204);
  remoteLocation = new NetAddress("127.0.0.1", 2205);

  dataPointsInit();
  initOctahedron();
  initParticles();
}

void draw() {
  showFrameRate();
  src.beginDraw();

  if (mode == 0) {
    rec.draw(src);
    dataPoints(src);
  } else if (mode == 1) {
    randomHorizontalLines(src);
  } else if (mode == 2) {
    randomVerticalLines(src);
  } else if (mode == 3) {
    randomDots(src);
  } else if (mode == 4) {
    src.background(0);
    drawLines(src);

  } else if (mode == 5) {
    src.background(0);
    drawOctahedron(src);
    drawParticles(src);
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
  if (key == ' ') {
    OscMessage msg = new OscMessage("/connect");
    msg.add(1);
    oscP5.send(msg, remoteLocation);
  }

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
  if (key == '5') {
    mode = 3;
    triggerCount = 10;
  }
  if (key == '6') {
    mode = 4;
    triggerCount = 10;
  }
  if (key == '7') {
    mode = 5;
    triggerCount = 10;
  }
}

void oscEvent(OscMessage msg) {
  // print("### received an osc message.");
  // print(" addrpattern: " + theOscMessage.addrPattern());
  // println(" typetag: "+theOscMessage.typetag());

  if (msg.checkAddrPattern("/bass")) {
    if (msg.checkTypetag("f")) {
      float value = msg.get(0).floatValue();
      rec.alpha = map(value, 0, 1, 150, 255);
    }
  } else if (msg.checkAddrPattern("/tick")) {
    if (msg.checkTypetag("i")) {
      updateText();

      if (mode == 5) {
        updateShowingParticles();
      }

      int b = msg.get(0).intValue();
      if (b > 96 && b < 128) {
        dataHold = true;
        updateDataX();
      } else {
        dataHold = false;
        updateDataY();
      }
    }
  } else if (msg.checkAddrPattern("/ns")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        mode = floor(random(1, 5));
      } else {
        mode = 0;
      }
    }
  } else if (msg.checkAddrPattern("/arp")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        rec.noise = true;
        rec.updateNoisePos();
      } else if (value == 0) {
        rec.noise = false;
      }
    }
  } else if (msg.checkAddrPattern("/octa")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        mode = 5;
      }
    }
  }
}

void showFrameRate() {
  String f="digital cortex, fr:"+int((int(frameRate/4))*4);
  surface.setTitle(f);
}
