PShape particles;
PShader particlesShader;
boolean showParticles = true;

void initParticles() {
  particlesShader = loadShader("particles/frag.glsl", "particles/vert.glsl");
  particles = createParticles(5000);
  lines = createLines(1000);
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
PShape createLines(int nOfL) {
  PShape s;
  float smooth = 0.8;
  s = createShape();
  s.beginShape(QUADS);
  float range = 0.9 * height;

  for (int i = 0; i < nOfL; i++) {
    float xpos1 = random(-range, range);
    float ypos1 = random(-range, range);
    float zpos1 = random(-range, range);

    float ns = noise(xpos1 * smooth + ypos1 * smooth + zpos1 * smooth, frameCount * smooth * 0.5);
    ns *= ns;
    float sz = 0.1;
    s.noStroke();
    // s.attribPosition("col", random(1), random(1), random(0.1));
    // float alpha = random(0.5, 1);
    float alpha = 1;
    // s.attribPosition("col", random(0.7), random(1), random(0.1));
    s.attribPosition("col", alpha, alpha, alpha);
    s.attrib("noise", ns);
    s.vertex(xpos1, ypos1, zpos1);
    s.vertex(xpos1 + sz, ypos1, zpos1);

    float xpos2 = random(-range, range);
    float ypos2 = random(-range, range);
    float zpos2 = random(-range, range);

    s.vertex(xpos2, ypos2, zpos2);
    s.vertex(xpos2 + sz, ypos2, zpos2);

    // 2nd
    s.vertex(xpos1, ypos1, zpos1);
    s.vertex(xpos1, ypos1 + sz, zpos1);

    s.vertex(xpos2, ypos2, zpos2);
    s.vertex(xpos2, ypos2 + sz, zpos2);

    // 3rd
    s.vertex(xpos1 + sz, ypos1, zpos1);
    s.vertex(xpos1, ypos1 + sz, zpos1);

    s.vertex(xpos2 + sz, ypos2, zpos2);
    s.vertex(xpos2, ypos2 + sz, zpos2);

  }

  s.endShape();
  return s;
}
void drawLines(PGraphics src) {
  updateParticlesShader();
  src.pushMatrix();
  src.shader(particlesShader);
  // src.background(0);
  src.translate(width * 0.5, height * 0.5);
  // src.ambientLight(0, 0, 0);
  src.rotateY(octaAlpha);
  // octaAlpha = random(0, 2 * PI);
  octaAlpha += 0.05;
  src.shape(lines);
  src.resetShader();
  src.popMatrix();
}
