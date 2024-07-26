#version 410 core

out vec4 fragColor;

uniform float Time;
uniform vec2 Resolution;

mat2 rot2D(float a) {
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}

vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (t + vec3(0.3, 0.416, 0.557)));
}

float sdOctahedron(vec3 p, float s) {
    p = abs(p);
    return (p.x + p.y + p.z - s) * 0.57735027;
}
float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

float sdTorus(vec3 p, vec2 t) {
    vec2 q = vec2(length(p.xy) - t.x, p.z);
    return length(q) - t.y;
}

// Scene distance
float map(vec3 p) {
    p.z += Time * 0.4; // Forward movement

    // Space repetition
    p.xy = fract(p.xy) - 0.5;     // spacing: 1
    p.z = mod(p.z, 0.25) - 0.125; // spacing: 0.25

    return sdSphere(p, 0.12); // Sphere
    // Uncomment to use Octahedron instead
    // return sdOctahedron(p, 0.15); // Octahedron
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - Resolution.xy) / Resolution.y;

	vec2 uPos = vec2(0.5,0.5);

    vec2 m = vec2(cos(Time * 0.2 * uPos.x), sin(Time * 0.2 * uPos.y)); // auto

    // Initialization
    vec3 ro = vec3(0.0, 0.0, -3.0);         // ray origin
    vec3 rd = normalize(vec3(uv, 1.0)); // ray direction
    vec3 col = vec3(0.0);               // final pixel color

    float t = 0.0; // total distance travelled

    int i; // Raymarching
    for (i = 0; i < 80; i++) {
        vec3 p = ro + rd * t; // position along the ray

        p.xy *= rot2D(t * 0.15 * m.x);     // rotate ray around z-axis

        p.y += sin(t * (m.y + 1.0) * 0.5) * 0.35;  // wiggle ray
        p.x += cos(t * (m.x + 1.0) * 0.5) * 0.35;  // wiggle ray

        float d = map(p);     // current distance to the scene

        t += d;               // "march" the ray

        if (d < 0.001 || t > 100.0) break; // early stop
    }

    // Coloring
    // col = palette(t * 0.02 + float(i) * 0.005);
    col = palette(t * 0.001 + float(i) * 0.005);
    fragColor = vec4(col, 1.0);
}
