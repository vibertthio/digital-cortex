import peasy.*;

PShape particles;
float alpha;
PShader sh;
PeasyCam cam;

void setup() {
  size(960, 540, P3D);
  cam = new PeasyCam(this, 700);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(700);

  sh = loadShader("frag.glsl", "vert.glsl");
  particles = createParticles(10000);
  shader(sh);
}

void draw() {
  showFrameRate();
  background(0);
  ambientLight(255, 255, 255);
  // translate(width * 0.5, height * 0.5);
  // rotateY(alpha);
  updateShader();
  alpha += 0.005;
  shape(particles);
}

void updateShader() {
  sh.set("uTime", millis() / 1000.0);
}

PShape createParticles(int nOfP) {
  PShape s;
  s = createShape();
  s.beginShape(TRIANGLES);

  float r = 300;
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

void showFrameRate() {
  String f="GPU Particles, fr:"+int((int(frameRate/4))*4);
  surface.setTitle(f);
}
