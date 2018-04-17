PShape particles;
PShader particlesShader;
boolean showParticles = true;

void initParticles() {
  particlesShader = loadShader("particles/frag.glsl", "particles/vert.glsl");
  particles = createParticles(5000);
  // lines = createLines(1000);
  lines = createLines2(2000);
  linesShader = loadShader("lines/frag.glsl", "lines/vert.glsl");
}
void drawParticles(PGraphics src) {
  if (showParticles) {
    if (random(1) < 0.9) {
      showParticles = false;
    }
    updateParticlesShader();

    src.shader(particlesShader);
    src.pushMatrix();
    // src.background(0);
    src.translate(width * 0.5, height * 0.5);
    // src.ambientLight(0, 0, 0);
    src.rotateY(octaAlpha);
    // octaAlpha += 0.005;
    src.shape(particles);
    src.resetShader();
    src.popMatrix();
  }
}
void updateShowingParticles() {
  if (showParticles) {
    if (random(1) < 0.9) {
      showParticles = false;
    }
  } else {
    if (random(1) < 0.9) {
      showParticles = true;
    }
  }
}
PShape createParticles(int nOfP) {
  PShape s;
  s = createShape();
  s.beginShape(TRIANGLES);

  float r = height * 0.3;
  float smooth = 0.8;
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    float theta = random(1) * PI * 2;
    float zpos = random(1) * 2 - 1;
    float rsin = sqrt(1 - zpos * zpos);
    float xpos = rsin * cos(theta);
    float ypos = rsin * sin(theta);

    float ns = noise(xpos * smooth + ypos * smooth + zpos * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 1.0;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    float alpha = random(0.5, 1);
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);

    s.attrib("noise", ns);
    s.vertex(r * xpos, r * ypos, r * zpos);
    s.vertex(r * xpos + sz, r * ypos, r * zpos);
    s.vertex(r * xpos, r * ypos + sz, r * zpos);

    s.vertex(r * xpos, r * ypos, r * zpos);
    s.vertex(r * xpos + sz, r * ypos, r * zpos);
    s.vertex(r * xpos, r * ypos, r * zpos + sz);

    s.vertex(r * xpos, r * ypos, r * zpos);
    s.vertex(r * xpos, r * ypos + sz, r * zpos);
    s.vertex(r * xpos, r * ypos, r * zpos + sz);

    s.vertex(r * xpos + sz, r * ypos, r * zpos);
    s.vertex(r * xpos, r * ypos + sz, r * zpos);
    s.vertex(r * xpos, r * ypos, r * zpos + sz);
  }

  s.endShape();
  return s;
}
void updateParticlesShader() {
  particlesShader.set("uTime", millis() / 1000.0);
}

