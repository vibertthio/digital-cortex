/*
 *
 * subdivision 6.2
 *
 * coded in Processing 3.0 IDE
 * i appreciate a mention/link back in derivative works
 *
 * hexmoire / michael mcknight
 * http://hexmoire.tumblr.com/
 *
 * this is cleaned up code, not a representation of the mess i make while developing an idea
 * the original code generated the gif at:
 * http://hexmoire.tumblr.com/post/132041914373/subdivision-62
 *
 */


int renderCount;
int renderCap;
float t;

boolean exporting;

PVector points[];

void setup() {

  //tumblr gif size.
  size(540, 540, P3D);

  //best antialiasing available using smooth.
  smooth(8);

  //position camera and
  //use scale to change axes.
  //+x is rightwards
  //+y is upwards
  //+z is outwards
  camera(0, 0, -height*3, 0, 0., 0, 0, -1, 0);

  //change field of view, preserving aspect ratio.
  //z clipping is an afterthought and does not scale.
  perspective(PI/6, width/(float)height, 10, 10000);

  //today we will be using white to fill in some happy triangles.
  //our friend the lighting model with be making most of them black.
  fill(255);

  //set up PVector array containing points on an octahedron.
  points=new PVector[6];
  points[0]=new PVector(0, height*.4, 0);
  points[1]=new PVector(height*.4, 0, 0);
  points[2]=new PVector(0, 0, -height*.4);
  points[3]=new PVector(-height*.4, 0, 0);
  points[4]=new PVector(0, 0, height*.4);
  points[5]=new PVector(0, -height*.4, 0);

  //set export to true to save frames as .gif files.
  exporting=false;
  //number of frames in animation loop.
  renderCap=140;

  //target display framerate.
  frameRate(30);

}

float alpha = 0;

void draw() {


  //set variables for current frame of animation.

  //this frame's number in animation loop.
  renderCount=(frameCount-1)%renderCap;
  //progress in animation loop scaled to [0,1), excluding 1.
  // t=renderCount/(float)renderCap;


  //clear screen.
  background(0);

  //reorient the coordinate system - a quick hack while composing the scene.
  // rotateZ(-PI/2);


  //set up lighting.

  //any surface not lit by some explicit lightsource will be completely dark.
  ambientLight(0,0,0);

  //set directional lights. using more than one to exceed max intensity.
  for(int i=0;i<4;i++){
    directionalLight(255,255,255,1,0,-1);
  }


  //rotate by t to spin the octahedron 90 degrees per loop.
  //exploiting symmetry to reduce frames.
  //offsetting a little for a better look.
  // float alpha;
  // alpha=-PI/2*t+PI/3;
  alpha += 0.01;
  rotateY(alpha);

  //define light vector counter rotated against previous transform.
  //it will be compared against pre transform triangles, this keeps its direction consistent
  //from the viewer's perspective as the triangles rotate.
  //this vector differs from the directionLight definitions in two ways:
  //1 - it represent's a light's position vector, not direction vector.
  //2 - at alpha==0 it sits on the negative x axis at (-1, 0, 0),
  //    whereas the light points *from* (-1, 0, 1).
  PVector lightV=new PVector(cos(alpha-PI),0,sin(alpha-PI));

  //radius of octahedron.
  float r = points[0].mag();

  //set number of recursions, as triangle wave rounded to int.
  //the 3.999 could be a 4 at this point, it's a throwback from a different wave.
  // int levels=(int)(abs(1-t*2)*3.999+.5);
  int levels=3;


  //visualization of octahedron vertices by index.
  //for the line fading to work, each triangle must be defined by
  //three vertices in clockwise order when viewed from the outside.
  //this makes the results of normal calculation consistent.
  /*
     0
     | 4
 3---+---1
   2 |
     5
  */


  beginShape(TRIANGLES);

  //call recursive subdivison for each face.
  subdivideTri(points[0], points[1], points[2], levels, r, lightV);
  subdivideTri(points[0], points[2], points[3], levels, r, lightV);
  subdivideTri(points[0], points[3], points[4], levels, r, lightV);
  subdivideTri(points[0], points[4], points[1], levels, r, lightV);
  subdivideTri(points[5], points[2], points[1], levels, r, lightV);
  subdivideTri(points[5], points[3], points[2], levels, r, lightV);
  subdivideTri(points[5], points[4], points[3], levels, r, lightV);
  subdivideTri(points[5], points[1], points[4], levels, r, lightV);

  endShape();


  //if exporting, save frames and exit at end of loop.
  if (exporting && renderCount<renderCap) {
    saveFrame("frames/f"+nf(renderCount, 3)+".gif");
  }
  if (exporting && frameCount==renderCap) {
    exit();
  }
}



//finally, the mechanism that makes all of this interesting.
//subdivideTri takes:
//
//  PVector a,b,c - the vertices for a triangle's points
//  int levels - representing how many levels are left to recurse
//  float radius - the radius of the sphere being approximated
//    (it could calculate this, but i think passing it in is cleaner
//     and makes for some interesting possibilities in revision.
//     probably the only extra code i didn't strip out.)
//  PVector lightVector - used to fade lines based on triangle normals

void subdivideTri(PVector a, PVector b, PVector c, int levels, float radius, PVector lightVector) {

  //let's start with the end case.
  //when levels finally reaches zero, actually draw something.
  if (levels==0) {

    //define the normal vector so that it can be passed to PVector.cross without a fuss from processing.
    PVector normal = new PVector(0,0,0);
    //store the cross product of the vector ba and ca in normal.
    //if clockwise triangles hadn't been guaranteed, normals might point in or out.
    PVector.cross(PVector.sub(b,a),PVector.sub(c,a),normal);

    //different alpha than before, this is the angle between the normal and the lightVector.
    float alpha=PVector.angleBetween(normal,lightVector);

    //use the alpha to determine line opacity. this was tuned until the fade looked good.
    // stroke(255,255,255,alpha/PI*255*2-120);
    stroke(255);

    //draw the triangle that was passed in. it may have come from draw() or from another subdivideTri.
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);

  }

  //if this isn't the last recursion, split the triangle and call subdivideTri for each new one.
  else {

    //calculate new vertices.
    PVector ab = PVector.lerp(a, b, .5);
    PVector bc = PVector.lerp(b, c, .5);
    PVector ca = PVector.lerp(c, a, .5);

    //make new vertices sit on sphere defined by radius.
    ab.setMag(radius);
    bc.setMag(radius);
    ca.setMag(radius);

    //call subdivideTri with new triangles, still in clockwise order.
    //  decrement levels because nobody likes infinite recursion.
    //  they might say they do until they see an implementation.
    subdivideTri(a, ab, ca, levels-1, radius, lightVector);
    subdivideTri(b, bc, ab, levels-1, radius, lightVector);
    subdivideTri(c, ca, bc, levels-1, radius, lightVector);
    subdivideTri(ab, bc, ca, levels-1, radius, lightVector);

  }

}
