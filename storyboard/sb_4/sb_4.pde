import oscP5.*;
import netP5.*;

PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;
float rectWidth;

int mode = 0;
int pdControlPhase = 0;
int[][] noiseChoice = {
  { 1, 2, 3 },
  { 6, 7, 8, 9 },
};
int triggerCount = 0;
boolean colorReverse = false;


OscP5 oscP5;
NetAddress remoteLocation;

// Drawing Objects
Plains plains;
Octa octa;
Grid grid;

float widthRender;
float heightRender;

float xOff;
float yOff;

void setup() {

  // size(1080, 900, OPENGL);
  // size(1210, 977, OPENGL);
  // size(540, 450, OPENGL);
  // size(960, 540, OPENGL);
  // size(1920, 1080, OPENGL);

  // 1. debug full
  size(1600, 1000, OPENGL);
  widthRender = 1216;
  heightRender = 1000;
  xOff = 202;
  yOff = 0;

  // 2. debug small
  // size(608, 500, OPENGL);
  // widthRender = 608;
  // heightRender = 500;
  // xOff = 0;
  // yOff = 0;

  // 3. live
   // fullScreen(OPENGL, SPAN);
   // widthRender = 1216;
   // heightRender = 1000;
   // xOff = 202;
   // yOff = 0;

  smooth(8);

  // widthRender = 1210;
  // heightRender = 998;
  // xOff = 205;
  // yOff = 0;


  unit = heightRender / 12;
  rectWidth = unit * 3 ;

  src = createGraphics(int(widthRender), int(heightRender), P3D);
  initGlow();
  font = createFont("fonts/TickingTimebombBB.ttf", 24);
  rec = new GlowRect();

  oscP5 = new OscP5(this, 2204);
  remoteLocation = new NetAddress("127.0.0.1", 2205);

  initParticles();
  initLines();

  octa = new Octa();
  plains = new Plains();
  grid = new Grid();

  tryConnect();
}

void draw() {
  showFrameRate();
  translate(xOff, yOff);
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
    if (pdControlPhase == 4) {
      if (random(1) < 0.2) {
        drawParticles(src);
      }
      if (random(1) < 0.7) {
        drawLines(src);
      }
    } else {
      drawLines(src);
    }
  } else if (mode == 5) {
    src.background(0);
    drawParticles(src);
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

  } else if (mode == 10) {
    src.background(0);
    drawLines(src, 2);
  } else if (mode == 11) {
    src.background(0);
    plains.update();
    plains.draw(src);
  } else if (mode == 12) {
    src.background(0);
    octa.draw(src);
    octa.drawLines(src);

  } else if (mode == 13) {

    // array octa
    src.background(0);
    octa.drawOctaArray(src);
  } else if (mode == 14) {

    // array octa
    src.background(0);
    grid.draw(src);
    octa.draw(src);
    octa.drawLines(src);
  }

  blink(src);
  src.endDraw();
  PGraphics graphics = glowManager.dowGlow(src);
  // image(graphics, 0, 0);
  background(0);
  margin();
  image(graphics, 0, 0);


  if (mode == 0) {
    drawText();
  } else if (mode == 5 || mode == 4) {
    drawMask();
  }

}

boolean maskOn = false;
boolean maskLeft = true;
void drawMask() {
  if (maskOn) {
    fill(0);
    noStroke();
    if (maskLeft) {
      rect(0, 0, widthRender * 0.5, heightRender);
    } else {
      rect(widthRender * 0.5, 0, widthRender * 0.5, heightRender);
    }
  }
}

void reverseMask() {
  maskLeft = !maskLeft;
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
    reset();
    // setState();
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
  if (key == 'y') {
    mode = 11;
  }

  if (key == 'a') {
    octa.resetTiming();
  }
  if (key == 's') {
    plains.startScanning();
  }
  if (key == 'd') {
    plains.alligning = !plains.alligning;
  }
  if (key == 'f') {
    if (plains.finalLongitude > 5) {
      plains.finalLongitude = 0;
    } else {
      plains.finalLongitude = plains.normalLongitude;
    }
  }

  if (key == 'z') {
    octa.reverse();
  }
  if (key == 'x') {
    octa.changeSize();
  }
  if (key == 'c') {
    reverseMask();
  }
  if (key == 'v') {
    plains.bangBass();
  }

}

void reset() {
  mode = 0;
  boxStr = "-$";

  rec.reset();
  plains.reset();
  grid.reset();
}