PShape lines;
PShader linesShader;
PShape createLines(int nOfL) {
  PShape s;
  float smooth = 0.8;
  s = createShape();
  s.beginShape(QUADS);
  float range = 0.9 * height;

  for (int i = 0; i < nOfL; i++) {
    // float xpos1 = 0;
    // float ypos1 = 0;
    // float zpos1 = 0;
    float xpos1 = random(-range, range);
    float ypos1 = random(-range, range);
    float zpos1 = 0;
    // float zpos1 = random(-range, range);

    float xpos2 = random(-range, range);
    float ypos2 = random(-range, range);
    float zpos2 = 0;
    // float zpos2 = random(-range, range);

    float xpos3 = random(-range, range);
    float ypos3 = random(-range, range);
    float zpos3 = 0;
    // float zpos3 = random(-range, range);

    float xpos4 = random(-range, range);
    float ypos4 = random(-range, range);
    float zpos4 = 0;
    // float zpos4 = random(-range, range);

    float ns = noise(xpos1 * smooth + ypos1 * smooth + zpos1 * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 0.5;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    // float alpha = random(0.5, 1);
    float alpha = 1;
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);
    s.attribPosition(
      "positionNew",
      xpos3,
      ypos3,
      0
    );

    s.attrib("noise", ns);
    s.vertex(xpos1, ypos1, zpos1);
    s.attribPosition(
      "positionNew",
      xpos3 + sz,
      ypos3,
      0
    );
    s.vertex(xpos1 + sz, ypos1, zpos1);

    s.attribPosition(
      "positionNew",
      xpos4,
      ypos4,
      0
    );
    s.vertex(xpos2, ypos2, zpos2);
    s.attribPosition(
      "positionNew",
      xpos4 + sz,
      ypos4,
      0
    );
    s.vertex(xpos2 + sz, ypos2, zpos2);

    // 2nd
    // s.vertex(xpos1, ypos1, zpos1);
    // s.vertex(xpos1, ypos1 + sz, zpos1);
    //
    // s.vertex(xpos2, ypos2, zpos2);
    // s.vertex(xpos2, ypos2 + sz, zpos2);
    //
    // // 3rd
    // s.vertex(xpos1 + sz, ypos1, zpos1);
    // s.vertex(xpos1, ypos1 + sz, zpos1);
    //
    // s.vertex(xpos2 + sz, ypos2, zpos2);
    // s.vertex(xpos2, ypos2 + sz, zpos2);

  }

  s.endShape();
  return s;
}
PShape createLines2(int nOfL) {
  PShape s;
  float smooth = 0.8;
  s = createShape();
  s.beginShape(QUADS);
  float range = 0.9 * height;

  for (int i = 0; i < nOfL; i++) {
    float r = height * 0.3;
    float theta = random(1) * PI * 2;
    float zpos = random(1) * 2 - 1;
    float rsin = sqrt(1 - zpos * zpos);
    float xpos = rsin * cos(theta);
    float ypos = rsin * sin(theta);
    xpos *= r;
    ypos *= r;
    zpos *= r;

    float xpos1 = -xpos;
    float ypos1 = ypos;
    float zpos1 = -zpos;
    // float zpos1 = random(-range, range);

    float xpos2 = xpos;
    float ypos2 = -ypos;
    float zpos2 = zpos;
    // float zpos2 = random(-range, range);

    float xpos3 = xpos;
    float ypos3 = ypos;
    float zpos3 = -zpos;
    // float zpos3 = random(-range, range);

    float xpos4 = -xpos;
    float ypos4 = ypos;
    float zpos4 = zpos;
    // float zpos4 = random(-range, range);

    float ns = noise(xpos1 * smooth + ypos1 * smooth + zpos1 * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 0.5;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    // float alpha = random(0.5, 1);
    float alpha = 1;
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);
    s.attribPosition(
      "positionNew",
      xpos3,
      ypos3,
      zpos3
    );

    s.attrib("noise", ns);
    s.vertex(xpos1, ypos1, zpos1);
    s.attribPosition(
      "positionNew",
      xpos3 + sz,
      ypos3,
      zpos3
    );
    s.vertex(xpos1 + sz, ypos1, zpos1);

    s.attribPosition(
      "positionNew",
      xpos4,
      ypos4,
      zpos4
    );
    s.vertex(xpos2, ypos2, zpos2);
    s.attribPosition(
      "positionNew",
      xpos4 + sz,
      ypos4,
      zpos4
    );
    s.vertex(xpos2 + sz, ypos2, zpos2);

  }

  s.endShape();
  return s;
}
PShape createLines3(int nOfL) {
  PShape s;
  float smooth = 0.8;
  s = createShape();
  s.beginShape(QUADS);
  float range = 0.9 * height;

  for (int i = 0; i < nOfL; i++) {
    float r = height * 0.3;
    float dist = 0.4;
    float theta = random(1) * PI * 2;
    float zpos = random(1) * 2 - 1;
    float rsin = sqrt(1 - zpos * zpos);
    float xpos = rsin * cos(theta);
    float ypos = rsin * sin(theta);
    xpos *= r;
    ypos *= r;
    zpos *= r;

    float xpos1 = xpos;
    float ypos1 = ypos;
    float zpos1 = zpos;
    // float zpos1 = random(-range, range);

    float xpos3 = xpos + random(-r * dist, r * dist);
    float ypos3 = ypos + random(-r * dist, r * dist);
    float zpos3 = zpos + random(-r * dist, r * dist);
    // float zpos2 = random(-range, range);


    theta = random(1) * PI * 2;
    zpos = random(1) * 2 - 1;
    rsin = sqrt(1 - zpos * zpos);
    xpos = rsin * cos(theta);
    ypos = rsin * sin(theta);
    xpos *= r;
    ypos *= r;
    zpos *= r;

    float xpos2 = xpos;
    float ypos2 = ypos;
    float zpos2 = zpos;
    // float zpos3 = random(-range, range);

    float xpos4 = xpos + random(-r * dist, r * dist);
    float ypos4 = ypos + random(-r * dist, r * dist);
    float zpos4 = zpos + random(-r * dist, r * dist);
    // float zpos4 = random(-range, range);

    float ns = noise(xpos1 * smooth + ypos1 * smooth + zpos1 * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 0.5;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    // float alpha = random(0.5, 1);
    float alpha = 1;
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);
    s.attribPosition(
      "positionNew",
      xpos3,
      ypos3,
      zpos3
    );

    s.attrib("noise", ns);
    s.vertex(xpos1, ypos1, zpos1);
    s.attribPosition(
      "positionNew",
      xpos3 + sz,
      ypos3,
      zpos3
    );
    s.vertex(xpos1 + sz, ypos1, zpos1);

    s.attribPosition(
      "positionNew",
      xpos4,
      ypos4,
      zpos4
    );
    s.vertex(xpos2, ypos2, zpos2);
    s.attribPosition(
      "positionNew",
      xpos4 + sz,
      ypos4,
      zpos4
    );
    s.vertex(xpos2 + sz, ypos2, zpos2);

  }

  s.endShape();
  return s;
}
PShape createLines4(int nOfL) {
  PShape s;
  float smooth = 0.8;
  s = createShape();
  s.beginShape(QUADS);
  float range = 0.9 * height;
  float r = height * 0.3;

  float centerX = r * 0.1;
  float centerY = r * -0.2;
  float centerZ = r * 0.3;

  float centerX2 = r * -0.1;
  float centerY2 = r * 0.5;
  float centerZ2 = r * 0.1;
  for (int i = 0; i < nOfL; i++) {

    float dist = 0.4;
    float theta = random(1) * PI * 2;
    float zpos = random(1) * 2 - 1;
    float rsin = sqrt(1 - zpos * zpos);
    float xpos = rsin * cos(theta);
    float ypos = rsin * sin(theta);
    xpos *= r;
    ypos *= r;
    zpos *= r;

    float xpos1;
    float ypos1;
    float zpos1;

    float xpos3;
    float ypos3;
    float zpos3;
    if (random(1) > 0.5) {
      xpos1 = centerX;
      ypos1 = centerY;
      zpos1 = centerZ;

      xpos3 = centerX;
      ypos3 = centerY;
      zpos3 = centerZ;
    } else {
      xpos1 = centerX2;
      ypos1 = centerY2;
      zpos1 = centerZ2;

      xpos3 = centerX2;
      ypos3 = centerY2;
      zpos3 = centerZ2;
    }


    theta = random(1) * PI * 2;
    zpos = random(1) * 2 - 1;
    rsin = sqrt(1 - zpos * zpos);
    xpos = rsin * cos(theta);
    ypos = rsin * sin(theta);
    xpos *= r;
    ypos *= r;
    zpos *= r;

    float xpos2 = xpos;
    float ypos2 = ypos;
    float zpos2 = zpos;
    // float zpos3 = random(-range, range);

    float xpos4 = xpos + random(-r * dist, r * dist);
    float ypos4 = ypos + random(-r * dist, r * dist);
    float zpos4 = zpos + random(-r * dist, r * dist);
    // float zpos4 = random(-range, range);

    float ns = noise(xpos2 * smooth + ypos2 * smooth + zpos2 * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 0.5;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    // float alpha = random(0.5, 1);
    float alpha = 1;
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);
    s.attribPosition(
      "positionNew",
      xpos3,
      ypos3,
      zpos3
    );

    s.attrib("noise", ns);
    s.vertex(xpos1, ypos1, zpos1);
    s.attribPosition(
      "positionNew",
      xpos3 + sz,
      ypos3,
      zpos3
    );
    s.vertex(xpos1 + sz, ypos1, zpos1);

    s.attribPosition(
      "positionNew",
      xpos4,
      ypos4,
      zpos4
    );
    s.vertex(xpos2, ypos2, zpos2);
    s.attribPosition(
      "positionNew",
      xpos4 + sz,
      ypos4,
      zpos4
    );
    s.vertex(xpos2 + sz, ypos2, zpos2);

  }

  s.endShape();
  return s;
}
void drawLines(PGraphics src) {
  updateLinesShader();
  src.pushMatrix();
  src.shader(linesShader);
  // src.background(0);
  src.translate(width * 0.5, height * 0.5);
  // src.ambientLight(0, 0, 0);
  // src.rotateZ(octaAlpha);
  // src.rotateY(octaAlpha);
  // octaAlpha = random(0, 2 * PI);
  octaAlpha += 0.005;
  src.shape(lines);
  src.resetShader();
  src.popMatrix();
}
void updateLinesShader() {
  linesShader.set("uTime", millis() / 1000.0);
}
