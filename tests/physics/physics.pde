import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;

import peasy.*;

// MODE:
//   0, POINTS
//   1, LINES
//   2, TRIANGLES
int MODE = 0;
int nOfP = 4000;

PShader shader;
float angle;

float[] positions;
float[] colors;
int[] indices;

// Buffers
FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;

// VBO IDs
int posVboId;
int colorVboId;
int indexVboId;

int posLoc;
int colorLoc;

PJOGL pgl;
GL2ES2 gl;

PeasyCam cam;

void setup() {
  size(960, 540, P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(500);

  // shaders initialization
  shader = loadShader("frag.glsl", "vert.glsl");

  positions = new float[nOfP * 4];
  colors = new float[nOfP * 4];
  indices = new int[nOfP];

  posBuffer = allocateDirectFloatBuffer(nOfP * 4);
  colorBuffer = allocateDirectFloatBuffer(nOfP * 4);
  indexBuffer = allocateDirectIntBuffer(nOfP);

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL2ES2();

  // Get GL ids for all the buffers
  IntBuffer intBuffer = IntBuffer.allocate(3);
  gl.glGenBuffers(3, intBuffer);
  posVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);
  indexVboId = intBuffer.get(2);
  // posVboId = 0;
  // colorVboId = 1;
  // indexVboId = 2;

  // Get the location of the attribute variables.
  shader.bind();
  posLoc = gl.glGetAttribLocation(shader.glProgram, "position");
  colorLoc = gl.glGetAttribLocation(shader.glProgram, "color");
  shader.unbind();

  // posLos: 1, colorLos: 0
  println("posLoc: " + posLoc);
  println("colorLoc: " + colorLoc);
  println("posVboId: " + posVboId);
  println("colorVboId: " + colorVboId);
  println("indexVboId: " + indexVboId);

  endPGL();
  initGeometry();
}
void draw() {
  showFrameRate();
  background(0);

  // translate(width / 2, height / 2);
  // shader(shader);
  noStroke();
  ambientLight(246, 36, 89);
  spotLight(249, 191, 59, 0, 0, 500, 0, 0, -1, PI/4, 2);
  // directionalLight(0, 255, 0, 0, -1, 0);

  pushMatrix();
  rotateY(angle * 0.1);
  // sphere(50.0);
  box(50.0);
  popMatrix();
  angle += 0.01;
  // rotateX(angle);
  // rotateY(0.2 * PI * cos(angle));
  // rotateZ(0.5 * PI * sin(angle));
  updateGeometry();
  glDraw();

}

void glDraw() {
  // Geometry transformations from Processing
  // are automatically passed to the shader
  // as long as the uniforms in the shader
  // have the right names.

  pgl = (PJOGL) beginPGL();
  gl = pgl.gl.getGL2ES2();

  shader.bind();
  updateShader();
  gl.glEnableVertexAttribArray(posLoc);
  gl.glEnableVertexAttribArray(colorLoc);

  // Copy vertex data to VBOs
  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, posVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * positions.length, posBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(posLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, colorVboId);
  gl.glBufferData(GL.GL_ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, GL.GL_DYNAMIC_DRAW);
  gl.glVertexAttribPointer(colorLoc, 4, GL.GL_FLOAT, false, 4 * Float.BYTES, 0);

  gl.glBindBuffer(GL.GL_ARRAY_BUFFER, 0);

  // Draw the triangle elements
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, indexVboId);
  pgl.bufferData(PGL.ELEMENT_ARRAY_BUFFER, Integer.BYTES * indices.length, indexBuffer, GL.GL_DYNAMIC_DRAW);
  switch(MODE) {
    case 0:
      gl.glDrawElements(PGL.POINTS, indices.length, GL.GL_UNSIGNED_INT, 0);
      break;
    case 1:
      gl.glDrawElements(PGL.LINES, indices.length, GL.GL_UNSIGNED_INT, 0);
      break;
    case 2:
      gl.glDrawElements(PGL.TRIANGLES, indices.length, GL.GL_UNSIGNED_INT, 0);
      break;
    default:
      break;
  }
  gl.glBindBuffer(PGL.ELEMENT_ARRAY_BUFFER, 0);

  gl.glDisableVertexAttribArray(posLoc);
  gl.glDisableVertexAttribArray(colorLoc);

  shader.unbind();

  endPGL();
}

