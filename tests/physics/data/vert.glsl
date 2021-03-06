// vert.glsl
#version 150

uniform mat4 transform;
uniform float uTime;
uniform float scale;

in vec4 position;
in vec4 color;

out vec4 vertColor;

void main() {
  vec4 newPos = position;
  newPos.x = position.x + 10.0 * sin(uTime + position.y * (sin(position.x) * 0.1));
  newPos.y = position.y + 5.0 * cos(uTime + position.x * (sin(position.y) * 0.1));
  newPos.z = position.z + 5.0 * cos(uTime + position.z * position.x * 0.1);

  // newPos.y = position.y + 20.0 * cos(uTime + position.x * (sin(position.y) * 0.1));

  gl_Position = transform * newPos;
  vertColor = color;
}
