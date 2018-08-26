import oscP5.*;
import netP5.*;
import peasy.*;

PGraphics src;

GlowRect rec;
GlowManager glowManager;

String boxStr = "";
PFont font;

float unit;
float rectWidth;

int mode = 4;
int pdControlPhase = 0;
int[][] noiseChoice = {
  { 1, 2, 3 },
  { 6, 7, 8, 9 },
};
int triggerCount = 0;
boolean colorReverse = false;


OscP5 oscP5;
NetAddress remoteLocation;

PeasyCam cam;

// Drawing Objects
Plains plains;
Octa octa;
Grid grid;

void setup() {
  size(1080, 900, OPENGL);
  // size(540, 450, OPENGL);
  // size(960, 540, OPENGL);
  // size(1920, 1080, OPENGL);
  // fullScreen(OPENGL);
  smooth(8);
  unit = height / 12;
  rectWidth = unit * 3 ;

  src = createGraphics(width, height, P3D);
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
  } else if (mode == 13) {

    // array octa
    src.background(0);
    octa.drawOctaArray(src);
  } else if (mode == 14) {

    // array octa
    src.background(0);
    grid.draw(src);
    octa.draw(src);
  }

  blink(src);
  src.endDraw();
  PGraphics graphics = glowManager.dowGlow(src);
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
      rect(0, 0, width * 0.5, height);
    } else {
      rect(width * 0.5, 0, width * 0.5, height);
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
    octa.reset();
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

}

void reset() {
  mode = 0;
  rec.alpha = 0;
  rec.fill = false;
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
        octa.changeSize(1.2);
        octa.scale = 1.0;
        blinkCount = 1;
      } else if (value == 6) {

        pdControlPhase = 6;
        mode = 14;
        octa.scale = 1.0;
        octa.changeSize(0.3);
        println("phase 6");

        octa.octaMerging = true;
        octa.reset();

      } else if (value == 20) {
        pdControlPhase = 20;
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
      if (value > 0) {
        mode = 13;
        octa.scale = 0.1;
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
