PGraphics sourceImage;
PGraphics maskImage;
void setup() {
  size(512, 512);

  // create source
  sourceImage = createGraphics(512,512);
  sourceImage.beginDraw();
  sourceImage.fill(255,0,0);
  sourceImage.translate(width/2,height/2);
  sourceImage.rotate(PI/3);
  sourceImage.rect(0,0,100,500);
  sourceImage.endDraw();

  // create mask
  maskImage = createGraphics(512,512);
  maskImage.beginDraw();
  // maskImage.triangle(30, 480, 256, 30, 480, 480);
  maskImage.ellipse(256, 256, 300, 300);
  maskImage.endDraw();

  // apply mask
  sourceImage.mask(maskImage);
}
void draw() {
  // show masked source
  image(sourceImage, 0, 0);
}


// https://forum.processing.org/two/discussion/23886/masking-a-shape-with-another-shape
