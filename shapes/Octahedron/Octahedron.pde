PShape octa;
float alpha;
PShader sh;

void setup() {
  size(540, 540, P3D);
  camera(0, 0, -height*3, 0, 0., 0, 0, -1, 0);

  sh = loadShader("frag.glsl", "vert.glsl");
  octa = createOctahedron(height, 4);
  shader(sh);
}

void draw() {
  background(0);
  ambientLight(0,0,0);
  // translate(width * 0.5, height * 0.5);
  rotateY(alpha);
  updateShader();
  alpha += 0.005;
  shape(octa);
}

void updateShader() {
  sh.set("uTime", millis() / 1500.0);
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
