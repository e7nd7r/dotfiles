#define SPEED_MULTIPLIER 10.
#define GREEN_ALPHA .5
#define BLACK_BLEND_THRESHOLD .4

#define R fract(1e2 * sin(p.x * 8. + p.y))

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 c, vec2 p) {
    // Conditions using step
    float condition1 = step(p.x, c.x) * step(c.y, p.y); // c.x < p.x && c.y > p.y
    float condition2 = step(c.x, p.x) * step(p.y, c.y); // c.x > p.x && c.y < p.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}
float ease(float x) {
    return pow(1.0 - x, 3.0);
}

vec4 saturate(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.)); // luminance
    return mix(vec4(gray), color, factor);
}

const vec4 TRAIL_COLOR = vec4(1.0, 0.725, 0.161, 1.0);
const vec4 TRAIL_COLOR_ACCENT = vec4(1.0, 0., 0., 1.0);
const float DURATION = 0.3; //IN SECONDS

vec4 applyCursor(vec4 fragColor, vec2 fragCoord)
{
    // #if !defined(WEB)
    // fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    // #endif

    // Normalization for fragCoord to a space of -1 to 1;
    vec2 vu = normalize(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    // Normalization for cursor position and size;
    // cursor xy has the postion in a space of -1 to 1;
    // zw has the width and height
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    // When drawing a parellelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    // Set every vertex of my parellogram
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);

    // Distance between cursors determine the total length of the parallelogram;
    float lineLength = distance(centerCC, centerCP);

    float mod = .007;

    //trailblaze
    // HACK: Using the saturate function because I currently don't know how to blend colors without losing saturation.
    vec4 trail = mix(saturate(TRAIL_COLOR_ACCENT, 1.5), fragColor, 1. - smoothstep(0., sdfTrail + mod, 0.007));
    trail = mix(saturate(TRAIL_COLOR, 1.5), trail, 1. - smoothstep(0., sdfTrail + mod, 0.006));
    trail = mix(trail, saturate(TRAIL_COLOR, 1.5), step(sdfTrail + mod, 0.));

    //cursorblaze
    trail = mix(saturate(TRAIL_COLOR_ACCENT, 1.5), trail, 1. - smoothstep(0., sdfCurrentCursor + .002, 0.004));
    trail = mix(saturate(TRAIL_COLOR, 1.5), trail, 1. - smoothstep(0., sdfCurrentCursor + .002, 0.004));

    fragColor = mix(trail, fragColor, 1. - smoothstep(0., sdfCurrentCursor, easedProgress * lineLength));

    return fragColor;
}

vec3 bendY(vec3 p, float k) {
    // guard against k ~ 0 (no bend)
    float kk = max(abs(k), 1e-6);
    float r  = 0.8 / kk;          // bend radius
    float a  = p.x * k;           // angle at this x
    float sa = sin(a), ca = cos(a);

    vec3 q;
    q.x = sa * r;                 // moved onto the cylinder
    q.y = p.y;
    q.z = p.z + (ca - 1.0) * r;   // shift so a=0 stays at z
    return q;
}

vec3 waveBend(vec3 p, float amp, float freq) {
    // bend in Z by curving X across Z
    p.z += amp * sin(p.x * freq);
    // or bend in X by curving along Y:
    // p.x += amp * sin(p.y * freq);
    return p;
}

vec3 hueShift(vec3 c, float shift) {
    const mat3 toYIQ = mat3(0.299, 0.587, 0.114,
                            0.596, -0.274, -0.322,
                            0.211, -0.523, 0.311);
    const mat3 toRGB = mat3(1.0, 0.956, 0.621,
                            1.0, -0.272, -0.647,
                            1.0, -1.107, 1.705);
    vec3 yiq = toYIQ * c;
    float angle = shift;
    float cosA = cos(angle), sinA = sin(angle);
    yiq.gb = mat2(cosA, -sinA, sinA, cosA) * yiq.gb;
    return toRGB * yiq;
}

void mainImage(out vec4 fragColor, vec2 fragCoord) {
    vec3 v = vec3(fragCoord, 1) / iResolution - .5;

    // time-varying bend (optional)
    // float k = 1.3 + 0.8 * sin(iTime * 3); // radians per unit
    // v = bendY(v, k);
    float amp = 1.60 * (0.5 + 0.5 * sin(iTime * 0.7));
    float freq = 6.0;
    float mask = 1.0 - smoothstep(0.10, 0.5, length(v.xy));
    v = waveBend(v, amp * mask, freq);
    // vec3 s = .5 / abs(v);
    // scale?
    vec3 s = .9 / abs(v);
    s.z = min(s.y, s.x);
    vec3 i = ceil( 8e2 * s.z * ( s.y < s.x ? v.xzz : v.zyz ) ) * .1;
    vec3 j = fract(i);
    i -= j;

    // float variableSpeed = 2.0 + sin(iTime * 0.01);
    float variableSpeed = 0.01 * sin(iTime * 0.02 + sin(iTime * 0.01));
    vec3 p = vec3(9, int(iTime * variableSpeed * (9. + 8. * sin(i).x)), 0) + i;
    vec3 col = vec3(0.0);
    col.g = R / s.z;
    p *= j;
    col *= (R >.5 && j.x < .6 && j.y < .8) ? GREEN_ALPHA : 0.;

    float shift = sin(iTime + v.y + sin(iTime + v.x * 3));
    col = hueShift(col, shift);

  	// Sample the terminal screen texture including alpha channel
    vec2 uv = fragCoord.xy / iResolution.xy;
  	vec4 terminalColor = texture(iChannel0, uv);

    float alpha = step(length(terminalColor.rgb), BLACK_BLEND_THRESHOLD);
    vec3 blendedColor = mix(terminalColor.rgb * 1.2, col, alpha);

    fragColor = vec4(blendedColor, terminalColor.a);

    // ← overlay cursor & trail AFTER your base color is ready
    fragColor = applyCursor(fragColor, fragCoord);
}

