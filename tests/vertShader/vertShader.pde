float angle = 0.0;
float offset;

void setup() {
    size(800, 800, P3D);
    noStroke();
    textureMode(NORMAL);
    initShader();
}

void draw() {
    background(0);
    camera(sin(angle += 0.0005) * 800, -800, cos(angle) * 800, 0, 500, 0, 0, 1, 0);
    renderLandscape();
}

public void initShader() {
    String[] vertSource = {
        "#version 150",

        "uniform mat4 transform;",

        "in vec4 vertex;",
        "in vec4 color;",
        "in vec2 texCoord;",

        "out vec4 vertColor;",
        "out vec2 vertTexCoord;",

        "void main() {",
            "vertColor = color;",
            "vertTexCoord = texCoord;",

            "gl_Position = transform * vertex;",
        "}"
    };
    String[] fragSource = {
        "#version 150",

        "uniform sampler2D texture;",

        "in vec4 vertColor;",
        "in vec2 vertTexCoord;",

        "out vec4 fragColor;",

        "void main() {",
            "float minDist = min(min(vertTexCoord.x, vertTexCoord.y), min(1.0 - vertTexCoord.x, 1.0 - vertTexCoord.y));",
            "float edgeIntensity = smoothstep(0.02, 0.04, minDist);",
            "fragColor = mix(vec4(0.0, 1.0, 0.5, 1.0), vertColor, edgeIntensity);",
        "}"
    };
    shader(new PShader(this, vertSource, fragSource));
}

public void renderLandscape() {
    PVector vecA = new PVector(), vecB = new PVector(), vecC = new PVector(), vecD = new PVector();
    float colA, colB, colC, colD;
    offset = frameCount * 0.003;
    beginShape(QUADS);
    for(int z1 = -5, z2 = -4; z1 < 5; ++z1, ++z2)
        for(int x1 = -5, x2 = -4; x1 < 5; ++x1, ++x2) {
            float y = noise(x1 * 0.2 + offset, z1 * 0.2 + offset);
            colA = 127 - y * 127;
            vecA.set(x1, y * 5, z1).mult(100);
            y = noise(x2 * 0.2 + offset, z1 * 0.2 + offset);
            colB = 127 - y * 127;
            vecB.set(x2, y * 5, z1).mult(100);
            y = noise(x2 * 0.2 + offset, z2 * 0.2 + offset);
            colC = 127 - y * 127;
            vecC.set(x2, y * 5, z2).mult(100);
            y = noise(x1 * 0.2 + offset, z2 * 0.2 + offset);
            colD = 127 - y * 127;
            vecD.set(x1, y * 5, z2).mult(100);
            // noFill();
            // fill(colA);
            vertex(vecA.x, vecA.y, vecA.z, 0.0, 0.0);
            // fill(colB);
            vertex(vecB.x, vecB.y, vecB.z, 1.0, 0.0);
            // fill(colC);
            vertex(vecC.x, vecC.y, vecC.z, 1.0, 1.0);
            // fill(colD);
            vertex(vecD.x, vecD.y, vecD.z, 0.0, 1.0);
        }
    endShape();
}
