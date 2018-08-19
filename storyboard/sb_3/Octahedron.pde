PShape octa;
PShader octaShader;
float octaAlpha;
float octaTime = 0;

void initOctahedron() {
  octaShader = loadShader("octahedron/frag.glsl", "octahedron/vert.glsl");
  octa = createOctahedron(height * 0.2, 4);
  // octa = createOctahedron(height * 0.1, 4);
  octaAlpha = 0;
}
void drawOctahedron(PGraphics src) {
  updateOctaShader();
  src.shader(octaShader);
  src.pushMatrix();
  // src.background(0);
  src.translate(width * 0.5, height * 0.5);
  // src.ambientLight(0, 0, 0);
  src.rotateY(octaAlpha);
  octaAlpha += 0.005;
  src.shape(octa);
  src.resetShader();
  src.popMatrix();
}
void drawOctahedron(PGraphics src, float _x, float _y, float _z) {
  updateOctaShader();
  src.shader(octaShader);
  src.pushMatrix();
  // src.background(0);
  src.translate(width * (0.5 + _x), height * (0.5 + _y), 200 * _z);
  // src.ambientLight(0, 0, 0);
  src.rotateY(octaAlpha);
  octaAlpha += 0.005;
  src.shape(octa);
  src.resetShader();
  src.popMatrix();
}
void updateOctaShader() {
  octaShader.set("uTime", (millis() - octaTime) / 1500.0);
  // octaShader.set("uTime", millis() / 1500.0);
}
void resetOctaShader() {
  octaTime = millis();
}
PShape createOctahedron(float radius, int levels) {
  PVector points[];
  PVector lightV=new PVector(-1, 0, 1);
  points=new PVector[6];
  points[0]=new PVector(0, radius, 0);
  points[1]=new PVector(radius, 0, 0);
  points[2]=new PVector(0, 0, -radius);
  points[3]=new PVector(-radius, 0, 0);
  points[4]=new PVector(0, 0, radius);
  points[5]=new PVector(0, -radius, 0);

  PShape s;
  s = createShape();
  s.beginShape(TRIANGLES);
  subdivideTri(s, points[0], points[1], points[2], levels, radius, lightV);
  subdivideTri(s, points[0], points[2], points[3], levels, radius, lightV);
  subdivideTri(s, points[0], points[3], points[4], levels, radius, lightV);
  subdivideTri(s, points[0], points[4], points[1], levels, radius, lightV);
  subdivideTri(s, points[5], points[2], points[1], levels, radius, lightV);
  subdivideTri(s, points[5], points[3], points[2], levels, radius, lightV);
  subdivideTri(s, points[5], points[4], points[3], levels, radius, lightV);
  subdivideTri(s, points[5], points[1], points[4], levels, radius, lightV);
  s.endShape();

  return s;
}
void subdivideTri(PVector a, PVector b, PVector c, int levels, float radius, PVector lightVector) {

  //let's start with the end case.
  //when levels finally reaches zero, actually draw something.
  if (levels==0) {

    //define the normal vector so that it can be passed to PVector.cross without a fuss from processing.
    PVector normal = new PVector(0,0,0);
    //store the cross product of the vector ba and ca in normal.
    //if clockwise triangles hadn't been guaranteed, normals might point in or out.
    PVector.cross(PVector.sub(b,a),PVector.sub(c,a),normal);

    //different alpha than before, this is the angle between the normal and the lightVector.
    float alpha=PVector.angleBetween(normal,lightVector);

    //use the alpha to determine line opacity. this was tuned until the fade looked good.
    // stroke(255,255,255,alpha/PI*255*2-120);
    stroke(255);

    //draw the triangle that was passed in. it may have come from draw() or from another subdivideTri.
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);

  }

  //if this isn't the last recursion, split the triangle and call subdivideTri for each new one.
  else {

    //calculate new vertices.
    PVector ab = PVector.lerp(a, b, .5);
    PVector bc = PVector.lerp(b, c, .5);
    PVector ca = PVector.lerp(c, a, .5);

    //make new vertices sit on sphere defined by radius.
    ab.setMag(radius);
    bc.setMag(radius);
    ca.setMag(radius);

    //call subdivideTri with new triangles, still in clockwise order.
    //  decrement levels because nobody likes infinite recursion.
    //  they might say they do until they see an implementation.
    subdivideTri(a, ab, ca, levels-1, radius, lightVector);
    subdivideTri(b, bc, ab, levels-1, radius, lightVector);
    subdivideTri(c, ca, bc, levels-1, radius, lightVector);
    subdivideTri(ab, bc, ca, levels-1, radius, lightVector);

  }

}
void subdivideTri(PShape shape, PVector a, PVector b, PVector c, int levels, float radius, PVector lightVector) {

    //let's start with the end case.
    //when levels finally reaches zero, actually draw something.
    if (levels==0) {

      //define the normal vector so that it can be passed to PVector.cross without a fuss from processing.
      PVector normal = new PVector(0,0,0);
      PVector center = new PVector(
        (a.x + b.x + c.x) / 3.0,
        (a.y + b.y + c.y) / 3.0,
        (a.z + b.z + c.z) / 3.0
      );
      //store the cross product of the vector ba and ca in normal.
      //if clockwise triangles hadn't been guaranteed, normals might point in or out.
      PVector.cross(PVector.sub(b,a),PVector.sub(c,a),normal);
      normal.normalize();

      //different alpha than before, this is the angle between the normal and the lightVector.
      float alpha=PVector.angleBetween(normal,lightVector);

      //use the alpha to determine line opacity. this was tuned until the fade looked good.
      // stroke(255,255,255,alpha/PI*255*2-120);
      // shape.stroke(255);
      // shape.fill(200);

      //draw the triangle that was passed in. it may have come from draw() or from another subdivideTri.
      shape.attribPosition("faceNormal", normal.x, normal.y, normal.z);
      shape.attribPosition("center", center.x, center.y, center.z);
      shape.attribPosition("delay", random(0.5), random(0.5), random(0.5));

      shape.noStroke();
      shape.vertex(a.x, a.y, a.z);
      shape.vertex(b.x, b.y, b.z);
      shape.vertex(c.x, c.y, c.z);
    }

    //if this isn't the last recursion, split the triangle and call subdivideTri for each new one.
    else {

      //calculate new vertices.
      PVector ab = PVector.lerp(a, b, 0.5);
      PVector bc = PVector.lerp(b, c, 0.5);
      PVector ca = PVector.lerp(c, a, 0.5);

      //make new vertices sit on sphere defined by radius.
      ab.setMag(radius);
      bc.setMag(radius);
      ca.setMag(radius);

      //call subdivideTri with new triangles, still in clockwise order.
      //  decrement levels because nobody likes infinite recursion.
      //  they might say they do until they see an implementation.
      subdivideTri(shape, a, ab, ca, levels - 1, radius, lightVector);
      subdivideTri(shape, b, bc, ab, levels - 1, radius, lightVector);
      subdivideTri(shape, c, ca, bc, levels - 1, radius, lightVector);
      subdivideTri(shape, ab, bc, ca, levels - 1, radius, lightVector);

    }
}