// Geometry
void initGeometry() {
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    positions[j] = random(-300, 300);
    positions[j + 1] = random(-300, 300);
    positions[j + 2] = random(-300, 300);
    positions[j + 3] = 1;
    // colors[j] = 1;
    colors[j] = random(1);
    colors[j + 1] = random(0.5);
    colors[j + 2] = 0.8;
    // colors[j + 3] = random(0.5);
    colors[j + 3] = 1;
    indices[i] = i;
  }
}
void setGeometry() {
  float r = 200;
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;

    if (random(1) > 0.1) {
      float theta = random(1) * PI * 2;
      float zpos = random(1) * 2 - 1;
      float rsin = sqrt(1 - zpos * zpos);

      float xpos = rsin * cos(theta);
      float ypos = rsin * sin(theta);

      positions[j] = r * xpos;
      positions[j + 1] = r * ypos;
      positions[j + 2] = r * zpos;
      positions[j + 3] = 1;
    } else {
      positions[j] = random(-300, 300);
      positions[j + 1] = random(-300, 300);
      positions[j + 2] = random(-300, 300);
      positions[j + 3] = 1;
      indices[i] = i;
    }

    indices[i] = i;
  }
}
void setSphereEven() {
  float r = 200;
  float theta = random(1) * PI * 2;
  float zpos = random(1) * 2 - 1;
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    theta += random(0.05) * PI;
    zpos += random(0.01);
    if (zpos > 1) {
      zpos -= 2;
    }

    float rsin = sqrt(1 - zpos * zpos);

    float xpos = rsin * cos(theta);
    float ypos = rsin * sin(theta);

    positions[j] = r * xpos;
    positions[j + 1] = r * ypos;
    positions[j + 2] = r * zpos;
    positions[j + 3] = 1;
    if (i % 2 == 0) {
      indices[i] = i / 2;
      indices[i + 1] = i / 2 + 1;
    }
  }
}
void setSphere() {
  float r = 200;
  float theta = random(1) * PI * 2;
  float phi = random(1) * PI;


  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    theta += random(0.1, 0.2) * PI;
    phi += random(0.01) * PI;

    float xpos = sin(phi) * cos(theta);
    float zpos = sin(phi) * sin(theta);
    float ypos = cos(phi);

    positions[j] = r * xpos;
    positions[j + 1] = r * ypos;
    positions[j + 2] = r * zpos;
    positions[j + 3] = 1;
    if (i % 4 == 0) {
      indices[i] = i / 2;
      indices[i + 1] = i / 2 + 1;
      if (i < nOfP - 2) {
        indices[i + 2] = i / 2;
        indices[i + 3] = i / 2 + 2;
      }
    }
  }
}
void setPlane() {
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    positions[j] = random(-500, 500);
    positions[j + 1] = random(50, 100);
    positions[j + 2] = random(-500, 500);
    positions[j + 3] = 1;
    indices[i] = i;
  }
}
void setSquare() {
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;
    positions[j] = random(-100, 100);
    positions[j + 1] = random(-100, 100);
    positions[j + 2] = 100;
    positions[j + 3] = 1;
    indices[i] = i;
  }
}

void setStrip() {
  float xpos = -500;
  float ypos = -300;
  int connection = 10;
  float xDes = 13;
  boolean right = true;
  for (int i = 0; i < nOfP; i++) {
    int j = 4 * i;

    if (right) {
      xpos += random(10, 40);
    } else {
      xpos -= random(10, 40);
    }
    float y = ypos + 150 * noise(5.0 * (i + frameCount));
    positions[j] = xpos;
    positions[j + 1] = y;
    positions[j + 2] = 0;
    positions[j + 3] = 1;
    if (xpos > 500) {
      right = !right;
      ypos += 100;
      xpos = 500;
    } else if (xpos < -500) {
      right = !right;
      ypos += 100;
      xpos = -500;
    }
    if (i % connection == 0) {
      for (int k = 0; k < connection; k++) {
        if (k % 2 == 0) {
          indices[i + k] = i / connection;
        } else {
          indices[i + k] = i / connection + k / 2;
        }
      }
      // if (xpos > 500 || xpos < -500) {
      //   right = !right;
      //   ypos += 100;
      // } else {
      //   for (int k = 0; k < connection; k++) {
      //     if (k % 2 == 0) {
      //       indices[i + k] = i / connection;
      //     } else {
      //       indices[i + k] = i / connection + k / 2;
      //     }
      //   }
      // }
    }
  }
}

void updateGeometry() {
  posBuffer.rewind();
  posBuffer.put(positions);
  posBuffer.rewind();

  colorBuffer.rewind();
  colorBuffer.put(colors);
  colorBuffer.rewind();

  indexBuffer.rewind();
  indexBuffer.put(indices);
  indexBuffer.rewind();
}
void updateShader() {
  shader.set("uTime", millis() / 200.0);
}
void keyPressed() {
  if (key == '1') {
    MODE = 0;
  } else if (key == '2') {
    MODE = 1;
  } else if (key == '3') {
    MODE = 2;
  }

  if (key == 'z') {
    setGeometry();
  }
  if (key == 'x') {
    setSphere();
  }
  if (key == 'c') {
    setPlane();
  }
  if (key == 'v') {
    setStrip();
  }
  if (key == 'b') {
    initGeometry();
  }
}
