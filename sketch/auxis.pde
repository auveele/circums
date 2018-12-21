/*
  PULSACIÓN TECLADO
*/
void keyReleased() {
  switch(key) {
  case 'e': 
    // m.export();
    break;
  case 's':
    save_png();
    break;
  default:
    break;
  }
}

/*
  GUARDAMOS PNG 
 */
void save_png() {
  // if (t.rendering == true) stop();
  saveFrame(get_file_name(".png"));
  println("PNG guardado.");
  // if (t.rendering == true) start();
}

/*
  DEVUELVE EL NOMBRE DE ARCHIVO CON LA FECHA
 */
static final String get_file_name(final String ext) {
  return "../exports/" + year() + nf(month(), 2) + nf(day(), 2) +
    nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + ext;
}