void drawIndexLines(PGraphics src) {
  float rate = 0.01;
  float radius = 100;
  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5);
  src.stroke(255);
  // src.rotateY(frameCount * rate);
  // src.rotateZ(frameCount * rate);
  float x = radius * cos(frameCount * rate);
  float y = radius * sin(frameCount * rate);
  float z = 250;
  // float z = 10 * sin(frameCount * rate);
  // float z = 0;


  src.line(0, 0, 0, x, y, z);
  src.translate(x, y, z);

  src.line(0, 0, 0, 50, 0, 0);
  src.translate(53, 0, 0);

  // src.noStroke();
  // src.fill(255);
  // src.rect(10, 0, 20, 20);

  src.textFont(font);
  src.textSize(10);
  src.textAlign(LEFT, CENTER);
  // src.textAlign(CENTER, CENTER);
  src.fill(255);
  src.text("vibert", 0, 0);

  src.popMatrix();

}
void drawIndexLines1(PGraphics src) {
  float rate = 0.01;
  float radius = 100;
  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5);
  src.stroke(255);
  // src.rotateY(frameCount * rate);
  // src.rotateZ(frameCount * rate);
  float x = -300 + 10 * cos(frameCount * rate);
  float y = -200 + 50 * sin(frameCount * rate);
  float z = 0;
  // float z = 10 * sin(frameCount * rate);
  // float z = 0;


  src.line(0, 0, 0, x, y, z);
  src.translate(x, y, z);

  src.line(0, 0, 0, -50, 0, 0);
  src.translate(-53, 0, 0);

  // src.noStroke();
  // src.fill(255);
  // src.rect(10, 0, 20, 20);

  src.textFont(font);
  src.textSize(10);
  src.textAlign(RIGHT, CENTER);
  // src.textAlign(CENTER, CENTER);
  src.fill(255);
  src.text("vertical", 0, 0);

  src.popMatrix();

}
void drawIndexLines2(PGraphics src, String txt, float _x, float _y, float _z, float _phase) {
  float rate = 0.01;
  float radius = 100;
  src.pushMatrix();
  src.translate(width * 0.5, height * 0.5);
  src.stroke(255);
  // src.rotateY(frameCount * rate);
  // src.rotateZ(frameCount * rate);
  float x = _x + 10 * cos(frameCount * rate + _phase);
  float y = _y + 50 * sin(frameCount * rate + _phase);
  float z = _z;
  // float z = 10 * sin(frameCount * rate);
  // float z = 0;


  src.line(0, 0, 0, x, y, z);
  src.translate(x, y, z);

  if (x < 0) {
    src.line(0, 0, 0, -50, 0, 0);
    src.translate(-53, 0, 0);
    src.textAlign(RIGHT, CENTER);
  } else {
    src.line(0, 0, 0, 50, 0, 0);
    src.translate(53, 0, 0);
    src.textAlign(LEFT, CENTER);
  }

  // src.noStroke();
  // src.fill(255);
  // src.rect(10, 0, 20, 20);

  src.textFont(font);
  src.textSize(10);
  // src.textAlign(RIGHT, CENTER);
  // src.textAlign(CENTER, CENTER);
  src.fill(255);
  src.text(txt, 0, 0);

  src.popMatrix();

}
