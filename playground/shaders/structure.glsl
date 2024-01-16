#include <flutter/runtime_effect.glsl>

uniform vec2 iResolution;
uniform float iTime;

out vec4 fragColor;

//convert HSV to RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec2 fragPos = FlutterFragCoord().xy / iResolution.xy;
    fragPos.y -= 0.5;

    vec3 color = hsv2rgb(vec3(fragPos.x * 0.5 - iTime * 3.0, 1.0, 1.0));
    color *= (0.015 / abs(fragPos.y));

    color += dot(color, vec3(0.299, 0.587, 0.114));

    fragColor = vec4(color, 1.0);
}