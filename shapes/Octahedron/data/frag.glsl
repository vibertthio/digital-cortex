// frag.glsl
#version 150

uniform mat4 transform;
uniform float uTime;

in vec4 vertColor;
in vec3 vPosition;
in float vNoise;
in float vNow;

out vec4 fragColor;

const vec3 lightDirection = vec3(2.0, -1.0, -1.0);
const float duration = 2.0;
const float delayAll = 1.0;

vec3 convertHsvToRgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  float now = clamp((uTime - delayAll - 1.5) / duration, 0.0, 1.0);
  vec3 normal = normalize(cross(dFdx(vPosition), dFdy(vPosition)));
  vec3 light = normalize(lightDirection);

  float diff = (dot(normal, light) + 1.0) / 2.0 * 0.2;
  float opacity = smoothstep(0.1, 0.2, vNow);
  // float opacity = 0.1;

  vec3 v = normalize(vPosition);
  vec3 rgb = (1.0 - now) * vec3(1.0) + convertHsvToRgb(vec3(
    0.5 + (v.x + v.y + v.x) / 40.0 + uTime * 0.1,
    // 0.9,
    0.0,
    0.4 + sin(uTime) * 0.05 + vNoise * 0.02)
  );

  fragColor =  vec4(rgb + diff, opacity);;
  // fragColor = vertColor;
}
