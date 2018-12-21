Circums c;
ControlFrame cf;


static String[] file_path;  // Nombre de la imagen que cargas
static String file_name;


void setup() {
  // Instanciamos
  c = new Circums();
  cf = new ControlFrame(this, 360, 720, "controlframe");
  

  // Tamaño inicial
  surface.setTitle("Vista previa");
  surface.setSize(500, 300);
  surface.setLocation(600, 200);
}

/*
  MAIN DRAW
 */
void draw() {
  c.update();
  c.display();
  cf.update();
}