boolean dongStarted = false;
void oscEvent(OscMessage msg) {
  // print("### received an osc message.");
  // println(" osc: " + msg.addrPattern());
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
        rec.dataHold = true;
        rec.updateDataX();
      } else {
        rec.dataHold = false;
        rec.updateDataY();
      }
    }
  } else if (msg.checkAddrPattern("/ns")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 1) {
        if (pdControlPhase == 4) {
          if (mode == 0) {
            mode = 3;
          } else {
            mode = 4;
          }
        } else if (pdControlPhase == 3) {
          mode = noiseChoice[0][int(random(3))];
        }
      } else if (value == 0) {
        if (pdControlPhase == 3) {
          mode = 0;
        } else if (pdControlPhase == 4) {
          reverseMask();
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

        // 1. rec fade in
        rec.reset();
        rec.startFadeIn();
        pdControlPhase = 1;
      } else if (value == 2) {

        // 2. flash rec
        pdControlPhase = 2;
      } else if (value == 3) {

        // 3. reading datas
        rec.fill = true;
        rec.showingDataPoints = true;
        pdControlPhase = 3;
      } else if (value == 4) {
        mode = 4;
        pdControlPhase = 4;
      } else if (value == 5) {
        pdControlPhase = 5;
        mode = 12;
        // octa.changeSize(1.2);
        // octa.changeSize(1.2);
        octa.nOfLinesShow = 10;
        octa.reset();
        blinkCount = 1;
      } else if (value == 6) {

        pdControlPhase = 6;
        mode = 14;
        octa.scale = 1.0;
        octa.nOfLinesShow = 0;
        octa.change(0.3, 20);

        octa.octaMerging = true;
        octa.resetTiming();
        grid.reset();
      } else if (value == 7) {
        pdControlPhase = 7;
        mode = 0;
        rec.showingDataPoints = false;
        rec.fill = true;
        rec.startFadeIn(4000);
        updateText("-$vibert thio");
      } else if (value == 8) {
        reset();
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
  } else if (msg.checkAddrPattern("/octa-array")) {
    if (msg.checkTypetag("i")) {

      int value = msg.get(0).intValue();
      if (value == 1) {
        octa.resetTiming();
        octa.octaTimeShift += 3000;
      }
      if (value > 0) {
        mode = 13;
        octa.change(0.6, 30.0, 0.1);
      }

      if (value < 7) {
        octa.arrayNumber = value;
      } else {
        octa.arrayNumber += 4;
      }

      if (value == 16) {
        mode = 14;
        blinkCount = 1;
        grid.redLineAlpha = 400;
      }
    }
  } else if (msg.checkAddrPattern("/bi")) {
    if (msg.checkTypetag("i")) {
      octa.nOfLinesShow += 1;
      octa.octaTimeShift += 1000;
    }
  } else if (msg.checkAddrPattern("/bap")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      blinkRed(1);
      if (value == 2) {
        grid.showSequence = false;
        grid.showScanning = false;
        grid.nOfNpsShowing = 0;
        octa.nOfLinesShow = 0;
        octa.reverse();
      } else if (value == 3) {
        blinkSwitching = true;
      } else if (value == 4) {
        blinkSwitching = false;
        mode = 11;
      }
    } else if (msg.checkTypetag("ii")) {
      int value = msg.get(0).intValue();
      int bapc = msg.get(1).intValue();

      octa.nOfLinesShow = 0;
      blinkRed(1);

      if (bapc == 0) {
        octa.change(0.4, 25);
        grid.showSequence = true;
      } else if (bapc == 1) {
        octa.change(0.6, 25);
        grid.showSequence = false;
        grid.showScanning = true;
      } else if (bapc == 2) {
        octa.change(0.7, 25);
        grid.showSequence = true;
        grid.showScanning = true;
        grid.nOfNpsShowing = 3;
        octa.nOfLinesShow = 6;
      } else if (bapc == 3) {
        octa.change(1.0, 25);
        grid.showSequence = false;
        grid.showScanning = false;
        grid.nOfNpsShowing = 0;
      }
      println("octa size: " + octa.size);
    }
  } else if (msg.checkAddrPattern("/kick")) {
    if (msg.checkTypetag("i")) {
      plains.bangBass();
      if (msg.get(0).intValue() == 2) {
        if (plains.drate == 0) {
          plains.changeDepth(1.0);
        } else {
          plains.changeDepth(plains.drate - 0.15);
        }
      }
    }
  } else if (msg.checkAddrPattern("/beat")) {
    if (msg.checkTypetag("i")) {
      int value = msg.get(0).intValue();
      if (value == 0) {
        plains.finalLongitude = plains.normalLongitude;
        plains.startScanning();

      }
      if (value % 4 == 0) {
        plains.alligning = !plains.alligning;
      }
    }
  }
}

void showFrameRate() {
  String f="digital cortex, fr:"+int((int(frameRate/4))*4);
  f += " md: " + mode;
  f += " ph: " + pdControlPhase;
  surface.setTitle(f);
}

void setState() {
  mode = 0;
  rec.fill = true;
  rec.showingDataPoints = true;
  rec.alpha = 255;
  pdControlPhase = 3;
}
void tryConnect() {
  OscMessage msg = new OscMessage("/connect");
  msg.add(1);
  oscP5.send(msg, remoteLocation);
}
void margin() {
  stroke(255, 0, 0);
  line(0, 0, 0, heightRender);
  line(0, 0, widthRender, 0);
  line(0, heightRender, widthRender, heightRender);
  line(widthRender, 0, widthRender, heightRender);
}
