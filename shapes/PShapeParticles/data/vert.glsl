// vert.glsl
#version 150

uniform mat4 transform;
uniform float uTime;
uniform float ucale;

in vec4 position;
in vec4 color;
in vec3 col;
in float noise;

out vec4 vertColor;

void main() {
  float factor = sin(noise * 10.0 + uTime * 2.0);
  vec3 updatePos = position.xyz * (1.0 + 0.03 * factor * factor);
  gl_Position = transform * vec4(updatePos, position.w);

  vertColor = vec4(col, 1.0);
}
