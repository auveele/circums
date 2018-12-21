


int w, h;
float radius;
float angleOld, angleNew;
boolean ready;
PImage img;
PGraphics g1, g2;


void setup() {
  img = loadImage("test1.jpg");
  size(654, 654);
  frameRate(120);
  // initialize();
}

void initialize() {

  background(255);
  w = img.width;
  h = img.height;
  ready = false;

  g1 = createGraphics(w, h);
  g1.beginDraw();
  g1.background(255);
  g1.stroke(0);
  g1.strokeWeight(0.2);
  
  g2 = createGraphics(w, h);
  g2.beginDraw();
  g2.image(img, 0, 0);
  g2.stroke(255);
  g2.strokeWeight(0.2);
  
  radius = min(w, h)/2;
  angleNew = random(2*PI);
}

/*
  MAIN DRAW
 */
void draw() {

  if (img.height>0 && ready==false) {
    initialize();
    ready = true;
  }

  angleOld = angleNew;
  float min, b, angle;
  int n = 200;
  min = 255;

  for (int i=0; i<n; i++) {
    angle = random(2*PI);
    b = chordBrightness(angleOld, angle);
    if (b < min) {
      min = b;
      angleNew = angle;
    }
  }

  g1.beginDraw();
  g2.beginDraw();
  drawChord(angleOld, angleNew);
  g1.endDraw();
  g2.endDraw();
  image(g1, 0, 0);
  if (mousePressed) {
    image(g2, 0, 0);
  }
}

void drawChord(float a1, float a2) {
  float x1, y1, x2, y2;
  x1 = radius*sin(a1)+w/2;
  y1 = radius*cos(a1)+h/2;
  x2 = radius*sin(a2)+w/2;
  y2 = radius*cos(a2)+h/2;
  g1.line(x1, y1, x2, y2);
  g2.line(x1, y1, x2, y2);
}

float chordBrightness(float a1, float a2) {
  float x1, y1, x2, y2, x, y;
  x1 = radius*sin(a1)+w/2;
  y1 = radius*cos(a1)+h/2;
  x2 = radius*sin(a2)+w/2;
  y2 = radius*cos(a2)+h/2;

  int nSteps = 200;
  float sum = 0;

  for (int i=0; i<nSteps; i++) {
    x = x1 + (float)i/nSteps*(x2-x1);
    y = y1 + (float)i/nSteps*(y2-y1);
    sum += red(g2.get((int)x, (int)y))/(float)nSteps;
  }
  // println(sum);
  return sum;
}

void keyReleased() {
  switch(key) {
  case 'e': 
    // m.export();
    break;
  case 's':
    // m.show_lines = !m.show_lines;
    break;
  default:
    break;
  }
  initialize();
}
