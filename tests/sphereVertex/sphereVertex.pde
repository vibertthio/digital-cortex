PShader shader;
PShape sphere;

float angle = 0;

void setup() {
  size(800, 600, P3D);
  shader = loadShader("frag.glsl", "vert.glsl");
  // sphere = createSphere(200, 50);
  sphere = createShape(SPHERE, 250);

}


void draw() {
  // background(255);
  background(0);
  translate(width * 0.5, height * 0.5);
  rotateY(angle);
  updateShader();


  shader(shader);
  // noFill();
  stroke(0);
  shape(sphere);

  angle += 0.005;
}

void updateShader() {
  shader.set("uTime", millis() / 1000.0);
}

PShape createSphere(float r, int detail) {
  // textureMode(NORMAL);
  PShape gr = createShape(GROUP);

  float dphi = TWO_PI / detail; // change in phi angle
  float dtheta = PI / detail; // change in theta angle

  // process the sphere one band at a time
  // going from almost south pole to almost north
  // poles must be handled separately
  float theta2 = -PI/2+dtheta;
  float z2 = sin(theta2); // height off equator
  float rxyUpper = cos(theta2); // closer to equator
  for (int i = 1; i < detail; i++) {
    float theta1 = theta2;
    theta2 = theta1 + dtheta;
    float z1 = z2;
    z2 = sin(theta2);
    float rxyLower = rxyUpper;
    rxyUpper = cos(theta2); // radius in xy plane

    PShape sh = createShape();
    sh.beginShape(QUAD_STRIP);
    // sh.noStroke();
    for (int j = 0; j <= detail; j++) {
      float phi = j * dphi; //longitude in radians
      float xLower = rxyLower * cos(phi);
      float yLower = rxyLower * sin(phi);
      float xUpper = rxyUpper * cos(phi);
      float yUpper = rxyUpper * sin(phi);
      float u = phi/TWO_PI;
      sh.normal(xLower, yLower, z1);
      sh.vertex(r*xLower, r*yLower, r*z1, u,(theta1+HALF_PI)/PI);
      sh.normal(xUpper, yUpper, z2);
      sh.vertex(r*xUpper, r*yUpper, r*z2, u,(theta2+HALF_PI)/PI);
    }
    sh.endShape();
    gr.addChild(sh);
  }

  return gr;
}
