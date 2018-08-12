PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;
float rectWidth;

int mode = 5;
int pdControlPhase = 0;
int[][] noiseChoice = {
  { 1, 2, 3 },
  { 6, 7, 8, 9 },
};
int triggerCount = 0;
boolean colorReverse = false;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress remoteLocation;


void setup() {
  size(1080, 900, OPENGL);
  // size(540, 450, OPENGL);
  // size(960, 540, OPENGL);
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

  initDataPoints();
  initOctahedron();
  initParticles();
  initLines();
}

void draw() {
  showFrameRate();
  src.beginDraw();

  if (mode == 0) {
    rec.draw(src);
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
    // drawLines(src);
    drawOctahedron(src);
    drawParticles(src);
    drawIndexLines2(src, "vertical", -300, -200, 0, PI);
    drawIndexLines2(src, "shinyi", -150, 150, 100, 0.5 * PI);
    drawIndexLines2(src, "vibert", 250, 100, -10, 0.1 * PI);

    drawGrid(src);

    // drawPlain(src);
  } else if (mode == 6) {
    src.background(0);
    drawLines(src, 0);
  } else if (mode == 7) {
    src.background(0);
    drawLines(src, 1);
  } else if (mode == 8) {
    src.background(0);
    drawLines(src, 2);
  } else if (mode == 9) {
    src.background(0);
    drawLines(src, 3);
    // drawOctahedron(src);

  } else if (mode == 10) {
    src.background(0);
    // drawOctahedron(src);
    drawLines(src, 2);
  } else if (mode == 11) {
    src.background(0);
    drawGrid(src);
  }

  blink(src);
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

  if (key == 'q') {
    mode = 6;
  }
  if (key == 'w') {
    mode = 7;
  }
  if (key == 'e') {
    mode = 8;
  }
  if (key == 'r') {
    mode = 9;
  }
  if (key == 't') {
    mode = 10;
  }

  if (key == 'a') {
    // rec.startFadeIn();

  }

}

boolean dongStarted = false;
void oscEvent(OscMessage msg) {
  // print("### received an osc message.");
  // print(" addrpattern: " + msg.addrPattern());
  // println(" typetag: "+ msg.typetag());

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

      if (pdControlPhase == 2) {
        rec.fill = !rec.fill;
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
        if (pdControlPhase == 4) {
          mode = 4;
        } else {
          mode = noiseChoice[0][int(random(3))];
        }
      } else if (value == 0) {
        if (pdControlPhase == 3) {
          mode = 0;
        } else if (pdControlPhase == 4) {
          mode = 5;
        }
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
        // mode = 7;
      }
    }
  } else if (msg.checkAddrPattern("/phase")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        rec.startFadeIn();
        pdControlPhase = 1;
      } else if (value == 2) {
        pdControlPhase = 2;
      } else if (value == 3) {
        rec.fill = true;
        rec.showingDataPoints = true;
        pdControlPhase = 3;
      } else if (value == 4) {
        // mode = 7;
        mode = 1;
        pdControlPhase = 4;
      } else if (value == 5) {
        pdControlPhase = 5;
        mode = 7;
      } else if (value == 6) {
        pdControlPhase = 6;
        mode = 0;
        rec.showingDataPoints = false;
        rec.startFadeIn(4000);
        updateText("-$vibert thio");
      }
    }
  } else if (msg.checkAddrPattern("/dong")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        dongStarted = true;
        mode++;
        if (mode > 9) {
          mode = 6;
        }
        // mode = noiseChoice[1][int(random(4))];
      }
    }
  } else if (msg.checkAddrPattern("/stutter")) {
    println("in");
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        if (!dongStarted) {
          blinkCount = 2;
        } else if (random(1) > 0.8) {
          blinkCount = 1;
        }
      }
    }
  }
}

void showFrameRate() {
  String f="digital cortex, fr:"+int((int(frameRate/4))*4);
  surface.setTitle(f);
}
