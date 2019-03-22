
class Circums {
  // Variables
  int max_width = 800;
  int max_height = 800;
  int default_iterations = 1000;
  int screws_quantity = 200;
  int[] screws_count = new int[screws_quantity];
  int max_count = 0;
  
  boolean rendering = false;
  float radius;
  int w, h;
  PImage img;
  PGraphics g1, g2;

  int n_iterations;
  // Tornillos
  int currentScreew, oldScreew;


  /*
    CONSTRUCTOR
   */
  Circums() {
  }

  /*
     LOOP A PINTAR
   */
  void update() {
    if (img == null) return;
    
    if (rendering == true) {
      if (n_iterations > 0) {
        oldScreew = currentScreew;
        float min, b;
        min = 255;

        for (int i=0; i < screws_quantity; i++) {
          if (i == oldScreew) continue;
          if (abs(i - oldScreew) < 15) continue;  
          b = chordBrightness(oldScreew, i);
          if (b < min) {
            min = b;
            currentScreew = i;
          }
        }

        // PINTAMOS LINEA
        drawChord(oldScreew, currentScreew);
        

        n_iterations--;
        println(n_iterations + " - " + "(" + oldScreew + " - " + currentScreew + ") - " + screws_count[currentScreew] + "/" + max_count);
        // guardo en el fichero el elemento
        output.println(currentScreew);
        output.flush(); // Writes the remaining data to the file
      }
    }
  }

  void display() {
    if (img == null) return;
    if (g1 == null) return;
    if (g2 == null) return;
    image(g1, 0, 0);
    if (mousePressed) {
      image(g2, 0, 0);
    }
  }

  /*
    CARGAMOS IMAGEN
   */
  void load_image(String path) {

    img = loadImage(path);
    w = img.width;
    h = img.height;

    // Cuadramos la imagen
    if (w != h) {
      println("Primero cuadramos la imagen: " + w + "w - " + h + "h");
      if (w > h) {
        img = img.get((w-h)/2, 0, h, h);
        w = img.width;
        h = img.height;
      } else {
        img = img.get(0, (h-w)/2, w, w);
        w = img.width;
        h = img.height;
      }
    } else {
      println("La imagen ya es cuadrada!");
    }

    // Escalamos al tamaño máximo permitido
    w = img.width;
    if (w > max_width) {
      img.resize(max_width, 0);
    }
    h = img.height;
    if (h > max_height) {
      img.resize(0, max_height);
    }

    // Redimensionamos ventana de Vista Previa
    w = img.width;
    h = img.height;
    println("Tamaño del frame: " + w + "w - " + h + "h");
    surface.setSize(w, h);

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
    // primer elemento aleatorio
    currentScreew = (int)random(screws_quantity);
    // guardo en el fichero el elemento
    output.println(currentScreew);
    // angleNew = PI;
    n_iterations = default_iterations;
    // Dibujamos tornillos
    draw_screws();
    // Limpiamos cuenta de tornillos
    max_count = 0;
    for (int i = 0; i < screws_quantity; i++){
      screws_count[i] = 0;
    }
    
  }
  
  /*
    Dibujamos los tornillos
  */
  void draw_screws(){
    PVector _screw = new PVector(0,0);
    for(int i = 0; i < screws_quantity; i++){
      _screw = get_screw(i);
      g1.circle(_screw.x, _screw.y, 2);
    }
  }

  /*
    Devuelve las cordenadas
      del tornillo número _n
      de un total _t tornillo
      inscritos en un círculo de radio _r    
  */
  PVector get_screw(int _n) {    
    PVector _screw = new PVector(0,0);
    float angle;
    
    angle = (2*PI*_n) / screws_quantity;
    _screw.x = radius * sin(angle) + w/2;
    _screw.y = radius * cos(angle) + h/2;
    return _screw;
  }
  


  /*
    PINTO LINEA
    y SUBSTRAIGO A LA IMAGEN
  */
  void drawChord(int _oldScreew, int _currentScreew) {
    float x1, y1, x2, y2;
    x1 = get_screw(_oldScreew).x;
    y1 = get_screw(_oldScreew).y;
    x2 = get_screw(_currentScreew).x;
    y2 = get_screw(_currentScreew).y;

    // Sumamos uno a la cuenta
    screws_count[_currentScreew]++;
    if ( screws_count[_currentScreew] > max_count){
      max_count = screws_count[_currentScreew]; 
    }
    
    g1.beginDraw();
    g1.line(x1, y1, x2, y2);
    g1.endDraw();
        
    g2.beginDraw();
    g2.line(x1, y1, x2, y2);
    g2.endDraw();
  }

  /*
    COMPRUEBO BRILLO DE LINEA
  */
  float chordBrightness(int _oldScreew, int _currentScreew) {
    float x1, y1, x2, y2, x, y;
    x1 = get_screw(_oldScreew).x;
    y1 = get_screw(_oldScreew).y;
    x2 = get_screw(_currentScreew).x;
    y2 = get_screw(_currentScreew).y;

    int nSteps = 200;
    float sum = 0;

    for (int i=0; i<nSteps; i++) {
      x = x1 + (float)i/nSteps*(x2-x1);
      y = y1 + (float)i/nSteps*(y2-y1);
      sum += red(g2.get((int)x, (int)y))/(float)nSteps;
    }
    return sum;
  }

  void render_on() {  rendering = true; }
  void render_off() { rendering = false; }
}
