// vert.glsl
#version 150

uniform mat4 transform;
uniform float uTime;
uniform float ucale;

in vec4 position;
in vec4 positionNew;
in vec3 col;
in float noise;

out vec4 vertColor;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
  // float factor = sin(noise * 10.0 + uTime * 2.0);
  // vec3 updatePos = position.xyz * (1.0 + 0.03 * factor * factor);

  float t = sin(noise * 10.0 + uTime * 0.5);
  vec3 updatePos = position.xyz * t * t + positionNew.xyz * (1.0 - t * t);
  gl_Position = transform * vec4(updatePos, position.w);
  // gl_Position = transform * position;

  vertColor = vec4(col, 1.0);
  // vertColor = vec4(rand(updatePos.xy + uTime * 100), rand(updatePos.yz + uTime * 100), 0, 1.0);
}
