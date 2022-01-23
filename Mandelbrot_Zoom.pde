/*
Author: Red1082
 
 This formula describes the fractal!
 Current formula: z1 = z0^2 + c
 z^2 = (a+bi)^2 = a^2 + 2abi - b^2
 Real(z^2) = a^2 - b^2
 Imag(z^2) = 2 * a * bi
 */
 
 
 
/* The classic Mandelbrot set formula */
///*
double [] formula (double real, double imag, double realConst, double imagConst) {
  return new double [] {
    real * real - imag * imag + realConst, 
    2 * real * imag + imagConst
  };
}
//*/


/* The burning - ship fractal */
/*
double [] formula (double real, double imag, double realConst, double imagConst) {
  return new double [] {
    abs(real * real - imag * imag) + realConst, 
    abs(2 * real * imag) + imagConst
  };
}
*/






double abs (double value) {
  return value < 0 ? -value : value;
}

final int maxIter = 200;
PVector min, max, mouse, pmouse;

void setup () {
  size(640, 480);
  float displayRatio = (float) width / height;
  min = new PVector(-2 * displayRatio, -1.5);
  max = new PVector(displayRatio, 1.5);
  print(displayRatio);
  mouse = new PVector();
  pmouse = new PVector();
  colorMode(HSB);
}

void draw () {
  background(0);
  mouse.set(mouseX, mouseY);
  loadPixels();
  for (int y = 0; y < height; y++)
    for (int x = 0; x < width; x++) {
      int n = iterate(screenToFractal(x, y));
      pixels[x + y * width] = color((float) n / maxIter * 255, 255, n == maxIter ? 0 : 255);
    }
  updatePixels();
  text(floor(frameRate) + " fps", 10, 20);
}

int iterate (double [] complex) {
  double realConst = complex[0];
  double imagConst = complex[1];
  double real = 0;
  double imag = 0;
  for (int n = 0; n < maxIter; n++) {
    double [] iteratedComplex = formula(real, imag, realConst, imagConst);
    real = iteratedComplex[0];
    imag = iteratedComplex[1];
    if (real * real + imag * imag > 4) return n;
  }
  return maxIter;
}

double [] screenToFractal (double x, double y) {
  return new double [] {
    x / width * (max.x - min.x) + min.x, 
    y / height * (max.y - min.y )+ min.y
  };
}

PVector screenToFractal (PVector pos) {
  double [] mappedPos = screenToFractal(pos.x, pos.y);
  return new PVector((float) mappedPos[0], (float) mappedPos[1]);
}

void mouseWheel (MouseEvent event) {
  float dz = event.getCount() * -.1;
  PVector mappedMouse = screenToFractal(mouse);
  PVector newMin = PVector.add(min, PVector.sub(mappedMouse, min).mult(dz));
  PVector newMax = PVector.add(max, PVector.sub(mappedMouse, max).mult(dz));
  double mag = PVector.sub(newMax, newMin).mag();
  if (mag < 2E-6 || mag > 100) return;
  min = newMin;
  max = newMax;
}

void mouseDragged () {
  if (!mousePressed) return;
  mouse.set(mouseX, mouseY);
  pmouse.set(pmouseX, pmouseY);
  PVector vec = PVector.sub(
    screenToFractal(pmouse), 
    screenToFractal(mouse)
    );
  min.add(vec);
  max.add(vec);
}
