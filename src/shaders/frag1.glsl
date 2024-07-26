#version 410 core

out vec4 fragColor;

uniform float Time;
uniform vec2 Resolution;

float sdSphere(vec3 p, vec3 center, float radius) {
    return length(p - center) - radius;
}

void main() {
    vec2 uv = (2.0 * gl_FragCoord.xy - Resolution.xy) / Resolution.y;

	vec2 Pos = vec2(0.5,0.5);

    vec3 camPos = vec3(0.0, 0.0, -1.0);
    vec3 rayDir = normalize(vec3(uv, 1.0));

    vec3 lightPos = vec3(Pos, -1.0);

    float t = 0.0;
    float maxDist = 100.0;
    for (int i = 0; i < 100; i++) {
        vec3 p = camPos + t * rayDir;
        float dist = sdSphere(p, vec3(0, 0, 1.0), 1.0);
        if (dist < 0.001 || t > maxDist) {
            break;
        }
        t += dist;
    }

    vec3 color = vec3(0.0);
    if (t < maxDist) {
        vec3 intersectionPoint = camPos + t * rayDir;
        vec3 normal = normalize(intersectionPoint - vec3(Pos, 1.0));

        vec3 lightDir = normalize(lightPos - intersectionPoint);
        float diffuseIntensity = max(dot(normal, lightDir), 0.0);

        color = vec3(1.0) * diffuseIntensity;
    }

    fragColor = vec4(color, 1.0);
}
