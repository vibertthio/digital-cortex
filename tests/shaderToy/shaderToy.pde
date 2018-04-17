PShader voronoi;

void setup() {
  size (1280, 720, P2D);
  voronoi = loadShader("voronoi.glsl");
  voronoi.set("iResolution", float(width), float(height));
}

void draw () {
  surface.setTitle(nf(frameRate, 2, 2));
  background(255);
  voronoi.set("iGlobalTime", millis() / 1000.0);
  filter(voronoi);
}
